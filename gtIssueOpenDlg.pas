unit gtIssueOpenDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, gtIssues;

type
  TIssueOpenDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    IssuesCombo: TComboBox;
    Label2: TLabel;
    TitleEdit: TEdit;
    procedure IssuesComboChange(Sender: TObject);
  private
    { Private declarations }
    f_Issues: TgtIssues;
    f_Lock: Boolean;
  public
    { Public declarations }
    function Execute(aIssues: TgtIssues; out aIssueNum, aIssueTitle: String): Boolean;
  end;

var
  IssueOpenDialog: TIssueOpenDialog;


implementation

{$R *.dfm}

procedure TIssueOpenDialog.IssuesComboChange(Sender: TObject);

begin
  if not f_Lock then
  begin
    f_Lock:= True;
    try
     TitleEdit.Text:= f_Issues.GetIssueTitle(IssuesCombo.Text)
    finally
      f_Lock:= False;
    end;
  end;
end;

function TIssueOpenDialog.Execute(aIssues: TgtIssues; out aIssueNum,
  aIssueTitle: String): Boolean;
begin
 Result:= False;
 aIssueNum:= '';
 aIssueTitle:= '';
 if aIssues <> nil then
 begin
  f_Lock:= False;
  f_Issues:= aIssues;
  with f_Issues do
   GetIssues(IssuesCombo.Items);
  IssuesCombo.ItemIndex:= IssuesCombo.Items.IndexOf(aIssues.GetActiveIssue);
  IssuesComboChange(Self);
  Result:= IsPositiveResult(ShowModal);
  if Result then
  begin
    aIssueNum:= IssuesCombo.Text;
    aIssueTitle:= TitleEdit.Text;
  end; // Result
 end; // aIssues <> nil
end;

end.
