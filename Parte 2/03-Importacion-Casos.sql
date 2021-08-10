---------------------------Ejercicio 2-----------------------------------

CREATE OR REPLACE FUNCTION importar_determinaciones(
    ruta varchar,
    nombre varchar)    
 RETURNS varchar
LANGUAGE plpgsql 
 AS
 $$
DECLARE
 v_rutaMasNombre varchar(200);
 vCantFilas integer;
 msj_salida varchar;

determinacionaux record;
idaux integer := (select id_determinacion from casos.determinacion order by id_determinacion desc limit 1)+1;
localidadaux integer;
id_localidadaux integer;
fecha_aux date := (select fechaRealizacion from casos.determinacion order by fechaRealizacion desc limit 1);

BEGIN
v_rutaMasNombre = ruta || '\' || nombre;
EXECUTE 'copy importacion.determinacionesPCR from '''||v_rutaMasNombre||''' with delimiter '','' CSV HEADER '; 
SELECT COUNT(1) INTO vCantFilas FROM casos.determinacion;
update importacion.determinacionesPCR set positivos=0 where positivos is null;


if fecha_aux is null then fecha_aux := '2019-12-31'; end if;
if idaux is null then idaux:=0; end if;
for determinacionaux in select codigo_indec_provincia, codigo_indec_departamento, codigo_indec_localidad, origen_financiamiento, fecha ,total , positivos from importacion.determinacionesPCR where fecha > fecha_aux
	LOOP
	localidadaux := cast (concat(LPAD(determinacionaux.codigo_indec_provincia::text, 2, '0'), LPAD(determinacionaux.codigo_indec_departamento::text, 3, '0'), LPAD(determinacionaux.codigo_indec_localidad::text, 3, '0')) as integer);
	id_localidadaux := (select id_localidad from territorio.localidad where localidadaux = cast(LPAD(identificador::text,8,'0') as integer));
	if  (id_localidadaux is not null and not exists (select * from casos.determinacion cd where cd.id_localidad = id_localidadaux and
													cd.origenFinanciamiento = determinacionaux.origen_financiamiento and
													cd.fechaRealizacion = determinacionaux.fecha)) then
		insert into casos.determinacion values (idaux,id_localidadaux, determinacionaux.origen_financiamiento, determinacionaux.fecha ,determinacionaux.total , determinacionaux.positivos) ;	 
		idaux := idaux+1;
	end if;
	end loop;

	delete from importacion.determinacionesPCR;
	vCantFilas := (SELECT COUNT(1) FROM casos.determinacion) - vCantFilas;
	msj_salida := 'Operacion Exitosa: Se insertaron ' || vCantFilas || ' filas.';
	return msj_salida;
	
 END;
 $$;

select importar_determinaciones( 'C:\Users\Daian\Desktop', '1.Covid19Determinaciones.csv');
select importar_determinaciones( 'C:\Users\Daian\Desktop', '2.Covid19Determinaciones.csv');
select importar_determinaciones( 'C:\Users\Daian\Desktop', '3.Covid19Determinaciones.csv');

select * from casos.determinacion;

------------------Ejercicio 3 --------------------------------------------

CREATE TYPE result_imp_caso
 AS (
   codigo_resultado int, -- 0 sin errores
   texto_resultado varchar(300),
   cant_filas int, -- cant filas importadas
   texto_detalle varchar
 ); 


CREATE OR REPLACE FUNCTION importar_casos(
    ruta varchar,
    nombre varchar)     
RETURNS result_imp_caso
LANGUAGE plpgsql
 AS
 $$
DECLARE
	result result_imp_caso;
	vCantFilas integer;
	v_rutaMasNombre varchar(200);

	id_casoaux integer := (select id_caso from casos.caso order by id_caso desc limit 1)+1;
	id_actaux integer := (select id_actualizacioncasos from casos.ActualizacionCasos order by id_actualizacioncasos desc limit 1)+1;
	id_clasaux integer;
	id_paisaux integer;
	id_dpto integer;
	casosaux record;
	contadorAux integer := 0;
BEGIN
	v_rutaMasNombre = ruta || '\' || nombre;
	EXECUTE 'copy importacion.caso from '''||v_rutaMasNombre||''' with delimiter '','' CSV HEADER '; 
	
	result.texto_detalle := '';
	if id_casoaux is null then id_casoaux:=0; end if;
	if id_actaux is null then id_actaux:=0; end if;

	insert into casos.actualizacioncasos values(id_actaux, current_Date);

	for casosaux in select residencia_pais_nombre, clasificacion_resumen,residencia_departamento_nombre, residencia_provincia_id, carga_provincia_id, id_evento_caso, origen_financiamiento, sexo, edad, edad_años_meses, fecha_inicio_sintomas, fecha_apertura, fecha_internacion, cuidado_intensivo, fecha_fallecimiento, asistencia_respiratoria_mecanica, fecha_diagnostico from importacion.caso
	LOOP
		
		
		if (extract(year from casosaux.fecha_apertura) > 2019) then
		
			select id_clasificacion into id_clasaux from casos.clasificacion where descripcion = casosaux.clasificacion_resumen;								
			select p.id_pais into id_paisaux from casos.pais p where p.nombre = casosaux.residencia_pais_nombre;	

			casosaux.residencia_provincia_id := (select id_provincia from territorio.provincia where identificador = casosaux.residencia_provincia_id);
			casosaux.carga_provincia_id := (select id_provincia from territorio.provincia where identificador = casosaux.carga_provincia_id);
			select d.id_departamento into id_dpto from territorio.departamento d where casosaux.residencia_departamento_nombre = d.nombre and d.id_provincia = casosaux.residencia_provincia_id;

			if(casosaux.origen_financiamiento not in ('Público', 'Privado', 'Sin Clasificar')) then
				result.texto_detalle := result.texto_detalle || ' - No se pudo insertar el caso ' || casosaux.id_evento_caso || ' ya que se 
											recibió el valor "'||casosaux.origen_financiamiento||'" en el campo Origen de financiamiento, y no está registrado previamente.';
			else
			if(casosaux.residencia_provincia_id is not null and casosaux.carga_provincia_id is not null and id_paisaux is not null and id_clasaux is not null and casosaux.origen_financiamiento is not null) then
	
				insert into casos.caso values (id_casoaux, id_actaux,id_clasaux, id_dpto, id_paisaux, casosaux.residencia_provincia_id, casosaux.carga_provincia_id, casosaux.id_evento_caso, casosaux.origen_financiamiento, cast(casosaux.sexo as varchar(1)), casosaux.edad, casosaux.edad_años_meses, casosaux.fecha_inicio_sintomas, casosaux.fecha_apertura, casosaux.fecha_internacion, CASE  WHEN casosaux.cuidado_intensivo = 'SI' THEN true ELSE false END, casosaux.fecha_fallecimiento, CASE   WHEN casosaux.asistencia_respiratoria_mecanica = 'SI' THEN true  ELSE false END, casosaux.fecha_diagnostico);	 
				id_casoaux := id_casoaux+1;
				contadorAux := contadorAux +1;
			else
				result.texto_detalle := result.texto_detalle || ' - No se pudo insertar el caso ' || casosaux.id_evento_caso || ' ya que le faltan datos obligatorios o son incorrectos';
			end if;
			end if;
		else
			result.texto_detalle := result.texto_detalle || ' - No se pudo insertar el caso ' || casosaux.id_evento_caso || ' ya que su fecha es anterior al 2020 o es null';
		end if;
	end loop;

	  SELECT COUNT(1) INTO vCantFilas FROM importacion.caso;
	  result.cant_filas := contadorAux;
	  IF (vCantFilas = contadorAux) Then
	     result.codigo_resultado := 0;
	     result.texto_resultado := 'Importación completa';
	     result.texto_detalle := 'Importación de archivos: IMPORTACION COMPLETA. Archivo: ' || $2 || ' - ' || to_char(current_timestamp,'DD/MM/YYYY - HH24:MI:SS');
	  ELSE 
	     result.codigo_resultado := -1;
	     result.texto_resultado := 'Importación errónea o incompleta';
	  END IF;

	delete from importacion.caso;
	
  RETURN result;
 END;
 $$;

select * from importar_casos('C:\Users\Daian\Desktop', 'Covid19Casos (1).csv');

