-- TABLAS
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
    poste (
        id int auto_increment,
        latitud double,
        longitud double,
        observacion varchar(255),
        id_referencia int,
        PRIMARY KEY (id),
        FOREIGN KEY (id_referencia) REFERENCES referencia (id) ON DELETE NO ACTION ON UPDATE CASCADE
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
    p.latitud,
    p.longitud,
    p.observacion,
    count(pl.id) as lum
from
    poste p
    inner join poste_luminaria pl on p.id = pl.id_poste
where
    p.id > 268
GROUP BY
    p.id;

SELECT
    p.id,
    CONCAT ('POINT(', p.longitud, ' ', p.latitud, ')') as wkt,
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
WHERE
    p.id > 268
ORDER BY
    p.id;