drop table new_properties_dups_deleted;

create table new_properties_dups_deleted as (
select * from new_properties_detailes_fixed
where uid in (
	select max(uid)
	from new_properties_detailes_fixed
	group by dup_id)
);