-- Потерянное время
select --ts.id, ts.StartTime, ts.FinishTime,
 Sum(strftime("%s", ifnull(FinishTime, time("now", "localtime")))-strftime("%s",[StartTime]))  as 'время, сек'
from timesheet as ts
where StartDate = date("now") 
and not id in (select TimeID from issuestime)

-- Отчет за сегодня
select t.issueid as 'Задача', CAST(Sum(t.worktime) as float) / 60  as 'часы' from
(Select it.Issueid, SUM(strftime("%s",ifnull(FinishTime, time("now", "localtime")))-strftime("%s",[StartTime])) / 60 as WorkTime 
from issuestime as it 
join timesheet as ts on ts.id = it.timeid
where StartDate = date("now")
group by it.issueid, it.timeid
order by it.issueid) t
group by t.issueid