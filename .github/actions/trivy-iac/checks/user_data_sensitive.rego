# METADATA
# title: Startup script variable is not marked sensitive
# description: The user_data startup script can hold secrets such as tokens or keys, so Terraform must not print it.
# custom:
#   id: ZAMA-TF-001
#   avd_id: ZAMA-TF-001
#   provider: generic
#   service: terraform
#   severity: HIGH
#   recommended_action: Set "sensitive = true" on the user_data variable.
#   input:
#     selector:
#       - type: terraform-raw
package user.terraform.zama_tf_001

import rego.v1

deny contains res if {
	some module in input.modules
	some block in module.blocks
	block.kind == "variable"
	block.name == "user_data"
	not block.attributes.sensitive.value == true
	res := result.new("Variable 'user_data' does not set 'sensitive = true'", block)
}
