delete from  casos.caso;
delete from  casos.determinacion;
delete from  casos.actualizacionCasos;
delete from  casos.clasificacion;


delete from  persona.INTEGRAORGANISMOENTIDAD ;
delete from  persona.organismoEntidad;
delete from  persona.PERSONAFISICA;
delete from  persona.PersonaJuridica;
delete from  persona.TipoOrgEnt;
delete from  persona.funcion;
delete from  persona.TIPOPERSONAJURIDICA;

update persona.persona set domicilioPrincipal = null , contactoPrincipal = null;

delete from  persona.contacto;
delete from  persona.domicilio;
delete from  persona.PERSONA ;

delete from persona.tipoDomicilio;

delete from territorio.localidad ;
delete from  territorio.municipio;
delete from territorio.departamento;
delete from territorio.provincia;

delete from  casos.pais;