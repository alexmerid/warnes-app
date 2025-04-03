from flaskext.mysql import MySQL
from flask import Flask
import csv


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
    with open("tmp/archivo.csv", "w") as archivo:
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


sumario()
