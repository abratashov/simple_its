class Status < ActiveRecord::Base
  attr_accessible :id, :name

  has_many :tickets

  scope :get_by, lambda { |regex_str|
    { :conditions => [" name REGEXP ? " , regex_str] }
  }

  def self.default
    @default ||= Status.find_by_name('Waiting for Staff Response').id
  end
end
