program LibraryProject;

uses
  Vcl.Forms,
  frmLogin in 'frmLogin.pas' {Login},
  frmAdminDashboard in 'frmAdminDashboard.pas' {AdminDashboard},
  frmMemberDashboard in 'frmMemberDashboard.pas' {MemberDashboard},
  frmUserManagement in 'frmUserManagement.pas' {UserManagement},
  frmAddEditBook in 'frmAddEditBook.pas' {AddEditBook};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLogin, Login);
  Application.CreateForm(TAdminDashboard, AdminDashboard);
  Application.CreateForm(TMemberDashboard, MemberDashboard);
  Application.CreateForm(TUserManagement, UserManagement);
  Application.CreateForm(TAddEditBook, AddEditBook);
  Application.Run;
end.
