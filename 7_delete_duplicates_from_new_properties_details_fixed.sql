-- select * from new_properties_detailes_fixed limit 10;

delete
from new_properties_detailes_fixed
where uid not in (
	select max(uid)
	from new_properties_detailes_fixed
	group by dup_id)