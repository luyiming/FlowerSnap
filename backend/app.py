from flask import Flask, request, jsonify
from PIL import Image
import io
import base64
import os
import json
from time import gmtime, strftime
import uuid
import shutil


app = Flask(__name__)

all_data = []
if os.path.exists('uploads/data.json'):
    with open('uploads/data.json', 'r') as f:
        all_data = json.load(f)


if not os.path.exists('uploads'):
    os.makedirs('uploads')


@app.route("/share", methods=['GET', 'POST'])
def share():
    global all_data

    data = request.get_json()
    print("name", data['name'])
    print("latitude", data['latitude'])
    print("longitude", data['longitude'])
    print("predictIndex", data['predictIndex'])
    print("predictProbs", data['predictProbs'])

    for x in all_data:
        if x['latitude'] == data['latitude'] and x['longitude'] == data['longitude']:
            if os.path.exists('uploads/{}.png'.format(x['image_index'])):
                os.remove('uploads/{}.png'.format(x['image_index']))
            print('removing:', 'uploads/{}.png'.format(x['image_index']))

    all_data = list(filter(lambda x: x['latitude'] != data['latitude'] or x['longitude'] != data['longitude'], all_data))

    image_index = uuid.uuid4().hex

    img = Image.open(io.BytesIO(base64.b64decode(data['sourceImage'])))
    img.save('uploads/{}.png'.format(image_index))

    data.pop('sourceImage')
    data['date'] = strftime("%Y-%m-%d %H:%M:%S", gmtime())
    data['image_index'] = image_index

    all_data.append(data)

    with open('uploads/data.json', 'w') as f:
        json.dump(all_data, f, ensure_ascii=False)

    return "ok"


@app.route("/query", methods=['GET'])
def query():
    return jsonify({
        'data': all_data
    })


@app.route("/detail", methods=['GET'])
def get_detail():
    print(request)
    print(request.args)
    image_index = request.args['image_index']
    print(image_index)
    with open('uploads/{}.png'.format(image_index), 'rb') as f:
        data = f.read()
        result = base64.b64encode(data).decode('ascii')

    return result

if __name__ == "__main__":
    app.run("0.0.0.0", 5000, debug=True)
