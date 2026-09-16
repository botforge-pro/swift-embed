.PHONY: test clean build docs format lint lint-fix

# Default target
all: clean build test

# Run tests
test:
	swift test -Xswiftc -warnings-as-errors

# Clean build artifacts
clean:
	swift package clean
	rm -rf .build

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
