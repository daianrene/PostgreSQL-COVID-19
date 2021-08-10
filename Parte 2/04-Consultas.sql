-----------------Ejercicio 4-------------------------------------------

--------- Consulta 1 ---------------

select extract(month from cd.fechaRealizacion) as Mes, loc.nombre as Localidad, sum(cd.total) as Casos, sum(cd.positivos) as Positivos
	from casos.determinacion cd inner join  territorio.localidad loc on
		cd.id_localidad = loc.id_localidad
	group by Mes,Localidad;

--------- Consulta 2 ---------------


select (select count(*) * 2800 
		from casos.determinacion cd inner join territorio.localidad loc on
			cd.id_localidad = loc.id_localidad inner join territorio.provincia prov on
			prov.id_provincia = loc.id_provincia
			where origenFinanciamiento = 'Público' and prov.identificador in (2,6)) as "Inversion Amba", 
	(select count(*) * 2800 
		from casos.determinacion cd inner join territorio.localidad loc on
			cd.id_localidad = loc.id_localidad inner join territorio.provincia prov on
			prov.id_provincia = loc.id_provincia
			where origenFinanciamiento = 'Público' and prov.identificador not in (2,6)) as "Inversion Resto Pais";

--------- Consulta 3 ---------------


create type tp_Ej_4c
as(
	Provincia varchar(60),
	Mes double precision ,
	TestRealizados bigint,
	TestPositivos bigint,
	Confirmados bigint
);

create or replace function Ej_4c ()
returns setof tp_Ej_4c
language plpgsql
as
$$
declare

auxprov record;
auxmes record;
positivos integer;
realizados integer;
confirmados integer;
ultima_act integer := (select id_actualizacioncasos from casos.actualizacioncasos order by fechaactualizacion desc limit 1);
auxret tp_Ej_4c;

begin
    for auxprov in (select distinct id_provincia, nombre from territorio.provincia order by nombre)
    loop

        for auxmes in (select distinct(extract(month from d.fechaRealizacion)) as mes from territorio.provincia prov inner join territorio.localidad l on l.id_provincia=prov.id_provincia inner join
                                                            casos.determinacion d on d.id_localidad=l.id_localidad
                                                      where prov.id_provincia = auxprov.id_provincia order by extract(month from d.fechaRealizacion))
        loop

        select sum(cd.total), sum(cd.positivos) into realizados, positivos

                from casos.determinacion cd inner join  territorio.localidad loc on
                    cd.id_localidad = loc.id_localidad inner join territorio.provincia prov on
              loc.id_provincia = prov.id_provincia where prov.id_provincia = auxprov.id_provincia and extract(month from cd.fechaRealizacion) = auxmes.mes;

	select count(ca.*) into confirmados from casos.caso ca inner join territorio.provincia prov on
			prov.id_provincia = ca.provinciaresidencia
			where ca.id_clasificacion = 1 and
				ca.provinciaResidencia = auxprov.id_provincia and
				extract(month from ca.fechaApertura) = auxmes.mes and
				ca.id_actualizacioncasos = ultima_act;

        select auxprov.nombre , auxmes.mes , realizados , positivos , confirmados  into auxret;

	return next auxret;
        end loop;
    end loop;
   
end
$$;

SELECT *
 FROM Ej_4c();