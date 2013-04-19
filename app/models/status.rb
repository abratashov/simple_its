class Status < ActiveRecord::Base
  attr_accessible :id, :name

  has_many :tickets

  def self.default
    @default ||= Status.find_by_name('Waiting for Staff Response').id
  end
end
