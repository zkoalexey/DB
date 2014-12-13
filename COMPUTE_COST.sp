create procedure COMPUTE_COST (
    ST_POINT integer,
    VAG integer,
    FINISH_POINT integer)
returns (
    COST decimal(5,2))
as
declare variable TEMP integer;
declare variable TEMP2 decimal(3,2);
declare variable LEN decimal(15,2);
declare variable KOEF_VAG decimal(15,2);
begin
  if(st_point is null or vag is null or finish_point is null) then exit;
  select vagons.vag_type from vagons where :vag=vagons.vagons_id
  into :temp;
   koef_vag=CASE
            WHEN temp=1  THEN 0.5
            WHEN temp=2  THEN 1
            when temp=3  then 2
            ELSE null
            END;

  select routes.distance,routes.nxt from routes where routes.routes_id=:st_point
  into :len, :temp;

  while(temp~=:finish_point)
  do
  begin
        select routes.distance,routes.nxt from routes where routes.routes_id=:temp
        into :temp2, :temp;
        len=len+temp2;
  end
  cost=round(maxvalue(34,:len*1.93*:koef_vag),2);
  suspend;
end
