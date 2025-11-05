# Core library
# Shared utilities and common functionality

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "core",
    srcs = glob(["*.cc"]),
    hdrs = glob(["*.h"]),
    deps = [],
)

cc_test(
    name = "core_test",
    srcs = glob(["*_test.cc"]),
    deps = [
        ":core",
        "@googletest//:gtest_main",
    ],
)
