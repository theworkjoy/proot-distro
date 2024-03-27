#!/usr/bin/env bash
set -e
: "${NEOTERM_APP_PACKAGE:="io.neoterm"}"
: "${NEOTERM_PREFIX:="/data/data/${NEOTERM_APP_PACKAGE}/files/usr"}"
: "${NEOTERM_ANDROID_HOME:="/data/data/${NEOTERM_APP_PACKAGE}/files/home"}"

echo "Installing $NEOTERM_PREFIX/bin/proot-distro"
install -d -m 700 "$NEOTERM_PREFIX"/bin
sed -e "s|@NEOTERM_APP_PACKAGE@|$NEOTERM_APP_PACKAGE|g" \
	-e "s|@NEOTERM_PREFIX@|$NEOTERM_PREFIX|g" \
	-e "s|@NEOTERM_HOME@|$NEOTERM_ANDROID_HOME|g" \
	./proot-distro.sh > "$NEOTERM_PREFIX"/bin/proot-distro
chmod 700 "$NEOTERM_PREFIX"/bin/proot-distro

echo "Symlinking $NEOTERM_PREFIX/bin/proot-distro --> $NEOTERM_PREFIX/bin/pd"
ln -sfr "$NEOTERM_PREFIX"/bin/proot-distro "$NEOTERM_PREFIX"/bin/pd

install -d -m 700 "$NEOTERM_PREFIX"/etc/proot-distro
for script in ./distro-plugins/*.sh*; do
	echo "Installing $NEOTERM_PREFIX/etc/proot-distro/$(basename "$script")"
	install -Dm600 -t "$NEOTERM_PREFIX"/etc/proot-distro/ "$script"
done

echo "Installing $NEOTERM_PREFIX/share/bash-completion/completions/proot-distro"
install -d -m 700 "$NEOTERM_PREFIX"/share/bash-completion/completions
sed -e "s|@NEOTERM_APP_PACKAGE@|$NEOTERM_APP_PACKAGE|g" \
	-e "s|@NEOTERM_PREFIX@|$NEOTERM_PREFIX|g" \
	-e "s|@NEOTERM_HOME@|$NEOTERM_ANDROID_HOME|g" \
	./completions/proot-distro.bash > "$NEOTERM_PREFIX"/share/bash-completion/completions/proot-distro

echo "Symlinking $NEOTERM_PREFIX/share/bash-completion/completions/proot-distro --> $NEOTERM_PREFIX/share/bash-completion/completions/pd"
ln -sfr "$NEOTERM_PREFIX"/share/bash-completion/completions/proot-distro "$NEOTERM_PREFIX"/share/bash-completion/completions/pd

echo "Installing $NEOTERM_PREFIX/share/doc/proot-distro/README.md"
install -Dm600 README.md "$NEOTERM_PREFIX"/share/doc/proot-distro/README.md
