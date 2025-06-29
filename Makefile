debug:
	@cd src && ./debug.sh

build:
	cat \
		src/preamble.sh \
		src/addon.sh \
		src/world.sh \
		src/commands.sh \
		src/help.sh \
		src/args.sh \
		src/main.sh \
		> mc.sh
	chmod 755 mc.sh
