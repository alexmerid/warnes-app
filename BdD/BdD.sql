/* TABLAS */
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

/*  CONSULTAS */
/* Postes y Luminarias */
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
where
    p.id < 269
ORDER BY
    p.id;

/* Postes y cantidad de luminarias por poste */
SELECT
    p.id,
    p.latitud,
    p.longitud,
    p.observacion,
    count(pl.id) as num_lum
from
    poste p
    inner join poste_luminaria pl on p.id = pl.id_poste
where
    p.id < 269
GROUP BY
    p.id;

SELECT
    *
from
    poste_luminaria pl
    inner join luminaria l on pl.id_luminaria = l.id;

/* Cantidad Total de Luminarias por Tipo y Potencia */
SELECT
    l.tipo,
    l.potencia,
    count(pl.id_luminaria)
from
    poste_luminaria pl
    inner join luminaria l on pl.id_luminaria = l.id
GROUP BY
    l.tipo,
    l.potencia
order by
    l.id;

/* Cantidad de Luminarias por Tipo y Potencia para una Referencia específica */
SELECT
    l.tipo,
    l.potencia,
    count(pl.id_luminaria) as cantidad
from
    poste p
    inner join poste_luminaria pl on p.id = pl.id_poste
    inner join luminaria l on pl.id_luminaria = l.id
where
    p.id_referencia = 7001
GROUP BY
    pl.id_luminaria;

/* Cantidad de Luminarias por Tipo y Potencia agrupadas por Referencia */
SELECT
    r.distrito,
    r.descripcion,
    l.tipo,
    l.potencia,
    count(pl.id_luminaria) as cantidad
from
    poste p
    inner join poste_luminaria pl on p.id = pl.id_poste
    inner join luminaria l on pl.id_luminaria = l.id
    inner join referencia r on p.id_referencia = r.id
GROUP BY
    p.id_referencia,
    pl.id_luminaria;

/*  Modificar la referencia de un grupo de postes
Usar con PRECAUCIÓN */
update poste
set
    id_referencia = 1000
where
    id >= 1
    and id <= 268;

/* SELECT p.id, CONCAT ('POINT(', p.longitud, ' ', p.latitud, ')') as wkt, p.latitud, p.longitud, p.observacion,
l.tipo, l.potencia, pl.estado
from poste p
inner join poste_luminaria pl on p.id = pl.id_poste
inner join luminaria l on pl.id_luminaria = l.id
WHERE p.id > 268
ORDER BY p.id; */