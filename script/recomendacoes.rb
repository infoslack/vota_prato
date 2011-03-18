# encoding: UTF-8
DEBUG = 1
@pessoa = {'Daniel Romero' => {'Beliscão' => 10.0, 'Fasano' => 7.0, 'Pastelaria Mei-Ze' => 5.0},
	'Jupira Trozoba' => {'Beliscão' => 7.0, 'Fasano' => 8.5, 'Pastelaria Mei-Ze' => 6.0},
		'Ronaldo Luiz' => {'Beliscão' => 7.5, 'Fasano' => 6.7, 'Pastelaria Mei-Ze' => 7.5}}

def new_example; puts "\n" + "-" * 80; end

#ESCALA DE CORRELAÇÃO DE PEARSON
def pearson(pessoa,p1,p2)

	sum1 = sum2 = sum1_sq = sum2_sq = length = 0
	pessoa[p2][pessoa[p1].to_a.first.first]
	sum_of_products = pessoa[p1].inject(0) do |product_sum, rating|
		if pessoa[p2][rating.first] 
			sum1 += pessoa[p1][rating.first]
			sum2 += pessoa[p2][rating.first]
			sum1_sq += pessoa[p1][rating.first] ** 2
			sum2_sq += pessoa[p2][rating.first] ** 2
			length += 1
			product_sum + pessoa[p1][rating.first] * pessoa[p2][rating.first]
		else
			product_sum
		end
	end

	num = sum_of_products - (sum1 * sum2 / length)
	den = Math.sqrt((sum1_sq - (sum1 ** 2) / length) * (sum2_sq - (sum2 ** 2) / length))

	return "den == 0" if den == 0
	num/den
end

if DEBUG > 0
	new_example
	test = pearson(@pessoa, 'Daniel Romero', 'Ronaldo Luiz')
	puts "#{test}"
end

#CLASSIFICAÇÃO DAS NOTAS DOS RESTAURANTES
def top_matches(pessoa, person, n=3)
	scores = pessoa.map do |critic, items|
		unless person == critic
			[(block_given? ? yield(pessoa, person, critic) : pearson(pessoa, person, critic)), critic]
		end
	end
	
	scores.compact.sort.reverse[0..n]
end

if DEBUG > 0
	new_example
	test = top_matches(@pessoa, 'Daniel Romero', 1) { |pessoa, person, critic| pearson(pessoa, person, critic) }
	puts "#{test.join(" , ")}"
end

#RECOMENDANDO ITENS
def recommendations(pessoa, person)
		
	totals = Hash.new(0.0)
	
	sim_sums = Hash.new(0.0)

	pessoa.each do |critic, items|
		next if critic == person

		sim = block_given? ? yield(pessoa, person, critic) : pearson(pessoa, person, critic)
		
		next if sim <= 0

		pessoa[critic].each do |item, rating|
			next if pessoa[person][item] 

			totals[item] += pessoa[critic][item] * sim
			sim_sums[item] += sim
		end
	end

	rankings = totals.map {|item, total| [total/sim_sums[item], item] }
	rankings.sort.reverse
end

if DEBUG > 0
	new_example
	test = recommendations(@pessoa, 'Daniel Romero')
	puts "#{test.join(", ")}"
end

#TRANSFORMAR O HASH
def transform_hash(pessoa)
	 h = Hash.new {|hash, key| hash[key] = {}}

	 pessoa.each do |person, ratings|
	 	ratings.each {|item, rating| 	h[item][person] = rating }
	 end

	 h

end

if DEBUG > 0
	new_example
	items = transform_hash(@pessoa)
	test = top_matches(items, 'Fasano')
	puts "#{test.join(", ")}"
end