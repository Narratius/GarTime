unit gtSQL;
{ Классы для работы с MySQL }

interface
Uses
  gtIntfs;

type
 TgtSQLTimer = class(TInterfacedObject, IgtTimer)
 private
  function GetIsStarted: Boolean;
 public
  constructor Create;
  destructor Destroy; override;
  function DaySheet(out theSheet, theGarSheet: Integer): string;
  procedure LoadFromFile(const aFileName: String);
  function MonthSheet(out theSheet, theGarSheet: Integer; aTotal: Boolean): string;
  procedure Pause;
  procedure SaveToFile(const aFileName: String);
  procedure Start;
  procedure Stop;
  function MinutesToString(aMinutes: Int64): ShortString;
  property IsStarted: Boolean read GetIsStarted;
 end;

implementation

{ TgtSQLTimer }

constructor TgtSQLTimer.Create;
begin

end;

function TgtSQLTimer.DaySheet(out theSheet, theGarSheet: Integer): string;
begin

end;

destructor TgtSQLTimer.Destroy;
begin

  inherited;
end;

function TgtSQLTimer.GetIsStarted: Boolean;
begin

end;

procedure TgtSQLTimer.LoadFromFile(const aFileName: String);
begin

end;

function TgtSQLTimer.MinutesToString(aMinutes: Int64): ShortString;
begin

end;

function TgtSQLTimer.MonthSheet(out theSheet, theGarSheet: Integer;
  aTotal: Boolean): string;
begin

end;

procedure TgtSQLTimer.Pause;
begin

end;

procedure TgtSQLTimer.SaveToFile(const aFileName: String);
begin

end;

procedure TgtSQLTimer.Start;
begin

end;

procedure TgtSQLTimer.Stop;
begin

end;

end.
