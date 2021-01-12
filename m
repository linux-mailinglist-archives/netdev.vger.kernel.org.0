Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEB42F407C
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393370AbhAMAmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390246AbhALXoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 18:44:34 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A56C061795;
        Tue, 12 Jan 2021 15:43:54 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id r9so421164ioo.7;
        Tue, 12 Jan 2021 15:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=UjqLWBff2oAK5ITVU1oqIMtLhE5XUJaVTO6IhzmEgyE=;
        b=EDsfLPV4vrt/W4PZd9DRhmCdwvvtq0w8+LEJLTfx8FZ7u6W+EKIBGr3mNgEXS0fIdt
         DME307Wmd//3s8MtFDgFZNieHuREheLUMaZpaszuUxowqdlO5186D4oVDy8uBcnwR/E6
         CGTYOcB6lgTTpv6NsOi9yuzEBg7V7C30GMxqFYjTKlDQmsWcU/vlmnPC1/yZO7/fmEIN
         ujt4qss+0ZM96XwUYT7vQb2gAhYFXdE7sGIHC9ySdZB1PFO7TAGIlylHRZdsIS8UqVO+
         YTugWGVwN9RyIAsam1CD990I1dDIVqP/dEnh8ZsHwexc8Sq/aFUtc+RZwPJBu/vDSriF
         b8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=UjqLWBff2oAK5ITVU1oqIMtLhE5XUJaVTO6IhzmEgyE=;
        b=H2EIO6xaSalF47N8qqCqcWzyyTJxwLflfgp6AQJw6W3YkUgxinLybXY4wRq1HLr26y
         mVMIG3jhXL8+3ei6cEorEnvVyaoIUUoLjrhPkZv50OfxXE3a7WZzLKfrlSjRcIecYLrw
         cJ3wLRs1BAmmv2AEFuc/CKy3ar8Dg5T7KvyjR4cIbFw2xhX9UKBcw98BnVCUbv4GW7vu
         8gjbNIS6XQP1KfAbTyjDw0K/RVCBQb97hbY6Lp9VMrj7ixUeSb+5phyLhshOHCHI+Kqo
         rnVJq0Ki0z/v0mqthfHD+4fo95ZQPGtoau0NP8kmJKEhTZeMyFJlXcQkm5dHjL+Sgo3W
         D4lw==
X-Gm-Message-State: AOAM530fVR9ZSfiBVAEhp9hOHtXlc3N00NmFiTNO1xgrXYFXGt8CxW3X
        8L8LedwKUthCOGiebOdaImj/qCMDiE4hWuzmMnZXtpMcz6eI2g==
X-Google-Smtp-Source: ABdhPJz5UQydtVFyQkapceVkeXgXLEU2zu+TJjfwekFMpYmQxv1TC9yWVtHQPhujSFXyn2UUDF3SeyLd/mAI0bhV7Ug=
X-Received: by 2002:a5e:d70e:: with SMTP id v14mr1247099iom.75.1610495033522;
 Tue, 12 Jan 2021 15:43:53 -0800 (PST)
MIME-Version: 1.0
References: <20210111180609.713998-1-natechancellor@gmail.com>
In-Reply-To: <20210111180609.713998-1-natechancellor@gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 13 Jan 2021 00:43:41 +0100
Message-ID: <CA+icZUXcsjwXOcoHRL3HSDMbE9thq7G3A9Uvzeg8tbNfLP7dfw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Hoise pahole version checks into Kconfig
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 7:06 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> After commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for
> vmlinux BTF"), having CONFIG_DEBUG_INFO_BTF enabled but lacking a valid
> copy of pahole results in a kernel that will fully compile but fail to
> link. The user then has to either install pahole or disable
> CONFIG_DEBUG_INFO_BTF and rebuild the kernel but only after their build
> has failed, which could have been a significant amount of time depending
> on the hardware.
>
> Avoid a poor user experience and require pahole to be installed with an
> appropriate version to select and use CONFIG_DEBUG_INFO_BTF, which is
> standard for options that require a specific tools version.
>
> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks for the patch, Nathan,

Might be good to gave a hint to the user if pahole version does not
match requirements?

Feel free to add my:

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -



> ---
>  MAINTAINERS               |  1 +
>  init/Kconfig              |  4 ++++
>  lib/Kconfig.debug         |  6 ++----
>  scripts/link-vmlinux.sh   | 13 -------------
>  scripts/pahole-version.sh | 16 ++++++++++++++++
>  5 files changed, 23 insertions(+), 17 deletions(-)
>  create mode 100755 scripts/pahole-version.sh
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b8db7637263a..6f6e24285a94 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3282,6 +3282,7 @@ F:        net/core/filter.c
>  F:     net/sched/act_bpf.c
>  F:     net/sched/cls_bpf.c
>  F:     samples/bpf/
> +F:     scripts/pahole-version.sh
>  F:     tools/bpf/
>  F:     tools/lib/bpf/
>  F:     tools/testing/selftests/bpf/
> diff --git a/init/Kconfig b/init/Kconfig
> index b77c60f8b963..872c61b5d204 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -74,6 +74,10 @@ config TOOLS_SUPPORT_RELR
>  config CC_HAS_ASM_INLINE
>         def_bool $(success,echo 'void foo(void) { asm inline (""); }' | $(CC) -x c - -c -o /dev/null)
>
> +config PAHOLE_VERSION
> +       int
> +       default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
> +
>  config CONSTRUCTORS
>         bool
>         depends on !UML
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 7937265ef879..70c446af9664 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -267,6 +267,7 @@ config DEBUG_INFO_DWARF4
>
>  config DEBUG_INFO_BTF
>         bool "Generate BTF typeinfo"
> +       depends on PAHOLE_VERSION >= 116
>         depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
>         depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
>         help
> @@ -274,12 +275,9 @@ config DEBUG_INFO_BTF
>           Turning this on expects presence of pahole tool, which will convert
>           DWARF type info into equivalent deduplicated BTF type info.
>
> -config PAHOLE_HAS_SPLIT_BTF
> -       def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
> -
>  config DEBUG_INFO_BTF_MODULES
>         def_bool y
> -       depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
> +       depends on DEBUG_INFO_BTF && MODULES && PAHOLE_VERSION >= 119
>         help
>           Generate compact split BTF type information for kernel modules.
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 6eded325c837..eef40fa9485d 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -139,19 +139,6 @@ vmlinux_link()
>  # ${2} - file to dump raw BTF data into
>  gen_btf()
>  {
> -       local pahole_ver
> -
> -       if ! [ -x "$(command -v ${PAHOLE})" ]; then
> -               echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
> -               return 1
> -       fi
> -
> -       pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
> -       if [ "${pahole_ver}" -lt "116" ]; then
> -               echo >&2 "BTF: ${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.16"
> -               return 1
> -       fi
> -
>         vmlinux_link ${1}
>
>         info "BTF" ${2}
> diff --git a/scripts/pahole-version.sh b/scripts/pahole-version.sh
> new file mode 100755
> index 000000000000..6de6f734a345
> --- /dev/null
> +++ b/scripts/pahole-version.sh
> @@ -0,0 +1,16 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Usage: $ ./scripts/pahole-version.sh pahole
> +#
> +# Print the pahole version as a three digit string
> +# such as `119' for pahole v1.19 etc.
> +
> +pahole="$*"
> +
> +if ! [ -x "$(command -v $pahole)" ]; then
> +    echo 0
> +    exit 1
> +fi
> +
> +$pahole --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'
>
> base-commit: e22d7f05e445165e58feddb4e40cc9c0f94453bc
> --
> 2.30.0
>
