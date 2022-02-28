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
    declare v_check int;
	
    set v_idSubscriptor = p_idSubscriptor;
    set v_codSubscriptor = p_codSubscriptor;
    set v_nombSubscriptor = p_nombSubscriptor;
    set v_apeSubscriptor = p_apeSubscriptor;
    
    select id_subscriptor from tbl_subscriptores where id_subscriptor=v_idsubscriptor into v_check;
    
    if vc_check is not null then
		update tbl_subscriptores
		set codigo_subscriptor=v_codSubscriptor, nombres=v_nomSubscriptor,apellidos=v_codSubscriptor
		where id_subscriptor=v_idSubscriptor;
	else
		insert into tbl_subscriptores (id_subscriptor,codigo_subscriptor,nombres,apellidos)
        values(v_idSubscriptor,v_codSubscriptor,v_nombSubscriptor,v_apeSubscriptor);
	end if;
commit;
select * from tbl_subscriptores;
END;