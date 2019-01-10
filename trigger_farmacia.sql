-- Trigger para controlar que un medicamento sea o ventaL o Receta

-- Si en medicamento indica que este medico es con ventaL , escribirlo en ventaL y eliminarlo de receta
CREATE FUNCTION receta() RETURNS trigger AS $receta$
BEGIN
	IF (SELECT tipo FROM mydb.medicamentos WHERE codigo = NEW.codigo)  <> 'receta' then 
	INSERT INTO mydb.ventaL VALUES (NEW.codigo,NEW.nombre);
	DELETE FROM mydb.receta WHERE codigo=NEW.codigo;
	return null;
	END IF;
	
	return null;
END;
$receta$ LANGUAGE pLpgsql;


CREATE TRIGGER receta AFTER INSERT OR UPDATE ON mydb.receta
FOR ROW EXECUTE PROCEDURE receta();


-- Si en medicamento indica que este medicamento es con receta , escribirlo en receta y eliminarlo de ventaL
CREATE FUNCTION venta() RETURNS trigger AS $venta$
BEGIN
	IF (SELECT tipo FROM mydb.medicamentos WHERE codigo = NEW.codigo)  <> 'ventaL' then 
	INSERT INTO mydb.receta VALUES (NEW.codigo,NEW.nombre);
	DELETE FROM mydb.ventaL WHERE codigo=NEW.codigo;
	return null;
	END IF;
	
	return null;
END;
$venta$ LANGUAGE pLpgsql;


CREATE TRIGGER venta AFTER INSERT OR UPDATE ON mydb.ventaL
FOR ROW EXECUTE PROCEDURE venta();

--Para modificar  la funcion 
-- Primero eliminar el trigger y despues la funcion

--DROP TRIGGER receta ON mydb.receta;
--DROP FUNCTION receta();
