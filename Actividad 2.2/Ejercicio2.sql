
delimiter $$
drop procedure if exists
sp_guardar_producto$$
creater procedure sp_guardar_producto
 
in nombreIN varchar(45);
in descripcionIN varchar (45);
in precio_costoIN decimal(12,2);
in precio_ventaIN decimal(12,2);


begin 
set precio_ventaIN=precio_costoIN+
(precio_costoIN*0.125);

insert into tbl_productos (nombre,descripcion,precio_costo,precio_venta);

values(nombreIN, descripcionIN,
precio_costoIN,precio_ventaIN);

commit;

end $$
