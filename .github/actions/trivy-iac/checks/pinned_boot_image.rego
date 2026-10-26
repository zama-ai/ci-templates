# METADATA
# title: Boot image is not pinned
# description: An image family or marketplace label resolves to the newest image, so the instance OS can change without a code change.
# custom:
#   id: ZAMA-TF-003
#   avd_id: ZAMA-TF-003
#   provider: generic
#   service: terraform
#   severity: MEDIUM
#   recommended_action: Pin the boot image by its ID.
#   input:
#     selector:
#       - type: terraform-raw
package user.terraform.zama_tf_003

import rego.v1

deny contains res if {
	some block in input.modules[_].blocks
	block.kind == "resource"
	block.type == "nebius_compute_v1_disk"
	not block.attributes.source_image_id
	res := result.new("Nebius disk does not pin 'source_image_id'", block)
}

# A literal that is not a UUID is a marketplace label
deny contains res if {
	some block in input.modules[_].blocks
	block.kind == "resource"
	block.type == "scaleway_instance_server"
	image := block.attributes.image
	image.known
	not regex.match(`^([a-z0-9-]+/)?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$`, image.value)
	res := result.new(sprintf("Scaleway instance uses image label '%s', not an image ID", [image.value]), block)
}
