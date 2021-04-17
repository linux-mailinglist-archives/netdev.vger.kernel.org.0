Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CFA3630C6
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 16:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbhDQO6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 10:58:46 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:18686 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236187AbhDQO6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 10:58:44 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 13HEw2OO025146;
        Sat, 17 Apr 2021 23:58:03 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 13HEw2OO025146
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1618671483;
        bh=rq83/8SBq3PTT68e2iZ8nPK/k8i2Myf6G/JabZ9UCXk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m/rWDIRwqAiR3uRtMHvdo4iK0ZEtfemTx6HIx8y94PKkX7OBTU1yDrryQpL6TPrA8
         uFs51PcQ70KRRoGCMdoLh5K8bQ7R9dA9RzYCNVb3klVCULT5DZD9SF47kLFWPW+PQQ
         3O/0tbhVx/hS+SwtxNYF93PK0APUhC2l1/uhVWb2eyK6JZYntN7nhlP1GEUGDenlEy
         fMNTWvWK+I4Tobket8dRDmJFbYv6L9IpDUxIWz0K0JSP6mNRjKe7LW+HrNBsyR3fYl
         6K5Y6wZ8Eux2lzlq3ss9ExvwlA0rU56ht7TG4sV5hALt4+44iHxNOdVgQ1s0uNcZRc
         IbeyyMbKeZNBg==
X-Nifty-SrcIP: [209.85.216.46]
Received: by mail-pj1-f46.google.com with SMTP id nk8so2378276pjb.3;
        Sat, 17 Apr 2021 07:58:03 -0700 (PDT)
X-Gm-Message-State: AOAM532kpT0/NFNgtMoWGm5zVkvD0/fpQxy3jTiVkl80BmK3prikS/uO
        1QSzHbO2/MDT6b/4AiZoJIuRY9AN5vo9G8G4CoU=
X-Google-Smtp-Source: ABdhPJxWkCXt7g4Du/Ih7Ckz0ekVFUITURxJW3giTvuAUEWpP1/B8Iy1Q/VxSxCEtVTt62gkLz8TXtY7EWsJFR/AdpY=
X-Received: by 2002:a17:90a:1056:: with SMTP id y22mr14523757pjd.153.1618671481674;
 Sat, 17 Apr 2021 07:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210416130051.239782-1-masahiroy@kernel.org>
In-Reply-To: <20210416130051.239782-1-masahiroy@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 17 Apr 2021 23:57:23 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS90BwrVZzpoavVE8AE0D01Ei7BuQg1E5eObQR+o74fow@mail.gmail.com>
Message-ID: <CAK7LNAS90BwrVZzpoavVE8AE0D01Ei7BuQg1E5eObQR+o74fow@mail.gmail.com>
Subject: Re: [PATCH v2] tools: do not include scripts/Kbuild.include
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 10:01 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Since commit d9f4ff50d2aa ("kbuild: spilt cc-option and friends to
> scripts/Makefile.compiler"), some kselftests fail to build.
>
> The tools/ directory opted out Kbuild, and went in a different
> direction. They copy any kind of files to the tools/ directory
> in order to do whatever they want in their world.
>
> tools/build/Build.include mimics scripts/Kbuild.include, but some
> tool Makefiles included the Kbuild one to import a feature that is
> missing in tools/build/Build.include:
>
>  - Commit ec04aa3ae87b ("tools/thermal: tmon: use "-fstack-protector"
>    only if supported") included scripts/Kbuild.include from
>    tools/thermal/tmon/Makefile to import the cc-option macro.
>
>  - Commit c2390f16fc5b ("selftests: kvm: fix for compilers that do
>    not support -no-pie") included scripts/Kbuild.include from
>    tools/testing/selftests/kvm/Makefile to import the try-run macro.
>
>  - Commit 9cae4ace80ef ("selftests/bpf: do not ignore clang
>    failures") included scripts/Kbuild.include from
>    tools/testing/selftests/bpf/Makefile to import the .DELETE_ON_ERROR
>    target.
>
>  - Commit 0695f8bca93e ("selftests/powerpc: Handle Makefile for
>    unrecognized option") included scripts/Kbuild.include from
>    tools/testing/selftests/powerpc/pmu/ebb/Makefile to import the
>    try-run macro.
>
> Copy what they need into tools/build/Build.include, and make them
> include it instead of scripts/Kbuild.include.
>
> Link: https://lore.kernel.org/lkml/86dadf33-70f7-a5ac-cb8c-64966d2f45a1@linux.ibm.com/
> Fixes: d9f4ff50d2aa ("kbuild: spilt cc-option and friends to scripts/Makefile.compiler")
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>


Applied to linux-kbuild.




> ---
>
> Changes in v2:
>   - copy macros to tools/build/BUild.include
>
>  tools/build/Build.include                     | 24 +++++++++++++++++++
>  tools/testing/selftests/bpf/Makefile          |  2 +-
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../selftests/powerpc/pmu/ebb/Makefile        |  2 +-
>  tools/thermal/tmon/Makefile                   |  2 +-
>  5 files changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/tools/build/Build.include b/tools/build/Build.include
> index 585486e40995..2cf3b1bde86e 100644
> --- a/tools/build/Build.include
> +++ b/tools/build/Build.include
> @@ -100,3 +100,27 @@ cxx_flags = -Wp,-MD,$(depfile) -Wp,-MT,$@ $(CXXFLAGS) -D"BUILD_STR(s)=\#s" $(CXX
>  ## HOSTCC C flags
>
>  host_c_flags = -Wp,-MD,$(depfile) -Wp,-MT,$@ $(KBUILD_HOSTCFLAGS) -D"BUILD_STR(s)=\#s" $(HOSTCFLAGS_$(basetarget).o) $(HOSTCFLAGS_$(obj))
> +
> +# output directory for tests below
> +TMPOUT = .tmp_$$$$
> +
> +# try-run
> +# Usage: option = $(call try-run, $(CC)...-o "$$TMP",option-ok,otherwise)
> +# Exit code chooses option. "$$TMP" serves as a temporary file and is
> +# automatically cleaned up.
> +try-run = $(shell set -e;              \
> +       TMP=$(TMPOUT)/tmp;              \
> +       mkdir -p $(TMPOUT);             \
> +       trap "rm -rf $(TMPOUT)" EXIT;   \
> +       if ($(1)) >/dev/null 2>&1;      \
> +       then echo "$(2)";               \
> +       else echo "$(3)";               \
> +       fi)
> +
> +# cc-option
> +# Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
> +cc-option = $(call try-run, \
> +       $(CC) -Werror $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
> +
> +# delete partially updated (i.e. corrupted) files on error
> +.DELETE_ON_ERROR:
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 044bfdcf5b74..17a5cdf48d37 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -include ../../../../scripts/Kbuild.include
> +include ../../../build/Build.include
>  include ../../../scripts/Makefile.arch
>  include ../../../scripts/Makefile.include
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index a6d61f451f88..5ef141f265bd 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -include ../../../../scripts/Kbuild.include
> +include ../../../build/Build.include
>
>  all:
>
> diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
> index af3df79d8163..c5ecb4634094 100644
> --- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
> +++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -include ../../../../../../scripts/Kbuild.include
> +include ../../../../../build/Build.include
>
>  noarg:
>         $(MAKE) -C ../../
> diff --git a/tools/thermal/tmon/Makefile b/tools/thermal/tmon/Makefile
> index 59e417ec3e13..9db867df7679 100644
> --- a/tools/thermal/tmon/Makefile
> +++ b/tools/thermal/tmon/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # We need this for the "cc-option" macro.
> -include ../../../scripts/Kbuild.include
> +include ../../build/Build.include
>
>  VERSION = 1.0
>
> --
> 2.27.0
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20210416130051.239782-1-masahiroy%40kernel.org.



-- 
Best Regards
Masahiro Yamada
