ALTER TABLE casos.determinacion
DROP CONSTRAINT chk_origenFinanciamiento;

ALTER TABLE casos.determinacion
ADD CONSTRAINT chk_origenFinanciamiento check (origenFinanciamiento in ('Privado', 'Público','Sin Clasificar'));

alter table territorio.localidad ALTER COLUMN nombre TYPE varchar(120);


ALTER TABLE casos.caso
ALTER COLUMN unidadEdad TYPE varchar(20);

ALTER TABLE casos.caso
ALTER COLUMN origenFinanciamiento TYPE varchar(20);

ALTER TABLE casos.caso
DROP CONSTRAINT chk_origenFinanciamiento;

ALTER TABLE casos.caso
ADD CONSTRAINT chk_origenFinanciamiento check (origenFinanciamiento in ('Privado', 'Público','Sin Clasificar'));
---


create schema importacion;



-----Carga provincias-----
create table importacion.provincia
(
categoria varchar(30) not null,
centroide_lat decimal not null,
centroide_lon decimal not null,
fuente varchar(30) not null,
id integer not null,
iso_id varchar(30) not null,
iso_nombre varchar(120) not null ,
nombre varchar(120) not null,
nombre_completo varchar(120)
);


create table importacion.departamento
(
categoria varchar(120) not null,
centroide_lat decimal not null,
centroide_lon decimal not null,
fuente varchar(120) not null,
id integer not null,
nombre varchar(120) not null,
nombre_completo varchar(120) not null ,
provincia_id integer not null,
provincia_interseccion varchar(120) not null ,
provincia_nombre varchar(120) not null 
);


create table importacion.localidadescensales
(
categoria varchar(120) not null,
centroide_lat decimal not null,
centroide_lon decimal not null,
departamento_id varchar(10) not null,
departamento_nombre varchar(120) not null,
fuente varchar(120) not null ,
funcion varchar(120) not null,
id integer not null ,
municipio_id varchar(120) not null ,
municipio_nombre varchar(120) not null ,
nombre varchar(120) not null ,
provincia_id integer not null ,
provincia_nombre varchar(120) not null 
);

----------Ej 2-------------

create table importacion.determinacionesPCR
(
fecha  date not null,
provincia varchar(200) not null,
codigo_indec_provincia int not null,
departamento  varchar(200) not null,
codigo_indec_departamento int not null,
localidad varchar(200) not null,
codigo_indec_localidad int not null,
origen_financiamiento varchar(30) null,
tipo varchar(30) null,
ultima_actualizacion date not null,
total integer not null,
positivos integer null
);

---------------------Ej 3-------------------------
-----inserts pa pais y clasificacion----------
insert into casos.clasificacion values (1,1,'Confirmado'); 
insert into casos.clasificacion values (2,2,'Sospechoso');
insert into casos.clasificacion values (3,3,'Descartado');

insert into casos.pais values (1, 'GB','Reino Unido'); 
insert into casos.pais values (2,'GT','Guatemala');
insert into casos.pais values (3,'VE','Venezuela');
insert into casos.pais values (4, 'AR','Argentina');
insert into casos.pais values (5, 'CO','Colombia');
insert into casos.pais values (6, 'US','EE.UU.');
insert into casos.pais values (7,'FR','Francia');
insert into casos.pais values (8, 'UY','Uruguay');
insert into casos.pais values (9, 'LB','Líbano');
insert into casos.pais values (10,'PA' ,'Panamá'); 
insert into casos.pais values (11,'CU' ,'Cuba'); 
insert into casos.pais values (12,'EC' ,'Ecuador'); 
insert into casos.pais values (13,'BR' ,'Brasil'); 
insert into casos.pais values (14,'SE' ,'SIN ESPECIFICAR'); 
insert into casos.pais values (15,'PY' ,'Paraguay'); 
insert into casos.pais values (16,'DO' ,'República Dominicana'); 
insert into casos.pais values (17,'IL' ,'Israel'); 
insert into casos.pais values (18,'CL','Chile');
insert into casos.pais values (19,'CA','Canadá');
insert into casos.pais values (20,'MY','Malasia');
insert into casos.pais values (21,'PH','Filipinas');
insert into casos.pais values (22,'UR','Ucrania');
insert into casos.pais values (23,'BO','Bolivia');
insert into casos.pais values (24,'IE','Irlanda');
insert into casos.pais values (25,'IT','Italia');
insert into casos.pais values (26,'PT','Portugal');
insert into casos.pais values (27,'PE','Perú');
insert into casos.pais values (28,'NL','Países Bajos');
insert into casos.pais values (29,'BE','Bélgica');
insert into casos.pais values (30,'MX','México');
insert into casos.pais values (31,'DE','Alemania');
insert into casos.pais values (32,'ES','España');
insert into casos.pais values (33,'CN','China');
insert into casos.pais values (34,'AT','Austria');
insert into casos.pais values (35,'PL','Polonia');
insert into casos.pais values (36,'AU','Australia');



create table importacion.caso
(
id_evento_caso integer not null,
sexo varchar(20) not null,
edad  integer  null,
edad_años_meses varchar(20) null,
residencia_pais_nombre varchar(200) null,
residencia_provincia_nombre varchar(200) null,
residencia_departamento_nombre varchar(200) null,
carga_provincia_nombre varchar(200) null,
fecha_inicio_sintomas date null,
fecha_apertura  date null,
sepi_apertura  integer null,
fecha_internacion  date null,
cuidado_intensivo  varchar(2) null,
fecha_cui_intensivo  date null,
fallecido varchar(2) null,
fecha_fallecimiento date null,
asistencia_respiratoria_mecanica varchar(2) null,
carga_provincia_id  integer not null,
origen_financiamiento varchar(30) null,
clasificacion varchar(200) null,
clasificacion_resumen varchar(200) null,
residencia_provincia_id  integer not null,
fecha_diagnostico  date null,
residencia_departamento_id  integer not null,
ultima_actualizacion date not null
);

insert into casos.clasificacion values (4,4,'Sin Clasificar');


ALTER TABLE casos.caso ALTER COLUMN edad DROP NOT NULL;

ALTER TABLE casos.caso ALTER COLUMN fechainiciosintomas DROP NOT NULL;

ALTER TABLE casos.caso ALTER COLUMN fechadiagnostico DROP NOT NULL;

ALTER TABLE casos.caso ALTER COLUMN fechaapertura DROP NOT NULL;


