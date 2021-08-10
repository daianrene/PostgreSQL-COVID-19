-------Ejercicio 1--------


--Carga a importacion

copy importacion.provincia from 'C:\Users\Daian\Desktop\provincias.csv' with delimiter ',' CSV HEADER;
copy importacion.departamento from 'C:\Users\Daian\Desktop\departamentos.csv' with delimiter ',' CSV HEADER;
copy importacion.localidadescensales from 'C:\Users\Daian\Desktop\localidades-censales.csv' with delimiter ',' CSV HEADER;


---Funciones de carga a unidades territoriales

create or replace function impprovincia()
returns void
language plpgsql
as
$$
declare idaux integer := 0;
	provinciaux record;

begin
	for provinciaux in select id, nombre from importacion.provincia 
	LOOP
	if provinciaux is not null then
		insert into territorio.provincia values (idaux , provinciaux.id,provinciaux.nombre);
		idaux :=idaux+1;
	end if;
	end loop;
	insert into territorio.provincia values(idaux,99,'SIN ESPECIFICAR');
end;
$$;


create or replace function impdepartamento()
returns void
language plpgsql
as
$$
declare idaux integer := 0;
	departamentoaux record;
	fkprovincia integer;

begin
	for departamentoaux in select provincia_id, id, nombre from importacion.departamento 
	LOOP
	if departamentoaux is not null then
		select id_provincia into fkprovincia from territorio.provincia p where p.identificador = departamentoaux.provincia_id;
		insert into territorio.departamento values (idaux , fkprovincia, departamentoaux.id, departamentoaux.nombre);
		idaux :=idaux+1;
	end if;
	end loop;
end;
$$;


create or replace function implocalidad()
returns void
language plpgsql
as
$$
declare idaux integer := 0;
	localidadaux record;
	fkprovincia integer;
	fkdepartamento integer;

begin
	for localidadaux in select provincia_id, departamento_id, id, nombre from importacion.localidadescensales 
	LOOP
	if localidadaux is not null then
		select id_provincia into fkprovincia from territorio.provincia p where p.identificador = localidadaux.provincia_id;
		select id_departamento into fkdepartamento from territorio.departamento d where LPAD(cast(d.identificador as varchar(10)), 5, '0') = localidadaux.departamento_id;
		insert into territorio.localidad (id_localidad,id_provincia,id_departamento,identificador,nombre) values (idaux , fkprovincia, fkdepartamento, localidadaux.id, localidadaux.nombre);
		idaux :=idaux+1;
	end if;
	end loop;
end;
$$;



---Llamada a las funciones de cargas----
select impprovincia();
select impdepartamento();
select implocalidad();

---------------Pruebas de cargas-------------
select * from casos.pais;
select * from territorio.provincia;
select * from territorio.departamento;
select * from territorio.localidad;