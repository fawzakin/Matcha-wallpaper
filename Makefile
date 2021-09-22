PREFIX ?= /usr/share/backgrounds

install:
	bash generate.sh
	mkdir -p $(DESTDIR)$(PREFIX)
	cp -r Matcha $(DESTDIR)$(PREFIX)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/Matcha

PHONY: install uninstall
