require 'yaml'

STRIPE_CONFIG = YAML.load_file(File.expand_path("../../../config/stripe.yml",__FILE__))
Stripe.api_key = STRIPE_CONFIG["#{Rails.env}"]['secret_key']

