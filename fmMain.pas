unit fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMain = class(TForm)      
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function Dos2Win(const aStr: String): String;
    procedure CaptureConsoleOutput(const ACommand, AParameters: String; AMemo: TMemo);
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

uses ShellApi;

{$R *.dfm}

procedure TMain.Button1Click(Sender: TObject);
//var myFile : TextFile;
//    line   : string;
begin
  Memo1.Lines.Clear;
  CaptureConsoleOutput('kubectl', 'cluster-info', Memo1);
{  ShellExecute(0, nil, 'cmd.exe', 'kubectl cluster-info > out.txt', nil, SW_HIDE);
//  Sleep(1000);
  AssignFile(myFile, 'out.txt');
  Reset(myFile);
  Memo1.Lines.Clear;
  while not Eof(myFile) do
  begin
    ReadLn(myFile, line);
    Memo1.Lines.Add(Dos2Win(line));
  end;}
end;

function TMain.Dos2Win(const aStr: String): String;
begin
 Result := aStr;
 if Result <> '' then
   OemToChar(PChar(Result),PChar(Result));
end;

procedure TMain.CaptureConsoleOutput(const ACommand, AParameters: String; AMemo: TMemo);
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

     if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity,
       @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup, piProcess)
       then
     begin
       repeat
         dRunning  := WaitForSingleObject(piProcess.hProcess, 100);
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
     total:=StringReplace(total,#10,#13#10, [rfReplaceAll]);
     AMemo.Lines.Text:=total;

   end;
   Screen.Cursor:=crDefault;
end;

procedure TMain.Button2Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  CaptureConsoleOutput('kubectl', 'get pods -o wide', Memo1);
end;

end.
