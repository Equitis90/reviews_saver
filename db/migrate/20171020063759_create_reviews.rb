class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.references :product, foreign_key: true
      t.string :title
      t.text :comment
      t.date :date

      t.timestamps
    end
  end
end
