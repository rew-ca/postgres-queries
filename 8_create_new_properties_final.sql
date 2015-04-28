create new_properties_final as (
	select 
		np.id as np.id,
		regexp_replace(regexp_replace(regexp_replace(lower(nnp.new_unit_number || '-' || nnp.new_street_number || '-' || nnp.new_street_direction || '-' || nnp.new_street_name || '-' || c.city_name || '-' || uid), ' ', '-', 'g'), '--', '-', 'g'), '--', '-', 'g') as slug,
		regexp_replace(regexp_replace(regexp_replace(lower(nnp.new_street_number || '-' || nnp.new_street_direction || '-' || nnp.new_street_name || '-' || c.city_name), ' ', '-', 'g'), '--', '-', 'g'), '--', '-', 'g') as nnp.parcel_slug,
		regexp_replace(regexp_replace(regexp_replace(lower(c.city_name || '/' || nnp.new_street_direction || '-' || nnp.new_street_name), ' ', '-', 'g'), '--', '-', 'g'), '--', '-', 'g') as nnp.street_slug,
		lower(c.city_name || '/' || nnp.postal_code) as nnp.postal_code_slug,
		nnp.new_street_number as nnp.street_number,
		np.new_street_name as np.street_name,
		np.new_street_direction as np.street_direction,
		np.new_unit_number as np.unit_number,
		np.city_id as np.city_id,
		np.postal_code as np.postal_code,
		(np.new_unit_number || '-' || np.new_street_number || ' ' || np.new_street_name || ', ' c.city_name || ', ' || p.code || ' ' || postal_code || ', ' || co.name) as np.formatted_address,
		np.latitude as np.latitude,
		np.longitude as np.longitude,
		np.geocode_source as np.geocode_source,
		np.geocode_type as np.geocode_type,
		np.geocode_status as np.geocode_status,
		np.new_legal_type as np.legal_type,
		np.new_strata_fee as np.strata_fee,
		np.new_property_tax as np.property_tax,
		np.new_year_built as np.year_built,
		np.new_floor_area as np.floor_area,
		np.new_bedroom as np.bedroom,
		np.new_bathroom as np.bathroom,
		np.new_assessed_type as np.assessed_type,
		np.new_lot_size as np.lot_size,
		np.created_at as np.created_at,
		np.updated_at as np.updated_at,
		np.new_den as np.den,
		np.new_normalized_type as np.normalized_type,
		np.parcel as np.parcel,
		np.published as np.published,
		np.new_lot_frontage as np.lot_frontage,
		np.new_lot_depth as np.lot_depth,
		np.use_point_for_street_view as np.use_point_for_street_view,
		np.matchable as np.matchable,
		np.uid as np.uid
		np.dup_id as dup_id
	from new_properties_details_fixed np, cities c, provinces p, countries co
	where np.city_id = c.id and 
		c.province_id = p.id and 
		p.country_id = co.id
	)
	