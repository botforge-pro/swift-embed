.PHONY: test build docs format lint lint-fix

# Default target
all: build test

# Run tests
test:
	swift test -Xswiftc -warnings-as-errors

# Build the library
build:
	swift build -Xswiftc -warnings-as-errors

docs:
	swift package --allow-writing-to-directory .build/docc generate-documentation \
		--target SwiftEmbed --output-path .build/docc \
		--warnings-as-errors \
		--transform-for-static-hosting \
		--hosting-base-path swift-embed

lint:
	swiftlint

lint-fix:
	swiftlint --fix
