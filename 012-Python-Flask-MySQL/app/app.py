#!/usr/bin/env python3
import time, sys, json
import sqlite3
import os, re

from flask import Flask, session, url_for, render_template, redirect, request


app = Flask(__name__)

def db_conn():
    dbname = "data/names.db"
    rv = sqlite3.connect(dbname)
    rv.row_factory = sqlite3.Row
    stat = os.stat(dbname)
    if stat.st_size == 0:
        with app.open_resource('../data/schema.sql', mode='r') as f:
            rv.cursor().executescript(f.read())
        rv.commit()
    return rv

@app.after_request
def add_header(r): 
    r.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    r.headers["Pragma"] = "no-cache"
    r.headers["Expires"] = "0"
    r.headers['Cache-Control'] = 'public, max-age=0'
    return r

@app.route('/')
def index():
    return render_template('index.tpl.j2')

@app.route('/list') 
def show(dateStart = None, dateEnd = None):


    dates = dict({
        'start': request.args.get('start', None), 
        'end': request.args.get('end', None)
    })  

    for dkey, dvalue in dates.items():
        if dvalue is not None and re.match( '^\d{4}-\d{2}-\d{2}$', dvalue) is None:
            dates[dkey] = None


    
    where = ""
    if dates.get('start') is not None and dates.get('end') is not None:
        where = "WHERE strftime('%Y-%m-%d', time) BETWEEN '{}' AND '{}'".format( dates.get('start'), dates.get('end'))  

    db = db_conn()
    sql = f'SELECT name, time FROM names {where} ORDER BY time DESC'
    cur = db.execute(sql  )

    return render_template('list.tpl.j2',  dates=dates, data=cur.fetchall())

@app.route('/add', methods=['GET', 'POST'])
def add():

    if request.method == 'POST':
        if len(request.form["name"]) > 3:
            # insert
            db = db_conn()
            db.execute('insert into main.names (name, time) values (?, DATETIME("now"))', 
                [request.form["name"]])
            db.commit()
            return redirect( url_for( 'add', ok="name-added" ) )
            # return json.dumps(request.form["name"])
       
        return redirect( url_for( 'add', error="empty-or-small-name" ) )

    return render_template('add.tpl.j2')


if __name__ == '__main__': 
    # db_conn()
    app.run(debug=True, host='0.0.0.0')