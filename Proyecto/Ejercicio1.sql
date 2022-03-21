select * from bd_sample.tbl_tickets_promo;
select * from tbl_ciclos_facturacion;

drop procedure bd_sample.SP_CREAR_TICKETS;

delimiter //
CREATE PROCEDURE bd_platvideo.SP_CREAR_FACTURA(
  in p_fechaVencimiento int,
  in p_idOrden  int,
  in p_totalUnidades  int,
  in p_tipoPago  varchar(45),
  in p_cliente int,
  in p_idCargo int
)

BEGIN
    declare  v_idFactura int;  
	declare  v_fechaEmision  datetime; 
	declare  v_fechaVencimiento datetime; 
	declare  v_totalUnidades int;
	declare  v_subtotalPagar decimal(12,2); 
    declare  v_isvTotal decimal(12,2);
    declare  v_subtotalPagar decimal(12,2);
	declare  v_totalPagar decimal(12,2);
    declare  v_tipoPago varchar(45);
    declare  v_idOrden int;
    declare  v_estadoOrden varchar(45);
    declare  v_Catalogo int;
    declare  v_precioCatalogo decimal(12,2);
    declare  v_diaFecha int;
    declare  v_cliente int;
    declare  v_cicloCliente int;
    declare  v_concepto varchar(80);
    declare  v_idCargo int;
    declare  v_edadSub int;
    
    set v_idOrden=p_idOrden;
    set v_cliente=p_cliente;
    
    select estado into v_estadoOrden from tbl_cartera where idorden=v_idOrden;
    
	select edad into v_edadSub from tbl_suscriptores where id_suscriptor=v_cliente;
    
    if v_estadoOrden="ACTIVO" then
    
    #creacion de factura resumen
	 select max(id_factura) into v_idFactura from tbl_fact_resumen;
     select fecha_pago into v_fechaEmision from tbl_cartera where idorden=v_idOrden;
     set v_fechaVencimiento=p_fechaVencimiento;
     set v_totalUnidades=p_totalUnidades;
     select id_cat into v_Catalogo from tbl_cartera where idorden=v_idOrden;
     select precio_venta into v_precioCatalogo from tbl_catalogo where idcat=v_Catalogo;
     if v_edadSub<60 then
		 set v_subtotalPagar=v_precioCatalogo;
		 set v_isvTotal=v_precioCatalogo*0.15;
		 set v_totalPagar=v_precioCatalogo*1.15;

	 else
		 set v_subtotalPagar=(v_precioCatalogo)*0.75;
		 set v_isvTotal=(v_precioCatalogo*0.15)*0.75;
		 set v_totalPagar=(v_precioCatalogo*1.15)*0.75;
     end if;
	 set v_tipoPago=p_tipoPago;
	 insert into 
		tbl_fact_resumen(id_factura,fecha_emision,fecha_vencimiento,total_unidades,subtotal_pagar,isv_total,total_pagar,tipo_pago,idorden)
     values
		(v_idFactura,v_fechaEmision,v_fechaVencimiento,v_totalUnidades,v_subtotalPagar,v_isvTotal,v_totalPagar,v_tipoPago);
	end if;
    #factura detalle
    
    select tbl_ciclos_facturacion.dia_calendario into v_cicloCliente from tbl_ciclos_facturacion left join tbl_suscriptores on tbl_suscriptores.idciclo=tbl_ciclos_facturacion.idciclo where tbl_suscriptores.id_suscriptor=v_cliente;
    set v_diafecha=DAY(v_fechaEmision);
    
	 if v_diafecha=v_cicloCliente then
     
     set v_idCargo=p_idCargo;
     
     select titulo into v_concepto from tbl_catalogo where idcat=v_Catalogo;
     set v_concepto=concat(v_concepto,"",v_subtotalPagar,"",v_isvTotal,"",v_totalPagar);
     
	 insert into 
		tbl_fact_detalle(id_factura,id_cargo,cantidad,concepto,monto,subtotal,isv,total_cargo,fecha_ingreso)
     values
		(v_idFactura,v_idCargo,v_totalUnidades,v_concepto,v_subtotalPagar,v_isvTotal,v_totalPagar,CURDATE());
     
     end if;
     
END;

call  bd_sample.SP_CREAR_TICKETS(
   6, 10
)

select * from bd_sample.tbl_tickets_promo;
select * from bd_sample.tbl_facturas_selectas;