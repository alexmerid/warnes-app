from flask import Flask
from flask import render_template, request, redirect
from flaskext.mysql import MySQL

app = Flask(__name__)
mysql = MySQL()

app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
app.config['MYSQL_DATABASE_DB'] = 'warnes'
mysql.init_app(app)


@app.route('/')
def inicio():

    return render_template('sitio/index.html')


@app.route('/luminarias')
def luminarias():
    conexion = mysql.connect()
    cursor = conexion.cursor()
    cursor.execute("SELECT * FROM luminaria")
    luminaria = cursor.fetchall()
    conexion.commit()

    return render_template('sitio/luminarias.html', luminarias=luminaria)


@app.route('/luminarias/guardar', methods=['POST'])
def luminarias_guardar():
    _id = request.form['txtId']
    _tipo = request.form['txtTipo']
    _potencia = request.form['txtPotencia']

    sql = "INSERT INTO luminaria (id, tipo, potencia) VALUES(%s, %s, %s);"
    datos = (_id, _tipo, _potencia)
    conexion = mysql.connect()
    cursor = conexion.cursor()
    cursor.execute(sql, datos)
    conexion.commit()

    return redirect('/luminarias')


@app.route('/luminarias/borrar', methods=['POST'])
def luminarias_borrar():
    _id = request.form['txtId']

    conexion = mysql.connect()
    cursor = conexion.cursor()
    cursor.execute("DELETE FROM luminaria WHERE id = %s;", (_id))
    conexion.commit()

    return redirect('/luminarias')


if __name__ == '__main__':
    app.run(debug=True)
