unit frmAddEditBook;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtDlgs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Menus, Data.Win.ADODB;

type
  TAddEditBook = class(TForm)
    MainMenu1: TMainMenu;
    Menu11: TMenuItem;
    ShowAllBooks1: TMenuItem;
    Member1: TMenuItem;
    ShowAllMembers1: TMenuItem;
    ransactions1: TMenuItem;
    ListofTransaction1: TMenuItem;
    Reports1: TMenuItem;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button1save: TButton;
    Button2delete: TButton;
    DBGrid1: TDBGrid;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label4: TLabel;
    Edit5: TEdit;
    Label5: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    Label6: TLabel;
    Button3upload: TButton;
    Image2: TImage;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    Label10: TLabel;
    DataSource1: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Button3uploadClick(Sender: TObject);
    procedure Button1saveClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button2deleteClick(Sender: TObject);
  private
    { Private declarations }
    FImagePath: string;
    procedure ClearForm;
  public
    { Public declarations }
  end;

var
  AddEditBook: TAddEditBook;

implementation

{$R *.dfm}

procedure TAddEditBook.ClearForm;
begin
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;
  Edit4.Clear;
  Edit5.Clear;
  Image2.Picture := nil; // Clear the image
end;

procedure TAddEditBook.Button2deleteClick(Sender: TObject);
var
  DeleteSQL: string;
begin
  if not ADOConnection1.Connected then
    ADOConnection1.Connected := True;

  DeleteSQL := 'DELETE FROM Books WHERE BookID = :BookID';

  ADOQuery1.Connection := ADOConnection1;
  ADOQuery1.SQL.Text := DeleteSQL;
  ADOQuery1.Parameters.ParamByName('BookID').Value := Edit2.Text;

  try
    ADOQuery1.ExecSQL;
    ShowMessage('Books deleted successfully.');

    ADOQuery1.SQL.Text := 'SELECT * FROM Books';
    ADOQuery1.Open;
  except
    on E: Exception do
      ShowMessage('Error deleting Books: ' + E.Message);
  end;
end;

procedure TAddEditBook.Button3uploadClick(Sender: TObject);
begin
 if OpenPictureDialog1.Execute then
  begin
    FImagePath := OpenPictureDialog1.FileName;
    Image2.Picture.LoadFromFile(FImagePath);
  end;
end;

procedure TAddEditBook.Button1saveClick(Sender: TObject);
var
  MemoryStream: TMemoryStream;
begin
  if not ADOConnection1.Connected then
    ADOConnection1.Connected := True;

  ADOQuery1.SQL.Text := 'INSERT INTO Books (Title, BookID, Author, Genre, PublishedYear, Cover) ' +
                        'VALUES (:Title, :BookID, :Author, :Genre, :PublishedYear, :Cover)';

  ADOQuery1.Parameters.ParamByName('Title').Value := Edit1.Text;
  ADOQuery1.Parameters.ParamByName('BookID').Value := Edit2.Text;
  ADOQuery1.Parameters.ParamByName('Author').Value := Edit3.Text;
  ADOQuery1.Parameters.ParamByName('Genre').Value := Edit4.Text;
  ADOQuery1.Parameters.ParamByName('PublishedYear').Value := Edit5.Text;

  if FImagePath <> '' then
  begin
    MemoryStream := TMemoryStream.Create;
    try
      Image2.Picture.SaveToStream(MemoryStream);
      MemoryStream.Position := 0;
      ADOQuery1.Parameters.ParamByName('Cover').LoadFromStream(MemoryStream, ftBlob);
    finally
      MemoryStream.Free;
    end;
  end
  else

  begin
    ADOQuery1.Parameters.ParamByName('Cover').Value := Null;
  end;

  try
    ADOQuery1.ExecSQL;
    ShowMessage('Book saved successfully.');

    // Refresh the grid to show the newly added book
    ADOQuery1.Close;
    ADOQuery1.SQL.Text := 'SELECT * FROM Books';
    ADOQuery1.Open;
  except
    on E: Exception do
      ShowMessage('Error saving book: ' + E.Message);
  end;
end;


procedure TAddEditBook.DBGrid1CellClick(Column: TColumn);
var
  MemoryStream: TMemoryStream;
begin
  Edit1.Text := ADOQuery1.FieldByName('Title').AsString;
  Edit2.Text := ADOQuery1.FieldByName('BookID').AsString;
  Edit3.Text := ADOQuery1.FieldByName('Author').AsString;
  Edit4.Text := ADOQuery1.FieldByName('Genre').AsString;
  Edit5.Text := ADOQuery1.FieldByName('PublishedYear').AsString;

  Image2.Picture := nil; // Clear the image if there's none in the database

  // Load the cover image from the database if it exists
  if not ADOQuery1.FieldByName('Cover').IsNull then
  begin
    MemoryStream := TMemoryStream.Create;
    try
      TBlobField(ADOQuery1.FieldByName('Cover')).SaveToStream(MemoryStream);
      MemoryStream.Position := 0;
      Image2.Picture.LoadFromStream(MemoryStream);
    finally
      MemoryStream.Free;
    end;
  end;
end;

procedure TAddEditBook.FormShow(Sender: TObject);
begin
  ADOQuery1.Close;
  ADOQuery1.SQL.Text := 'SELECT * FROM Books';  // Adjust the table name and fields as needed
  ADOQuery1.Open;
  DBGrid1.DataSource := DataSource1;
  DataSource1.DataSet := ADOQuery1;
end;

procedure TAddEditBook.Image1Click(Sender: TObject);
begin
  ClearForm;
end;

end.
