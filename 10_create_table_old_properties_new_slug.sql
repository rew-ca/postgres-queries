drop table old_properties_new_slug;

create table old_properties_new_slug as(
select id,
	np.slug,
	ns.slug as new_slug,
	np.parcel_slug,
	np.street_slug,
	np.postal_code_slug, 
	np.street_number,
	np.street_name,
	np.street_direction,
	np.unit_number,
	np.postal_code,
	np.formatted_address,
	np.latitude,
	np.longitude,
	np.geocode_source,
	np.geocode_type,
	np.geocode_status,
	np.legal_type,
	np.strata_fee,
	np.property_tax,
	np.year_built,
	np.floor_area,
	np.bedroom,
	np.bathroom,
	np.assessed_type,
	np.lot_size,
	np.created_at,
	np.updated_at,
	np.den,
	np.normalized_type,
	np.parcel,
	np.published,
	np.lot_frontage,
	np.lot_depth,
	np.use_point_for_street_view,
	np.matchable,
	np.uid
	from new_properties_dup_id np
	left join dup_id_new_slug ns
	using (dup_id)
);