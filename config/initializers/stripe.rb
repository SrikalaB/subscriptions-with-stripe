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

  events.subscribe 'invoice.payment_succeeded' do |event|
    # Retrieve the latest version of the stripe invoice
    stripe_invoice = event.data.object
    stripe_invoice = Stripe::Invoice.retrieve(stripe_invoice.id)
  end


  events.subscribe 'invoice.payment_failed' do |event|
    # Retrieve the latest version of the stripe invoice
    stripe_invoice = event.data.object
    stripe_invoice = Stripe::Invoice.retrieve(stripe_invoice.id)
  end


  events.subscribe 'customer.updated' do |event|
    # Retrieve the latest version of the stripe customer
    stripe_customer = event.data.object
    stripe_customer = Stripe::Customer.retrieve(stripe_customer.id)
  end


  events.subscribe 'customer.deleted' do |event|
    stripe_customer = event.data.object
    puts 'customer.deleted'
    # Find the subscription record in local database, or skip executing this event if it's not found
    # subscription = Subscription.where(customer_uid: stripe_customer.id).first || next

    # subscription.block!
  end


  events.subscribe 'customer.subscription.deleted' do |event|
    stripe_subscription = event.data.object
  end


  events.subscribe 'customer.subscription.created' do |event|
    # Retrieve the latest version of the stripe subscription
    stripe_subscription = event.data.object
    stripe_customer = Stripe::Customer.retrieve(stripe_subscription.customer)
    stripe_subscription = stripe_customer.subscriptions.first
  end


  events.subscribe 'customer.subscription.updated' do |event|
    # Retrieve the latest version of the stripe subscription
    stripe_subscription = event.data.object
    stripe_customer = Stripe::Customer.retrieve(stripe_subscription.customer)
    stripe_subscription = stripe_customer.subscriptions.first
  end


  events.subscribe 'customer.subscription.trial_will_end' do |event|
    # Retrieve the latest version of the stripe subscription
    stripe_subscription = event.data.object
    stripe_customer = Stripe::Customer.retrieve(stripe_subscription.customer)
  end
end
