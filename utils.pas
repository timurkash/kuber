unit utils;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Grids;

function CaptureConsoleOutput(const ACommand, AParameters: String): TStrings;
function Kubectl(const AParameters: String): TStrings;
//function Dos2Win(const aStr: String): String;
function getHTTP(url: string): string;

procedure Put2StringGrid(stringGrid: TStringGrid; lines: TStrings);

procedure AdjustWidths(stringGrid: TStringGrid);
function getName(stringGrid: TStringGrid): string;
function getNameSpace(stringGrid: TStringGrid): string;

implementation

uses ShellApi
    ,IdHTTP
    ,fmMain
     ;


function getHTTP(url: string): string;
var
    HTTP: TIdHTTP;
begin
  HTTP := TIdHTTP.Create(Main);
  result:=HTTP.Get(url);
  HTTP.Free;
  result:=StringReplace(result, #10, #13#10, [rfReplaceAll]);
end;

function Kubectl(const AParameters: String): TStrings;
begin
  result:=CaptureConsoleOutput('kubectl', AParameters);
end;

function ExecCmd(const aCommand, aPath: String; const aShow, aWaitExit: Boolean): Boolean;
var
  pi: TProcessInformation;
  si: TStartupInfo;
  cmdLine, Path: String;
begin
  ZeroMemory(@si,sizeof(si));
  si.cb:=SizeOf(si);
  si.dwFlags := STARTF_FORCEONFEEDBACK+STARTF_USESHOWWINDOW;
  if aShow then
    si.wShowWindow := SW_SHOWNORMAL
  else
    si.wShowWindow := SW_HIDE;
  Path := aPath;
  cmdLine := aCommand;

  Result :=
        CreateProcess( nil,
                       PChar(cmdLine),
                       nil,
                       nil,
                       False,
                       0,
                       nil,
                       PChar(Path),
                       si,
                       pi );
 if Result then
 begin
   CloseHandle(pi.hThread);
   if aWaitExit then WaitForSingleObject( pi.hProcess, infinite );
   CloseHandle(pi.hProcess);
 end;

end;

function CaptureConsoleOutput(const ACommand, AParameters: String): TStrings;
 const
   CReadBuffer = 2400;
 var
   saSecurity: TSecurityAttributes;
   hRead: THandle;
   hWrite: THandle;
   suiStartup: TStartupInfo;
   piProcess: TProcessInformation;
   pBuffer: array[0..CReadBuffer] of AnsiChar;
   dRead: DWord;
   dRunning: DWord;
   total: string;
 begin
   result:=TStringList.Create;
   Screen.Cursor:=crHourGlass;
   saSecurity.nLength := SizeOf(TSecurityAttributes);
   saSecurity.bInheritHandle := True;
   saSecurity.lpSecurityDescriptor := nil;

   if CreatePipe(hRead, hWrite, @saSecurity, 0) then begin
     FillChar(suiStartup, SizeOf(TStartupInfo), #0);
     suiStartup.cb := SizeOf(TStartupInfo);
     suiStartup.hStdInput := hRead;
     suiStartup.hStdOutput := hWrite;
     suiStartup.hStdError := hWrite;
     suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
     suiStartup.wShowWindow := SW_HIDE;

     if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), {@saSecurity,}nil,
       {@saSecurity, }nil, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup, piProcess)
       then
     begin
       repeat
         dRunning  := WaitForSingleObject(piProcess.hProcess, 1000);
         Application.ProcessMessages();
         repeat
           dRead := 0;
           ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
           pBuffer[dRead] := #0;

           OemToAnsi(pBuffer, pBuffer);
           total:=total + String(pBuffer);
         until (dRead < CReadBuffer);
       until (dRunning <> WAIT_TIMEOUT);
       CloseHandle(piProcess.hProcess);
       CloseHandle(piProcess.hThread);
     end;

     CloseHandle(hRead);
     CloseHandle(hWrite);
     total:=StringReplace(total, #10, #13#10, [rfReplaceAll]);
     result.Text:=total;

   end;
   Screen.Cursor:=crDefault;
end;

function Dos2Win(const aStr: String): String;
begin
 Result := aStr;
 if Result <> '' then
   OemToChar(PChar(Result),PChar(Result));
end;

procedure Put2StringGrid(stringGrid: TStringGrid; lines: TStrings);
var columns: TStringList;
    column, line: string;
    pos: array of integer;
    i, j: integer;
    ch: char;
    space: boolean;
    count: integer;
    cell: string;
begin
  stringGrid.FixedCols:=0;
  stringGrid.FixedRows:=1;
  stringGrid.ColCount:=1;
  stringGrid.RowCount:=2;
  columns:=TStringList.Create;
  line:=lines[0];
  space:=false;
  SetLength(pos,63);
  pos[0]:=1;
  count:=1;
  for i:=1 to length(line) do begin
    ch:=line[i];
    if ch = ' ' then begin
      if not space then begin
        columns.Add(column);
        column:='';
        space:=true;
      end;
    end
    else begin
      column:=column+ch;
      if space then begin
        pos[count]:=i;
        inc(count);
      end;
      space:=false;
    end;
  end;
  if column <> '' then
    columns.Add(column);
//  columns:=lines[0];
//  l:=length(columns);
  stringGrid.ColCount:=columns.Count;
  for i:=0 to columns.Count-1 do begin
    stringGrid.Cells[i, 0]:=columns[i];
  end;
  columns.Free;
  stringGrid.RowCount:=lines.Count;
  for j:=1 to lines.Count-1 do begin
    line:=lines[j];
    for i:=0 to count-2 do begin
      cell:=Copy(line, pos[i]+1, pos[i+1]-pos[i]);
      stringGrid.Cells[i, j]:=Trim(Copy(line, pos[i], pos[i+1]-pos[i]));
    end;
    stringGrid.Cells[count-1, j]:=Copy(line, pos[i], 1000);
  end;
  AdjustWidths(stringGrid);
end;

function GetWidthText(const Text:String; Font:TFont) : Integer;
var
  LBmp: TBitmap;
begin
  LBmp := TBitmap.Create;
  try
   LBmp.Canvas.Font := Font;
   Result := LBmp.Canvas.TextWidth(Text);
  finally
   LBmp.Free;
  end;
end;

procedure AdjustWidths(stringGrid: TStringGrid);
var i, j, width, maxWidth: integer;
    text: string;
begin
  for i:=0 to stringGrid.ColCount-1 do begin
    maxWidth:=0;
    for j:=0 to stringGrid.RowCount-1 do begin
      text:=stringGrid.Cells[i, j];
      width:=GetWidthText(text, stringGrid.Font);
      if width>maxWidth then maxWidth:=width;
    end;
    stringGrid.ColWidths[i]:=maxWidth+10;
  end;
end;

function getName(stringGrid: TStringGrid): string;
var i, r: integer;
begin
  r:=StringGrid.Row;
  for i:=0 to StringGrid.ColCount-1 do begin
    if StringGrid.Cells[i, 0] = 'NAME' then
      break;
  end;
  result:=StringGrid.Cells[i, r];
end;

function getNameSpace(stringGrid: TStringGrid): string;
var i, r: integer;
begin
  r:=StringGrid.Row;
  for i:=0 to StringGrid.ColCount-1 do begin
    if StringGrid.Cells[i, 0] = 'NAMESPACE' then
      break;
  end;
  result:=StringGrid.Cells[i, r];
end;

end.
