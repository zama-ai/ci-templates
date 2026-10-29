# METADATA
# title: Compute instance has no security group
# description: An instance without a security group uses the provider default rules, which can allow all inbound traffic.
# custom:
#   id: ZAMA-TF-002
#   avd_id: ZAMA-TF-002
#   provider: generic
#   service: terraform
#   severity: HIGH
#   recommended_action: Attach a security group to the instance.
#   input:
#     selector:
#       - type: terraform-raw
package user.terraform.zama_tf_002

import rego.v1

deny contains res if {
	some block in input.modules[_].blocks
	block.kind == "resource"
	block.type == "scaleway_instance_server"
	not block.attributes.security_group_id
	res := result.new("Scaleway instance does not set 'security_group_id'", block)
}

deny contains res if {
	some block in input.modules[_].blocks
	block.kind == "resource"
	block.type == "nebius_compute_v1_instance"
	some nic in block.attributes.network_interfaces.value
	count(object.get(nic, "security_groups", [])) == 0
	res := result.new("Nebius network interface does not set 'security_groups'", block)
}
