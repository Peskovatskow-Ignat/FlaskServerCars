from flask import Flask, request
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2.sql import SQL, Literal
import logging
import os


def get_pg_connect():
    conn = psycopg2.connect(host = "host.docker.internal", port = os.getenv("POSTGRES_PORT"), database = os.getenv("POSTGRES_DB"), user = os.getenv("POSTGRES_USER"),
                            password = os.getenv("POSTGRES_PASSWORD"), cursor_factory=RealDictCursor)
    conn.autocommit = True
    return conn


app = Flask(__name__)
app.config["JSON_AS_ASCII"] = True


@app.route("/")
def hello_word():
    return "<p>And what are we doing here :) </p>"


@app.route("/service")
def service():
    try:
        querty = """
with service_with_sc as (select s.id,
                               s.name_s,
                               s.founding_date,
                               s.quality,
                               s.place,
                               coalesce(
                                               json_agg(
                                               json_build_object('function', sc.function, 'wage', sc.wage, 'prize', sc.prize)
                                           ) filter (where sc.function is not null),
                                               '[]') as service_cooperator
                        from service s 
                                 left join service_cooperator sc on s.id = sc.service_id
                        group by s.id, s.name_s, s.founding_date, s.quality, s.place),
     service_with_cars as (select service_id,
                                      coalesce(
                                              json_agg(
                                                      json_build_object('name_cars', c.name, 'date_of_manufacture', c.date_of_manufacture, 'rating', c.rating, 'review', c.review, 'driving_style', c.driving_style, 'quantity', c.quantity, 'fuel', fuel)
                                                  ),
                                              '[]') as cars
                               from cars_to_service cs
                                        join cars c  on c.id = cs.cars_id
                               group by service_id)
select id, name_s, founding_date, quality, place, service_cooperator, coalesce(cars, '[]') as cars
from service_with_sc swsc
         left join service_with_cars swc on swsc.id = swc.service_id;
        """
        with get_pg_connect() as conn, conn.cursor() as cur:
            cur.execute(querty)
            holders = cur.fetchall()
        return holders
    except Exception as ex:
        logging.error(ex, exc_info=True)
        return "Bad request", 400


@app.route("/service/create", methods=["POST"])
def create_service():
    try:
        body = request.json
        name = body["name_s"]
        founding_date = body["founding_date"]
        quality = body["quality"]
        place = body["place"]

        query = SQL("""
        insert into service(name_s, founding_date, quality, place) 
        values({name}, {founding_date}, {quality}, {place}) 
        returning name_s, founding_date, quality, place
        """).format(name=Literal(name), founding_date=Literal(founding_date), quality=Literal(quality), place=Literal(place))

        with get_pg_connect() as conn, conn.cursor() as cur:
            cur.execute(query)
            service = cur.fetchone()
        return {
            "msg": f"Service with name = {service['name_s']}, phone = {service['founding_date']}, quality = {service['quality']}, place = {service['place']} created"}
    except Exception as ex:
        logging.error(ex, exc_info=True)
        return "Bad request", 400


@app.route("/service/update", methods=['POST'])
def update_service():
    try:
        body = request.json
        id = body['id']
        name = body['name_s']
        founding_date = body['founding_date']
        quality = body['quality']
        place = body['place']

        query = SQL("""
        update service 
        set name_s = {name}, founding_date = {founding_date}, quality = {quality}, place = {place}
        where id = {id}
        returning id, name_s, founding_date, quality, place
        """).format(id=Literal(id), name=Literal(name), founding_date=Literal(founding_date), quality=Literal(quality), place=Literal(place))

        with get_pg_connect() as conn, conn.cursor() as cur:
            cur.execute(query)
            service = cur.fetchone()

        return {"msg": f"Service with id = {service['id']} updated."}
    except Exception as ex:
        logging.error(ex, exc_info=True)
        return "Bad request.", 400


@app.route("/service/delete", methods=["DELETE"]) 
def delete_service():
    try:
        body = request.json
        id = body["id"]

        query = SQL("""delete from service
         where id = {id} 
         returning id, name_s, founding_date, quality, place""").format(id=Literal(id))

        with get_pg_connect() as conn, conn.cursor() as cur:
            cur.execute(query)
            service = cur.fetchone()
        return {
            "msg": f"Service with name = {service['name_s']}, founding_date = {service['founding_date']}, quality = {service['quality']}, place = {service['place']} delete"}
    except Exception as ex:
        logging.error(ex, exc_info=True)
        return "Bad request", 400

