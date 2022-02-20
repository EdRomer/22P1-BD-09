delimiter //
CREATE PROCEDURE sp_guardar_subscriptor()
BEGIN
	declare v_idSubscriptor int;
    declare v_codSubscriptor int;
    declare v_nombSubscriptor varchar(25);
    declare v_apeSubscriptor varchar(25);
    
    
    update tbl_subscriptores
	set codigo_subscriptor=v_codSubscriptor, nombres=v_nomSubscriptor,apellidos=v_codSubscriptor
    where id_subscriptor=v_idSubscriptor;
END;
select * from tbl_subscriptores;
