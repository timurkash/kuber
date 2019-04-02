unit fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, Grids, ExtCtrls;

type
  TMain = class(TForm)
    MainMenu1: TMainMenu;
    Main1: TMenuItem;
    N1: TMenuItem;
    GroupBox3: TGroupBox;
    Panel1: TPanel;
    MemoMain: TMemo;
    GroupBox1: TGroupBox;
    StringGridNodes: TStringGrid;
    GroupBox2: TGroupBox;
    StringGridPods: TStringGrid;
    MemoYaml: TMemo;
    Panel2: TPanel;
    GroupBox4: TGroupBox;
    StringGridNamespaces: TStringGrid;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGridNodesDblClick(Sender: TObject);
    procedure StringGridPodsDblClick(Sender: TObject);
    procedure StringGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGridNamespacesDblClick(Sender: TObject);
  private
    first: boolean;
    lines: TStrings;
  public
    { Public declarations }
  end;

var
  Main: TMain;

const HOST = 'http://localhost:8002/';

implementation

uses utils
    ,ShellApi
     ;

{$R *.dfm}

procedure TMain.FormActivate(Sender: TObject);
begin
  if first then begin
    first:=false;
    MemoMain.Lines.Text:=Kubectl('cluster-info').Text;
    Put2StringGrid(StringGridNamespaces, Kubectl('get namespaces'));
    Put2StringGrid(StringGridNodes, Kubectl('get nodes -o wide'));
    Put2StringGrid(StringGridPods, Kubectl('get pods --all-namespaces --show-labels -o wide'));
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  first:=true;
  lines:=TStringList.Create;
end;

procedure TMain.StringGridNodesDblClick(Sender: TObject);
begin
  MemoYaml.Lines.Text:=getHTTP(HOST + 'api/v1/nodes/' + getName(TStringGrid(Sender)));
end;

procedure TMain.StringGridPodsDblClick(Sender: TObject);
var nameSpace, name: string;
begin
  name:=getName(TStringGrid(Sender));
  nameSpace:=GetNameSpace(TStringGrid(Sender));
  MemoYaml.Lines.Text:=getHTTP(HOST + 'api/v1/namespaces/' + nameSpace + '/pods/' + name);
end;

procedure TMain.StringGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  StringGrid: TStringGrid;
begin
  if Key = 13 then begin
    StringGrid:=TStringGrid(Sender);
    if Assigned(StringGrid.OnDblClick) then
      StringGrid.OnDblClick(Sender);
  end;
end;

procedure TMain.StringGridNamespacesDblClick(Sender: TObject);
begin
  MemoYaml.Lines.Text:=getHTTP(HOST + 'api/v1/namespaces/' + getName(TStringGrid(Sender)));
end;

end.
