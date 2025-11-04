# API Gateway Service
# Routes and aggregates requests to backend services

package(default_visibility = ["//visibility:public"])

java_library(
    name = "gateway_lib",
    srcs = glob(["src/main/java/**/*.java"]),
    resources = glob(["src/main/resources/**"]),
    deps = [
        "@maven//:org_springframework_cloud_spring_cloud_starter_gateway",
        "@maven//:org_springframework_boot_spring_boot_starter_actuator",
        "@maven//:redis_clients_jedis",
    ],
)

java_binary(
    name = "gateway_service",
    main_class = "com.okimi.gateway.GatewayServiceApplication",
    runtime_deps = [":gateway_lib"],
)

java_test(
    name = "gateway_test",
    srcs = glob(["src/test/java/**/*.java"]),
    deps = [
        ":gateway_lib",
        "@maven//:org_springframework_boot_spring_boot_starter_test",
        "@maven//:junit_junit",
    ],
)
