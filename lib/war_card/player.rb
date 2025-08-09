# frozen_string_literal: true

module WarCard
    class Player
        attr_accessor :player_cards, :name

        def initialize(name)
            @name = name
            @player_cards = []
        end

        def add_cards(cards)
            return if cards.blank?

            player_cards << cards

            player_cards.flatten! # Ensure player_cards is a flat array and save the player_cards
        end

        def cards_left
            player_cards.size
        end

        def has_cards?
            !player_cards.empty?
        end

        def face_up_card
            return if player_cards.empty?

            player_cards.shift
        end
    end
end
