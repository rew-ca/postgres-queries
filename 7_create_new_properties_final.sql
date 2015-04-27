create new_properties_final as (
select * from new_properties_detailes_fixed
where uid in (
	select max(uid)
	from new_properties_detailes_fixed
	group by dup_id)
);