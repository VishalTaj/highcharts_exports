from flask import Flask, jsonify, request
from highcharts_core.chart import Chart
import base64

app = Flask(__name__)

@app.route('/')
def heartbeat():
    return "OK"

@app.route('/generate', methods = ['POST'])
def generate():
    if request.is_json:
        data = request.get_json()
        chart = Chart.from_options(data)
        my_png_image = chart.download_chart(format = 'png')

        return {
            'image': base64.b64encode(my_png_image).decode('utf-8')
        }
    
    return jsonify({
      'error': 'Unable to process the image',
      'image': ''
    }), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)