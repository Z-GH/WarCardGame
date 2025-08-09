# frozen_string_literal: true

RSpec.describe WarCard::Player do
    describe "add_cards" do
        subject { described_class.new("Player 1") }

        let(:card_j) { WarCard::Card.new("spades", "J", 11) }
        let(:card_a) { WarCard::Card.new("hearts", "A", 14) }

        context "pass correct card data" do
            it "returns correct data" do
                subject.add_cards([ card_j, card_a ])

                expect(subject.cards_left).to eq(2)
                expect(subject.has_cards?).to be true
                expect(subject.player_cards).to eq([ card_j, card_a ])

                expect(subject.face_up_card).to eq(card_j)
                expect(subject.cards_left).to eq(1)

                expect(subject.face_up_card).to eq(card_a)
                expect(subject.cards_left).to eq(0)
                expect(subject.has_cards?).to be false
            end
        end

        context "pass nil card data" do
            let(:card) { nil }

            it "returns nil if card is nil" do
                subject.add_cards(card)

                expect(subject.player_cards.size).to eq(0)
            end
        end
    end
end
