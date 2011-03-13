class Prato < ActiveRecord::Base
	validates_presence_of :nome, :message => " - deve ser preenchido"

	validates_uniqueness_of :nome, :message => " - nome já cadastrado"

	has_and_belongs_to_many :restaurantes
	has_one :receita
end
