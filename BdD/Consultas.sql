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
GROUP BY
    p.id;

/*  Postes y luminarias por poste*/
SELECT
    p.id,
    p.latitud,
    p.longitud,
    p.observacion,
    p.id_referencia,
    GROUP_CONCAT (l.id, '-', pl.estado) AS luminaria
FROM
    poste p
    inner join poste_luminaria pl ON p.id = pl.id_poste
    INNER JOIN luminaria l ON pl.id_luminaria = l.id
WHERE
    p.id < 268
GROUP BY
    p.id;

/* Cantidad Total de Luminarias por Tipo y Potencia */
SELECT
    l.id,
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