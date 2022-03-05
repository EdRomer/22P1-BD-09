drop procedure bd_sample.SP_CREAR_CADENA;
delimiter //
CREATE PROCEDURE bd_sample.SP_CREAR_CADENA(
   in p_max int 
)

BEGIN
    declare i             int default 0;  
    declare v_id_factura    varchar(25); 
    declare v_fecha_emision varchar(25);
    declare v_id_subscriptor varchar(25);
	declare lista varchar(2000);
    

    set lista = "";
    
    while i < p_max do 
		set i = i+1;
        
		select 
			id_factura, fecha_emision, id_subscriptor
		into 
			v_id_factura, v_fecha_emision, v_id_subscriptor
		from bd_sample.tbl_facturas where id_factura = i; 
        
        set lista = concat(lista,' ,[{',v_id_factura, ' , ' ,v_fecha_emision, ' , ' ,v_id_subscriptor, '}] ');
	
    end while;
    select lista;

END;

call SP_CREAR_CADENA( 5 );







	select *
	from bd_sample.tbl_facturas 