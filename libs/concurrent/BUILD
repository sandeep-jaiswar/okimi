# Concurrent library
# Lock-free data structures and concurrent primitives

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "concurrent",
    srcs = glob(["*.cc"]),
    hdrs = glob(["*.h"]),
    deps = [
        "//libs/core",
    ],
)

cc_test(
    name = "concurrent_test",
    srcs = glob(["*_test.cc"]),
    deps = [
        ":concurrent",
        "@googletest//:gtest_main",
    ],
)
