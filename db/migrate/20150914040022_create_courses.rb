class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :avatar
      t.text :description
      t.text :content
      t.integer :status, default: 0
      t.date :start_date
      t.date :end_date
      t.timestamps null: false
    end
  end
end
