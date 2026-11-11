
-- PRE-ENTREGA 6 - Paso 5: RBAC con ROLES.

CREATE ROLE analytics_rt;
CREATE ROLE analytics_ar;

-- La capa raw queda restringida.
REVOKE ALL ON SCHEMA raw_streaming FROM PUBLIC;

-- El rol de tiempo real puede consultar la capa de consumo.
GRANT USAGE ON SCHEMA analytics_consumption TO ROLE analytics_rt;
GRANT SELECT ON ALL TABLES IN SCHEMA analytics_consumption TO ROLE analytics_rt;

-- El rol de analitica tambien necesita acceso al esquema.
GRANT USAGE ON SCHEMA analytics_consumption TO ROLE analytics_ar;
