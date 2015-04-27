drop table new_properties_detailes_fixed;

create table new_properties_detailes_fixed as
(
select * from 
new_properties_dup_id
left join property_details
using (dup_id)
);

update new_properties_detailes_fixed
	set new_legal_type = legal_type
	where new_legal_type is null;

update new_properties_detailes_fixed
	set new_strata_fee = strata_fee
	where new_strata_fee is null;

update new_properties_detailes_fixed
	set new_property_tax = property_tax
	where new_property_tax is null;

update new_properties_detailes_fixed
	set new_year_built = year_built
	where new_year_built is null;

update new_properties_detailes_fixed
	set new_floor_area = floor_area
	where new_floor_area is null;

update new_properties_detailes_fixed
	set new_bedroom = bedroom
	where new_bedroom is null;

update new_properties_detailes_fixed
	set new_bathroom = bathroom
	where new_bathroom is null;

update new_properties_detailes_fixed
	set new_assessed_type = assessed_type
	where new_assessed_type is null;

update new_properties_detailes_fixed
	set new_lot_size = lot_size
	where new_lot_size is null;

update new_properties_detailes_fixed
	set new_den = den
	where new_den is null;

update new_properties_detailes_fixed
	set new_normalized_type = normalized_type
	where new_normalized_type is null;

update new_properties_detailes_fixed
	set new_lot_frontage = lot_frontage
	where new_lot_frontage is null;

update new_properties_detailes_fixed
	set new_lot_depth = lot_depth
	where new_lot_depth is null;