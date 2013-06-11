class CreateFedoraRailsFedoraAttributes < ActiveRecord::Migration
  def change
    create_table :fedora_rails_fedora_attributes do |t|

      t.integer :fedorable_id
      t.string :fedorable_type

      t.string :pid

      t.timestamps
    end
  end
end
