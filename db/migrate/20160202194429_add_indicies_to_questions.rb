class AddIndiciesToQuestions < ActiveRecord::Migration
  def change
    # this will add an index (not unique) to the questions table on the title
    # column
    add_index :questions, :title
    add_index :questions, :body


    # This creates a unique index
    # add_index :questions, :body, unique: true

    # To create a composite index you can do:
    # add_index :questions, [:title, :body]
  end
end
