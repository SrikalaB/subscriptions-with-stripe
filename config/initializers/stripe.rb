require 'yaml'

STRIPE_CONFIG = YAML.load_file(File.expand_path("../../../config/stripe.yml",__FILE__))
Stripe.api_key = STRIPE_CONFIG["#{Rails.env}"]['secret_key']

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    # Define subscriber behavior based on the event object
    event.class       #=> Stripe::Event
    event.type        #=> "charge.failed"
    event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
  end

  events.all do |event|
    # Handle all event types - logging, etc.
  end
end
