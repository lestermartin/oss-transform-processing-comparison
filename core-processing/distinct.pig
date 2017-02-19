all_planes  = LOAD 'plane'  USING org.apache.hive.hcatalog.pig.HCatLoader();

aircraft_types = FOREACH all_planes GENERATE aircraft_type;

distinct_aircraft_types = DISTINCT aircraft_types;
DUMP distinct_aircraft_types;

just_rotocraft = FILTER all_planes BY
    aircraft_type == 'Rotorcraft';

just_rotor_makers = FOREACH just_rotocraft GENERATE manufacturer;

distinct_rotor_makers = DISTINCT just_rotor_makers;
DUMP distinct_rotor_makers;
