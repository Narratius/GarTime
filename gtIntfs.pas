unit gtIntfs;

{ ���������� ��� ������� }

interface

type
 IgtTimer = interface
   ['{91E534E3-5F89-46B6-89F5-53DE73B8C631}']
  function DaySheet(out theSheet, theGarSheet: Integer): string;
  function MonthSheet(out theSheet, theGarSheet: Integer; aTotal: Boolean): string;
  procedure Pause;
  procedure Start;
  procedure Stop;
  function GetIsStarted: Boolean;
  property IsStarted: Boolean read GetIsStarted;
 end;


implementation

end.
