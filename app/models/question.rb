class Question < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  # This will establish a `has_many` association with answers. This assumes
  # that your answer model has a `question_id` integer field that references
  # the question. with has_many `answers` must be plural (Rails convention).
  # We must pass a `dependent` option to maintain data integrity. The possible
  # values you can give it are: :destroy or :nullify
  # With :destroy: if you delete a question it will delete all associated answers
  # With :nullify: if you delete a question it will update the `question_id` NULL
  #                for all associated records (they won't get deleted)
  has_many :answers, dependent: :destroy

  # This enables us to access all the comments created for all the question's
  # answers. This generates a single SQL statement with `INNER JOIN` to
  # accompolish it
  has_many :comments, through: :answers

  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  has_many :favourites, dependent: :destroy
  has_many :favrouting_users, through: :favourites, source: :user


  # this will fail validations (so it won't create or save) if the title is
  # not provided
  validates :title, presence:   true,
                    uniqueness: { case_sensitive: false },
                    length:     {minimum: 3, maximum: 255}

  # DSL: Domain Specific Language
  # the code we use in here is completely valid Ruby code but the method naming
  # and arguments are specific to ActiveRecord so we call this an ActiveRecord
  # DSL
  validates(:body, {uniqueness: {message: "must be unique!"}})

  # this validates that the combination of the title and body is unique. Which
  # means the title doesn't have to be unique by itself and the body doesn't
  # have to be unique by itself. However, the combination of the two fields
  # must be unique
  # validates :title, uniqueness: {scope: :body}

  validates :view_count, numericality: {greater_than_or_equal_to: 0}

  #   validates :email,
  #             format: { with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }

  # This is using custom validation method. We must make sure that `no_monkey`
  # is a method available for our class. The method can be public or private
  # It's more likely we will have it a private method because we don't need
  # to use it outside this class.
  validate :no_monkey

  after_initialize :set_defaults
  before_save :capitalize_title

  # scope :recent, lambda {|x| order("created_at DESC").limit(x) }
  def self.recent(number = 5)
    order("created_at DESC").limit(number)
  end

  def self.popular
    where("view_count > 10")
  end

  # Wildcard search by title or body
  # ordered by view_count in a descending order
  def self.search(term)
    where(["title ILIKE ? OR body ILIKE ?", "%#{term}%", "%#{term}%"]).
    order("view_count DESC")
  end

  def category_name
    category.name if category
  end

  # delegate :full_name, to: :user, prefix: true, allow_nil: true
  def user_full_name
    user.full_name if user
  end

  def like_for(user)
    likes.find_by_user_id user
  end

  def fav_for(user)
    favourites.find_by_user_id user
  end

  private

  def set_defaults
    self.view_count ||= 0
  end

  def capitalize_title
    self.title.capitalize!
  end

  def no_monkey
    if title && title.downcase.include?("monkey")
      errors.add(:title, "No monkey!!")
    end
  end

end
