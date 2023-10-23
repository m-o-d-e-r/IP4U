
build: clean
	flutter build apk --release --target-platform android-arm64

replace:
	cp build/app/outputs/flutter-apk/app-release.apk ./ip4u.apk

clean:
	flutter clean
