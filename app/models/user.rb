class User < ActiveRecord::Base
  has_one :plan
end
