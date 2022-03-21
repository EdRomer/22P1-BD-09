############################## EJERCICIO 3 ##############################################################
#Crear un procedimiento para registrar un suscriptor. 
#El proceso debe permitir que se registre los datos de un suscriptor. 
#Al momento de registrarlo, se le debe asignar el ciclo de facturación con el día calendario 
#más cercano al día calendario de la inscripción más 20 días.

select * from bd_platvideo.tbl_suscriptores;
select * from bd_platvideo.tbl_productos;
select * from bd_platvideo.tbl_ciclos_facturacion;
select * from bd_platvideo.tbl_cartera;
select * from bd_platvideo.tbl_fact_detalle;
drop procedure bd_platvideo.SP_CREAR_SUSCRIPTOR;


delimiter //
CREATE PROCEDURE bd_platvideo.SP_CREAR_SUSCRIPTOR(
    in p_id_suscriptor      int, 
    in p_nombres            varchar(45),
    in p_apellidos 	        varchar(45),
	in p_telefono           varchar(45),
    in p_email              varchar(45),
	in p_usuario            varchar(45),
    in p_contrasena         varchar(400),
    in p_fechanacimiento    datetime,
    in p_edad               int,
    in p_fecha_ingreso       datetime,
    in p_fecha_modificacion  datetime,
    in p_fecha_ultima_act    datetime
    
   
    
)
BEGIN
    declare v_id_suscriptor int;  
    declare v_nombres       varchar(45); 
    declare v_apellidos     varchar(45);
    declare v_telefono      varchar(45);
	declare v_email         varchar(45);
    declare v_usuario       varchar(45);
    declare v_contrasena    varchar(400);
    declare v_fechanacimiento datetime;
    declare v_edad            int;
    declare v_fecha_ingreso       datetime;
    declare v_fecha_modificacion  datetime;
    declare v_fecha_ultima_act    datetime;
    declare v_id_ciclo            int;
    declare aux2                  int default 0;
	
    
#asignar valores de parametros a variables 

    set v_id_suscriptor		= p_id_suscriptor ;
	set v_nombres	        = p_nombres; 
    set v_apellidos     	= p_apellidos;
    set v_telefono          = p_telefono;
    set v_email     	    = p_email;
    set v_usuario           = p_usuario;
    set v_contrasena     	= p_contrasena;
    set v_fechanacimiento   = p_fechanacimiento;
    set v_edad     	        = p_edad;
    set v_fecha_ingreso     = p_fecha_ingreso;
	set v_fecha_modificacion = p_fecha_modificacion;
    set v_fecha_ultima_act   = p_fecha_ultima_act;
    
 	insert into bd_platvideo.tbl_suscriptores(
		      id_suscriptor, nombres, apellidos, telefono, email, usuario, contrasena, fechanacimiento, edad, fecha_inrgreso, fecha_modificacion, fecha_ultima_act, idciclo  
		 )values(
			v_id_suscriptor, v_nombres, v_apellidos, v_telefono, v_email,v_usuario, v_contrasena, v_fechanacimiento, v_edad, v_fecha_ingreso, v_fecha_modificacion, v_fecha_ultima_act, bd_platvideo.id_result(v_fecha_ingreso)
		 );
  
END;
delimiter //;

# Ejecutar procedimiento 
CALL bd_platvideo.SP_CREAR_SUSCRIPTOR(
	null, 					# p_id_suscriptor  
    'Laura',    			    # p_nombre 
	'Rivera',				    # p_apellidos			 
	24544589, 				    # p_telefono
	'usuario56@umh.edu',    	    # p_email 
	'm0ri1745',				    # p_usuario			 
	'clase1235', 				# p_contrasena
	now(),                      # p_fechanacimiento 
	15,				        # p_edad			 
	'2022-03-10 13:02:16',   # p_fecha_ingreso
    curdate(),				# p_fecha_modificacion			 
	curdate()        		# p_fecha_ultima_act
    
);

############################################# EJERCICO 1 ###########################################################
#Funciones almacenadas
#Crear una función almacenada que devuelva el valor real o valor porcentual (según se indique) 
#de una tarifa que se encuentre en la tabla tarifas.
drop procedure bd_platvideo.SP_CREAR_TARIFA;
select * from bd_platvideo.tbl_tarifas;
delimiter //
CREATE PROCEDURE bd_platvideo.SP_CREAR_TARIFA(
    in p_id                 int,
    in p_valor 	            varchar(45)
)

BEGIN
	declare v_nombre           varchar(45); 
    declare v_valor_real       decimal(12,2);
    declare v_valor_porcentual decimal(12,2);
    declare v_eleccion         decimal(12,2);
    declare aux1                varchar(45);
    declare aux2                varchar(45);
    declare result              varchar(400);

    select nombre, valor_real,valor_procentual into v_nombre,v_valor_real,v_valor_porcentual 
      from bd_platvideo.tbl_tarifas where id_tarifa =  p_id;
        CASE
		  when p_valor = 'real'         then    set v_eleccion = v_valor_real  ; 
		  when p_valor = 'porcentual'   then    set v_eleccion = v_valor_porcentual;  
		  else set v_eleccion = null;
		END CASE;
    set aux1 = v_eleccion;
    set aux2 = v_nombre;
    set result = concat(aux2, ': ' , aux1);
    select result;
    
END;

CALL bd_platvideo.SP_CREAR_TARIFA(

   4,    #p_id
   'real'    #p_valor

);

################################ Ejercicio 2 ############################################################
#Procedimientos almacenados:
#Crear un procedimiento almacenado para generar facturas. 
#Una factura se genera a partir de una orden activa en la cartera. 
#Por medio de esa orden obtiene los datos de la oferta del catálogo registrada para el cliente. 
#Para cada factura, se debe registrar en la tabla de detalle, todas las ofertas de catálogo del 
#cliente en las cuales el día de la fecha de pago coincida con el día calendario de ciclo indicado 
#como parámetro. En el detalle de factura, el concepto corresponde al título del catálogo ordenado 
#por el cliente, así como el monto y los cálculos respectivos. Para aquellos clientes que apliquen, 
#considerar ingresar un cargo por descuento de tercera edad.

select * from bd_platvideo.tbl_cartera;
select * from bd_platvideo.tbl_fact_detalle;
select * from bd_platvideo.tbl_fact_resumen;
select * from bd_platvideo.tbl_catalogo;

delimiter //
CREATE PROCEDURE bd_platvideo.SP_FACTURA_RESUMEN(
    in p_id_factura              int,
    in p_fecha_emision 	         datetime,
    in p_fecha_vencimiento       datetime,
	in p_tipo_pago               varchar(45),
    in p_idorden                 int
    
)

BEGIN
    declare v_id_factura              int;
    declare v_fecha_emision 	      datetime;
    declare v_fecha_vencimiento       datetime;
    declare v_tipo_pago               varchar(45);
    declare v_estado                  varchar(45);
    declare mensaje                   varchar(400);
    declare v_id_cat                  int; 
    declare v_conteo_catalogo         int;
    declare v_suma_costo              decimal(12,2);
    
    set v_id_factura =               p_id_factura;
	set v_fecha_emision =	         p_fecha_emision;
    set v_fecha_vencimiento  =       p_fecha_vencimiento;
	set v_tipo_pago   =              p_tipo_pago ;
    set mensaje =                    'no esta habilitada en cartera';
    
    select estado, id_cat into v_estado,v_id_cat  from bd_platvideo.tbl_cartera where idorden = p_idorden ;
    select count(id_cat),sum(costo) into v_conteo_catalogo,v_suma_costo from bd_platvideo.tbl_catalogo where id_cat = v_id_cat;
    
    if v_estado = 'activo' then
		insert into bd_platvideo.tbl_fact_resumen(id_factura, fecha_emision,fecha_vencimiento, 
                    tipo_pago,idorden )
		values (v_id_factura,v_fecha_emision,v_fecha_vencimiento,v_tipo_pago,p_idorden );
        
        update bd_platvideo.tbl_fact_resumen
        set  total_unidades = v_conteo_catalogo,
             subtotal_pagar = v_suma_costo,
             isv_total = v_suma_costo*0.15,
             total_pagar = v_suma_costo*1.15
		where idorden = p_idorden;
	else 
        select mensaje;
	end if;
       
END;

CALL  bd_platvideo.SP_FACTURA_RESUMEN(
         null,                              # p_idfactura
		now(),                              # p_fecha_emision 	          
		'2022-03-31 13:02:16',              # p_fecha_vencimiento          
		'Tarjeta credito',					# p_tipo_pago   
			9							    #p_orden
);
##################################### Ejercicio 2 ######################################################################

drop procedure bd_platvideo.SP_GESTIONAR_DETALLE_FACT;
delimiter //
CREATE PROCEDURE bd_platvideo.SP_GESTIONAR_DETALLE_FACT(
    in p_id_cargo 	             int,
    in p_id_factura              int,
    in p_dia_ciclo               int
)

BEGIN
    declare v_id_cargo           int;
    declare v_titulo             varchar(45);
    declare v_id_factura         int;
    declare v_subtotal_pagar     decimal(12,2);
    declare v_isv_total          decimal(12,2);
    declare v_total_pagar        decimal(12,2);
    declare v_idorden            decimal(12,2);
    declare v_total_unidades     int;
    declare v_id_cat             int;
    declare v_fecha_ingreso      datetime;
    declare v_fecha_pago         datetime;
    declare v_estado             varchar(45);
    declare mensaje              varchar(400);
  
    set mensaje =    'no esta habilitada ';
    
	select subtotal_pagar,total_unidades, isv_total, total_pagar, idorden 
    into v_subtotal_pagar,v_total_unidades, v_isv_total, v_total_pagar, v_idorden 
    from bd_platvideo.tbl_fact_resumen where id_factura = p_id_factura;
    
    select id_cat, fecha_ingreso,fecha_pago,estado 
    into v_id_cat, v_fecha_ingreso, v_fecha_pago,v_estado 
    from bd_platvideo.tbl_cartera where idorden = v_idorden;
    
    select id_cargo into v_id_cargo  
    from bd_platvideo.tbl_fact_cargos where id_cargo = p_id_cargo;
    
    select titulo into v_titulo
    from bd_platvideo.tbl_catalogo where id_cat = v_id_cat;
    
    if v_estado = 'activo' then
		if day(v_fecha_pago) = p_dia_ciclo   then
			INSERT INTO bd_platvideo.tbl_fact_detalle(id_factura ,id_cargo, cantidad, concepto, monto, subtotal, isv, total_cargo,fecha_ingreso)
			VALUES (p_id_factura, p_id_cargo, v_total_unidades, v_titulo, v_total_unidades, v_subtotal_pagar,v_isv_total,v_total_pagar, v_fecha_ingreso);
		else
			select mensaje;
		end if;
	else 
            select mensaje;
	end if;

END;

CALL   bd_platvideo.SP_GESTIONAR_DETALLE_FACT(
          5,                                    # p_id_cargo 	          
		  1,                                    # p_id_factura
          31                                     #p_dia_ciclo
);

select * from bd_platvideo.tbl_fact_cargos;
select * from bd_platvideo.tbl_cartera;
select * from bd_platvideo.tbl_fact_resumen;
select * from bd_platvideo.tbl_fact_detalle;
select * from bd_platvideo.tbl_catalogo;


################################################################################################
###############################################################################################
###############################################################################################
############################ ejercicio 4 ###############################################################

#Crear un procedimiento para gestionar la cartera de un cliente. Es decir, que permita crear,
#actualizar y cancelar ordenes de un cliente especifico en la tabla cartera. Siempre y cuando
# se cumpla con la siguiente norma: Se puede cancelar ordenes de clientes con ofertas de catálogo
#gratuitos sin importar la antigüedad. Se pueden cancelar ordenes solo si el cliente no tiene 
 #facturas pendientes.
select * from bd_platvideo.tbl_catalogo;
select * from bd_platvideo.tbl_cartera;
drop procedure bd_platvideo.SP_GESTIONAR_CARTERA;

delimiter //
CREATE PROCEDURE bd_platvideo.SP_GESTIONAR_CARTERA(
    in p_idorden                 int,
    in p_id_cat 	             int,
    in p_id_suscriptor           int,
    in p_fecha_ingreso           datetime,
    in p_fecha_pago              datetime,
    in p_estado                  varchar(45)
)

BEGIN
    declare v_idorden                 int;
    declare v_id_cat 	              int;
    declare v_id_suscriptor           int;
    declare v_fecha_ingreso           datetime;
    declare v_fecha_pago              datetime;
    declare v_estado                  varchar(45);
    
    set v_idorden=                   p_idorden;
	set v_id_cat =	                 p_id_cat;
    set v_id_suscriptor =            p_id_suscriptor;
    set v_fecha_ingreso  =           p_fecha_ingreso;
    set v_fecha_pago  =              p_fecha_pago ;
    set v_estado =                   p_estado;
    
 

    insert into bd_platvideo.tbl_cartera(idorden, id_cat , id_suscriptor, fecha_ingreso, fecha_pago, estado)
    values (v_idorden,v_id_cat,v_id_suscriptor,v_fecha_ingreso,v_fecha_pago, v_estado);
    

END;

CALL  bd_platvideo.SP_GESTIONAR_CARTERA(
         null,                                  # p_idorden
          4,                                    # p_id_cat 	          
          14,                                    # p_id_suscriptor         
         curdate(),                             # p_fecha_ingreso         
		'2022-03-31 13:02:16',					# p_fecha_pago            
		'activo'								# p_estado                  
);

######################################### Ejercicio 5 ###############################################################
#Crear un procedimiento almacenado para gestionar el catálogo de productos permitiendo crear, 
#actualizar o desactivar catálogos. Además, en el mismo procedimiento debe permitir agregar
# o quitar productos al catálogo.
select * from bd_platvideo.tbl_catalogo;
select * from bd_platvideo.tbl_cartera;
select * from bd_platvideo.tbl_productos;
select * from bd_platvideo.tbl_cat_prods;
drop procedure bd_platvideo.SP_GESTIONAR_CATALOGO;

delimiter //
CREATE PROCEDURE bd_platvideo.SP_GESTIONAR_CATALOGO(
    in p_id_cat 	             int,
    in p_titulo                  varchar(45),
    in p_descripcion             varchar(45),
    in p_costo                   decimal(12,2),
    in p_precio_venta            decimal(12,2),
    in p_fecha_inicio            datetime,
    in p_fecha_fin               datetime
)

BEGIN
	declare v_id_cat 	             int;
    declare v_titulo                  varchar(45);
    declare v_descripcion             varchar(45);
    declare v_costo                   decimal(12,2);
    declare v_precio_venta            decimal(12,2);
    declare v_fecha_inicio            datetime;
    declare v_fecha_fin               datetime;
    
    set v_id_cat =	                 p_id_cat;
    set v_titulo =                   p_titulo;
    set v_descripcion =              p_descripcion;
    set v_costo =                    p_costo;
    set v_precio_venta =             p_precio_venta;
    set v_fecha_inicio =             p_fecha_inicio;
    set v_fecha_fin   =              p_fecha_fin;

    INSERT INTO bd_platvideo.tbl_catalogo(id_cat ,titulo, descripcion, costo, precio_venta, fecha_inicio, fecha_fin)
    VALUES (v_id_cat,v_titulo,v_descripcion,v_costo, v_precio_venta, v_fecha_inicio,v_fecha_fin);
    
END;

CALL  bd_platvideo.SP_GESTIONAR_CATALOGO(
         null,                                     # p_id_cat 	          
         'Autos',                                 # p_titulo
         'gratuito',                                #p_descripcion
         33.50,                                     #p_costo
         52226.0,                                      #p_precio_venta
         curdate(),                                 # p_fecha_inicio         
		'2022-03-30 13:02:16'					    # p_fecha_fin            
);
##############################################################################################
################################################################################################
###############################################################################################
select * from bd_platvideo.tbl_ciclos_facturacion;
drop function bd_platvideo.id_ciclo;
drop function bd_platvideo.id_valor;
drop function bd_platvideo.id_result;
drop procedure bd_platvideo.SP_Clasificacion;
drop trigger tg_indice;
drop trigger tg_id1;
delimiter //
CREATE FUNCTION bd_platvideo.id_ciclo(
    p_dia_ingreso int
)RETURNS INT DETERMINISTIC
  
BEGIN
	declare v_indice   int;
    CASE
	  when p_dia_ingreso between 03 and 10  then    set v_indice = 1 ; #5
      when p_dia_ingreso between 11 and 17 then    set v_indice = 2 ;  #15
      when p_dia_ingreso between 18 and 22 then    set v_indice = 3 ; #20
      when p_dia_ingreso between 23 and 27 then    set v_indice = 4 ; #25
      when p_dia_ingreso between 28 and 31 then    set v_indice = 5 ;  #30
      when p_dia_ingreso between 01 and 02 then      set v_indice = 5 ;  #30
      else set v_indice=0;
    END CASE;
    
   
    return v_indice;
END;

select bd_platvideo.id_ciclo(21)
delimiter //;

delimiter //
CREATE FUNCTION bd_platvideo.id_result(
    v_fecha_ingreso datetime
)RETURNS INT DETERMINISTIC
  
BEGIN
   declare p_dia_ingreso  int;
   declare v_ingreso  int;
   declare aux        int;
   
   set p_dia_ingreso = day(v_fecha_ingreso) + 20;
	if  p_dia_ingreso <= 31 then
         set v_ingreso = bd_platvideo.id_ciclo(p_dia_ingreso);
	else 
	     set aux = ABS(p_dia_ingreso-31);
         set v_ingreso = bd_platvideo.id_ciclo(aux);
	end if;
    
    return v_ingreso;
END;
select bd_platvideo.id_result('2022-03-28 13:02:16')
delimiter //;

################################################## Ejercicio 1 ################

delimiter //
CREATE FUNCTION bd_platvideo.id_valor(
     p_valor  varchar(45),
     p_real    decimal(12,2),
     p_porcentual  decimal(12,2)
     
)RETURNS DECIMAL DETERMINISTIC
  
BEGIN
    declare v_eleccion   decimal(12,2);
    CASE
	  when p_valor = 'real'  then           set v_eleccion = p_real  ; 
      when p_valor = 'porcentual'   then    set v_eleccion = p_procentual ;  
      else set v_eleccion = null;
	END CASE;
     return v_eleccion;
END;

delimiter //;
