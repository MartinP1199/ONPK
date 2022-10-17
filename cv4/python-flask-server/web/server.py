from flask import Flask, render_template, request
from modules.helper import getSubnets


app = Flask(__name__)


@app.route("/")
def index():
    return render_template("home.html")


@app.route("/subnets", methods=["GET"])
def subnetsMenu():
    return render_template("subnets.html")


@app.route("/subnets", methods=["POST"])
def subnets():
    address = request.form.get("address")
    mask = request.form.get("mask")
    hosts = request.form.get("hosts")
    variableMask = request.form.get("variableMask") == "on"
    return getSubnets(address, mask, hosts, variableMask)


@app.route("/helper", methods=["GET"])
def helper():
    if request.method == "GET":
        return render_template("helper.html")


def startServer():
    app.run("0.0.0.0", 80)


