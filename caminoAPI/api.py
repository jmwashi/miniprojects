import pandas as csvparse
import re
from collections import defaultdict
from flask import Flask, request
from flask_restful import Resource, Api, reqparse
import json
import requests
import wget
import csv
from werkzeug.datastructures import FileStorage
app = Flask(__name__)
api = Api(app)

"""
0 - year
1- month
2- fund id
3- department id
4- fund name
5- department name
6- amount
"""
parser = reqparse.RequestParser()
parser.add_argument('file',type=FileStorage,location='files')
class Vividict(dict):
    def __missing__(self, key):
        value = self[key] = type(self)()
        return value
class Request(Resource):
        def post(self):
                args = parser.parse_args()
                #with open('myfile.csv','w') as f:
                  #      w = csv.writer(f)
                 #       w.writerows(input.items())
                #parse csv file and create array for each row
                file1 = csvparse.read_csv(args['file'],skipinitialspace=True)
                outputJSON = Vividict()
                outputArray = []
                fileDict = file1.to_dict('index')
                #adding elements from dict to array
                for i, (k, v) in enumerate(fileDict.items()):
                        outputArray.append(list(fileDict[i].values()))
                outputJSON["rows_parsed"] =  outputArray
                outputJSON["aggregations"] = createOutputDict(outputArray)
                return outputJSON

def createOutputDict(inputArray):
        years = []
        output = Vividict()
        #creates the dictionary for the output JSON going line by line
        for transaction in inputArray:
                #writing values from each transaction to temporary variables
                years.append(transaction[0])
                year = str(transaction[0])
                fund = str(transaction[4])
                department = str(transaction[5])
                amountStr = str(transaction[6])
                amountStr = amountStr.replace(',', '')
                amount = float(amountStr)
                if type(amount) == float:
                        if amount > 0:
                                output[year]['revenues']['funds'][fund] = round(output[year]['revenues']['funds'].get(fund, 0) + amount,2)
                                output[year]['revenues']['departments'][department] = round(output[year]['revenues']['departments'].get(department, 0) + amount,2)
                                output[year]['revenues']['total']= round(output[year]['revenues'].get('total', 0) + amount,2)
                        else:
                                output[year]['expenses']['funds'][fund] = round(output[year]['expenses']['funds'].get(fund, 0) + amount,2)
                                output[year]['expenses']['departments'][department] = round(output[year]['expenses']['departments'].get(department, 0) + amount,2)
                                output[year]['expenses']['total']= round(output[year]['expenses'].get('total', 0) + amount,2)
        return output


api.add_resource(Request,'/scrub',endpoint='scrub')

if __name__ == '__main__':
     app.run(port='5000')