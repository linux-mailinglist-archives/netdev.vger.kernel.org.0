Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B93B587A
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 01:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfIQXTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 19:19:54 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46156 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbfIQXTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 19:19:54 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so5888252qkd.13;
        Tue, 17 Sep 2019 16:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rW0fUUzyh5J4//FBaJRiFgdgywM+/ZSdY6ujE4+DAUk=;
        b=lCs6VbxaKxAcvuw2itRNfnACUY+KBtbP/PA2lQCYDPK1Qqch4hCbKt0Fgzd1ONvV3+
         FimQFOOM3mAqLKmB2aNVhOJGIHnRTpljEE9amCuPiKljm+LnLC6i7AeyOKQYKI9CHZoH
         6D2bGca0Tl1I4F10dOUt2ARwHgKGGa2kZtR++DXCxQe0yNQ2iHOFvzcWFFaF7RZL+ZRD
         eo1qVjORUf+KuGyKYzXsMLDdumRW5gkiD1jTjKzAElZKQ1Hs2nj5JZxrHFWFc0o5MObc
         iYtgCf21N9yIQIi7FjISAmYevQ/pObU0lYa9fyXp/OUOlDrjC5nVkbbhkeHowVo7GN6K
         UBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rW0fUUzyh5J4//FBaJRiFgdgywM+/ZSdY6ujE4+DAUk=;
        b=FF4q22tMDiiDt+Bthx0hOBElYpVJ2zmoKZZf/jBg4kb68qg15XYUZWwP2uxKVU/ASe
         sakm3CsNSUjoh8KExActCnYnfihZggrk8bn1qAoU/IgIBGY/vPV/rYIzZ3RE8U5nqVhP
         JbbwOu4g4sCz2D4vhd25EU00twPVcIdVl8iiDVhY8iaFCKUhhUJ2IyYf5N0SdqsI949b
         EMmCum7ptZuSsU1UJAf6U0PPO8pCUex8OTZCaQDg7I7gIWXKr3ZfONohvj+LlZBn0YW5
         YMnOQ34bhwdVnAfy3wtBwIztb/+erwNlePdAZlVs0tvl+rJga5JELvx51KlRXlSBlyip
         zVUA==
X-Gm-Message-State: APjAAAXAKaSVRxYtA5LKBLOyNSfYetKtifjPfPc6uFTIdiHUsl1jgCwZ
        dRglrBypDecFUTvpTd5r5NtK9aQtLBiPtBfnoI8=
X-Google-Smtp-Source: APXvYqw8N50R1EkGST4sURMrvsr2zGYEOgcUNG/iu4IF+XBMsJJxJ7g8waXOxXrpMDZStlLRdjpv9Yi1hiF693QWKWc=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr1147148qkk.39.1568762391880;
 Tue, 17 Sep 2019 16:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-8-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-8-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 16:19:40 -0700
Message-ID: <CAEf4Bzaidog3n0YP6F5dL2rCrHtKCOBXS0as7usymk8Twdro4w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 07/14] samples: bpf: add makefile.target for
 separate CC target build
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 3:58 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> The makefile.target is added only and will be used in

typo: Makefile

> sample/bpf/Makefile later in order to switch cross-compiling on CC

on -> to

> from HOSTCC environment.
>
> The HOSTCC is supposed to build binaries and tools running on the host
> afterwards, in order to simplify build or so, like "fixdep" or else.
> In case of cross compiling "fixdep" is executed on host when the rest
> samples should run on target arch. In order to build binaries for
> target arch with CC and tools running on host with HOSTCC, lets add
> Makefile.target for simplicity, having definition and routines similar
> to ones, used in script/Makefile.host. This allows later add
> cross-compilation to samples/bpf with minimum changes.
>
> The tprog stands for target programs built with CC.

Why tprog? Could we just use prog: hostprog vs prog.

>
> Makefile.target contains only stuff needed for samples/bpf, potentially
> can be reused later and now needed only for unblocking tricky
> samples/bpf cross compilation.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  samples/bpf/Makefile.target | 75 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
>  create mode 100644 samples/bpf/Makefile.target
>
> diff --git a/samples/bpf/Makefile.target b/samples/bpf/Makefile.target
> new file mode 100644
> index 000000000000..fb6de63f7d2f
> --- /dev/null
> +++ b/samples/bpf/Makefile.target
> @@ -0,0 +1,75 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# ==========================================================================
> +# Building binaries on the host system
> +# Binaries are not used during the compilation of the kernel, and intendent

typo: intended

> +# to be build for target board, target board can be host ofc. Added to build

What's ofc, is it "of course"?

> +# binaries to run not on host system.
> +#
> +# Sample syntax (see Documentation/kbuild/makefiles.rst for reference)
> +# tprogs-y := xsk_example
> +# Will compile xdpsock_example.c and create an executable named xsk_example

You mix references to xsk_example and xdpsock_example, which is very
confusing. I'm guessing you meant to use xdpsock_example consistently.

> +#
> +# tprogs-y    := xdpsock
> +# xdpsock-objs := xdpsock_1.o xdpsock_2.o
> +# Will compile xdpsock_1.c and xdpsock_2.c, and then link the executable
> +# xdpsock, based on xdpsock_1.o and xdpsock_2.o
> +#
> +# Inherited from scripts/Makefile.host

"Inspired by" or "Derived from" would be probably more appropriate term :)

> +#
> +__tprogs := $(sort $(tprogs-y))
> +
> +# C code
> +# Executables compiled from a single .c file
> +tprog-csingle  := $(foreach m,$(__tprogs), \
> +                       $(if $($(m)-objs),,$(m)))
> +
> +# C executables linked based on several .o files
> +tprog-cmulti   := $(foreach m,$(__tprogs),\
> +                       $(if $($(m)-objs),$(m)))
> +
> +# Object (.o) files compiled from .c files
> +tprog-cobjs    := $(sort $(foreach m,$(__tprogs),$($(m)-objs)))
> +
> +tprog-csingle  := $(addprefix $(obj)/,$(tprog-csingle))
> +tprog-cmulti   := $(addprefix $(obj)/,$(tprog-cmulti))
> +tprog-cobjs    := $(addprefix $(obj)/,$(tprog-cobjs))
> +
> +#####
> +# Handle options to gcc. Support building with separate output directory
> +
> +_tprogc_flags   = $(TPROGS_CFLAGS) \
> +                 $(TPROGCFLAGS_$(basetarget).o)
> +
> +# $(objtree)/$(obj) for including generated headers from checkin source files
> +ifeq ($(KBUILD_EXTMOD),)
> +ifdef building_out_of_srctree
> +_tprogc_flags   += -I $(objtree)/$(obj)
> +endif
> +endif
> +
> +tprogc_flags    = -Wp,-MD,$(depfile) $(_tprogc_flags)
> +
> +# Create executable from a single .c file
> +# tprog-csingle -> Executable
> +quiet_cmd_tprog-csingle        = CC  $@
> +      cmd_tprog-csingle        = $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ $< \
> +               $(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
> +$(tprog-csingle): $(obj)/%: $(src)/%.c FORCE
> +       $(call if_changed_dep,tprog-csingle)
> +
> +# Link an executable based on list of .o files, all plain c
> +# tprog-cmulti -> executable
> +quiet_cmd_tprog-cmulti = LD  $@
> +      cmd_tprog-cmulti = $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ \
> +                         $(addprefix $(obj)/,$($(@F)-objs)) \
> +                         $(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
> +$(tprog-cmulti): $(tprog-cobjs) FORCE
> +       $(call if_changed,tprog-cmulti)
> +$(call multi_depend, $(tprog-cmulti), , -objs)
> +
> +# Create .o file from a single .c file
> +# tprog-cobjs -> .o
> +quiet_cmd_tprog-cobjs  = CC  $@
> +      cmd_tprog-cobjs  = $(CC) $(tprogc_flags) -c -o $@ $<
> +$(tprog-cobjs): $(obj)/%.o: $(src)/%.c FORCE
> +       $(call if_changed_dep,tprog-cobjs)
> --
> 2.17.1
>

tprogs is quite confusing, but overall looks good to me.
