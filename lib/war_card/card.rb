# frozen_string_literal: true

module WarCard
    class Card
        attr_accessor :suit, :card_type, :rank

        def initialize(suit, card_type, rank)
            @suit = suit
            @card_type = card_type
            @rank = rank
        end

        def display_name
            "#{card_type}-#{suit}"
        end
    end
end
