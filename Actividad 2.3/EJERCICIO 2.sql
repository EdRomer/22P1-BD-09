EJERCICIO # 2 ::::::::KENDY HERNANDEZ:::::::::::


Delimiter $$
drop procedure if exists sp_guardar_producto$$
create procedure
sp_guardar_produto( in p_producto Id int, 
in p_nombre varchar (45)
in p_descripcion varchar (45)
in p_precio_costo decimal (12,2)
in p_porcentaje decimal (12,2)

begin 
declare v_id_producto int;
declare v_nombre varchar( 45);
declare v_descripcion varchar (45);
declare v_precioCosto decimal (12,2);
declare v_precioVenta decimal (12,2);
declare v_porcentaje decimal (12,2);
declare v_fecha_insercion datetime;

set v_id_producto =p_productoId;
set v_nombre = p_nombre;
set v_descripcion =p_descripcion;
set v_precioCosto =p_precio_costo ;
set v_porcentaje = p_porcentaje ;
select now () into v_fecha_insercion;

case
when v_precioCosto between 0 and 3.99 then set v_porcentaje = 1.3 ;
when v_precioCosto between 4 and 7.99 then set v_porcentaje = 1.5 ;
when v_precioCosto  >= then set v_porcentaje = 1.6 ;  end case ;

           set v_precioVenta= v precioCosto + (v_precioCosto * v_porcentaje);
 ❏ if not exists (select id_producto from tbl productos = v_id_producto) then
 insert into tbl_productos_hist (id_producto) then 
 
 insert into tbl_productos_hist (id_producto, nombre, descripcion,precio_costo_precio_costo, precio_venta, 
 v_fecha_insercion);
 
 else 
   update tbl_productos set nombre = v_nombre,
                              descripcion=
 v_descripcion,               
                              precio_costo=
 v_precioCosto,               
							  precio_venta=
 v_precioVenta  
                              where id_producto=
                              
 v_id_producto;
 end if;
 commit;
 end $$
