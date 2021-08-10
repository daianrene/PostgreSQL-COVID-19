--------------------Ejercicio 5----------------------------------------------------------
create schema auditoria;

create table auditoria.log_auditoria(
	id_log_auditoria serial not null,
	identificador_territorio	integer	not null,
	usuario	varchar(60)	not null,
	fecha	date	not null,
	instruccion  varchar(20)  not null,
	valor_prev   varchar  null,
	valor_nuev   varchar  null
);

------------ Function Trigger -----------------------

create or replace function func_tr_Ej5()
returns trigger
language plpgsql
as
$$
declare valor_previo varchar;
	valor_nuevo varchar;
begin
	if (TG_OP = 'DELETE') THEN
		valor_previo := row(old.*);
		insert into auditoria.log_auditoria (identificador_territorio,usuario,fecha,instruccion,valor_prev,valor_nuev) values(old.identificador,user,current_date,TG_OP,valor_previo,null);
                 
	elsif (TG_OP = 'UPDATE') THEN
		valor_previo := row(old.*);
		valor_nuevo := row(new.*);
                 insert into auditoria.log_auditoria (identificador_territorio,usuario,fecha,instruccion,valor_prev,valor_nuev) values(old.identificador,user,current_date,TG_OP,valor_previo,valor_nuevo);

	elsif (TG_OP = 'INSERT') THEN
		valor_nuevo := row(new.*);
		insert into auditoria.log_auditoria (identificador_territorio,usuario,fecha,instruccion,valor_prev,valor_nuev) values(new.identificador,user,current_date,TG_OP,null,valor_nuevo);
	end if;
	return null;
end;
$$;

----------- Creacion de Triggers ------------	
	
create trigger tr_localidad
	after insert or update or delete
	on territorio.localidad
	for each row
execute procedure func_tr_Ej5();


create trigger tr_provincia
    after insert or update or delete
    on territorio.provincia
    for each row
execute procedure func_tr_Ej5();

create trigger tr_departamento
    after insert or update or delete
    on territorio.departamento
    for each row
execute procedure func_tr_Ej5();

create trigger tr_municipio
    after insert or update or delete
    on territorio.municipio
    for each row
execute procedure func_tr_Ej5();


------------- Prueba -----------

begin transaction;
insert into territorio.localidad values (-1,1,null,null,-20,'dai');
update territorio.localidad set nombre = 'mati' where id_localidad = -1;
delete from territorio.localidad where nombre = 'mati';

insert into territorio.provincia values (-1,1,'dai');
update territorio.provincia set nombre = 'mati' where id_provincia = -1;
delete from territorio.provincia where nombre = 'mati';

select * from auditoria.log_auditoria;