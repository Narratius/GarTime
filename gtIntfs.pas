unit gtIntfs;

{ Интерфейсы для классов }

interface

type
 IgtTimer = interface
   ['{91E534E3-5F89-46B6-89F5-53DE73B8C631}']
  function DaySheet(out theSheet, theGarSheet: Integer): string;
  procedure LoadFromFile(const aFileName: String);
  function MonthSheet(out theSheet, theGarSheet: Integer; aTotal: Boolean): string;
  procedure Pause;
  procedure SaveToFile(const aFileName: String);
  procedure Start;
  procedure Stop;
  function MinutesToString(aMinutes: Int64): ShortString;
  function GetIsStarted: Boolean;
  property IsStarted: Boolean read GetIsStarted;
 end;

implementation

end.
