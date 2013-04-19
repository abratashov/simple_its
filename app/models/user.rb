class User < ActiveRecord::Base
  # attr_accessible :title, :body
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation, :name, :department_id
  
  belongs_to :department
  has_many :messages

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
end
