SysrootInfo = provider(fields = {
    "directory": provider_field(DefaultInfo),
    "clippy_driver_bin": provider_field(RunInfo),
    "rustc_bin": provider_field(RunInfo),
    "rustdoc_bin": provider_field(RunInfo),
})
