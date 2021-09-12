ifndef DESTDIR
DESTDIR=/usr/
endif
ifndef CONFDIR
CONFDIR=/etc
endif

install:
	mkdir -p /usr/lib/kvc/ && mkdir -p /etc/kvc/
	install -v -m 644 ice-kmod-lib.sh $(DESTDIR)/lib/kvc/
	install -v -m 644 ice-kmod.conf $(CONFDIR)/kvc/
	install -v -m 755 ice-kmod-wrapper.sh $(DESTDIR)/lib/kvc/
