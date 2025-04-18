import csv
from flaskext.mysql import MySQL
from flask import Flask


# Función para generar un archivo CSV que contiene un reporte de las cantidades por tipo de luminarias
# para cada Referencia
def sumario():
    app = Flask(__name__)
    mysql = MySQL()

    app.config['MYSQL_DATABASE_HOST'] = 'localhost'
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
    app.config['MYSQL_DATABASE_DB'] = 'warnes'
    mysql.init_app(app)

    consulta = """
        select p.id_referencia, r.distrito, r.descripcion, l.tipo, l.potencia, count(pl.id_luminaria) as cantidad
        from poste p inner join poste_luminaria pl on p.id=pl.id_poste
        inner join luminaria l on pl.id_luminaria = l.id
        inner join referencia r on p.id_referencia = r.id
        group by p.id_referencia, pl.id_luminaria;
"""
    conexion = mysql.connect()
    cursor = conexion.cursor()
    cursor.execute(consulta)
    tabla = cursor.fetchall()
    conexion.commit()
    id_ant = 0
    total = 0
    with open("tmp/Sumario.csv", "w") as archivo:
        writer = csv.writer(archivo)
        writer.writerow([".", "..", "..."])
        for t in tabla:
            if t[0] != id_ant:
                if id_ant > 0:
                    writer.writerow(["Total", "", total])
                    writer.writerow(["", "", ""])
                    total = 0
                if t[0] >= 1000:
                    writer.writerow([f"Distrito {t[1]} - {t[2]} ", "", ""])
                else:
                    writer.writerow([t[2], "", ""])
                writer.writerow(["Tipo", "Potencia", "Cantidad"])
            writer.writerow([t[3], t[4], t[5]])
            total += t[5]
            id_ant = t[0]
        writer.writerow(["Total", "", total])


# Funcion para generar archivos CSV con la información de Postes y Luminarias  para cada tipo de Luminaria.
def rep_luminaria():
    app = Flask(__name__)
    mysql = MySQL()

    app.config['MYSQL_DATABASE_HOST'] = 'localhost'
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
    app.config['MYSQL_DATABASE_DB'] = 'warnes'
    mysql.init_app(app)

    consulta = "SELECT * from luminaria"
    conexion = mysql.connect()
    cursor = conexion.cursor()
    cursor.execute(consulta)
    luminarias = cursor.fetchall()
    conexion.commit()
    for lum in luminarias:
        _id_luminaria = lum[0]
        _tipo = str(lum[1]).split(" ", 1)[0]
        if lum[2] is None:
            _potencia = ""
        else:
            _potencia = lum[2]

        sql = """
            SELECT p.id, p.latitud, p.longitud, p.observacion, pl.id_luminaria, l.tipo, l.potencia, pl.estado
            from poste p
            inner join poste_luminaria pl on p.id = pl.id_poste
            inner join luminaria l on pl.id_luminaria = l.id
            WHERE pl.id_luminaria = %s
            ORDER BY p.id;
            """
        conexion = mysql.connect()
        cursor = conexion.cursor()
        cursor.execute(sql, (_id_luminaria))
        pos_lum = cursor.fetchall()
        conexion.commit()
        if not pos_lum:
            continue
        nom_arch = f"tmp/{_tipo}{_potencia}-{len(pos_lum)}.csv"
        with open(nom_arch, "w") as archivo:
            writer = csv.writer(archivo)
            writer.writerow(["id", "latitud", "longitud",
                            "observacion", "id_luminaria", "tipo", "potencia", "estado"])
            for pl in pos_lum:
                writer.writerow(
                    [pl[0], pl[1], pl[2], pl[3], pl[4], pl[5], pl[6], pl[7]])


# Funcion que recibe los id's de tipos de luminarias y un nombre de archivo csv para llenarlo con la información de
# Postes y Luminarias en base a los tipos de luminarias especificados.
def rep_luminariaId(id_lum, nom_arch):
    app = Flask(__name__)
    mysql = MySQL()

    app.config['MYSQL_DATABASE_HOST'] = 'localhost'
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
    app.config['MYSQL_DATABASE_DB'] = 'warnes'
    mysql.init_app(app)

    with open(nom_arch, "w") as archivo:
        writer = csv.writer(archivo)
        writer.writerow(["id", "latitud", "longitud", "observacion",
                        "id_luminaria", "tipo", "potencia", "estado"])
        for id in id_lum:
            sql = """
                SELECT p.id, p.latitud, p.longitud, p.observacion, pl.id_luminaria, l.tipo, l.potencia, pl.estado
                from poste p
                inner join poste_luminaria pl on p.id = pl.id_poste
                inner join luminaria l on pl.id_luminaria = l.id
                WHERE pl.id_luminaria = %s
                ORDER BY p.id;
                """
            conexion = mysql.connect()
            cursor = conexion.cursor()
            cursor.execute(sql, (id))
            pos_lum = cursor.fetchall()
            conexion.commit()
            for pl in pos_lum:
                writer.writerow(
                    [pl[0], pl[1], pl[2], pl[3], pl[4], pl[5], pl[6], pl[7]])


# sumario()
rep_luminariaId([3070, 4020, 2125, 3150, 1000, 0], "tmp/Varios.csv")
rep_luminariaId([6000, 6100, 6050, 6040, 6150], "tmp/Led.csv")
rep_luminariaId([1150], "tmp/Sodio150.csv")
rep_luminariaId([1250], "tmp/Sodio250.csv")
rep_luminariaId([6035], "tmp/Led35.csv")
rep_luminariaId([1070], "tmp/Sodio70.csv")

# rep_luminaria()
