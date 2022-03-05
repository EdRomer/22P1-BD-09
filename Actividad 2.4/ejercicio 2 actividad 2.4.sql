select * from bd_sample.tbl_tickets_promo;
select * from bd_sample.tbl_facturas_selectas;

drop procedure bd_sample.SP_CREAR_TICKETS;

delimiter //
CREATE PROCEDURE bd_sample.SP_CREAR_TICKETS(
  in p_inicio int,
  in p_final  int
)

BEGIN
    declare  i int default 0;  
	declare  v_idticket  int ; 
	declare  v_idfactura int; 
	declare  v_numero_random int;
	declare  v_fecha_creacion datetime; 
    declare  v_fecha_emision datetime; 
    
    set i = p_inicio; 
    set v_idticket = null;
 

    

	select p_final;
    
      while i < p_final + 1 do 
      
		select  id_factura, fecha_emision
		into    v_idfactura, v_fecha_emision
		from bd_sample.tbl_facturas_selectas where orden = i;
        
        set v_numero_random = ceil( RAND()*(10000-0)+10000 );
        
        insert into bd_sample.tbl_tickets_promo( 
			idticket, idfactura, numero_random,	fecha_creacion)
		values( 
			v_idticket, 	v_idfactura,	v_numero_random, v_fecha_emision);
        
	set i = i+1; 
	end while;
    

END;

call  bd_sample.SP_CREAR_TICKETS(
   6, 10
)

select * from bd_sample.tbl_tickets_promo;
select * from bd_sample.tbl_facturas_selectas;