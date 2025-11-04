# Observability library
# Logging, metrics, and tracing

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "observability",
    srcs = glob(["*.cc"]),
    hdrs = glob(["*.h"]),
    deps = [
        "//libs/core",
    ],
)

cc_test(
    name = "observability_test",
    srcs = glob(["*_test.cc"]),
    deps = [
        ":observability",
        "@googletest//:gtest_main",
    ],
)
