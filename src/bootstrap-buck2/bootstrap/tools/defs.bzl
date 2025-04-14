load("@prelude//:native.bzl", "native")
load("@prelude//rust:cargo_package.bzl", "cargo")
load("@bootstrap//:toolchain_types.bzl", "RustBootstrapInternalToolsInfo")

def _bootstrap_internal_tools_impl(ctx: AnalysisContext) -> list[Provider]:
    return [
        DefaultInfo(),
        RustBootstrapInternalToolsInfo(
            assemble_sysroot = ctx.attrs._assemble_sysroot[RunInfo],
            example_tool = ctx.attrs._example_tool[RunInfo],
        ),
    ]

bootstrap_internal_tools = rule(
    impl = _bootstrap_internal_tools_impl,
    attrs = {
        "_assemble_sysroot": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default = "bootstrap//tools:assemble_sysroot")),
        "_example_tool": attrs.default_only(attrs.exec_dep(providers = [RunInfo], default = "bootstrap//tools:example_tool")),
    },
)

def rust_bootstrap_binary(name, **kwargs):
    native.configured_alias(
        name = name,
        actual = ":_" + name,
        platform = "bootstrap//platforms:rust_bootstrap_stage0",
        visibility = kwargs.pop("visibility", []),
    )
    cargo.rust_binary(
        name = "_" + name,
        **kwargs,
    )
