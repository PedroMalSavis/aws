from flask import Flask, render_template, url_for, flash, redirect
from flask_sqlalchemy import SQLAlchemy
app = Flask(__name__)

import boto3 
import json

from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from wtforms.validators import DataRequired

class PostForm(FlaskForm):
    content = StringField('Content')
    submit = SubmitField('Post')

app.config['SECRET_KEY'] = '6dfb14ac6cec02f5734e7c8828c147cd'
# app.config['SQL_ALCHEMY_DATABASE_URI'] = 'sqlite:///site.db'

# db = SQLAlchemy(app)

# class Post(db.Model):
#   id = db.Column(db.Integer, primary_key = True)
#   content = db.Column(db.String(1000))

#   def __repr__(self):
#     return f"Post('{self.content}')"


pails = boto3.resource('s3')
comprehend = boto3.client(service_name='comprehend', region_name='us-west-2')


products = [
  { 
    "name": "Rice",
    "photo": "https://sorasystem-cdn.sirv.com/ricefarmer.jpg",
    "description": "Rice from Mindanao"
  },
  { 
    "name": "Pineapples",
    "photo": "https://sorasystem-cdn.sirv.com/pineapples.jpg",
    "description": "Pinya"
  },
  { 
    "name": "Meat",
    "photo": "https://sorasystem-cdn.sirv.com/fillet.jpg",
    "description": "Meat for cooking"
  },
]


@app.route("/", methods=['GET', 'POST'])
def home():
  form = PostForm() # creates a form object
  if form.validate_on_submit():
      flash(f'ok!', 'success')
      return redirect(url_for('home'))
  return render_template("home.html", products=products, pails=pails, form=form) # sets the form onto the html

@app.route("/input")
def input():
  return render_template("input.html")

@app.route("/about")
def about():
  return render_template("about.html")

# allow running from python
if __name__ == '__main__':
  app.run(debug=True)
  