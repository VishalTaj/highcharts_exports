#!/bin/bash
set -e

docker run -p 5000:5000 -v "$(pwd)":/app highcharts_export