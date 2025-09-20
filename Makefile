.PHONY: test clean build release format lint

# Default target
all: clean build test

# Run tests
test:
	swift test

# Clean build artifacts
clean:
	swift package clean
	rm -rf .build

# Build the library
build:
	swift build

lint:
	swiftlint

lint-fix:
	swiftlint --fix

