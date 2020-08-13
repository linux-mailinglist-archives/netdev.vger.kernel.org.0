Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A175243281
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 04:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHMCbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 22:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgHMCbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 22:31:45 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F71C061383;
        Wed, 12 Aug 2020 19:31:44 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id k4so4257811ilr.12;
        Wed, 12 Aug 2020 19:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qNWYLoXZVMonMKBHLVmtYLhOlAGwJ6EBuGHChAsIpUo=;
        b=qhdCfedfr/Ep9bZBLmhAKJeAwZhN0pMo6GUSitTaAQbtSuVYKoxD/0YKcoO24/2JP0
         Nndmv39jDWxQWcGPmIkOGCsblGpa51/QHIbiFGsA2Ox/f9A23qiGqy+MmslFALRf0/do
         4UddMMK+QndME3ZYl5nNVv4kbRnlJgfjDgHalzUtOfP7ooM7aeK8MLdx+NZX5TEPc5bR
         1FCDbrWi//y3YbA2epAJeOgxnsnCDdhTxyjpc97A8XWRwV5xe2waWZmURHlXxrdWeoSI
         z57vPWGcQRVzy8YiP/NMjBuSKftyKu4kSEKChHxmMeA4LIFRZC28QHFOMRseMPT1ujra
         mRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qNWYLoXZVMonMKBHLVmtYLhOlAGwJ6EBuGHChAsIpUo=;
        b=aXyqpg5TDUcwy2/hRo9GjUI9YUvi7qikxHmwJvIyzLpGwpWMOhVMLj8lgdwACRdoIL
         UL8weJhObf7oncVpDUDSyGm30x8EaXAW8gOMqxkkKCWoUOC4tG6aQWhHF/T+mGitHkkI
         HYelzhni/09kjTOfwIKtj8hTKgUX16318mI4BqyqDrroW1gMzQL/MHVDOPJHWjZfYrAV
         vXdk9yNF0uSYNtDHFcvt8gHcUPNY+uU243hIQzpiSCR9bffwOP9pz/h2vYItQtEFXBMZ
         tvuWEc4eqUHv8PqNIwbNrxVzzAgJC7Pt2+YF/i1swOwiRSjb+Bucd9J9v1x+G8Wm6Cpz
         p+xg==
X-Gm-Message-State: AOAM530fWc7a3JIvFphwY3yaw9jyQ9QJrhwk9QVYwY2dRmksaHvQUxdk
        DswK3GU9+HVKV+qT/l4TazpGoyiWPv4VgcI98n6tYv2s9rJ1Vw==
X-Google-Smtp-Source: ABdhPJylH3v+THRzQhBifdrCGGocqIQ2qtemdjHQ2VqrVR69VQbCYWZ4Su1ADSxdglVhaS2CyyO1m0ylSx1GTkqkISg=
X-Received: by 2002:a92:9e48:: with SMTP id q69mr2671414ili.170.1597285903798;
 Wed, 12 Aug 2020 19:31:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200812221518.2869003-1-daniel.diaz@linaro.org>
In-Reply-To: <20200812221518.2869003-1-daniel.diaz@linaro.org>
From:   Tom Hebb <tommyhebb@gmail.com>
Date:   Wed, 12 Aug 2020 19:31:32 -0700
Message-ID: <CAMcCCgRGpi+3D4479MLU2xQZJYBA1c6mzZ=bb1VLEwPg3VAgLg@mail.gmail.com>
Subject: Re: [PATCH] tools build feature: Quote CC and CXX for their arguments
To:     =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 3:15 PM Daniel D=C3=ADaz <daniel.diaz@linaro.org> w=
rote:
>
> When using a cross-compilation environment, such as OpenEmbedded,
> the CC an CXX variables are set to something more than just a
> command: there are arguments (such as --sysroot) that need to be
> passed on to the compiler so that the right set of headers and
> libraries are used.
>
> For the particular case that our systems detected, CC is set to
> the following:
>
>   export CC=3D"aarch64-linaro-linux-gcc  --sysroot=3D/oe/build/tmp/work/m=
achine/perf/1.0-r9/recipe-sysroot"
>
> Without quotes, detection is as follows:
>
>   Auto-detecting system features:
>   ...                         dwarf: [ OFF ]
>   ...            dwarf_getlocations: [ OFF ]
>   ...                         glibc: [ OFF ]
>   ...                          gtk2: [ OFF ]
>   ...                        libbfd: [ OFF ]
>   ...                        libcap: [ OFF ]
>   ...                        libelf: [ OFF ]
>   ...                       libnuma: [ OFF ]
>   ...        numa_num_possible_cpus: [ OFF ]
>   ...                       libperl: [ OFF ]
>   ...                     libpython: [ OFF ]
>   ...                     libcrypto: [ OFF ]
>   ...                     libunwind: [ OFF ]
>   ...            libdw-dwarf-unwind: [ OFF ]
>   ...                          zlib: [ OFF ]
>   ...                          lzma: [ OFF ]
>   ...                     get_cpuid: [ OFF ]
>   ...                           bpf: [ OFF ]
>   ...                        libaio: [ OFF ]
>   ...                       libzstd: [ OFF ]
>   ...        disassembler-four-args: [ OFF ]
>
>   Makefile.config:414: *** No gnu/libc-version.h found, please install gl=
ibc-dev[el].  Stop.
>   Makefile.perf:230: recipe for target 'sub-make' failed
>   make[1]: *** [sub-make] Error 2
>   Makefile:69: recipe for target 'all' failed
>   make: *** [all] Error 2
>
> With CC and CXX quoted, some of those features are now detected.
>
> Fixes: e3232c2f39ac ("tools build feature: Use CC and CXX from parent")
>
> Signed-off-by: Daniel D=C3=ADaz <daniel.diaz@linaro.org>

Whoops, I'm the one who introduced this issue. Fix looks good, thanks!

Reviewed-by: Thomas Hebb <tommyhebb@gmail.com>
Fixes: e3232c2f39ac ("tools build feature: Use CC and CXX from parent")

> ---
>  tools/build/Makefile.feature | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
> index 774f0b0ca28a..e7818b44b48e 100644
> --- a/tools/build/Makefile.feature
> +++ b/tools/build/Makefile.feature
> @@ -8,7 +8,7 @@ endif
>
>  feature_check =3D $(eval $(feature_check_code))
>  define feature_check_code
> -  feature-$(1) :=3D $(shell $(MAKE) OUTPUT=3D$(OUTPUT_FEATURES) CC=3D$(C=
C) CXX=3D$(CXX) CFLAGS=3D"$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" CXX=
FLAGS=3D"$(EXTRA_CXXFLAGS) $(FEATURE_CHECK_CXXFLAGS-$(1))" LDFLAGS=3D"$(LDF=
LAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C $(feature_dir) $(OUTPUT_FEATURES)te=
st-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
> +  feature-$(1) :=3D $(shell $(MAKE) OUTPUT=3D$(OUTPUT_FEATURES) CC=3D"$(=
CC)" CXX=3D"$(CXX)" CFLAGS=3D"$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))"=
 CXXFLAGS=3D"$(EXTRA_CXXFLAGS) $(FEATURE_CHECK_CXXFLAGS-$(1))" LDFLAGS=3D"$=
(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C $(feature_dir) $(OUTPUT_FEATURE=
S)test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)

We should probably also be quoting the arguments that expand $(OUTPUT_FEATU=
RES)
too, although trying to handle path names with spaces is probably a
lost cause anyway.

>  endef
>
>  feature_set =3D $(eval $(feature_set_code))
> --
> 2.25.1
>
