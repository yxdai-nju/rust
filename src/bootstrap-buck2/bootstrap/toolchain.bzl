load("@bootstrap//:toolchain_types.bzl", "RustBootstrapToolchainInfo", "RustBootstrapInternalToolsInfo")

def _buck2_bootstrap_stage0_rust_toolchain_impl(ctx: AnalysisContext) -> list[Provider]:
    return [
        DefaultInfo(),
        RustBootstrapToolchainInfo(
            internal_tools = ctx.attrs._internal_tools[RustBootstrapInternalToolsInfo],
        ),
    ]

buck2_bootstrap_stage0_rust_toolchain = rule(
    impl = _buck2_bootstrap_stage0_rust_toolchain_impl,
    attrs = {
        "_internal_tools": attrs.default_only(attrs.exec_dep(providers = [RustBootstrapInternalToolsInfo], default = "bootstrap//tools:internal_tools")),
    },
    is_toolchain_rule = True,
)
