unit frmUserManagement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Menus, Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TUserManagement = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    ADOConnection1: TADOConnection;
    MainMenu1: TMainMenu;
    Menu11: TMenuItem;
    ShowAllBooks1: TMenuItem;
    Exit1: TMenuItem;
    Member1: TMenuItem;
    ShowAllMembers1: TMenuItem;
    ransactions1: TMenuItem;
    ListofTransaction1: TMenuItem;
    Catalogue1: TMenuItem;
    Reports1: TMenuItem;
    LoansManagement1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ConfigureGridColumns;
  public
    { Public declarations }
    procedure ClearForm;
  end;

var
  UserManagement: TUserManagement;

implementation

{$R *.dfm}

uses frmLogin, frmAdminDashboard;

procedure TUserManagement.ClearForm;
begin
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;
  Edit4.Clear;
end;

procedure TUserManagement.Button1Click(Sender: TObject);
var
  InsertSQL: string;
begin
   // Ensure that ADOConnection1 is connected
  if not ADOConnection1.Connected then
    ADOConnection1.Connected := True;

  // Prepare the SQL INSERT statement
  InsertSQL := 'INSERT INTO Users (Name, Username, Password, Role) ' +
               'VALUES (:Name, :Username, :Password, :Role)';

  // Set up the query
  ADOQuery1.Connection := ADOConnection1;
  ADOQuery1.SQL.Text := InsertSQL;

  // Bind the parameters to the Edit controls
  ADOQuery1.Parameters.ParamByName('Name').Value := Edit1.Text;
  ADOQuery1.Parameters.ParamByName('Username').Value := Edit2.Text;
  ADOQuery1.Parameters.ParamByName('Password').Value := Edit3.Text;
  ADOQuery1.Parameters.ParamByName('Role').Value := Edit4.Text;

  // Execute the query
  try
    ADOQuery1.ExecSQL;
    ShowMessage('User added successfully.');

    // Optionally, refresh the grid to show the newly added user
    ADOQuery1.SQL.Text := 'SELECT * FROM Users';
    ADOQuery1.Open;
  except
    on E: Exception do
      ShowMessage('Error inserting user: ' + E.Message);
  end;
end;

procedure TUserManagement.Button2Click(Sender: TObject);
begin
begin
  // Make sure that ADOConnection1 is connected
  if not ADOConnection1.Connected then
    ADOConnection1.Connected := True;

  // Get the search term from Edit1

  // Set up the SQL query to search for books
  ADOQuery1.Connection := ADOConnection1;
  ADOQuery1.SQL.Text := 'SELECT * FROM Users';

  // Open the query
  try
    ADOQuery1.Open;

    // Check if any records are returned
    if ADOQuery1.IsEmpty then
      ShowMessage('No Users found matching the search criteria.')
    else
      ShowMessage(IntToStr(ADOQuery1.RecordCount) + ' Users found.');

    // Connect the query to the data source and the grid
    DataSource1.DataSet := ADOQuery1;
    DBGrid1.DataSource := DataSource1;

    ConfigureGridColumns;

    ShowMessage('Search completed successfully.');

  except
    on E: Exception do
      ShowMessage('Error executing search query: ' + E.Message);
  end;
end;
end;

// Delete User  Button Procedure
procedure TUserManagement.Button3Click(Sender: TObject);
var
  DeleteSQL: string;
begin
  if not ADOConnection1.Connected then
    ADOConnection1.Connected := True;

  DeleteSQL := 'DELETE FROM Users WHERE Username = :Username';

  ADOQuery1.Connection := ADOConnection1;
  ADOQuery1.SQL.Text := DeleteSQL;
  ADOQuery1.Parameters.ParamByName('Username').Value := Edit2.Text;

  try
    ADOQuery1.ExecSQL;
    ShowMessage('User deleted successfully.');

    ADOQuery1.SQL.Text := 'SELECT * FROM Users';
    ADOQuery1.Open;
  except
    on E: Exception do
      ShowMessage('Error deleting user: ' + E.Message);
  end;
end;

procedure TUserManagement.ConfigureGridColumns;
begin
  with DBGrid1.Columns do
  begin
    // Ensure columns are properly set up
    // This assumes there are columns for BookID, Title, Author etc
    if Count > 0 then
    begin
      Items[0].Width := 100;  // Width for BookID column
      Items[1].Width := 50; // Width for Title column
      Items[2].Width := 50; // Width for Author column
      Items[3].Width := 50; // Width for Genre column
    end;
  end;
end;

procedure TUserManagement.FormShow(Sender: TObject);
begin
 begin
  // Make sure that ADOConnection1 is connected
  if not ADOConnection1.Connected then
    ADOConnection1.Connected := True;


  // Set up the SQL query to search for books
  ADOQuery1.Connection := ADOConnection1;
  ADOQuery1.SQL.Text := 'SELECT * FROM Users';

  // Open the query
  try
    ADOQuery1.Open;

    // Connect the query to the data source and the grid
    DataSource1.DataSet := ADOQuery1;
    DBGrid1.DataSource := DataSource1;

    ConfigureGridColumns;

  except
    on E: Exception do
      ShowMessage('Error executing search query: ' + E.Message);
  end;
end;
end;


// Populate the Edit controls with the selected row's data
procedure TUserManagement.DBGrid1CellClick(Column: TColumn);
begin
  Edit1.Text := ADOQuery1.FieldByName('Name').AsString;
  Edit2.Text := ADOQuery1.FieldByName('Username').AsString;
  Edit3.Text := ADOQuery1.FieldByName('Password').AsString;
  Edit4.Text := ADOQuery1.FieldByName('Role').AsString;
end;

procedure TUserManagement.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UserManagement.Close; // Show AdminDashboard after close
end;

procedure TUserManagement.Exit1Click(Sender: TObject);
begin
UserManagement.Close;
end;

procedure TUserManagement.Image1Click(Sender: TObject);
begin
  ClearForm;
end;


end.
