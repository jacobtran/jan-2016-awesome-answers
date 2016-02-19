class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user_id, :question_id, presence: true
  # this ensures that the user_id / question_id combination is unique which
  # means a user can only like a question once.
  validates :user_id, uniqueness: {scope: :question_id}
end
