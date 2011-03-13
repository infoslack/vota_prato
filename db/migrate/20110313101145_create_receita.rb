class CreateReceita < ActiveRecord::Migration
  def self.up
    create_table :receita do |t|
	    t.integer :prato_id
	    t.text :conteudo

      t.timestamps
    end
  end

  def self.down
    drop_table :receita
  end
end
