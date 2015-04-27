delete
from new_properties_details_fixed
where uid not in (
	select max(uid)
	from new_properties_details_fixed
	group by dup_id)