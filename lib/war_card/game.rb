# frozen_string_literal: true

module WarCard
    class Game
        class << self
            def start
                GeneralService.log_data("*** War Card Game has to have 2 or 4 players. Please, Enter number of the players: ***")
                number_of_players = GeneralService.user_input

                return unless GeneralService.check_number_of_players(number_of_players)

                GeneralService.log_data("*** Welcome to War Card Game ***")
                play = WarCard::Play.new(number_of_players.to_i)

                play.play_the_game
            end
        end
    end
end
