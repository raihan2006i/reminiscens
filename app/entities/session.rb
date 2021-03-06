class Session < ActiveRecord::Base
  # Start external modules declaration
  #
  # Remove this line and start writing your code here
  #
  # End external modules declaration

  # Start attributes reader/writer declaration
  # Please try to maintain alphabetical order
  #
  # Remove this line and start writing your code here
  #
  # End attributes reader/writer declaration

  # Start constants declaration
  # Please try to maintain alphabetical order
  #
  STATUS_NOT_STARTED = 'not_started'
  STATUS_ONGOING = 'ongoing'
  STATUS_FINISHED = 'finished'
  #
  # End constants declaration

  # Start relations declaration
  # Please try to maintain alphabetical order
  #
  belongs_to :creator, polymorphic: true
  has_many :slots, dependent: :destroy
  has_many :blocks, through: :slots
  has_many :session_histories, dependent: :destroy
  #
  # End relations declaration

  # Start validations declaration
  # Please try to maintain alphabetical order
  #
  # Remove this line and start writing your code here
  #
  # End validations declaration

  # Start callbacks declaration
  # Please try to maintain alphabetical order
  #
  # Remove this line and start writing your code here
  #
  # End callbacks declaration

  # Start instance method declaration
  # Please try to maintain alphabetical order
  #
  def start!
    update_attribute(:status, STATUS_ONGOING)
  end
  #
  # End instance method declaration

  # Start class method declaration
  # Please try to maintain alphabetical order
  #
  def self.status_options
    [STATUS_NOT_STARTED, STATUS_ONGOING, STATUS_FINISHED]
  end

  def self.status_options_for_dropdown
    status_options.sort.collect{|s| [s.humanize, s]}
  end
  #
  # End class method declaration

  # Protected methods
  # Please try to maintain alphabetical order
  protected
  # Remove this line and start writing your code here
  #
  # End protected methods

  # Private methods
  # Please try to maintain alphabetical order
  #
  private
  # Remove this line and start writing your code here
  #
  # End private methods
end
