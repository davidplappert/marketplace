module Wages
  class WageReportFactory

    attr_accessor :wage_report, :current_report

    def self.call(organization_party, report_timespan, args)
      new(organization_party, args).wage_report
    end

    def initialize
      @organization_party = organization_party
      @wage_report = organization_party.wage_reports.new
      @wage_report_template = nil
      @ui_contribution_report_determination = @organization_party.ui_contribution_report_determination_for(report_timespan)

      # assign_wage_report_attributes(args)
    	find_wage_report_template
      populate_wage_entries
    end

    def self.set_current_report(report)
      @current_report = report
    end


    def self.get_current_report 
      @current_report
    end

    def self.amend(report, params)
      cloned_report = report.clone 
      if params[:wages_wage_report][:new_wage_entry][:person_first_name].present?
        add_entries(cloned_report, params)
      else
      wage_entry_ids = cloned_report.wage_entries.map(&:_id)
      wage_entry_ids.each do |id|
        if params[:wages_wage_report][:wage_entries][id.to_s]
          update_clone(id,cloned_report,  params[:wages_wage_report][:wage_entries][id.to_s])
        end
      end
    end
    end
    
    
 


    def self.add_entries(report, params)
      if params[:commit] == "Add Entry"
        submission_kind = :original
        amend_reason = "Original"
        report_submission_kind = :original
      else 
        submission_kind = :amended
        amend_reason = params[:amend_reason]
        report_submission_kind = :amended
      end
      wage_params = params[:wages_wage_report][:new_wage_entry]
      gross_wages =  wage_params[:state_total_gross_wages]
      person =  Parties::PersonParty.create!(
        current_first_name: wage_params[:person_first_name],
        current_last_name: wage_params[:person_last_name],
        ssn: wage_params[:ssn])
      report.update_attributes(submission_kind: report_submission_kind)
      entry =  report.wage_entries.new(submission_kind: submission_kind, submitted_at: Time.now, amend_reason: amend_reason)
      entry.wage = Wages::Wage.new(
        person_party_id: person.id,
        timespan_id: report.timespan.id,
        state_total_gross_wages: gross_wages,
        state_excess_wages: Wages::Wage.new.sum_excess_wages(gross_wages),
        state_taxable_wages: Wages::Wage.new.sum_taxable_wages(gross_wages),
        state_total_wages: gross_wages
      )
      entry.save
      report.save
      if params[:commit] == "Add Entry"
        set_current_report(report)
      else 
        set_current_report(nil)
      end
    end

    def self.update_clone(id,cloned_report, wage_params)

      entry = cloned_report.wage_entries.find(id)
      wage = entry.wage
      entry.update_attributes!(
        amend_reason:  wage_params[:amend_reason] 
      )
      entry.save!
      wage.update_attributes!(
        state_total_gross_wages: wage_params[:wage][:state_total_gross_wages] || 0
      )
      cloned_report.update_attributes(submission_kind: :amended, 
      submitted_at: Time.now.to_date,
      state_total_gross_wages: cloned_report.sum_state_total_wages,
      state_ui_excess_wages: cloned_report.sum_state_excess_wages,
      state_ui_taxable_wages: cloned_report.sum_state_taxable_wages,
      )
      cloned_report.save!
    end

    def self.create_report_and_add_entries(params)
      if @current_report 
        add_entries(@current_report, params)
      else
        party = Parties::OrganizationParty.find(params[:employer_id])
        span = Timespans::Timespan.current_timespan
        report =  Wages::WageReport.create!(
          organization_party: party,
          timespan: span,
          submission_kind: :original,
          filing_method_kind: :manual_entry,
          status: :submitted,
          state_total_gross_wages: 0,
          state_ui_taxable_wages: 0,
          ui_total_due: 0,
          submitted_at: Time.now,
          state_ui_total_wages:0 ,
          state_ui_excess_wages: 0,
          ui_paid_amount:  0,
          ui_tax_amount: 0,
          ui_amount_due: 0,
          total_employees: 0)
          add_entries(report, params)
      end
    end


    def assign_wage_report_attributes(args)
      args.each_pair do |k, v|
        @wage_report.send("#{k}=".to_sym, v)
      end
    end

    # Any factors necessary here?
    def assign_wage_report_ui_contribution_factors
    end

    def populate_wage_entries
    	# Build subclasses
    	clone_from_wage_report_template
    end

    def build_original_report_wage_entries
    	# Build from prior time period template or from scratch (empty)
    end

    def build_ammended_report_submission_kind
    	# Build from same time period template
    end

    def find_wage_report_template
    	same_timespan_wage_report || preceding_timespan_wage_report
    end

    def same_timespan_wage_report
    	wage_report_list = Wages::WageReports.where(organization_party: organization_party, timespan: report_timespan).order(submitted_at: desc).entries

    	if wage_report_list.size > 0
    		@wage_report.submission_kind = :ammended
	    	@wage_report_template = wage_report_list.first
    	else
    		nil
	    end
    end

    def preceding_timespan_wage_report
    	wage_report_list = Wages::WageReports.where(organization_party: organization_party, timespan: report_timespan.predecessor).order(submitted_at: desc).entries

    	if wage_report_list.size > 0
    		@wage_report.submission_kind = :original
	    	@wage_report_template = wage_report_list.first
    	else
    		nil
	    end
    end

    def clone_from_wage_report_template
    end


    def self.validate(wage_report)
      # TODO: Add validations
      true
    end

  end
end
