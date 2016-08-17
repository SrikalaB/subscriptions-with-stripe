class SubscriptionsController < ApplicationController
  require "stripe"
  def index
    @stripe_subscriptions_list = Stripe::Subscription.all()['data']
  end

  def edit
    @subscription = Stripe::Subscription.retrieve(params[:id])
  end

  def update
    subscription = Stripe::Subscription.retrieve(params[:id])
    subscription.quantity = params[:quantity]
    subscription.save
    redirect_to subscriptions_path
  end
end
