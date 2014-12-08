create procedure SHOW_STAT_OF_ROUTE (
    NAMERTS_ID integer)
returns (
    DAY_RUN_ROUTE integer,
    TIME_RUN_ROUTE time,
    TIME_PAUSE_ROUTE time,
    LENGTH_ROUTE decimal(15,2))
as
declare variable TEMP_CHAR varchar(20);
declare variable TEMP_PAUSE_SEC integer;
declare variable TEMP_RUN_SEC integer;
declare variable TEMP_DIST decimal(15,2);
declare variable TEMP_RUN time;
declare variable TEMP integer;
declare variable TEMP_PAUSE time;
declare variable TEMP_NXT integer;
begin
  /* Procedure Text */
  day_run_route=0;
  length_route=0;
  temp_pause_sec=0;
  temp_run_sec=0;
  select routes.distance,routes.time_run,routes.time_pause,routes.nxt from name_routes,routes
  where name_routes.name_routes_id=:namerts_id and name_routes.start_point=routes.routes_id
  into :temp_dist,:temp_run,:temp_pause,:temp_nxt;
  while(:temp_nxt is not NULL)
  do
  begin
          length_route=length_route+temp_dist;
          if(temp_pause is not NULL)  then
          temp_pause_sec=temp_pause_sec+extract(SECOND from temp_pause)+60*extract(MINUTE from temp_pause);
          temp_run_sec=temp_run_sec+extract(SECOND from temp_run)+60*extract(MINUTE from temp_run)+360*extract(HOUR from temp_run);
          select routes.distance,routes.time_run,routes.time_pause,routes.nxt from routes
          where :temp_nxt=routes.routes_id
          into :temp_dist,:temp_run,:temp_pause,:temp_nxt;
  end
  day_run_route = temp_run_sec/86400;
  temp_run_sec=mod(temp_run_sec,86400);

  temp=temp_run_sec/3600;
  temp_run_sec = mod(temp_run_sec,3600);
  temp_char=temp||':';

  temp=temp_run_sec/60;
  temp_run_sec = mod(temp_run_sec,60);
  temp_char=temp_char||temp||':'||temp_run_sec;

  time_run_route=cast(temp_char as time);
  --Расчет времени паузы


  temp=temp_pause_sec/3600;
  temp_pause_sec = mod(temp_pause_sec,3600);
  temp_char=temp||':';


  temp=temp_pause_sec/60;
  temp_pause_sec = mod(temp_pause_sec,60);
  temp_char=temp_char||temp||':'||temp_pause_sec;

  time_pause_route=cast(temp_char as time);
  suspend;
end
