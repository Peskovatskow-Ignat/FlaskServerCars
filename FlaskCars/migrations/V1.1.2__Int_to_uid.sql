BEGIN;

create extension if not exists "uuid-ossp"; 

alter table cars_to_service 
	drop constraint cars_to_service_service_id_fkey;

alter table cars_to_service 
	drop constraint cars_to_service_cars_id_fkey;

alter table cars_to_service 
	rename service_id to old_service_id;
	
alter table cars_to_service 
	add column service_id uuid;



alter table service_cooperator 
	drop constraint service_cooperator_service_id_fkey;

alter table service_cooperator 
	rename column service_id to old_service_id;

alter table service_cooperator 
	add column service_id uuid;

alter table service  
	rename column id to old_id;
	
alter table service  
	add column id uuid default uuid_generate_v4();




do
$$
	declare 
	service_row record;
	begin 
		for service_row in select * from service
			loop
				update cars_to_service set service_id = service_row.id where old_service_id = service_row.old_id;
				update service_cooperator  set service_id = service_row.id where old_service_id = service_row.old_id;
			end loop;
		
	end
	
$$;


alter table service  
	drop constraint service_pkey;

alter table service 
	drop column old_id;
	
alter table service 
	add primary key (id);

alter table cars_to_service  
	drop column old_service_id;

alter table cars_to_service  
	add constraint fk_service_id foreign key (service_id) references service;


alter table service_cooperator  
	drop column old_service_id;

alter table service_cooperator   
	add constraint fk_service_id foreign key (service_id) references service;

commit;
