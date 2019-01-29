module Wages

	TAXABLE_WAGES_MAXIMUM = 9_000
	
	class WageReport
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  SUBMISSION_KINDS 		= [:original, :ammended, :estimated]
	  FILING_METHOD_KINDS = [:upload, :manual_entry, :no_wages]

	  STATUS_KINDS 				= [:processed]

		# attr_readonly :submission_kind, :submitted_at

	  field :submitted_at, 							type: Time
	  field :submitted_by_id, 					type: BSON::ObjectId
	  field :user_account_id, 					type: BSON::ObjectId

	  field :status,										type: Symbol
	  field :submission_kind,						type: Symbol
	  field :filing_method_kind,				type: Symbol

	  field :total_wages, 							type: BigDecimal
	  field :excess_wages, 							type: BigDecimal
	  field :taxable_wages, 						type: BigDecimal

	  field :ui_tax_contribution, 			type: BigDecimal
	  field :ui_admin_fee_contribution,	type: BigDecimal
	  field :ui_interest_charges_paid, 	type: BigDecimal
	  field :ui_penalty_charges_paid, 	type: BigDecimal

	  field :ui_total_due, 							type: BigDecimal
	  field :ui_paid_amount, 						type: BigDecimal
	  field :ui_amount_due, 						type: BigDecimal


	  embeds_many	:wage_entries,
	  						class_name: 'Wages::WageEntry'

	  belongs_to	:organization_party,
	  						class_name: 'Parties::OrganizationParty'

	  embeds_many 		:timespans, 
	  						class_name: 'Timespans::Timespan'

	  validates_presence_of :organization_party, :timespans, :wage_entries, :filing_method_kind,
	  											:submission_kind #:total_wages, 
	  											# :excess_wages, :taxable_wages



	end
end