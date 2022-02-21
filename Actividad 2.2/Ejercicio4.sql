select * from tbl_items_factura;
delimiter //
CREATE PROCEDURE sp_guardar_subscriptor(
	in p_idFactura int,
    in p_idProducto int,
    in p_Cantidad int,
    in p_precio int
)
BEGIN
	declare v_idFactura int;
    declare v_idProducto int;
    declare v_Cantidad int;
    declare v_precio int;
    
    set v_idFactura = p_idFactura;
    set v_idProducto = p_idProducto;
    set v_Cantidad = p_Cantidad;
    set v_precio = p_precio;
    
    
    insert tbl_items_factura (id_factura,id_subscriptor,cantidad)
    values (v_idFactura,v_idProducto,v_Cantidad);
    
    update tbl_facturas
    Set numero_item=numero_item+1,subtotal= subtotal + v_precio, isv_total= (subtotal + v_precio)*0.15, totapagar=(subtotal + v_precio)*1.15
    where id_factura=v_idFactura;
    
END;