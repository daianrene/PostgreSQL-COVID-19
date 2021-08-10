

/*==============================================================*/
/*                   Inserciones Nivel 1			*/
/*==============================================================*/

insert into territorio.provincia values (1, 10, 'Santa Fe');
insert into territorio.provincia values (2, 12, 'Entre Rios');
insert into territorio.provincia values (3, 5, 'Buenos Aires');
insert into territorio.provincia values (4, 6, 'Formosa');

insert into casos.clasificacion values (1, 1, 'Critico');
insert into casos.clasificacion values (2, 2, 'Estandar');

insert into casos.actualizacionCasos values (1, '17-10-2020');
insert into casos.actualizacionCasos values (2, '11-09-2020');
insert into casos.actualizacionCasos values (3, '02-07-2020');

insert into casos.pais values (1, 'CH', 'Chile');
insert into casos.pais values (2, 'AR', 'Argentina');
insert into casos.pais values (3, 'UR', 'Uruguay');

insert into persona.tipoDomicilio values (1, 08, 'General');
insert into persona.tipoDomicilio values (2, 01, 'Real');

insert into persona.tipoPersonaJuridica values (1, 100, 'Sociedad Civil');
insert into persona.tipoPersonaJuridica values (2, 102, 'Sociedad Comercial');

insert into persona.funcion values (1, 50, 'Embajador');

insert into persona.tipoOrgEnt values (1, 123, 'Unidad de mando');
insert into persona.tipoOrgEnt values (2, 321, 'Filantropica');



/*==============================================================*/
/*                   Inserciones Nivel 2			*/
/*==============================================================*/

insert into territorio.departamento values (1, 1, 5, 'Santo Tome');
insert into territorio.departamento values (2, 1, 7, 'Rosario');
insert into territorio.departamento values (3, 2, 2, 'Parana');
insert into territorio.departamento values (4, 2, 3, 'La Paz');

insert into persona.persona(id_persona,nacionalidad,codigo,correoElectronico,fechaalta,telefonoMovil)
	values (1,2,1,'matisole123@gmail.com',current_date,'3425363115');
insert into persona.persona(id_persona,nacionalidad,codigo,correoElectronico,fechaalta,telefonoMovil)
	values (2,3,2,'daianrene99@gmail.com',current_date,'0800-DAY:)');
insert into persona.persona(id_persona,nacionalidad,codigo,correoElectronico,fechaalta,telefonoMovil)
	values (3,1,3,'facundozerruya@gmail.com',current_date,'SUERTE2020');

/*==============================================================*/
/*                   Inserciones Nivel 3			*/
/*==============================================================*/

insert into territorio.municipio values (1, 3, 7, 'Crespo');
insert into territorio.municipio values (2, 1, 10, 'Rosario');
insert into territorio.municipio values (3, 3, 1, 'Parana');
insert into territorio.municipio values (4, 1, 5, 'Santa Fe');

insert into casos.caso(id_caso,id_actualizacionCasos,id_clasificacion,residenciaDepto,residenciaPais,provinciaResidencia,provinciaDeCarga,identificacion,origenFinanciamiento,sexo,edad,unidadedad,fechaInicioSintomas,fechaApertura,fechaInternacion,cuidadoIntensivo,asistenciaRespMecanica,fechaDiagnostico)
	values (1,1,2,1,2,3,1,12,'privado','M',24,2,'17-08-2020','21-08-2020','22-08-2020',true,true,'23-08-2020');

insert into persona.contacto values (1,1,'Disponible de tarde','TM');
insert into persona.contacto values (2,2,'Disponible de tarde','TF');
insert into persona.contacto values (3,3,'Disponible de mañana','WP');
--Agregamos un contacto principal a persona
update persona.persona set contactoPrincipal = 1 where id_persona = 2;
update persona.persona set contactoPrincipal = 2 where id_persona = 1;

insert into persona.organismoEntidad values (1,21,1,2,'Dais INK.');
insert into persona.organismoEntidad values (2,78,2,1,'SoleGoogle');

insert into persona.personafisica values (1,'41698151','D', 2,'René', 'Daián', '26-03-1999', '17-10-2020','M','Mejor alumno de base de datos');
insert into persona.personafisica values (2,'41792321','D', 1,'Solé', 'Matias', '19-04-1999', null,'M','Peor alumno de base de datos');
insert into persona.personafisica values (3,'41123451','D', 3,'Serruya', 'Facundo', '02-11-1997', null,'M',null);

insert into persona.personaJuridica values (1,2,1,'2546663','Sole S.A.','Google');

/*==============================================================*/
/*                   Inserciones Nivel 4			*/
/*==============================================================*/

insert into persona.integraOrganismoEntidad values (1,1,2,2,45,null,'12-04-2003',null);

insert into territorio.localidad values (1,1,4,null,23,'Ciudad de Santa Fe');
insert into territorio.localidad values (2,3,3,null,26,'Ciudad de Parana');

/*==============================================================*/
/*                   Inserciones Nivel 5           		*/
/*==============================================================*/

insert into casos.determinacion values (1,1,'publico','17-04-2020',16000,1999);
insert into casos.determinacion values (2,2,'privado','17-04-2020',12532,547);

insert into persona.domicilio values (1, 1,1,2,56, 'Casa de estadia');
--Insertamos domilicio principal a persona
update persona.persona set domicilioPrincipal = 1 where id_persona = 3;

