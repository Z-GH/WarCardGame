# frozen_string_literal: true

module WarCard
    class Deck
        attr_accessor :cards
        def initialize
            @cards = []
        end

        def create_deck
            cards_data = []
            [ "spades", "hearts", "clubs", "diamonds" ].each do |suit|
                (2..10).each do |n|
                    cards_data << Card.new(suit, n, n)
                end

                [ "J", "Q", "K", "A" ].each_with_index do |c, index|
                    cards_data << Card.new(suit, c, index + 11)
                end
            end

            # Shuffle the cards
            @cards += cards_data.shuffle
        end

        def get_size
            cards.size
        end

        def get_cards(number_of_cards)
            return if number_of_cards > cards.size

            cards.shift(number_of_cards)
        end

        def get_card
            cards.shift
        end
    end
end
