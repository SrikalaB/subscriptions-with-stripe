config = YAML.load_file(File.expand_path("../../../config/stripe.yml",__FILE__))
Stripe.api_key = config["#{Rails_env}"]['secret_key']

