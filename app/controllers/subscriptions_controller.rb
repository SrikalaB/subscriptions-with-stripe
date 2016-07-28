class SubscriptionsController < ApplicationController
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

end
