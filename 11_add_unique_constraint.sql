ALTER TABLE new_properties_final ADD CONSTRAINT properties_uid_constraint UNIQUE (uid);
ALTER TABLE old_properties_new_slug_uid ADD CONSTRAINT uid_constraint_old_properties UNIQUE (uid);