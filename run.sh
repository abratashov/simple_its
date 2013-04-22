#!/bin/bash

resque-web &
rake resque:work QUEUE='*' &
echo 'Rake was strated'
rails s --port=3001
