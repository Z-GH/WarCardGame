# frozen_string_literal: true

module WarCard
  class Play
      attr_accessor :players, :deck, :number_of_players

      def initialize(number_of_players)
        @players = []
        @number_of_players = number_of_players
        @deck = Deck.new
        setup
      end

      def play_the_game
        round = 1
        winner = nil

        while true
            if winner
              GeneralService.log_data("*** #{winner.name} wins the game! ***")
              break
            end

            if players.count { |p| p.has_cards? } <= 1
              GeneralService.log_data("================================")
              GeneralService.log_data("*** Game Over! ***")
              break
            end

            GeneralService.log_data("================================")
            GeneralService.log_data("*** Round #{round} ***")
            GeneralService.log_data("================================")
            play_round(players.select(&:has_cards?))
            eliminate_players

            round += 1
        end

        winner = @players.find(&:has_cards?)
        GeneralService.log_data("*** Winner is #{winner.name} with #{winner.cards_left} cards! ***")
      end

      private

      def setup
        deck.create_deck
        cards_per_player = deck.get_size / number_of_players

        number_of_players.times do |i|
          player = Player.new("Player #{i + 1}")
          player.add_cards(deck.get_cards(cards_per_player))
          players << player
          GeneralService.log_data("*** #{player.name} has #{player.player_cards.map(&:display_name)} cards ***")
        end
      end

      def play_round(players)
          played_cards = {}

          players.each do |player|
            card = player.face_up_card
            played_cards[player] = [ card ]
            GeneralService.log_data("*** #{player.name} *** ==> plays #{card.display_name} ***")
          end

          resolve_war(played_cards)
      end

      def eliminate_players
        @players.reject! { |player| !player.has_cards? }
      end

      def resolve_war(played_cards, war_cards = {}, face_down_cards = [])
        highest_card = played_cards.values.map(&:last).map { |card| card&.rank }.max
        winners = played_cards.select { |_player, cards| cards&.last&.rank == highest_card }.keys

        war_cards.merge!(played_cards) { |_key, war_cards_val, played_cards_val| war_cards_val + [ played_cards_val ] }

        # If there is a single winner, they take all the cards
        if winners.size == 1
          winner = winners.first
          won_cards = war_cards.values.flatten.shuffle
          won_cards.compact!
          GeneralService.log_data("*** Face up cards #{won_cards.map(&:display_name)}  ***")


          winner.add_cards(won_cards)
          unless face_down_cards.empty?
                        winner.add_cards(face_down_cards)
                        GeneralService.log_data("*** Face down cards #{face_down_cards.map(&:display_name)}  ***")
          end

          GeneralService.log_data("*** #{winner.name} wins this round and takes #{won_cards.size + face_down_cards.size} cards ***")
          GeneralService.log_data("*** #{winner.name} total cards: #{winner.cards_left} ***")


        # If there is more than one player with the same highest card, a war occurs between them
        else
          GeneralService.log_data("*** War between players: #{winners.map(&:name).join(", ")} ***")
          new_play = {}

          winners.each do |player|
            if player.cards_left < 4
              (player.cards_left - 1).times { face_down_cards << player.face_up_card }
              face_up = player.face_up_card
            else
              3.times { face_down_cards << player.face_up_card }
              face_up = player.face_up_card
            end
            new_play[player] = [ face_up ]
            GeneralService.log_data("*** #{player.name} plays #{face_up.display_name} face up for war ***") unless face_up.nil?
          end
          resolve_war(new_play, war_cards, face_down_cards)
        end
      end
  end
end
