/*
 *  NormalizeGeometry - PL/pgSQL function to remove spikes and simplify geometries with PostGIS.
 *      Author          : Gaspare Sganga
 *      Version         : 1.2.0
 *      License         : MIT
 *      Documentation   : https://gasparesganga.com/labs/postgis-normalize-geometry/
 */


/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
WARNING, DON'T EXECUTE THIS FILE AS A WHOLE!

In this file there are some replacement functions that you might need in case you are using an
older version of PostgreSQL which is missing some new functionalities used by NormalizeGeometry.
Carefully select only the functions you really need depending on your PostgreSQL version.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */


/*
####################################################################################################
# PostgreSQL 9.2 or lower: array_remove() backport
####################################################################################################
Notes:
    - The negated "=" operator is used instead of "<>" to prevent an "operator not unique" error
    - The CASE statement is needed to correctly handle NULL values
*/
CREATE OR REPLACE FUNCTION array_remove(
      PAR_array     anyarray
    , PAR_element   anyelement
) RETURNS anyarray
AS $$
    SELECT ARRAY(
        SELECT value
            FROM unnest(PAR_array) AS value
            WHERE CASE WHEN PAR_element IS null THEN (value IS NOT null) ELSE (NOT value = PAR_element) END
    );
$$
LANGUAGE sql;