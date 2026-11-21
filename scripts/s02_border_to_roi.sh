#!/bin/bash
# S02_BORDER_TO_ROI  Convert a hand-drawn Workbench border into a surface mask.
#
# Methods, "Anchor region definitions": each anchor region was defined by
# (1) drawing a generous border around the anatomical zone on the individual's
#     inflated surface in Connectome Workbench,
# (2) converting the border to a mask with wb_command  <-- this script,
# (3) intersecting the mask with that individual's Dataset 1 network estimate
#     (s02_anchor_regions.m).
#
# Usage:
#   bash s02_border_to_roi.sh <surface.surf.gii> <in.border> <right_hemi_empty.func.gii> <out_dir>
#
#   surface.surf.gii          : left-hemisphere fsaverage6 surface the border was drawn on
#   in.border                 : border file; the border name inside the file must equal its basename
#   right_hemi_empty.func.gii : all-zero right-hemisphere metric (40,962 vertices),
#                               used to build a whole-cortex dscalar
#   out_dir                   : output folder
#
# All anchor regions are left-hemisphere (intLANG and aLANG are left-lateralized).
set -euo pipefail

surf=$1
border=$2
rh_empty=$3
out_dir=$4
mkdir -p "${out_dir}"

name=$(basename "${border}" .border)
tmp_metric="${out_dir}/${name}.tmp.func.gii"

# border -> binary ROI metric on the left hemisphere
wb_command -border-to-rois "${surf}" "${border}" "${tmp_metric}" -border "${name}"

# left metric + empty right metric -> whole-cortex dense scalar
wb_command -cifti-create-dense-scalar "${out_dir}/${name}.dscalar.nii" \
    -left-metric "${tmp_metric}" -right-metric "${rh_empty}"

rm -f "${tmp_metric}"
echo "Wrote ${out_dir}/${name}.dscalar.nii"
