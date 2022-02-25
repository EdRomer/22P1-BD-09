select * from tbl_items_factura;
delimiter //
CREATE PROCEDURE sp_procesar_factura(
    in p_id_factura int,
    in p_id_producto int,
    in p_cantidad int,
    
)
BEGIN
    declare v_id_factura        int;
    declare v_id_producto       int;
    declare v_cantidad          int;
    declare v_numero_items      int;
    declare v_precio_prod       decimal(12,2);
    
    set v_id_factura = p_id_factura;
    set v_id_producto = p_id_producto;
    set v_cantidad = p_cantidad;
    set v_numero_items      = 0;
    set v_precio_prod       = 0.0;
    
    
    insert tbl_items_factura (id_factura,id_producto,cantidad)
    values (v_id_factura,v_id_producto,v_cantidad);
    
    select sum(cantidad) into v_numero_items
    from bd_sample.tbl_items_factura 
    where id_factura = v_id_factura; 

    select precio_venta into v_precio_prod  
    from bd_sample.tbl_productos 
    where id_producto = v_id_producto; 

    update tbl_facturas
    Set numero_item = v_numero_items,
        isv_total   = (subtotal + v_precio_prod*v_cantidad)*0.15,
        subtotal    =  subtotal + v_precio_prod*v_cantidad,
	totapagar=     (subtotal)*1.15
    where id_factura=v_idFactura;
    
    commit;
    
END;
