FROM mysql:5.7 AS build-env

FROM debian:stretch-slim

	# linux-vdso.so.1 (0x00007ffea9f56000)
	# libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f65def60000)
	# librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f65ded58000)
	# libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f65de94c000)
	# libncurses.so.5 => /lib/x86_64-linux-gnu/libncurses.so.5 (0x00007f65de729000)
	# libtinfo.so.5 => /lib/x86_64-linux-gnu/libtinfo.so.5 (0x00007f65de4ff000)
	# libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f65de17d000)
	# libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f65dde79000)
	# libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f65ddc62000)
	# libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f65dd8c3000)
	# /lib64/ld-linux-x86-64.so.2 (0x00007f65df7ff000)

RUN apt-get update && apt-get install -y git
COPY --from=build-env /usr/lib/x86_64-linux-gnu/libatomic.so.1 usr/lib/x86_64-linux-gnu/
COPY --from=build-env /lib/x86_64-linux-gnu/libncurses.so.5  /usr/lib/x86_64-linux-gnu/
COPY --from=build-env /lib/x86_64-linux-gnu/libtinfo.so.5  /lib/x86_64-linux-gnu/

COPY --from=build-env /usr/bin/mysql /usr/bin/
WORKDIR /usr/bin/


CMD ["sleep", "3600"]
