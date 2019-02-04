class TpasController < ApplicationController
  layout 'two_column'

  def index
  end

  def get_tpas
    @tpas = []
    Parties::Party.each do |party|
      if party.present?
        kind = party.party_roles.first
        if kind.present?
        if kind.party_role_kind.key = :tpa
          @tpas << party
        end
        end
      end
    end
    render json: { data: @tpas }
  end

end
