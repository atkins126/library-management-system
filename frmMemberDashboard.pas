unit frmMemberDashboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Data.DB, Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Vcl.Menus;

type
  TMemberDashboard = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button5: TButton;
    Button2: TButton;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    Update1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ConfigureGridColumns;
  public
    { Public declarations }
  end;

var
  MemberDashboard: TMemberDashboard;

implementation

{$R *.dfm}

uses frmLogin;

// Column Configuration
procedure TMemberDashboard.ConfigureGridColumns;
begin
  with DBGrid1.Columns do
  begin
    // Ensure columns are properly set up
    // This assumes there are columns for BookID, Title, Author etc
    if Count > 0 then
    begin
      Items[0].Width := 60;  // Width for BookID column
      Items[1].Width := 150; // Width for Title column
      Items[2].Width := 150; // Width for Author column
      Items[3].Width := 150; // Width for Genre column
    end;
  end;
end;

// Column Configuration Trigger
procedure TMemberDashboard.FormShow(Sender: TObject);
begin
begin
  // Make sure that ADOConnection1 is connected
  if not Login.ADOConnection1.Connected then
    Login.ADOConnection1.Connected := True;

  // Set up the SQL query to search for books
  ADOQuery1.Connection := Login.ADOConnection1;
  ADOQuery1.SQL.Text := 'SELECT * FROM Books';

  // Open the query
  try
    ADOQuery1.Open;

    // Connect the query to the data source and the grid
    DataSource1.DataSet := ADOQuery1;
    DBGrid1.DataSource := DataSource1;

    // Configure grid columns
    ConfigureGridColumns;


  except
    on E: Exception do
      ShowMessage('Error executing search query: ' + E.Message);
  end;
end;
end;

// Button Refresh Click
procedure TMemberDashboard.Button2Click(Sender: TObject);
begin
  // Make sure that ADOConnection1 is connected
  if not Login.ADOConnection1.Connected then
    Login.ADOConnection1.Connected := True;

  // Set up the SQL query to select all books
  ADOQuery1.Connection := Login.ADOConnection1;
  ADOQuery1.SQL.Text := 'SELECT * FROM Books';

  // Open the query
  try
    ADOQuery1.Open;

    // Check if any records are returned
    if ADOQuery1.IsEmpty then
      ShowMessage('No books found in the Books table.')
    else
      ShowMessage(IntToStr(ADOQuery1.RecordCount) + ' books found.');

    // Connect the query to the data source and the grid
    DataSource1.DataSet := ADOQuery1;
    DBGrid1.DataSource := DataSource1;

    // Configure grid columns
    ConfigureGridColumns;

    ShowMessage('Books database successfully updated.');

  except
    on E: Exception do
      ShowMessage('Error opening query: ' + E.Message);
  end;
end;

//Button Search Books
procedure TMemberDashboard.Button5Click(Sender: TObject);
var
  SearchTerm: string;
begin
  // Make sure that ADOConnection1 is connected
  if not Login.ADOConnection1.Connected then
    Login.ADOConnection1.Connected := True;

  // Get the search term from Edit1
  SearchTerm := Edit1.Text;

  // Set up the SQL query to search for books
  ADOQuery1.Connection := Login.ADOConnection1;
  ADOQuery1.SQL.Text := 'SELECT * FROM Books WHERE Title LIKE :SearchTerm';
  ADOQuery1.Parameters.ParamByName('SearchTerm').Value := '%' + SearchTerm + '%';

  // Open the query
  try
    ADOQuery1.Open;

    // Check if any records are returned
    if ADOQuery1.IsEmpty then
      ShowMessage('No books found matching the search criteria.')
    else
      ShowMessage(IntToStr(ADOQuery1.RecordCount) + ' books found.');

    // Connect the query to the data source and the grid
    DataSource1.DataSet := ADOQuery1;
    DBGrid1.DataSource := DataSource1;

    // Configure grid columns
    ConfigureGridColumns;

    ShowMessage('Search completed successfully.');

  except
    on E: Exception do
      ShowMessage('Error executing search query: ' + E.Message);
  end;
end;

procedure TMemberDashboard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Login.Show;
end;


end.
