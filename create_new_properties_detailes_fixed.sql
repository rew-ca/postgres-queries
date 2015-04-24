create table new_properties_detailes_fixed as
(
select * from property_detailes_dup_id
left join property_details
using dup_id
)