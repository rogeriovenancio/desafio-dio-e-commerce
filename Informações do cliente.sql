-- criação do banco de dados para o cenário de E-commerce
-- drop database ecommerce;
create database ecommerce;
use ecommerce;

show tables;
-- idClient, Fname, Minit, Lname, CPF, Address
insert into Clients (Fname, Minit, Lname, CPF, Address)
	values('Maria', 'S', 'Silva', 123456789, 'rua silva de prata 29, Carangola - Cidade das flores'),
		  ('Rogerio', 'V', 'Souza', 123456789, 'rua oliveira de prata 19, Ingleses - Florianópolis'),
          ('Helena', 'N', 'Souza', 123456789, 'rua direita de prata 299, Gaivotas - Goiânia'),
          ('Josi', 'B', 'Souza', 123456789, 'rua rodovia de prata 298, Canasvieiras - Brasilia'),
          ('Flavio', 'A', 'Souza', 123456789, 'rua norte de prata 229, Itacurubi - São Paulo'),
          ('Amora', 'V', 'Souza', 123456789, 'rua laurindo de prata 329, Centro - Porto Seguro');
		
-- idProduct, Pname, classification_kids boolean, category('Eletrônico', 'Moda', 'Livros', 'Brinquedos', 'Alimentos'), avaliação, size
insert into product (Pname, classification_kids, category, avaliação, size) values
		('Celular', false, 'Eletrônico', '1',null),
        ('Xadrez', true, 'Brinquedo', '4',null),
        ('Body Carters', true, 'Moda', '2',null),
        ('Microfone - Youtuber', False, 'Eletrônico', '1',null),
        ('Mesa', False, 'Livros', '3',null),
        ('Feijão', true, 'Alimentos', '5', null),
        ('Dom Quixote', true, 'Livros', '3',null);
        
 -- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash
 insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
		(1, null, 'compra via aplicativo',null,1),
        (2, null, 'compra via aplicativo',50,0),
        (3, 'Confirmado',null,null,1),
        (4, null, 'compra via web site',150,0);
        
-- idPOproduct, idPOorder, poQuantity, poStatus
select * from orders;
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
		(1,5,2,null),
        (2,5,1,null),
        (3,6,1,null);
        
-- storageLocation,quantity
insert into productStorage (storageLocation,quantity) values
		('Rio de Janeiro',1000),
        ('Rio de Janeiro',500),
        ('São Paulo',10),
        ('São Paulo',100),
        ('São Paulo',30),
        ('Brasília',60);
        
-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
		(1,2,'RJ'),
        (2,6,'GO');
        
-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values
		('Venâncio e Souza', 123456789102345, '22356859'),
        ('Nascimento e Souza', 323456789102345, '44356859'),
        ('Santos e Souza', 423456789102345, '33356859');
        
select * from supplier;
-- idPsSuppier, idPsProduct, quantity
insert into prouctSupplier (idPsSuppier, idPsProduct, quantity) values
		(1,5,500),
        (2,4,400),
        (3,3,300),
        (4,2,5),
        (5,1,50);
        
-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
		('Tech eletronics', null, 123456789102589, null, 'Rio de Janeiro', 123987456),
        ('Imperatriz', null, 6789102589, null, 'Belo Horizonte', 333987456),
        ('Atacadão', null, 823456789102589, null, 'Goiânia', 543987456);
        
select * from seller;
-- idPseller, idPproduct, prodQuantity
insert into productSeller (idPseller, idPproduct, prodQuantity) values
		(1,6,80),
        (2,7,10);
        
select * from productSeller;

select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;
select Fname,Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname, ' ',Lname) as Client, idOrder as Request, orderStatus as Status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
						(2, default, 'compra via aplicativo',null,1);
        
select count(*) from clients c, orders o 
				where c.idClient = idOrderClient;
                
select * from orders;
select * from clients c 
			  inner join orders o ON c.idClient = o.idOrderClient
              inner join productOrder p on p.idPOorder = o.idOrder
	  group by idClient;
-- Recuperar quantos pedidos foram realizados pelos clientes?
select * from clients left outer join orders ON idClient = idOrderClient;
select c.idClient, Fname, count(*) as Number_of_orders from clients c 
			 inner join orders o ON c.idClient = o.idOrderClient
	 group by idClient;
     

create table clients(
	idClient int auto_increment primary key,
	Fname varchar(10),
	Minit char(3),
	Lname varchar(20),
	CPF char(11) not null,
	Address varchar(255),
	constraint unique_cpf_client unique (CPF)
);

create table product(
	idProduct int auto_increment primary key,
	Pname varchar(10) not null,
	classification_kids bool default false,
	category enum('Eletrônico', 'Moda', 'Livros', 'Brinquedos', 'Alimentos') not null,
	avaliação float default 0,
	size varchar(10)
);

create table ordes(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false,
    constraint fk_ordes_client foreign key (idOrderClient) references clients(idClient)
);

create table payments(
	idclient int,
    idPayment int,
    typePayment enum('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable float,
    primary key(idClient, idPayment)
);

create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

create table supplier(
	idSupplier int auto_increment primary key,
	SocialName varchar(255) not null,
	CNPJ char(15) not null,
	contact char(11) not null,
	constraint unique_supplier unique (CNPJ)
);

create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

create table productSeller(
	idPseller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idPseller, idProduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
	constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

create table storegeLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
	constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

desc productSupplier;

show tables;

show databases;
use information_schema;
show tables;
desc referential_constrainsts;
select * from referential_constraints where constraint_schema = 'ecommerce';







