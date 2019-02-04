import { Controller } from "stimulus"
import Rails from 'rails-ujs'

export default class extends Controller {

  static targets = [ "companyType", "evidence", "previousOrganization", "contributionStep", "message" ]
  wasPrevious;
  stepIndex;
  contributorText;
  initialize() {
        var form = $(".validation-wizard").show();

				function submitForm() {
					let contactInfo = localStorage.getItem('Contact Info');
					let addressInfo = localStorage.getItem('Address Info');
					let companyInfo = localStorage.getItem('Company Info');

					fetch('/employers', {
			      method: 'POST',
			      body: JSON.stringify({'address_info': addressInfo, 'contact_info': contactInfo, 'employer_info': companyInfo}),
			      headers: {
			        'Content-Type': 'application/json',
			        'X-CSRF-Token': Rails.csrfToken()
			      },
			      credentials: 'same-origin',
			    })
			    .then(response => response.json())
			    .then(response => {
			      if (response.code === 200) {
			        swal({
								title: "Form Received!",
								text: "Your employer registration has successfully been submitted.",
								icon: "success",
							})
							.then(() => {
								window.location.pathname = '/dashboard'
							})

							localStorage.removeItem('Contact Info');
							localStorage.removeItem('Address Info');
							localStorage.removeItem('Company Info');
			      }
			    })
				}

        $(".validation-wizard").steps({
            headerTag: "h6",
            bodyTag: "section",
            transitionEffect: "fade",
            titleTemplate: '<span class="step">#index#</span> #title#',
            labels: {
                finish: "Submit"
            },
            onStepChanging: function (event, currentIndex, newIndex) {
							// Temporaily stores data from form to pass to rails on submit

							let formData = form[0].elements;
							if (currentIndex === 0) {
								localStorage.setItem('Contact Info', JSON.stringify({
									'first_name': formData[2].value,
									'last_name': formData[3].value,
									'dob': formData[4].value,
									'email': formData[5].value,
									'area_code': formData[6].value,
									'number': formData[7].value
								}))
							}

							if (currentIndex === 1) {
								localStorage.setItem('Address Info', JSON.stringify({
									'kind': formData[9].value,
									'address_1': formData[8].value,
									'address_2': formData[10].value,
									'city': formData[11].value,
									'state': formData[12].value,
									'zip': formData[13].value,
									'county': formData[14].value
								}))
							}

							if (currentIndex === 2) {
								localStorage.setItem('Company Info', JSON.stringify({
									'legal_name': formData[15].value,
									'dba': formData[16].value,
									'fein': formData[17].value,
									'kind': formData[18].value,
									'date_of_first_wages': formData[20].value,
									//'company_type': formData[19].value
								}))
							}

              return currentIndex > newIndex || !(3 === newIndex && Number($("#age-2").val()) < 18) && (currentIndex < newIndex && (form.find(".body:eq(" + newIndex + ") label.error").remove(), form.find(".body:eq(" + newIndex + ") .error").removeClass("error")), form.validate().settings.ignore = ":disabled,:hidden", form.valid())
            },
            onFinishing: function (event, currentIndex) {
								submitForm();
                return form.validate().settings.ignore = ":disabled", form.valid()
            },
            onFinished: function (event, currentIndex) { }
        }), $(".validation-wizard").validate({
            ignore: "input[type=hidden]",
            errorClass: "text-danger",
            successClass: "text-success",
            highlight: function (element, errorClass) {
                $(element).removeClass(errorClass)
            },
            unhighlight: function (element, errorClass) {
                $(element).removeClass(errorClass)
            },
            errorPlacement: function (error, element) {
                error.insertAfter(element)
            },
            rules: {
                email: {
                    email: !0
                }
            }
        })
        // Adds click event to buttons generated by jquery steps wizard
        let ele = document.querySelectorAll('[role="menuitem"]');
        for (var i = 0; i < ele.length; i++) {
          ele[i].setAttribute('data-action', 'employer-registrations#showText');
        }

  }

  evidenceNeeded() {
    if (this.companyTypeTarget.value == "reimbursable") {
      this.evidenceTarget.classList.remove('d-none')
    } else {
      this.evidenceTarget.classList.add('d-none')
    }
  }

  showText() {
    let comType = this.companyTypeTarget.value;

    this.previousOrganizationTargets.map(input => {
      if (input.checked) {
        this.wasPrevious = input.value;
      }
    })

    let prevOrg = this.wasPrevious;

    if (comType && comType === 'contributor') this.contributorText = 'Thank you for registering.  As a new employer in the district, your tax liablity rate for the first year is set at 2.7%. This rate will be adjusted for future tax years based on your experience, including turnover and claims experience.'
    if (comType && prevOrg && comType === 'reimbursable' && prevOrg === 'no') this.contributorText = 'Thank you for registering. Verification of your reimbursable status is underway. DOES staff will contact you if any additional information is requested. Once verified, your tax liability rate as a reimbursable employer will be set at 0%.'
    if (comType && prevOrg && comType === 'reimbursable' && prevOrg === 'yes') this.contributorText = 'Verification of this organizations relationship with the provided predecessor is underway. DOES staff will contact you if any additional information is required. Once verified, your tax liability rate will be set at the most recent rate of the predecessor organization.'
    this.messageTarget.innerText = this.contributorText;
  }
}
