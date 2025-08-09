# frozen_string_literal: true

module WarCard
    class GeneralService
       class << self
            def log_data(message)
                Rails.logger.info(message)
            end

            def user_input
                gets.chomp.strip.downcase
            end

            def check_number_of_players(number_of_players)
                if number_of_players.blank?
                    log_data("*** No input provided. Please, Enter number of the players: ***")
                    return false
                end

                if number_of_players.to_i == 0
                    log_data("*** #{number_of_players} is not a number. Please, Enter number of the players: ***")
                    return false
                end

                number_of_players = number_of_players.to_i

                unless number_of_players == 2 || number_of_players == 4
                    log_data("*** War Card Game has to have 2 or 4 players ***")
                    return false
                end

                true
            end
       end
    end
end
