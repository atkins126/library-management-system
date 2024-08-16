unit frmAdminDashboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.StdCtrls, System.Actions, Vcl.ActnList, Data.DB,
  Data.Win.ADODB, Vcl.DBGrids, Vcl.Grids;

type
  TAdminDashboard = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit2: TEdit;
    Label3: TLabel;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    MainMenu1: TMainMenu;
    Menu11: TMenuItem;
    ShowAllBooks1: TMenuItem;
    Member1: TMenuItem;
    ShowAllMembers1: TMenuItem;
    ransactions1: TMenuItem;
    ListofTransaction1: TMenuItem;
    Reports1: TMenuItem;
    Exit1: TMenuItem;
    Catalogue1: TMenuItem;
    LoansManagement1: TMenuItem;
    procedure ShowAllMembers1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListofTransaction1Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AdminDashboard: TAdminDashboard;

implementation

{$R *.dfm}

uses frmLogin, frmUserManagement, frmAddEditBook;


procedure TAdminDashboard.Button6Click(Sender: TObject);
begin
AddEditBook.ShowModal;
end;


procedure TAdminDashboard.Button9Click(Sender: TObject);
begin
UserManagement.ShowModal;
end;

procedure TAdminDashboard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
login.Show;
end;

procedure TAdminDashboard.ListofTransaction1Click(Sender: TObject);
begin
AddEditBook.ShowModal;
end;

procedure TAdminDashboard.ShowAllMembers1Click(Sender: TObject);
begin
  UserManagement.ShowModal
end;

end.



