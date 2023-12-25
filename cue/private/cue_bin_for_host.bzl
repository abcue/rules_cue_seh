# Copyright 2023 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@local_config_platform//:constraints.bzl", "HOST_CONSTRAINTS")
load("//cue/private/tools/cue:toolchain.bzl", "CUE_TOOLCHAIN")

def _ensure_target_cfg(ctx):
    # A target is assumed to be built in the target configuration if it is neither in the exec nor
    # the host configuration (the latter has been removed in Bazel 6). Since there is no API for
    # this, use the output directory to determine the configuration, which is a common pattern.
    if "-exec-" in ctx.bin_dir.path or "/host/" in ctx.bin_dir.path:
        fail("//cue is only meant to be used with 'bazel run', not as a tool.")

def _cue_bin_for_host_impl(ctx):
    """Exposes the go binary of the current Go toolchain for the host."""
    _ensure_target_cfg(ctx)

    return [
        DefaultInfo(),
    ]

cue_bin_for_host = rule(
    implementation = _cue_bin_for_host_impl,
    toolchains = [CUE_TOOLCHAIN],
    # Resolve a toolchain that runs on the host platform.
    exec_compatible_with = HOST_CONSTRAINTS,
)
