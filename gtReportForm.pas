unit gtReportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TDailyReportForm = class(TForm)
    ClipButton: TButton;
    Button2: TButton;
    ReportList: TListBox;
    procedure ClipButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute;
  end;

var
  DailyReportForm: TDailyReportForm;

implementation

Uses
  Clipbrd,
  gtIssues;

{$R *.dfm}

procedure TDailyReportForm.ClipButtonClick(Sender: TObject);
var
 l_Text: TStrings;
 i: Integer;
begin
  // Забрать содержимое Мемо в буфер
  l_Text:= TStringList.Create;
  try
    for I := 0 to ReportList.Items.Count - 1 do
      l_Text.Add('http://ws2.medwork.ru:33380/redmine/issues/'+ ReportList.Items[i]);
    Clipboard.SetTextBuf(PAnsiChar(l_Text.Text));
  finally
    FreeAndNil(l_text);
  end;
end;

procedure TDailyReportForm.Execute;
begin
end;

end.
