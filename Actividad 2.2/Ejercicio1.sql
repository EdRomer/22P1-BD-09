delimiter //
CREATE PROCEDURE sp_guardar_subscriptor(
	in p_idSubscriptor int,
    in p_codSubscriptor int,
    in p_nombSubscriptor varchar(25),
    in p_apeSubscriptor varchar(25)
)
BEGIN
	declare v_idSubscriptor int;
    declare v_codSubscriptor int;
    declare v_nombSubscriptor varchar(25);
    declare v_apeSubscriptor varchar(25);
	
    set v_idSubscriptor = p_idSubscriptor;
    set v_codSubscriptor = p_codSubscriptor;
    set v_nombSubscriptor = p_nombSubscriptor;
    set v_apeSubscriptor = p_apeSubscriptor;
    
    
    update tbl_subscriptores
	set codigo_subscriptor=v_codSubscriptor, nombres=v_nomSubscriptor,apellidos=v_codSubscriptor
    where id_subscriptor=v_idSubscriptor;
commit;
select * from tbl_subscriptores;
END;
