all: build run
	@echo ok

run:
	@./mc.sh

gitstamp:
	@echo "# revision:" $(shell git rev-parse --verify HEAD) "\n" > /tmp/mc-gitstamp.txt

build: gitstamp
	cd src && cat \
		preamble.sh \
		/tmp/mc-gitstamp.txt \
		addon.sh \
		manifest.sh \
		world.sh \
		args.sh \
		messages.sh \
		main.sh \
		> ../mc.sh
	chmod 755 mc.sh
