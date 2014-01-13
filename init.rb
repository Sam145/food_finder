### FOOD FINDER ###

APP_ROOT = File.dirname(__FILE__)

require File.join(APP_ROOT, 'lib', 'guide')
require File.join(APP_ROOT, 'lib', 'restaurant')
require File.join(APP_ROOT, 'lib', 'support', 'string_extend')



guide =  Guide.new('restaurant.txt')
guide.launch!