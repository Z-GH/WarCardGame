# frozen_string_literal: true

RSpec.describe WarCard::Card do
    describe 'get_card' do
        subject { described_class.new(suit, card_type, rank) }

        let(:suit) { :spades }
        let(:card_type) { 9 }
        let(:rank) { 9 }

        context 'display_name with number returns correct data' do
            it 'returns correct data' do
                expect(subject.display_name).to eq("9-spades")
            end
        end

        context 'get_card with letter returns correct data' do
            let(:card_type) { "J" }

            it 'returns correct data' do
                expect(subject.display_name).to eq("J-spades")
            end
        end
    end
end
