-- Primero voy a cambiar el tipo de dato de bonificacion y total_ventas
-- de varchar a int

--ALTER TABLE mydb.cliente ALTER COLUMN bonificacion TYPE INT
--USING bonificacion::integer;

--ALTER TABLE mydb.cliente ALTER COLUMN total_ventas TYPE INT
--USING total_ventas::integer;

-- OJO es preciso primero cambiar el atributo ventas de Empleado ,pasarlo de varchar a int
-- ALTER TABLE mydb.empleado ALTER COLUMN ventas TYPE INT
-- USING ventas::integer;


CREATE FUNCTION ventas() RETURNS trigger AS $ventas$
DECLARE
	ventas_cliente INT;
	--ventas_cliente NEW.ventas_cliente%TYPE;
BEGIN
	
	ventas_cliente := (SELECT total_ventas FROM mydb.cliente WHERE DNI = ( SELECT DNI_c FROM mydb.Producto_Empleado_Cliente WHERE DNI_e = NEW.DNI));
	IF ventas_cliente > NEW.ventas then 
		UPDATE mydb.empleado SET ventas = ventas_cliente;
		--RAISE EXCEPTION 'Debido a que la cantidad de ventas del empleado % no concuerdan con respecto al cliente del empleado, se ha modificado la columna' , OLD.DNI;
		return null;
	END IF;
	
	return null;
END;
$ventas$ LANGUAGE pLpgsql;


CREATE TRIGGER ventas AFTER INSERT OR UPDATE ON mydb.empleado
FOR ROW EXECUTE PROCEDURE ventas();


-- UPDATE mydb.empleado SET ventas = 6  WHERE DNI = 1111;
-- DROP TRIGGER ventas ON mydb.empleado;
-- DROP FUNCTION ventas();
