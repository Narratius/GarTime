unit gtReportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, gtIssues, Grids;

type
  TDailyReportForm = class(TForm)
    ClipButton: TButton;
    Button2: TButton;
    ReportGrid: TStringGrid;
    procedure ClipButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute(aIssues: TgtIssues);
  end;

var
  DailyReportForm: TDailyReportForm;

implementation

Uses
  Clipbrd, SQliteTable3;

{$R *.dfm}

const
 cNumber = 0;
 cTitle  = 1;
 cTime   = 2;


procedure TDailyReportForm.ClipButtonClick(Sender: TObject);
var
 l_Text: TStrings;
 i: Integer;
begin
  // Забрать содержимое Мемо в буфер
  l_Text:= TStringList.Create;
  try
    for I := 1 to ReportGrid.RowCount - 2 do
      with ReportGrid do
        l_Text.Add(Format('%d. http://ws2.medwork.ru:33380/redmine/issues/%s (%s) %s',
            [i, Cells[cNumber, i], Cells[cTitle, i], Cells[cTime, i]]));
    // Неплохо бы поменять язык на русский :)
    Clipboard.SetTextBuf(PAnsiChar(l_Text.Text));
  finally
    FreeAndNil(l_text);
  end;
end;


procedure TDailyReportForm.Execute(aIssues: TgtIssues);
var
 l_Table: TSQLiteTable;
 l_Row: Integer;
 l_Total: Real;
begin
 with ReportGrid do
 begin
  ColWidths[cNumber]:= 40;
  ColWidths[cTitle]:= Width - 84;
  ColWidths[cTime]:= 40;
  l_Row:= 0;
  l_Total:= 0;
  Cells[cNumber, l_Row]:= 'Номер';
  Cells[cTitle, l_Row]:= 'Название задачи';
  Cells[cTime, l_Row]:= 'Время';
  l_Table:= aIssues.MakeDayReport;
   try
    RowCount:= l_Table.Count+2;
    while not l_Table.EOF do
    begin
      Inc(l_Row);
      Cells[cNumber, l_Row]:= l_Table.FieldAsString(0);
      Cells[cTitle, l_Row]:= UTF8ToAnsi(l_Table.FieldAsString(1));
      Cells[cTime, l_Row]:= Format('%4.1f ч', [l_Table.FieldAsDouble(2)]);
      l_Total:= l_Total + l_Table.FieldAsDouble(2);
      l_Table.Next;
    end; // while
  finally
    FreeAndNil(l_Table);
  end;
  Inc(l_Row);
  Cells[cTitle, l_Row]:= 'Всего за день';
  Cells[cTime, l_Row]:= Format('%4.1f ч', [l_Total]);
 end;
 ShowModal
end;

end.
