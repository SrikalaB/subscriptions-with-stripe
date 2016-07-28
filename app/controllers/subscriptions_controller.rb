class SubscriptionsController < ApplicationController
  protect_from_forgery except: :webhooks
  require "stripe"

  def new

  end

  def create
    subscription = Stripe::Plan.create(
      amount: (params[:amount].to_i)*100,
      interval: params[:interval],
      name: params[:plan_name],
      currency: 'usd',
      trial_plan: nil,
      id: SecureRandom.uuid # This ensures that the plan is unique in stripe
    )
    #Save the response to your DB
    flash[:notice] = "Plan successfully created"
    redirect_to subscriptions_path
  end

  def index
  end

  def plans
    @stripe_list = Stripe::Plan.all
    @plans = @stripe_list[:data]
  end

  def subscription_checkout
    plan_id = params[:plan_id]
    plan = Stripe::Plan.retrieve(plan_id)
    #This should be created on signup.
    customer = Stripe::Customer.create(
            :description => "Customer for test@example.com",
            :source => params[:stripeToken],
            :email => "test@example.com"
          )
    # # Save this in your DB and associate with the user;s email
    # stripe_subscription = customer.subscriptions.create(:plan => plan.id)

    flash[:notice] = "Successfully created a charge"
    redirect_to plans_path
  end

  def webhooks
    begin
      event_json = JSON.parse(request.body.read)
      event_object = event_json['data']['object']
      #refer event types here https://stripe.com/docs/api#event_types
      case event_json['type']
        when 'invoice.payment_succeeded'
          handle_success_invoice event_object
        when 'invoice.payment_failed'
          handle_failure_invoice event_object
        when 'charge.failed'
          handle_failure_charge event_object
        when 'customer.subscription.deleted'
        when 'customer.subscription.updated'
      end
    rescue Exception => ex
      render :json => {:status => 422, :error => "Webhook call failed"}
      return
    end
    render :json => {:status => 200}
  end
end
