-- TABLAS
CREATE TABLE
    luminaria (
        id int NOT NULL,
        tipo varchar(255),
        potencia int,
        PRIMARY KEY (id)
    );

CREATE TABLE
    poste (
        id int auto_increment,
        latitud double,
        longitud double,
        observacion varchar(255),
        PRIMARY KEY (id)
    );

CREATE TABLE
    poste_luminaria (
        id int auto_increment,
        id_poste int not null,
        id_luminaria int not null,
        estado varchar(25),
        PRIMARY KEY (id),
        FOREIGN KEY (id_poste) REFERENCES poste (id),
        FOREIGN KEY (id_luminaria) REFERENCES luminaria (id)
    );

-- CONSULTAS
SELECT
    p.id,
    p.latitud,
    p.longitud,
    p.observacion,
    l.tipo,
    l.potencia,
    pl.estado
from
    poste p
    inner join poste_luminaria pl on p.id = pl.id_poste
    inner join luminaria l on pl.id_luminaria = l.id
ORDER BY
    p.id;

SELECT
    p.id,
    CONCAT ('POINT(', p.latitud, ' ', p.longitud, ')') as wkt,
    p.observacion,
    l.tipo,
    l.potencia,
    pl.estado
from
    poste p
    inner join poste_luminaria pl on p.id = pl.id_poste
    inner join luminaria l on pl.id_luminaria = l.id
ORDER BY
    p.id;