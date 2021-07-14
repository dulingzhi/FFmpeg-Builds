#!/bin/bash

LIBXEXT_REPO="https://gitlab.freedesktop.org/xorg/lib/libxext.git"
LIBXEXT_COMMIT="47904063048fa6ef6e8e16219ddef4d14d5d9a4b"

ffbuild_enabled() {
    [[ $TARGET != linux* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$LIBXEXT_REPO" "$LIBXEXT_COMMIT" libxext
    cd libxext

    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
        --without-xmlto
        --without-fop
        --without-xsltproc
        --without-lint
    )

    if [[ $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}
