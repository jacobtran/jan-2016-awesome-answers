class CreateQuestions < ActiveRecord::Migration
  def change
    # No need to specify an `id` column. ActiveRecord automatically created
    # an integer field called `id` with AUTOINCREMENT
    create_table :questions do |t|
      t.string :title
      t.text :body

      t.timestamps null: false
      # timestamps will add two datetime fields: created_at & updated_at
    end
  end
end
