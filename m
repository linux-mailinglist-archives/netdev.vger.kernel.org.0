Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EB630FAFE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbhBDSNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238952AbhBDSMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:12:21 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FA4C061788;
        Thu,  4 Feb 2021 10:11:41 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n2so4202658iom.7;
        Thu, 04 Feb 2021 10:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=mX+HVztL7COZOVg08FHszVvmk8CCQMV0ipmWEw65Bsc=;
        b=II6mxEEra02hOipf+IprgYlfYGMxNWO3p1CvehqKhNyJJFq8mhYc0KZ4gbnmAGYd08
         O8lfTLDZu4rRBrzpc7wM9ZRERAFYfcgwY4vtQqskffHAA6kgQYe4oBarP1GIZE6PUGpN
         KsAWjykgkrzSYQHRsKnVRuXwZUFvGpO+XB/ZxOpJovRiEPUNlLK/lQgqNqjtL3HAuSRP
         M/xwAIVlRs6+tCepphYjZvwUtXwe0Ebbc9h9Dp6QjmerUZleUymSmWZ4/LKwyeG3sbWY
         pavDpjgZucQ8NvYTH85/EXVmGoNko8pkmb6KNOeKgQHhfsHLFOqnnrTe9AFS1f4get/x
         vhtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=mX+HVztL7COZOVg08FHszVvmk8CCQMV0ipmWEw65Bsc=;
        b=IGU5aQjIHoqjZTcd+Eo2fpCqVn/zW32VVorqn12/r8emLUkl2sKU3vbfHPZx8zuw4+
         76Va51qWHEP8x+kKrE4g6mMAO10Gy9+2jHm+KGw8jeLdflB6isky/4/Bkqt4qIFmmyuT
         RIDcaNjrFrxgSrwqccjorKoqc14STWiX5kEBp8fMuCsb6wMvLcQfHrjuegocCKWaurX8
         JvdtW0ZedJDb5fGBm3Nq5EZUNPqzlHt2jkmqxPB7p5KkNOccqu1EqRH4oo/yiMq5MswL
         MEQ976q1sg4qXv8eZ6rikxsiOTeX35uzCU6AZMx0KVWAzafNNdd0gab+4MIGM7PoKUbQ
         EUwA==
X-Gm-Message-State: AOAM532hQjDswgzHJIDLd/InRoV7cKDUcMRMOZv++ik+CzTF4Waqxdeu
        IdZSMa4BkqKIbRPSPPlfrXRFsSv1AyYeELqBnN8=
X-Google-Smtp-Source: ABdhPJzooRkc7eG40RJB52QRYKk/HMotDMOmGbS0wDPNAKH3EL1UbtP4q3R8P2YVNB7VduLIvGu7VG0HrhDPCa2nz+g=
X-Received: by 2002:a02:1649:: with SMTP id a70mr724319jaa.97.1612462300646;
 Thu, 04 Feb 2021 10:11:40 -0800 (PST)
MIME-Version: 1.0
References: <20210111180609.713998-1-natechancellor@gmail.com>
In-Reply-To: <20210111180609.713998-1-natechancellor@gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Feb 2021 19:11:28 +0100
Message-ID: <CA+icZUXztrp2Ow4VtXa6rwpzVzD71x-rVKd2Y09d-99VdtYV6Q@mail.gmail.com>
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

Cannot say if all supported pahole in the Linux kernel have that feature/option:

$ /opt/pahole/bin/pahole --numeric_version
120

- Sedat -

> base-commit: e22d7f05e445165e58feddb4e40cc9c0f94453bc
> --
> 2.30.0
>
