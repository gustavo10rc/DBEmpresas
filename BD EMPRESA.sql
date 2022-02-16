create database EMPRESA;
	USE EMPRESA;

	create table cargo(
		IDCargo INT(11) not null  AUTO_INCREMENT,
		nome varchar (100),
		SalarioMAXcargo decimal(12,2),
		DataInicioCargo DATE,
		PRIMARY KEY (IDCargo)
		);
	alter table cargo ADD IDCargoSuperior int (11) not null;
	
	alter table cargo ADD CONSTRAINT CargoS_FKindex1 FOREIGN KEY (IDCargoSuperior)
	REFERENCES cargo(IDCargo);

	create table funcionario(
		IDFun int (11)not null AUTO_INCREMENT,
		IDCargo int (11)not null,
		nome varchar(100),
		profissao varchar (30),
		DTNascimento DATE,
		DTContrato DATE,
		EstadoCivil varchar(10),
		PossuiDepend BIT(1),
		Salario decimal(10,2),
		PRIMARY KEY (IDFun),
		
		CONSTRAINT cargo_FKindex1 
		FOREIGN KEY (IDCargo) REFERENCES cargo(IDCargo)
		);
	

	create table Dependentes(
		IDDepend int (11) not null AUTO_INCREMENT,
		IDFun int (11) not null,
		nome varchar(100),
		DTNascimento date,
		relacao varchar(100),
		PRIMARY KEY (IDDepend),
		
		CONSTRAINT funcionario_FKindex1 
		FOREIGN KEY (IDFun) REFERENCES funcionario(IDFun)
		);
	INSERT INTO cargo (nome, SalarioMAXcargo, DataInicioCargo,IDCargoSuperior) VALUES ("GERENTE",8110.00,'2010-02-27', 1);
	INSERT INTO cargo (nome, SalarioMAXcargo, DataInicioCargo,IDCargoSuperior) VALUES ("CONTADOR",7110.00,'2010-03-25', 2);
	INSERT INTO cargo (nome, SalarioMAXcargo, DataInicioCargo,IDCargoSuperior) VALUES ("VENDEDOR",6110.00,'2010-04-19', 3);
	INSERT INTO cargo (nome, SalarioMAXcargo, DataInicioCargo,IDCargoSuperior) VALUES ("RH",7810.00,'2010-05-20', 4);


	INSERT INTO funcionario (IDCargo, nome,profissao,DTNascimento,DTContrato,EstadoCivil,PossuiDepend,Salario) VALUES (3,"maria","vendedor",'1987-02-21','2012-06-30',"casado",1,900.00);
	INSERT INTO funcionario (IDCargo, nome,profissao,DTNascimento,DTContrato,EstadoCivil,PossuiDepend,Salario) VALUES (1,"Antonio","CONTADOR",'1987-02-22','2011-07-30',"casado",1,110.00);
	INSERT INTO funcionario (IDCargo, nome,profissao,DTNascimento,DTContrato,EstadoCivil,PossuiDepend,Salario) VALUES (2,"Juliana","RH",'1987-02-21','2012-06-30',"casado",1,900.00);
	INSERT INTO funcionario (IDCargo, nome,profissao,DTNascimento,DTContrato,EstadoCivil,PossuiDepend,Salario) VALUES (3,"Joao","vendedor",'1988-06-22','2014-06-30',"solteiro",1,900.00);
	INSERT INTO funcionario (IDCargo, nome,profissao,DTNascimento,DTContrato,EstadoCivil,PossuiDepend,Salario) VALUES (4,"Paulo","GERENTE",'1987-02-21','2012-05-10',"casado",1,900.00);

	INSERT INTO Dependentes (IDFun,nome,DTNascimento,relacao) VALUES (5,"carlos",'1998-02-22',"Filho");
	INSERT INTO Dependentes (IDFun,nome,DTNascimento,relacao) VALUES (3,"elenice",'1967-06-15',"FILHA");
	INSERT INTO Dependentes (IDFun,nome,DTNascimento,relacao) VALUES (2,"laura",'1994-05-29',"Esposa");
	INSERT INTO Dependentes (IDFun,nome,DTNascimento,relacao) VALUES (1,"vitor",'1990-03-20',"Marido");
	INSERT INTO Dependentes (IDFun,nome,DTNascimento,relacao) VALUES (4,"caio",'1989-07-28',"Filho");

/*4) Faça uma consulta que mostre os dependentes dos funcionários que possuam o cargo 2. (utilizar subconsulta) */
select *from Dependentes where IDFun in(select f.IDFun from funcionario f where IDcargo=2);

/*5) Faça uma consulta que retorne todos os nome de funcionários e seus respectivos dependentes em uma único campo. (utilizar Union)*/
select nome as  from funcionario 
Union
select nome  from  Dependentes;

/*6) Depois que retornar a consulta acima, faça uma consulta que retorne todos que tenham o nome começado por ‘jo’.*/
select nome  from funcionario f where f.nome like 'jo%'
Union
select nome  from  Dependentes d where d.nome like 'jo%';

/*7) Faça uma consulta para verificar se existe algum dependente que faça aniversario hoje. (utilizar exists).*/
select *from funcionario where exists (select Dependentes.DTNascimento from Dependentes  where DTNascimento like'%02-22%'  AND funcionario.IDFun =Dependentes.IDFun);

/*8) Faça uma consulta para verificar todos os funcionários que tenham dependente com o nome ‘Maria’ nome caio.*/
select *from funcionario where exists (select nome from Dependentes where nome='caio' AND funcionario.IDFun =Dependentes.IDFun);

/*9) Faça uma query que exiba o cargo que possuí maior número de dependentes. (utilizar count() por agrupamento de cargo e uma subconsultapara obter o cargo com maior número de funcionários)*/
select IDCargo, count(IDCargo) as qtd
from Dependentes d, funcionario funcionario
where d.IDFun = f.IDFun
group by IDCargo order by qtd limit 1;

select *from (select IDCargo, count(IDCargo) as qtd
from Dependentes d, funcionario f
where d.IDFun = f.IDFun
group by IDCargo) temp

where qtd=(select IDCargo, count(IDCargo) as qtd
from Dependentes d, funcionario f
where d.IDFun = f.IDFun group by IDCargo) temp2;

/*10) Faça uma consulta que retorne todos os funcionários ordenados pelo salário em ordem decrescente.*/
select *from funcionario order by nome desc,salario desc;

/*11) Faça uma consulta que retorne os aniversariantes do mês de Fevereiro, tanto dos funcionários quanto dos dependentes.*/
select *from funcionario where exists ( AND funcionario.IDFun =Dependentes.IDFun);
select DTNascimento from Dependentes  where DTNascimento like'%02%' 