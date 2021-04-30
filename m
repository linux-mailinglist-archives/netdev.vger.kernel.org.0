Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99E53700A9
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhD3SmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:42:09 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52608 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3SmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:42:05 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 7EAB51F43B85
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Rob Herring <robh+dt@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        devicetree@vger.kernel.org, keyrings@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] .gitignore: prefix local generated files with a slash
Organization: Collabora
References: <20210430020308.66792-1-masahiroy@kernel.org>
Date:   Fri, 30 Apr 2021 14:41:08 -0400
In-Reply-To: <20210430020308.66792-1-masahiroy@kernel.org> (Masahiro Yamada's
        message of "Fri, 30 Apr 2021 11:03:08 +0900")
Message-ID: <87wnsj4nuj.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Masahiro Yamada <masahiroy@kernel.org> writes:

> The pattern prefixed with '/' matches files in the same directory,
> but not ones in sub-directories.
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Acked-by: Miguel Ojeda <ojeda@kernel.org>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Andra Paraschiv <andraprs@amazon.com>

Acked-by: Gabriel Krisman Bertazi <krisman@collabora.com>

> ---
>
> Changes in v2:
>   - rebase
>
>  Documentation/devicetree/bindings/.gitignore |  4 ++--
>  arch/.gitignore                              |  4 ++--
>  certs/.gitignore                             |  4 ++--
>  drivers/memory/.gitignore                    |  2 +-
>  drivers/tty/vt/.gitignore                    |  6 +++---
>  fs/unicode/.gitignore                        |  4 ++--
>  kernel/.gitignore                            |  2 +-
>  lib/.gitignore                               | 10 +++++-----
>  samples/auxdisplay/.gitignore                |  2 +-
>  samples/binderfs/.gitignore                  |  3 ++-
>  samples/connector/.gitignore                 |  2 +-
>  samples/hidraw/.gitignore                    |  2 +-
>  samples/mei/.gitignore                       |  2 +-
>  samples/nitro_enclaves/.gitignore            |  2 +-
>  samples/pidfd/.gitignore                     |  2 +-
>  samples/seccomp/.gitignore                   |  8 ++++----
>  samples/timers/.gitignore                    |  2 +-
>  samples/vfs/.gitignore                       |  4 ++--
>  samples/watch_queue/.gitignore               |  3 ++-
>  samples/watchdog/.gitignore                  |  2 +-
>  scripts/.gitignore                           | 18 +++++++++---------
>  scripts/basic/.gitignore                     |  2 +-
>  scripts/dtc/.gitignore                       |  4 ++--
>  scripts/gcc-plugins/.gitignore               |  2 +-
>  scripts/genksyms/.gitignore                  |  2 +-
>  scripts/mod/.gitignore                       |  8 ++++----
>  usr/.gitignore                               |  4 ++--
>  27 files changed, 56 insertions(+), 54 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/.gitignore b/Documentation/devicetree/bindings/.gitignore
> index 3a05b99bfa26..a77719968a7e 100644
> --- a/Documentation/devicetree/bindings/.gitignore
> +++ b/Documentation/devicetree/bindings/.gitignore
> @@ -1,4 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  *.example.dts
> -processed-schema*.yaml
> -processed-schema*.json
> +/processed-schema*.yaml
> +/processed-schema*.json
> diff --git a/arch/.gitignore b/arch/.gitignore
> index 4191da401dbb..756c19c34f99 100644
> --- a/arch/.gitignore
> +++ b/arch/.gitignore
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -i386
> -x86_64
> +/i386/
> +/x86_64/
> diff --git a/certs/.gitignore b/certs/.gitignore
> index 6cbd1f1a5837..8c3763f80be3 100644
> --- a/certs/.gitignore
> +++ b/certs/.gitignore
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -x509_certificate_list
> -x509_revocation_list
> +/x509_certificate_list
> +/x509_revocation_list
> diff --git a/drivers/memory/.gitignore b/drivers/memory/.gitignore
> index caedc4c7d2db..5e84bee05ef8 100644
> --- a/drivers/memory/.gitignore
> +++ b/drivers/memory/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -ti-emif-asm-offsets.h
> +/ti-emif-asm-offsets.h
> diff --git a/drivers/tty/vt/.gitignore b/drivers/tty/vt/.gitignore
> index 3ecf42234d89..0221709b177d 100644
> --- a/drivers/tty/vt/.gitignore
> +++ b/drivers/tty/vt/.gitignore
> @@ -1,4 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0
> -conmakehash
> -consolemap_deftbl.c
> -defkeymap.c
> +/conmakehash
> +/consolemap_deftbl.c
> +/defkeymap.c
> diff --git a/fs/unicode/.gitignore b/fs/unicode/.gitignore
> index 9b2467e77b2d..361294571ab0 100644
> --- a/fs/unicode/.gitignore
> +++ b/fs/unicode/.gitignore
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -mkutf8data
> -utf8data.h
> +/mkutf8data
> +/utf8data.h
> diff --git a/kernel/.gitignore b/kernel/.gitignore
> index 4abc4e033ed8..4dc1ffe9770b 100644
> --- a/kernel/.gitignore
> +++ b/kernel/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -kheaders.md5
> +/kheaders.md5
> diff --git a/lib/.gitignore b/lib/.gitignore
> index 327cb2c7f2c9..5e7fa54c4536 100644
> --- a/lib/.gitignore
> +++ b/lib/.gitignore
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -gen_crc32table
> -gen_crc64table
> -crc32table.h
> -crc64table.h
> -oid_registry_data.c
> +/crc32table.h
> +/crc64table.h
> +/gen_crc32table
> +/gen_crc64table
> +/oid_registry_data.c
> diff --git a/samples/auxdisplay/.gitignore b/samples/auxdisplay/.gitignore
> index 2ed744c0e741..d023816849bd 100644
> --- a/samples/auxdisplay/.gitignore
> +++ b/samples/auxdisplay/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -cfag12864b-example
> +/cfag12864b-example
> diff --git a/samples/binderfs/.gitignore b/samples/binderfs/.gitignore
> index eb60241e8087..8fa415a3640b 100644
> --- a/samples/binderfs/.gitignore
> +++ b/samples/binderfs/.gitignore
> @@ -1 +1,2 @@
> -binderfs_example
> +# SPDX-License-Identifier: GPL-2.0
> +/binderfs_example
> diff --git a/samples/connector/.gitignore b/samples/connector/.gitignore
> index d86f2ff9c947..0e26039f39b5 100644
> --- a/samples/connector/.gitignore
> +++ b/samples/connector/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -ucon
> +/ucon
> diff --git a/samples/hidraw/.gitignore b/samples/hidraw/.gitignore
> index d7a6074ebcf9..5233ab63262e 100644
> --- a/samples/hidraw/.gitignore
> +++ b/samples/hidraw/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -hid-example
> +/hid-example
> diff --git a/samples/mei/.gitignore b/samples/mei/.gitignore
> index db5e802f041e..fe894bcb6a62 100644
> --- a/samples/mei/.gitignore
> +++ b/samples/mei/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -mei-amt-version
> +/mei-amt-version
> diff --git a/samples/nitro_enclaves/.gitignore b/samples/nitro_enclaves/.gitignore
> index 827934129c90..6a718eec71f4 100644
> --- a/samples/nitro_enclaves/.gitignore
> +++ b/samples/nitro_enclaves/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0
> -ne_ioctl_sample
> +/ne_ioctl_sample
> diff --git a/samples/pidfd/.gitignore b/samples/pidfd/.gitignore
> index eea857fca736..d4cfa3176b1b 100644
> --- a/samples/pidfd/.gitignore
> +++ b/samples/pidfd/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -pidfd-metadata
> +/pidfd-metadata
> diff --git a/samples/seccomp/.gitignore b/samples/seccomp/.gitignore
> index 4a5a5b7db30b..a6df0da77c5d 100644
> --- a/samples/seccomp/.gitignore
> +++ b/samples/seccomp/.gitignore
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -bpf-direct
> -bpf-fancy
> -dropper
> -user-trap
> +/bpf-direct
> +/bpf-fancy
> +/dropper
> +/user-trap
> diff --git a/samples/timers/.gitignore b/samples/timers/.gitignore
> index 40510c33cf08..cd9ff7b95383 100644
> --- a/samples/timers/.gitignore
> +++ b/samples/timers/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -hpet_example
> +/hpet_example
> diff --git a/samples/vfs/.gitignore b/samples/vfs/.gitignore
> index 8fdabf7e5373..79212d91285b 100644
> --- a/samples/vfs/.gitignore
> +++ b/samples/vfs/.gitignore
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -test-fsmount
> -test-statx
> +/test-fsmount
> +/test-statx
> diff --git a/samples/watch_queue/.gitignore b/samples/watch_queue/.gitignore
> index 2aa3c7e56a1a..823b351d3db9 100644
> --- a/samples/watch_queue/.gitignore
> +++ b/samples/watch_queue/.gitignore
> @@ -1 +1,2 @@
> -watch_test
> +# SPDX-License-Identifier: GPL-2.0-only
> +/watch_test
> diff --git a/samples/watchdog/.gitignore b/samples/watchdog/.gitignore
> index 74153b831244..a70a0150ed9f 100644
> --- a/samples/watchdog/.gitignore
> +++ b/samples/watchdog/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -watchdog-simple
> +/watchdog-simple
> diff --git a/scripts/.gitignore b/scripts/.gitignore
> index a6c11316c969..e83c620ef52c 100644
> --- a/scripts/.gitignore
> +++ b/scripts/.gitignore
> @@ -1,11 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -bin2c
> -kallsyms
> -unifdef
> -recordmcount
> -sorttable
> -asn1_compiler
> -extract-cert
> -sign-file
> -insert-sys-cert
> +/asn1_compiler
> +/bin2c
> +/extract-cert
> +/insert-sys-cert
> +/kallsyms
>  /module.lds
> +/recordmcount
> +/sign-file
> +/sorttable
> +/unifdef
> diff --git a/scripts/basic/.gitignore b/scripts/basic/.gitignore
> index 98ae1f509592..961c91c8a884 100644
> --- a/scripts/basic/.gitignore
> +++ b/scripts/basic/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -fixdep
> +/fixdep
> diff --git a/scripts/dtc/.gitignore b/scripts/dtc/.gitignore
> index 8a8b62bf3d3c..e0b5c1d2464a 100644
> --- a/scripts/dtc/.gitignore
> +++ b/scripts/dtc/.gitignore
> @@ -1,3 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -dtc
> -fdtoverlay
> +/dtc
> +/fdtoverlay
> diff --git a/scripts/gcc-plugins/.gitignore b/scripts/gcc-plugins/.gitignore
> index b04e0f0f033e..5cc385b9eb97 100644
> --- a/scripts/gcc-plugins/.gitignore
> +++ b/scripts/gcc-plugins/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -randomize_layout_seed.h
> +/randomize_layout_seed.h
> diff --git a/scripts/genksyms/.gitignore b/scripts/genksyms/.gitignore
> index 999af710f83d..0b275abf9405 100644
> --- a/scripts/genksyms/.gitignore
> +++ b/scripts/genksyms/.gitignore
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -genksyms
> +/genksyms
> diff --git a/scripts/mod/.gitignore b/scripts/mod/.gitignore
> index 07e4a39f90a6..ed2e13b708ce 100644
> --- a/scripts/mod/.gitignore
> +++ b/scripts/mod/.gitignore
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -elfconfig.h
> -mk_elfconfig
> -modpost
> -devicetable-offsets.h
> +/elfconfig.h
> +/mk_elfconfig
> +/modpost
> +/devicetable-offsets.h
> diff --git a/usr/.gitignore b/usr/.gitignore
> index 935442ed1eb2..8996e7a88902 100644
> --- a/usr/.gitignore
> +++ b/usr/.gitignore
> @@ -1,4 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -gen_init_cpio
> -initramfs_data.cpio
> +/gen_init_cpio
> +/initramfs_data.cpio
>  /initramfs_inc_data

-- 
Gabriel Krisman Bertazi
