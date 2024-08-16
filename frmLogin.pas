unit frmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Data.DB, Data.Win.ADODB, frmAdminDashboard, frmMemberDashboard,
  Vcl.Imaging.pngimage, Vcl.Menus;

type
  TLogin = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Image1: TImage;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    Button2: TButton;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function ValidateUser(const Username, Password: string; out UserRole: string): Boolean;
  public
    { Public declarations }
  end;

var
  Login: TLogin;

implementation

{$R *.dfm}

function TLogin.ValidateUser(const Username, Password: string; out UserRole: string): Boolean;
begin
  Result := False;
  UserRole := '';

  ADOQuery1.Close;
  ADOQuery1.SQL.Text := 'SELECT Role FROM Users WHERE Username = :Username AND Password = :Password';
  ADOQuery1.Parameters.ParamByName('Username').Value := Username;
  ADOQuery1.Parameters.ParamByName('Password').Value := Password;
  ADOQuery1.Open;

  // Check if there is a matching user
  if not ADOQuery1.IsEmpty then
  begin
    UserRole := ADOQuery1.Fields[0].AsString;
    Result := True;
  end;

  ADOQuery1.Close;
end;

procedure TLogin.Button1Click(Sender: TObject);
var
  UserRole: string;
  AdminDashboard: TAdminDashboard;
  MemberDashboard: TMemberDashboard;
begin
  if ValidateUser(Edit1.Text, Edit2.Text, UserRole) then
  begin
    ShowMessage('Login Successful!');

    if UserRole = 'Admin' then
    begin
      // Create and show AdminDashboard form
      AdminDashboard := TAdminDashboard.Create(nil);
      try
      Hide; // Hide the login form
      AdminDashboard.ShowModal;
      finally
      AdminDashboard.Free; // Ensure the form is freed
    end;
    end
    else if UserRole = 'Member' then
    begin
      // Create and show MemberDashboard form
      MemberDashboard := TMemberDashboard.Create(nil);
      try
        Hide; // Hide the login form
        MemberDashboard.ShowModal;
      finally
        MemberDashboard.Free; // Ensure the form is freed
      end;
    end;

    // Close the login form after showing the appropriate dashboard
    Close;
  end
  else
  begin
    ShowMessage('Invalid username or password.');
  end;
end;

end.

