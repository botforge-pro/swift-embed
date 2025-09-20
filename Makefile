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

# Create a new release
release:
	@echo "Creating release $(VERSION)"
	@test -n "$(VERSION)" || (echo "Error: VERSION not set. Usage: make release VERSION=1.3.0" && exit 1)
	git tag -a v$(VERSION) -m "Release v$(VERSION)"
	git push origin v$(VERSION)