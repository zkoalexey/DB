create procedure FIND_NEED_ROUTES (
    FROM_STATION integer,
    TO_STATION integer)
returns (
    ID integer)
as
declare variable BOOL_FF integer;
declare variable TEMP_ST integer;
declare variable TEMP_NXT integer;
begin
  /* Procedure Text */
  for select name_routes.name_routes_id, routes.st,routes.nxt from name_routes,routes
  where name_routes.start_point=routes.routes_id
  into :id,:temp_st,:temp_nxt
  do
  begin
  bool_ff=0;
  while(:temp_nxt is not NULL)
  do
  begin
          if(temp_st=from_station)  then bool_ff=1;
          if(temp_st=to_station and bool_ff=1) then
          begin
            temp_nxt=null;
            suspend;
          end
          select routes.st,routes.nxt from routes
          where routes.routes_id=:temp_nxt
          into :temp_st,:temp_nxt;
  end
  end
end
