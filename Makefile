all: build run
	@echo ok

run:
	@./mc.sh

build:
	cd src && cat \
		preamble.sh \
		addon.sh \
		manifest.sh \
		world.sh \
		args.sh \
		messages.sh \
		main.sh \
		> ../mc.sh
	chmod 755 mc.sh
