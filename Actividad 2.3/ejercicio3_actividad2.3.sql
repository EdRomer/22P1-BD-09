

########################## EjerciciO No3 #################### Jose Danilo Rivera  202101607 ########################
#3.Modifique el procedimiento "sp_procesar_factura" de manera que utilice el procedimiento sp_guardar_factura
# creado en el inciso anterior, para actualizar los valores de la factura, cada vez que se registre un nuevo producto.

select * from bd_sample.tbl_facturas;
DROP PROCEDURE bd_sample.SP_GUARDAR_FACTURA;

DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_sample.SP_GUARDAR_FACTURA(
	in p_id_factura      	int, 
    in p_fecha_emision      datetime,
    in p_id_subscriptor 	int,
	in p_id_producto        int,
    in p_cantidad           int     
  
)

BEGIN
#definir variables

declare v_id_factura      	int;
declare v_fecha_emision     datetime;
declare v_id_subscriptor 	int;
declare v_numero_items 		int default 0;
declare v_isv_total         decimal(12,2) default 0;
declare v_subtotal          decimal(12,2) default 0;
declare v_totapagar         decimal(12,2) default 0;
declare v_precio_prod       decimal(12,2) default 0;
declare v_id_producto       int;
declare v_cantidad 	        int;


 #asignar valores de parametros a variables 
    set v_id_factura 		= p_id_factura;
	set v_fecha_emision	    = p_fecha_emision; 
    set v_id_subscriptor	= p_id_subscriptor;
    set v_id_producto       = p_id_producto;
    set v_cantidad 	        = p_cantidad;
    
#controlador if
	if not exists(select * from bd_sample.tbl_facturas where id_factura = v_id_factura) then  
	# crear factura
        
         select precio_venta into v_precio_prod  
		 from bd_sample.tbl_productos 
		 where id_producto = v_id_producto; 
         
		 set v_numero_items = numero_items+p_cantidad;
         set v_subtotal    = p_cantidad*v_precio_prod;
         set v_isv_total   = v_subtotal*0.15;
         set v_totapagar   = v_subtotal*1.15;
         
		 insert into bd_sample.tbl_facturas (
		   id_factura, fecha_emision, id_subscriptor, numero_items, isv_total, subtotal, totapagar
		 )values(
			v_id_factura, v_fecha_emision,v_id_subscriptor,v_numero_items,v_isv_total,v_subtotal,v_totapagar
		 );
	else
	   insert bd_sample.tbl_items_factura (id_factura,id_producto,cantidad)
		values (v_id_factura,v_id_producto,v_cantidad);
		
		select sum(cantidad) into v_numero_items
		from bd_sample.tbl_items_factura 
		where id_factura = v_id_factura; 

		select precio_venta into v_precio_prod  
		from bd_sample.tbl_productos 
		where id_producto = v_id_producto; 

		update  bd_sample.tbl_facturas
		Set numero_items = v_numero_items,
			fecha_emision =v_fecha_emision,
			isv_total   = (subtotal + v_precio_prod*v_cantidad)*0.15,
			subtotal    =  subtotal + v_precio_prod*v_cantidad,
		totapagar=     (subtotal)*1.15
		where id_factura = v_id_factura;
	end if;
 
 commit;
END;

# Ejecutar procedimiento 
CALL bd_sample.SP_GUARDAR_FACTURA(
	39, 					# p_id_factura  
	curdate(),    			# p_fecha_emision 
   19,				        # p_id_subscriptor			 
	3 ,				        # p_id_producto
	2                     # p_cantidad
);

#Buscar id subscriptor

select * 
from bd_sample.tbl_facturas
where fecha_emision =(select max(fecha_emision)
from bd_sample.tbl_facturas) and id_subscriptor=12;

select * 
from bd_sample.tbl_items_factura;




#4.Modifique el procedimiento "sp_procesar_factura" de manera que utilice el procedimiento sp_guardar_factura 
#creado en el inciso anterior, para actualizar los valores de la factura, cada vez que se registre un nuevo producto.



