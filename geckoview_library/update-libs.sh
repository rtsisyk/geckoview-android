#!/bin/sh -e

sync() {
	EXAMPLE=$1
	LIBRARY=$2
	rsync -tv ${EXAMPLE}/assets/* ./src/main/assets/
	rsync -rtv ${LIBRARY}/res/ ./src/main/res/
	rsync -tv  ${LIBRARY}/libs/*.jar ./libs/
	ARCH=$(basename ${LIBRARY}/libs/*/)
	mkdir -p ./src/main/jniLibs/${ARCH}
	# Cleanup other architectures
	for a in $(find ./src/main/jniLibs/ -mindepth 1 -maxdepth 1 -type d); do
		if [ $(basename "$a") != ${ARCH} ]; then
			rm -rf $a
		fi
	done
	rsync -tv ${LIBRARY}/libs/${ARCH}/*.so ./src/main/jniLibs/${ARCH}/
}

source() {
	echo "Updating libraries from Mozilla source build"
	MOZILLA_SOURCE=../../mozilla-central/

	sync ${MOZILLA_SOURCE}/obj-arm-linux-androideabi/embedding/android/geckoview_example \
		${MOZILLA_SOURCE}/obj-arm-linux-androideabi/mobile/android/geckoview_library
}

nightly() {
	echo "Updating libraries from Mozilla nightly build"
	REPO=http://ftp.mozilla.org/pub/mozilla.org/mobile/nightly/latest-mozilla-central-android/
	BUILDDIR=./build/tmp

	mkdir -p ${BUILDDIR}
	wget -N -P ${BUILDDIR} ${REPO}/geckoview_library.zip ${REPO}/geckoview_assets.zip
	echo $?
	unzip -o -u -d ${BUILDDIR} ${BUILDDIR}/geckoview_assets.zip
	rsync -t ${BUILDDIR}/assets/*.so ./src/main/assets/
	unzip -o -u -d ${BUILDDIR} ${BUILDDIR}/geckoview_library.zip
	sync ${BUILDDIR} ${BUILDDIR}/geckoview_library
}

case "$1" in
	source)
		source
		;;
	nightly)
		nightly
		;;
	**)
		echo "Usage: $0 {source|nightly}"
		exit 1
esac
