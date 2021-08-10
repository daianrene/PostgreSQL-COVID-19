/*==============================================================*/
/*                    Esquema Territorio			*/
/*==============================================================*/
create schema territorio;

/*==============================================================*/
/*                    Nivel 1					*/
/*==============================================================*/
create table territorio.provincia
(
   id_provincia         int                            not null,
   identificador        int                            not null,
   nombre               varChar(60)                    not null,
   constraint pk_provincia primary key (id_provincia),
   constraint uk_provincia unique (identificador)
);

/*==============================================================*/
/*                    Nivel 2					*/
/*==============================================================*/

create table territorio.departamento(
id_departamento		int				not null,
id_provincia		int				not null,
identificador		int				not null,
nombre			varchar(60)			not null,

constraint pk_departamento primary key (id_departamento),
constraint fk_departamento_provincia foreign key (id_provincia) references territorio.provincia (id_provincia),
constraint uk_departamento unique (identificador, id_provincia)
);

create index idx_departamento_provincia on territorio.departamento (id_provincia);

/*==============================================================*/
/*                    Nivel 3					*/
/*==============================================================*/

create table territorio.municipio(
id_municipio		int				not null,
id_departamento		int				null,
identificador		int				not null,
nombre			varchar(60)			not null,

constraint pk_municipio primary key (id_municipio),
constraint fk_municipio_departamento foreign key (id_departamento) references territorio.departamento (id_departamento),
constraint uk_municipio unique (identificador)
);

create index idx_municipio_departamento on territorio.municipio (id_departamento);

/*==============================================================*/
/*                    Nivel 4					*/
/*==============================================================*/

create table territorio.localidad 
(
   id_localidad         int                            not null,
   id_provincia         int                            not null,
   id_municipio         int                            null,
   id_departamento      int                            null,
   identificador        int                            not null,
   nombre               varChar(60)                    not null,
   constraint pk_localidad primary key (id_localidad),
   constraint uk_localidad unique (identificador, id_provincia),
   constraint fk_localidad_provincia foreign key (id_provincia) references territorio.provincia (id_provincia),
   constraint fk_localidad_municipio foreign key (id_municipio) references territorio.municipio (id_municipio),
   constraint fk_localidad_departamento foreign key (id_departamento) references territorio.departamento (id_departamento)
);
   create index idx_localidad_provincia on territorio.localidad (id_provincia);
   create index idx_localidad_municipio on territorio.localidad (id_municipio);
   create index idx_localidad_departamento on territorio.localidad (id_departamento);

/*==============================================================*/
/*                    Esquema Casos				*/
/*==============================================================*/
create schema casos;

/*==============================================================*/
/*                    Nivel 1					*/
/*==============================================================*/

create table casos.clasificacion(
id_clasificacion 	int			not null,
codigo			int			not null,
descripcion		varchar			not null,
constraint pk_clasificacion primary key (id_clasificacion),
constraint uk_clasificacion unique (codigo)
);


create table casos.actualizacionCasos(
id_actualizacionCasos 	int			not null,
fechaActualizacion	date			not null,
constraint pk_actualizacioncasos primary key (id_actualizacionCasos),
constraint uk_actualizacionCasos unique (fechaActualizacion)
);


create table casos.pais(
id_pais		 	int			not null,
codigo			char(2)			not null,
nombre			varchar(60)		not null,
constraint pk_pais primary key (id_pais),
constraint uk_pais unique (codigo)
);

/*==============================================================*/
/*                    Nivel 3					*/
/*==============================================================*/

create table casos.caso
(
   ID_CASO              int                            not null,
   id_actualizacionCasos int                            not null,
   ID_CLASIFICACION     int                            not null,
   RESIDENCIADEPTO       int                            null,
   RESIDENCIAPAIS       int                            not null,
   PROVINCIARESIDENCIA  int                            not null,
   PROVINCIADECARGA     int                            not null,
   IDENTIFICACION       int                           not null,
   ORIGENFINANCIAMIENTO varChar(7)                     not null,
   SEXO                 varChar(1)                     not null,
   EDAD                 int                            not null,
   UNIDADEDAD           int                            not null,
   FECHAINICIOSINTOMAS  Date                           not null,
   FECHAAPERTURA        Date                           not null,
   FECHAINTERNACION     Date                           null,
   CUIDADOINTENSIVO     Boolean                        not null,
   FECHAFALLECIDO       Date                           null,
   ASISTENCIARESPMECANICA Boolean                      not null,
   FECHADIAGNOSTICO     Date                           not null,
   constraint PK_CASO primary key (ID_CASO),
   constraint UK_CASO unique (IDENTIFICACION, id_actualizacionCasos),
   constraint fk_caso_actualizacionCasos foreign key (id_actualizacionCasos) references casos.actualizacionCasos (id_actualizacionCasos),
   constraint fk_caso_clasificacion foreign key (id_clasificacion) references casos.clasificacion (id_clasificacion),
   constraint fk_caso_departamento foreign key (residenciaDepto) references territorio.departamento (id_departamento),
   constraint fk_caso_pais foreign key (residenciaPais) references casos.pais (id_pais),
   constraint fk_caso_provincia_1 foreign key (provinciaResidencia) references territorio.provincia (id_provincia),
   constraint fk_caso_provincia_2 foreign key (provinciaDeCarga) references territorio.provincia (id_provincia),
   constraint chk_origenFinanciamiento check (origenFinanciamiento in ('privado', 'publico'))
);
   create index idx_caso_actualizacionCasos on casos.caso (id_actualizacionCasos);
   create index idx_caso_clasificacion on casos.caso (id_clasificacion);
   create index idx_caso_departamento on casos.caso (residenciaDepto);
   create index idx_caso_pais on casos.caso (residenciaPais);
   create index idx_caso_provincia_1 on casos.caso (provinciaResidencia);
   create index idx_caso_provincia_2 on casos.caso (provinciaDeCarga);


/*==============================================================*/
/*                    Nivel 5					*/
/*==============================================================*/

create table casos.determinacion(
id_determinacion 	int 			not null,
id_localidad 		int			not null,
origenFinanciamiento 	varChar(7)		not null,
fechaRealizacion 	date 			not null,
total 			int 			not null,
positivos 		int 			not null,

constraint pk_determinacion primary key (id_determinacion),
constraint chk_origenFinanciamiento check (origenFinanciamiento in ('privado', 'publico')),
constraint fk_determinacion_localidad foreign key (id_localidad) references territorio.localidad (id_localidad),
constraint uk_determinacion unique (id_localidad,origenFinanciamiento,fechaRealizacion)
);

create index idx_determinacion_localidad on casos.determinacion (id_localidad);

/*==============================================================*/
/*                    Esquema Persona				*/
/*==============================================================*/
create schema persona;

/*==============================================================*/
/*                    Nivel 1					*/
/*==============================================================*/

create table persona.tipoDomicilio(
id_tipoDomicilio	int		not null,
codigoTipoDomicilio	smallint	not null,
nombreTipoDomicilio	varchar(60)	not null,
constraint pk_tipoDomicilio primary key (id_tipoDomicilio),
constraint uk_tipoDomicilio unique (codigoTipoDomicilio)
);

create table persona.TIPOPERSONAJURIDICA (
ID_TIPOPERSONAJURIDICA	int             not null,
CODIGO			smallint        not null,
NOMBRETIPOPJ		varChar(60)     not null,
constraint PK_TIPOPERSONAJURIDICA primary key (ID_TIPOPERSONAJURIDICA),
constraint uk_tipoPersonaJuridica unique (CODIGO)
);



create table persona.funcion(
id_funcion 		int 		not null,
codigo  		smallint 	not null,
nombre     		varchar(60) 	not null,

constraint pk_funcion primary key (id_funcion),
constraint uk_funcion unique (codigo)
);


create table persona.TipoOrgEnt(
id_TipoOrgEnt 		int  		not null,
codigo  		int 		not null,
nombreTipoOrgEnt	varChar(60) 	not null,

constraint pk_TipoOrgEnt primary key (id_TipoOrgEnt),
constraint uk_TipoOrgEnt unique (codigo)
);

/*==============================================================*/
/*                    Nivel 2					*/
/*==============================================================*/

create table persona.PERSONA 
(
   ID_PERSONA           int                            not null,
   NACIONALIDAD         int                            not null,
   CONTACTOPRINCIPAL    int                            null,
   DOMICILIOPRINCIPAL   int                            null,
   CODIGO               int                            not null,
   CORREOELECTRONICO    varChar                        null,
   FECHAALTA            Date                           not null,
   FECHABAJA            Date                           null,
   TELEFONO             varChar                        null,
   TELEFONOMOVIL        varChar                        null,
   constraint PK_PERSONA primary key (ID_PERSONA),
   constraint uk_persona unique (CODIGO),
   constraint fk_persona_pais foreign key (nacionalidad) references casos.pais (id_pais)
);

create index idx_persona_pais on persona.persona (nacionalidad);
create index idx_persona_contacto on persona.persona (contactoPrincipal);
create index idx_persona_domicilio on persona.persona (domicilioPrincipal);

/*==============================================================*/
/*                    Nivel 3					*/
/*==============================================================*/
create table persona.contacto(
id_contacto 		int  		not null,
id_persona 		int  		not null,
datalleContacto 	Varchar(120) 	not null,
TipoContacto 		Varchar(30) 	not null,

constraint pk_contacto primary key (id_contacto),
constraint fk_contacto_persona foreign key (id_persona) references persona.persona (id_persona),
constraint uk_contacto unique (id_persona),
constraint chk_tipoContacto check (tipoContacto in ('CE', 'TM' ,'TF', 'WP', 'OT'))
);

create index idx_contacto_persona on persona.persona(id_persona);
alter table persona.persona add constraint fk_persona_contactoPrincipal foreign key (contactoPrincipal) references persona.contacto (id_contacto);

create table persona.organismoEntidad(
id_organismoEntidad	int		not null,
codigo			int		not null,
id_tipoOrgEnt		int		not null,
id_persona		int		not null,
nombre			varchar		not null,
constraint pk_organismoEntidad primary key (id_organismoEntidad),
constraint uk_organismoEntidad unique (codigo),
constraint uk_organismoEntidad_persona unique (id_persona),
constraint fk_organismoEntidad_tipoOrgEnt foreign key (id_tipoOrgEnt) references persona.tipoOrgEnt (id_tipoOrgEnt),
constraint fk_organismoEntidad_persona foreign key (id_persona) references persona.persona (id_persona)
);

create index idx_organismoEntidad_tipoOrgEnt on persona.organismoEntidad (id_tipoOrgEnt);
create index idx_organismoEntidad_persona on persona.organismoEntidad (id_persona);

create table persona.PERSONAFISICA
(
   ID_PERSONAFISICA     int                            not null,
   NUMERODOCUMENTO      int                            not null,
   TIPODOCUMENTO        Char(1)                        not null,
   ID_PERSONA           int                            not null,
   APELLIDO             varChar(120)                   not null,
   NOMBRE               varChar(120)                   not null,
   FECHANACIMIENTO      Date                           null,
   FECHAMUERTE          Date                           null,
   SEXO                 varChar(30)                    not null,
   OBSERVACIONES        varChar(120)                   null,
   constraint PK_PERSONAFISICA primary key (ID_PERSONAFISICA),
   constraint uk_personaFisica unique (NUMERODOCUMENTO, TIPODOCUMENTO),
   constraint uk_personaFisica_persona unique (ID_PERSONA),
   constraint fk_personaFisica_persona foreign key (id_persona) references persona.persona (id_persona),
   constraint chk_tipoDocumento check (tipoDocumento in ( 'D','E','C','P','N'))
);
   create index idx_personaFisica_persona on persona.personaFisica (id_persona);


create table persona.PersonaJuridica(
id_personaJuridica 	int 			not null,
id_persona 		int 			not null,
id_tipoPersonaJuridica 	int 			not null,
cuit 			Varchar(60) 		not null,
razonSocial		Varchar(120) 		not null,
nombreFantasia 		Varchar(120)  		null,

constraint pk_determinacion primary key (id_personaJuridica),
constraint fk_PersonaJuridica_Persona foreign key (id_persona) references persona.persona(id_persona),
constraint fk_PersonaJuridica_TipoPersonaJuridica foreign key (id_tipoPersonaJuridica) references persona.TipoPersonaJuridica(id_tipoPersonaJuridica),
constraint uk_PersonaJuridica_persona unique (id_persona),
constraint uk_PersonaJuridica  unique (cuit)
);

create index idx_PersonaJuridica_persona on persona.personaJuridica(id_persona);
create index idx_PersonaJuridica_TipoPersonaJuridica on persona.personaJuridica (id_tipoPersonaJuridica);


/*==============================================================*/
/*                    Nivel 4					*/
/*==============================================================*/

create table persona.INTEGRAORGANISMOENTIDAD 
(
   ID_INTEGRAORGANISMOENTIDAD int                      not null,
   ID_FUNCION           int                            not null,
   ID_PERSONAFISICA     int                            not null,
   ID_ORGANISMOENTIDAD  int                            not null,
   ITEM                 int                            not null,
   OBSERVACIONES        varChar(120)                   null,
   FECHAALTA            Date                           not null,
   FECHABAJA            Date                           null,
   constraint PK_INTEGRAORGANISMOENTIDAD primary key (ID_INTEGRAORGANISMOENTIDAD),
   constraint uk_integraOrganismoEntidad unique (id_organismoEntidad, item),
   constraint fk_integraOrganismoEntidad_funcion foreign key (id_funcion) references persona.funcion (id_funcion),
   constraint fk_integraOrganismoEntidad_organismoEntidad foreign key (id_organismoEntidad) references persona.organismoEntidad (id_organismoEntidad),
   constraint fk_integraOrganismoEntidad_personaFisica foreign key (id_personaFisica) references persona.personaFisica (id_personaFisica)
);

   create index idx_integraOrganismoEntidad_funcion on persona.integraOrganismoEntidad (id_funcion);
   create index idx_integraOrganismoEntidad_organismoEntidad on persona.integraOrganismoEntidad (id_organismoEntidad);
   create index idx_integraOrganismoEntidad_personaFisica on persona.integraOrganismoEntidad (id_personaFisica);
   
/*==============================================================*/
/*                    Nivel 5					*/
/*==============================================================*/

create table persona.domicilio(
id_domicilio		int		not null,
id_persona		int		not null,
id_localidad		int		not null,
id_tipoDomicilio	int		not null,
item			int		not null,
observaciones		varchar(120)	not null,
constraint pk_domicilio primary key (id_domicilio),
constraint uk_domicilio unique (id_persona,item),
constraint fk_domicilio_persona foreign key (id_persona) references persona.persona (id_persona),
constraint fk_domicilio_localidad foreign key (id_localidad) references territorio.localidad (id_localidad),
constraint fk_domicilio_tipodomicilio foreign key (id_tipoDomicilio) references persona.tipoDomicilio (id_tipoDomicilio)
);

create index idx_domicilio_persona on persona.domicilio (id_persona);
create index idx_domicilio_localidad on persona.domicilio (id_localidad);
create index idx_domicilio_tipoDomicilio on persona.domicilio (id_tipoDomicilio);

alter table persona.persona add constraint fk_persona_domicilioPrincipal foreign key (domicilioPrincipal) references persona.domicilio (id_domicilio)