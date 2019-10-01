Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACD1C344E
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 14:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387752AbfJAMdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 08:33:49 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:36852 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfJAMds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 08:33:48 -0400
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id x91CXb5n009302;
        Tue, 1 Oct 2019 21:33:38 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x91CXb5n009302
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1569933218;
        bh=vZ/by6QGyvjk+iMrCPDyuHl+7HvLeaF7vg7qAlH/0gM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LcxUtM7Szvj3Aa2e4c2A1wzxF3fUSR8DEKqTJvpb1RlRemNEy9bn14M3IRgHYzs11
         AjHa/fw1zpSswKnqtBDS03OHuKplMR057CnPolWhMcv4iyYAr6tGBM8ga4SR12S76P
         cG5et+8g+yyQFVCC6bhCsLC2GsGuFROtLfVo8PYphiJ0yzCD+X4S7ms6WL/sNrdaUw
         PGNEu9uPWIt6jJL17RcM68FMLNK1mOFaTP/jOrO+BgOSvrGLInFE2ByW7SSkIeoTb8
         GPNFBqfkKsf1lj+gHbF2sgU+4rJO4i+krzAlxs9wjyHpsat1odB9sGygYPq53lIz3w
         F5N56NLrRJ2IA==
X-Nifty-SrcIP: [209.85.217.47]
Received: by mail-vs1-f47.google.com with SMTP id y129so8217342vsc.6;
        Tue, 01 Oct 2019 05:33:37 -0700 (PDT)
X-Gm-Message-State: APjAAAVqoUo4xMHtaIhWOsrj2nqL9/L7VKuzLpFhlUsDoxqHN917PWLL
        qtDUaa7pg8TwXe+hqgCpmSn0rTCJAVkApQikIW4=
X-Google-Smtp-Source: APXvYqzyG7S32nGz1uEUNLPUcQCQ8TKvJylySJaOoKcfZPW3A+jS3aqcfynfl9dnbk2g6Sr1O9oa0d+P231N1XKqaRU=
X-Received: by 2002:a67:1e87:: with SMTP id e129mr13181899vse.179.1569933216622;
 Tue, 01 Oct 2019 05:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com>
In-Reply-To: <20191001101429.24965-1-bjorn.topel@gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 1 Oct 2019 21:33:00 +0900
X-Gmail-Original-Message-ID: <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
Message-ID: <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn

On Tue, Oct 1, 2019 at 7:14 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> This commit makes it possible to build the BPF samples via a Kconfig
> option, CONFIG_SAMPLE_BPF. Further, it fixes that samples/bpf/ could
> not be built due to a missing samples/Makefile subdir-y entry, after
> the introduction of commit 394053f4a4b3 ("kbuild: make single targets
> work more correctly").
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  samples/Kconfig  | 4 ++++
>  samples/Makefile | 1 +
>  2 files changed, 5 insertions(+)
>
> diff --git a/samples/Kconfig b/samples/Kconfig
> index c8dacb4dda80..054297ac89ad 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -169,4 +169,8 @@ config SAMPLE_VFS
>           as mount API and statx().  Note that this is restricted to the =
x86
>           arch whilst it accesses system calls that aren't yet in all arc=
hes.
>
> +config SAMPLE_BPF
> +       bool "BPF samples"
> +       depends on HEADERS_INSTALL
> +
>  endif # SAMPLES
> diff --git a/samples/Makefile b/samples/Makefile
> index 7d6e4ca28d69..49aa2f7d044b 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -20,3 +20,4 @@ obj-$(CONFIG_SAMPLE_TRACE_PRINTK)     +=3D trace_printk=
/
>  obj-$(CONFIG_VIDEO_PCI_SKELETON)       +=3D v4l/
>  obj-y                                  +=3D vfio-mdev/
>  subdir-$(CONFIG_SAMPLE_VFS)            +=3D vfs
> +subdir-$(CONFIG_SAMPLE_BPF)            +=3D bpf


Please keep samples/Makefile sorted alphabetically.




I am not checking samples/bpf/Makefile, but
allmodconfig no longer compiles for me.



samples/bpf/Makefile:209: WARNING: Detected possible issues with include pa=
th.
samples/bpf/Makefile:210: WARNING: Please install kernel headers
locally (make headers_install).
error: unable to create target: 'No available targets are compatible
with triple "bpf"'
1 error generated.
readelf: Error: './llvm_btf_verify.o': No such file
*** ERROR: LLVM (llc) does not support 'bpf' target
   NOTICE: LLVM version >=3D 3.7.1 required

--=20
Best Regards
Masahiro Yamada
