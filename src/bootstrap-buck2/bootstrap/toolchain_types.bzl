RustBootstrapInternalToolsInfo = provider(fields = {
    "assemble_sysroot": provider_field(RunInfo),
})

RustBootstrapToolchainInfo = provider(fields = {
    # TODO(yxdai-nju): `typing.Any` should be `RustBootstrapInternalToolsInfo`,
    # see the [tracking issue](https://github.com/facebook/buck2/issues/890)
    "internal_tools": provider_field(typing.Any), 
})
