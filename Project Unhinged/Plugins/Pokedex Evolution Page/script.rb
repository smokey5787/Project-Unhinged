#===============================================================================
# Pokedex Evolution Page
#===============================================================================
# Adding the page
#===============================================================================
UIHandlers.add(:pokedex, :page_evolution, {
  "name"      => "EVOLUTION",
  "suffix"    => "evolution",
  "order"     => 40,
	"onlyOwned" => true,
  "layout"    => proc { |pkmn, scene| scene.drawPageEvolution }
})

#===============================================================================
# Page Script
#===============================================================================
class PokemonPokedexInfo_Scene
	alias org_pbStartScene pbStartScene
  def pbStartScene(*args)
		org_pbStartScene(*args)
		10.times do |i|
			@sprites["evoicon#{i}"] = PokemonSpeciesIconSprite.new(nil, @viewport)
    	@sprites["evoicon#{i}"].setOffset(PictureOrigin::CENTER)
    	@sprites["evoicon#{i}"].x = 0
    	@sprites["evoicon#{i}"].y = 158
			@sprites["evoicon#{i}"].visible = false
		end
		pbUpdateDummyPokemon
	end

	alias org_pbUpdateDummyPokemon pbUpdateDummyPokemon
	def pbUpdateDummyPokemon
		org_pbUpdateDummyPokemon
		stage_1 = GameData::Species.get(@species).get_baby_species
		stage_2 = GameData::Species.get(stage_1).get_evolutions.map {|poke| poke.push(stage_1)}
		stage_3 = []
		stage_2.each do |pkmn|
			stage_3.concat(GameData::Species.get(pkmn[0]).get_evolutions.map {|poke| poke.push(pkmn[0])})
		end
		@evolutions = [[[stage_1]]]
		@evolutions.push(stage_2.uniq {|pkmn| pkmn[0]}) if !stage_2.empty?
		@evolutions.push(stage_3.uniq {|pkmn| pkmn[0]}) if !stage_3.empty?
		10.times do |i|
			@sprites["evoicon#{i}"]&.species = nil
		end
		index = 0
		@evolutions.length.times do |i|
			@evolutions[i].length.times do |v|
				@sprites["evoicon#{index}"]&.species = @evolutions[i][v][0]
				@sprites["evoicon#{index}"]&.x = ((Graphics.width + 100) / (@evolutions[i].length + 1)) * (v + 1) - 50
				@sprites["evoicon#{index}"]&.y = (Graphics.height / (@evolutions.length + 1)) * (i + 1)
				index += 1
			end
		end
		index = 0
		if @evolutions[0][0][0].to_sym == :EEVEE
			@evolutions.length.times do |i|
				@evolutions[i].length.times do |v|
					@sprites["evoicon#{index}"]&.x = [256, 103, 409, 103, 256, 409, 103, 256, 409][index]
					@sprites["evoicon#{index}"]&.y = [96, 96, 96, 192, 192, 192, 288, 288, 288][index]
					index += 1
				end
			end
		end
	end

	alias org_drawPage drawPage
	def drawPage(page)
		10.times do |i|
			@sprites["evoicon#{i}"].visible = false if @sprites["evoicon#{i}"]
		end
		pbSetSystemFont(@sprites["overlay"].bitmap)
		org_drawPage(page)
	end

	def drawPageEvolution
		10.times do |i|
			@sprites["evoicon#{i}"].visible = true if !@sprites["evoicon#{i}"].species.nil?
		end
    overlay = @sprites["overlay"].bitmap
		pbSetNarrowFont(overlay)
    base    = Color.new(88, 88, 80)
    shadow  = Color.new(168, 184, 184)
    # Write species and form name
    species = ""
    @available.each do |i|
      if i[1] == @gender && i[2] == @form
        formname = i[0]
        break
      end
    end
    textpos = []
		index = 0
		@evolutions.length.times do |i|
			@evolutions[i].length.times do |v|
				if GameData::Species.get(@evolutions[i][v][0]).get_baby_species == @evolutions[i][v][0]
					index += 1
					next
				end
				case @evolutions[i][v][1]
				when :Level,:Silcoon,:Cascoon then evo_txt = ["Lv. #{@evolutions[i][v][2]}"]
				when :LevelMale then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(Male)"]
				when :LevelFemale then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(Female)"]
				when :LevelDay then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(during the day)"]
				when :LevelNight then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(at night)"]
				when :LevelMorning then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(during the morning)"]
				when :LevelAfternoon then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(during the afternoon)"]
				when :LevelNoWeather then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(during the evening)"]
				when :LevelSun then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(during sun)"]
				when :LevelRain then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(during rain)"]
				when :LevelSnow then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(during snow)"]
				when :LevelSandstorm then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(during sandstorm)"]
				when :LevelCycling then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(while cycling)"]
				when :LevelSurfing then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(while surfing)"]
				when :LevelDiving then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(while diving)"]
				when :LevelDarkness then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(on dark places)"]
				when :LevelDarkInParty then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(with a Dark-type in the party)"]
				when :AttackGreater then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(Atk > Def)"]
				when :AtkDefEqual then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(Atk = Def)"]
				when :DefenseGreater then evo_txt = ["Lv. #{@evolutions[i][v][2]}", "(Atk < Def)"]
				when :Ninjask then evo_txt = ["Lv. #{@evolutions[i][v][2]}"]
				when :Shedinja then evo_txt = ["Pokeball in bag", "and space in party"]
				when :Happiness then evo_txt = ["Lv. up", "with high friendship"]
				when :HappinessMale then evo_txt = ["High friendship", "(Male)"]
				when :HappinessFemale then evo_txt = ["High friendship", "(Female)"]
				when :HappinessDay then evo_txt = ["High friendship", "(during the day)"]
				when :HappinessNight then evo_txt = ["High friendship", "(at night)"]
				when :HappinessMove then evo_txt = ["High friendship", "knowing #{GameData::Move.get(@evolutions[i][v][2]).name}"]
				when :HappinessMoveType then evo_txt = ["High friendship", "knowing #{GameData::Type.get(@evolutions[i][v][2]).name}-type move"]
				when :HappinessHoldItem then evo_txt = ["High friendship", "holding #{GameData::Item.get(@evolutions[i][v][2]).name}"]
				when :MaxHappiness then evo_txt = ["Lv. up", "with max friendship"]
				when :Beauty then evo_txt = ["Lv. up", "with high beauty"]
				when :HoldItem then evo_txt = ["Lv. up", "holding #{GameData::Item.get(@evolutions[i][v][2]).name}"]
				when :HoldItem then evo_txt = ["Lv. up", "holding #{GameData::Item.get(@evolutions[i][v][2]).name}"]
				when :HoldItemMale then evo_txt = ["Lv. up holding", "#{GameData::Item.get(@evolutions[i][v][2]).name} (Male)"]
				when :HoldItemFemale then evo_txt = ["Lv. up holding", "#{GameData::Item.get(@evolutions[i][v][2]).name} (Female)"]
				when :DayHoldItem then evo_txt = ["Lv. up holding", "#{GameData::Item.get(@evolutions[i][v][2]).name} (during the day)"]
				when :NightHoldItem then evo_txt = ["Lv. up holding", "#{GameData::Item.get(@evolutions[i][v][2]).name} (at night)"]
				when :HasMove then evo_txt = ["Lv. up", "knowing #{GameData::Move.get(@evolutions[i][v][2]).name}"]
				when :HasMoveType then evo_txt = ["Lv. up", "knowing #{GameData::Type.get(@evolutions[i][v][2]).name}-type move"]
				when :HasInParty then evo_txt = ["Lv. up", "with #{GameData::Species.get(@evolutions[i][v][2]).name} in party"]
				when :Location then evo_txt = ["Lv. up", "near #{@evolutions[i][v][2]}"]
				when :LocationFlag then evo_txt = ["Lv. up", "near #{@evolutions[i][v][2]}"]
				when :Item then evo_txt = ["#{GameData::Item.get(@evolutions[i][v][2]).name}"]
				when :ItemMale then evo_txt = ["#{GameData::Item.get(@evolutions[i][v][2]).name}", "(Male)"]
				when :ItemFemale then evo_txt = ["#{GameData::Item.get(@evolutions[i][v][2]).name}", "(Female)"]
				when :ItemDay then evo_txt = ["#{GameData::Item.get(@evolutions[i][v][2]).name}", "(during the day)"]
				when :ItemNight then evo_txt = ["#{GameData::Item.get(@evolutions[i][v][2]).name}", "(at night)"]
				when :ItemHappiness then evo_txt = ["#{GameData::Item.get(@evolutions[i][v][2]).name}", "with high friendship"]
				when :Trade then evo_txt = ["Trade"]
				when :TradeMale then evo_txt = ["Trade", "(Male)"]
				when :TradeFemale then evo_txt = ["Trade", "(Female)"]
				when :TradeDay then evo_txt = ["Trade", "(during the day)"]
				when :TradeNight then evo_txt = ["Trade", "(at night)"]
				when :TradeItem then evo_txt = ["Trade", "holding #{GameData::Item.get(@evolutions[i][v][2]).name}"]
				when :TradeSpecies then evo_txt = ["Trade", "for #{GameData::Species.get(@evolutions[i][v][2]).name}"]
				when :BattleDealCriticalHit then evo_txt = ["After dealing critical hit in battle"]
				when :Event then evo_txt = ["Special Event"]
				when :EventAfterDamageTaken then evo_txt = ["Special Event", "after taking damage"]
				else evo_txt = ["???"]
				end
				evo_txt = [evo_txt[0] + " " + evo_txt[1]] if @evolutions[i].length < 2 && evo_txt.length > 1
				evo_txt = [evo_txt[0] + " " + evo_txt[1]] if evo_txt[1] && (evo_txt[0].length + evo_txt[1].length <= 16)
				textpos.push([evo_txt[0], @sprites["evoicon#{index}"].x, @sprites["evoicon#{index}"].y + 32, :center, base, shadow])
				textpos.push([evo_txt[1], @sprites["evoicon#{index}"].x, @sprites["evoicon#{index}"].y + 64, :center, base, shadow]) if evo_txt.length > 1
				index += 1
			end
		end
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
	end
end