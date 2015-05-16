module Dota
  module API
    class Match
      class Side < Entity
        TOWERS = [
          :ancient_top,
          :ancient_bottom,
          :bottom_tier_3,
          :bottom_tier_2,
          :bottom_tier_1,
          :middle_tier_3,
          :middle_tier_2,
          :middle_tier_1,
          :top_tier_3,
          :top_tier_2,
          :top_tier_1
        ].freeze

        BARRACKS = [
          :bottom_ranged,
          :bottom_melee,
          :middle_ranged,
          :middle_melee,
          :top_ranged,
          :top_melee
        ].freeze

        def id
          raw["team_id"]
        end

        def name
          raw["name"]
        end

        def logo_id
          raw["logo"]
        end

        def complete?
          raw["team_complete"] == 1
        end

        def tower_status
          format_status raw["tower_status"], :towers
        end

        def barracks_status
          format_status raw["barracks_status"], :barracks
        end

        def players
          raw["players"].map do |raw_player|
            Player.new(raw_player)
          end
        end

        def captain_id
          raw["captain"]
        end

        private

        def format_status(obj, type)
          target = (type == :barracks ? BARRACKS : TOWERS)
          # Convert to binary
          # Leading zeros are stripped, so add them manually
          obj = obj.to_s(2).rjust(target.length, '0')

          status = {}
          target.each_with_index do |position, i|
            status[position] = (obj[i] == '1')
          end
          status
        end
      end
    end
  end
end