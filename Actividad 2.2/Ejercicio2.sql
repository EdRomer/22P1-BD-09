
delimiter $$
drop procedure if exists
sp_guardar_producto$$
CREATE PROCEDURE sp_guardar_producto(
in p_nombreIN varchar(45),
in p_descripcionIN varchar (45),
in p_precio_costoIN decimal(12,2)
in p_precio_ventaIN decimal(12,2)
)
 
declare v_nombreIN varchar(45);
declare v_descripcionIN varchar (45);
declare v_precio_costoIN decimal(12,2);
declare v_precio_ventaIN decimal(12,2);

set v_nombreIN = p_nombreIN
set v_descripcionIN = p_descripcionIN
set v_precio_costoIN = p_precio_costoIN
set v_precio_ventaIN = p_precio_ventaIN


begin 
set precio_ventaIN=precio_costoIN+
(precio_costoIN*0.25);

insert into tbl_productos (nombre,descripcion,precio_costo,precio_venta);

values(nombreIN, descripcionIN,
precio_costoIN,precio_ventaIN);

commit;

end $$
