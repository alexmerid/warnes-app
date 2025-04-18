CREATE TABLE
    luminaria (
        id int NOT NULL,
        tipo varchar(255),
        potencia int,
        PRIMARY KEY (id)
    );

CREATE TABLE
    referencia (
        id int not null,
        distrito int,
        descripcion varchar(255),
        PRIMARY KEY (id)
    );

CREATE TABLE
    censista (
        id int not null,
        nombre varchar(255),
        usuario varchar(25),
        pass varchar(25),
        PRIMARY KEY (id)
    );

CREATE TABLE
    poste (
        id int auto_increment,
        latitud double,
        longitud double,
        observacion varchar(255),
        id_referencia int,
        id_censista int,
        fecha_censo date,
        PRIMARY KEY (id),
        FOREIGN KEY (id_referencia) REFERENCES referencia (id) ON DELETE NO ACTION ON UPDATE CASCADE,
        FOREIGN KEY (id_censista) REFERENCES censista (id) ON DELETE NO ACTION ON UPDATE CASCADE
    );

CREATE TABLE
    poste_luminaria (
        id int auto_increment,
        id_poste int not null,
        id_luminaria int not null,
        estado varchar(25),
        fecha_inst date,
        PRIMARY KEY (id),
        FOREIGN KEY (id_poste) REFERENCES poste (id) ON DELETE NO ACTION ON UPDATE CASCADE,
        FOREIGN KEY (id_luminaria) REFERENCES luminaria (id) ON DELETE NO ACTION ON UPDATE CASCADE
    );