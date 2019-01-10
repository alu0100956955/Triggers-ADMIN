-- Trigger para controlar que una persona no resida en un piso y una vivienda unifamiliar a la vez

-- Si en medicamento indica que este medico es con ventaL , escribirlo en ventaL y eliminarlo de receta
CREATE FUNCTION reside_u() RETURNS trigger AS $reside_u$
BEGIN
	IF (SELECT DNI FROM mydb.reside_p ) = NEW.DNI then 
	DELETE FROM mydb.reside_u WHERE DNI=NEW.DNI;
	return null;
	END IF;
	
	return null;
END;
$reside_u$ LANGUAGE pLpgsql;


CREATE TRIGGER reside_u AFTER INSERT OR UPDATE ON mydb.reside_u
FOR ROW EXECUTE PROCEDURE reside_u();
