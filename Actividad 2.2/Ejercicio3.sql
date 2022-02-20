########################## EjerciciO No3 ############################################

#Cree el procedimiento almacenado "sp_guardar_factura" que registre una  
#nueva factura según los parámetros recibidos.

select * from bd_sample.tbl_facturas;
DROP PROCEDURE bd_sample.SP_GUARDAR_FACTURA;

DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_sample.SP_GUARDAR_FACTURA(
	in p_id_factura      	int, 
    in p_fecha_emision      datetime,
    in p_id_subscriptor 	int,
    in p_numero_items 		int,
    in p_isv_total          decimal(12,2),
    in p_subtotal           decimal(12,2),
    in p_totapagar          decimal(12,2)
)
BEGIN
#definir variables

declare v_id_factura      	int;
declare v_fecha_emision     datetime;
declare v_id_subscriptor 	int;
declare v_numero_items 		int;
declare v_isv_total         decimal(12,2);
declare v_subtotal          decimal(12,2);
declare v_totapagar         decimal(12,2);


 #asignar valores de parametros a variables 
    set v_id_factura 		= p_id_factura;
	set v_fecha_emision	    = p_fecha_emision; 
    set v_id_subscriptor	= p_id_subscriptor;
    set v_numero_items 		= p_numero_items;
    set v_isv_total         = p_isv_total;
    set v_subtotal          = p_subtotal;
    set v_totapagar         = p_totapagar;
    
# crear factura

 insert into bd_sample.tbl_facturas (
   id_factura, fecha_emision, id_subscriptor, numero_items, isv_total, subtotal, totapagar
 )values(
    v_id_factura, v_fecha_emision,v_id_subscriptor,v_numero_items,v_isv_total,v_subtotal,v_totapagar
 );
 
 
 commit;
END;

# Ejecutar procedimiento 
CALL bd_sample.SP_GUARDAR_FACTURA(
	null, 					# p_id_factura  
	curdate(),    			# p_fecha_emision 
    12,				        # p_id_subscriptor			 
    0 ,				        # p_numero_items 
	0 ,				        # p_isv_total
	0 ,				        # p_subtotal
	0 				        # p_totapagar
);

#Buscar factura

select * 
from bd_sample.tbl_facturas
where fecha_emision =(select max(fecha_emision)
from bd_sample.tbl_facturas) and id_subscriptor=12;
