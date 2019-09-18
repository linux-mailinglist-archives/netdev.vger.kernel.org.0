Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0694B6EC5
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 23:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbfIRVWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 17:22:34 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34649 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbfIRVWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 17:22:33 -0400
Received: by mail-qt1-f194.google.com with SMTP id j1so1602907qth.1;
        Wed, 18 Sep 2019 14:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qb2A3C5wATz4Nf57ckt7sqoju+5mQuN9qsWAH5MpuUY=;
        b=RE+8BfDRWntiDVKQ3WDv5+71lmLHNmNsGFyLfABFO0SdCT9ZdHT3WL3fKGIb4+xhex
         785g0yD8Z6Axqs35gWAMMboxyJeKYOrWir1aeshj0V+qwdr48Y99JE5dxacHYoABIB/5
         JigM5lYne0Ef7qLIpsktompbTSG3jUugUOKcJ2t8/iTwyQvmqdzSjLs+zmbDkVTL6Zcy
         KiSOj9tdNZvyqnCc9EzMDEecRcP7mrx1lyXD5jqgzZz8EXM0eE6Dm1OWskQdJrCXcTSh
         vvaxmaevqRUA2HSdxyoFr5t96Y4H0GY1WD0rJPdZDJgzDBAWOp+3T6j0amljny5xlBWt
         1MUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qb2A3C5wATz4Nf57ckt7sqoju+5mQuN9qsWAH5MpuUY=;
        b=O5b+vBB9X9LzS8LoN51zNZ49rHUm70jSSHS1VPKWmjJGHx5yVKziCKj9SJIW0DVKOp
         Cj9JBiueOxf+0KySDDzGbpuu97vRI4Eow9GsZNASO4xlLf/iQJmJt8sFc/j/kwncSA1o
         SXaUc7dEY3Ukd80zBVhmAH+Zc91Qmex2S0KVXeV1OKgQKEvckWqJZXTs0bC+Ttsp5oT/
         xE3KOfEEVLqGhDgvtoGTB1AhsseN/QUxlFKbFLeEu9lkBKAma7yydAV6QzrkzFjyOw4e
         +x7268T/gfV6XqlOOTA+0SgKT4sHaTmF7sb+0ndTjOp2TGt4D6/cKpkFp/3zTyOpwEsU
         qXMQ==
X-Gm-Message-State: APjAAAUIIrisd5tt7MLJf8d8eiH01ile8KXss9/pMTEug+NEP3hraSXp
        kEEnh1BmKl4etkTqOZIc7yGvEaOpGQET0ogD8ug=
X-Google-Smtp-Source: APXvYqwsN5vTmQ45cFxtG7pPB/xmJDK70GBKn/PVuTNFZGyQ+wn3m7FXKwmZlYNz7zk/eIl0C4f00zJPu8PvOl3jtAU=
X-Received: by 2002:ac8:4658:: with SMTP id f24mr5936081qto.93.1568841750692;
 Wed, 18 Sep 2019 14:22:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
 <20190916105433.11404-8-ivan.khoronzhuk@linaro.org> <CAEf4Bzaidog3n0YP6F5dL2rCrHtKCOBXS0as7usymk8Twdro4w@mail.gmail.com>
 <20190918101216.GA2908@khorivan>
In-Reply-To: <20190918101216.GA2908@khorivan>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Sep 2019 14:22:19 -0700
Message-ID: <CAEf4BzZt0DnjU3Fw7TfiqqyZDOAX0mcKWasY4zWG3EcYyDzHxw@mail.gmail.com>
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

On Wed, Sep 18, 2019 at 3:12 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Tue, Sep 17, 2019 at 04:19:40PM -0700, Andrii Nakryiko wrote:
> >On Mon, Sep 16, 2019 at 3:58 AM Ivan Khoronzhuk
> ><ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> The makefile.target is added only and will be used in
> >
> >typo: Makefile
> >
> >> sample/bpf/Makefile later in order to switch cross-compiling on CC
> >
> >on -> to
> >
> >> from HOSTCC environment.
> >>
> >> The HOSTCC is supposed to build binaries and tools running on the host
> >> afterwards, in order to simplify build or so, like "fixdep" or else.
> >> In case of cross compiling "fixdep" is executed on host when the rest
> >> samples should run on target arch. In order to build binaries for
> >> target arch with CC and tools running on host with HOSTCC, lets add
> >> Makefile.target for simplicity, having definition and routines similar
> >> to ones, used in script/Makefile.host. This allows later add
> >> cross-compilation to samples/bpf with minimum changes.
> >>
> >> The tprog stands for target programs built with CC.
> >
> >Why tprog? Could we just use prog: hostprog vs prog.
> Prev. version was with prog, but Yonghong Song found it ambiguous.
> As prog can be bpf also. So, decision was made to follow logic:
> * target prog - non bpf progs
> * bpf prog = bpf prog, that can be later smth similar, providing build options
>   for each bpf object separately.
>

Well, I'm not going to insist, but BPF program is a C function,
compiled BPF .o file is BPF object, so I don't think there is going to
be too much confusion to have progs and hostprogs in Makefile. But I'm
fine with tprog.

> Details here:
> https://lkml.org/lkml/2019/9/13/1037
>
> >
> >>
> >> Makefile.target contains only stuff needed for samples/bpf, potentially
> >> can be reused later and now needed only for unblocking tricky
> >> samples/bpf cross compilation.
> >>
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>  samples/bpf/Makefile.target | 75 +++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 75 insertions(+)
> >>  create mode 100644 samples/bpf/Makefile.target
> >>
> >> diff --git a/samples/bpf/Makefile.target b/samples/bpf/Makefile.target
> >> new file mode 100644
> >> index 000000000000..fb6de63f7d2f
> >> --- /dev/null
> >> +++ b/samples/bpf/Makefile.target
> >> @@ -0,0 +1,75 @@
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# ==========================================================================
> >> +# Building binaries on the host system
> >> +# Binaries are not used during the compilation of the kernel, and intendent
> >
> >typo: intended
> >
> >> +# to be build for target board, target board can be host ofc. Added to build
> >
> >What's ofc, is it "of course"?
> yes, ofc )

Alright, let's not try to save 5 letters, it's quite confusing.

>
> >
> >> +# binaries to run not on host system.
> >> +#
> >> +# Sample syntax (see Documentation/kbuild/makefiles.rst for reference)
> >> +# tprogs-y := xsk_example
> >> +# Will compile xdpsock_example.c and create an executable named xsk_example
> >
> >You mix references to xsk_example and xdpsock_example, which is very
> >confusing. I'm guessing you meant to use xdpsock_example consistently.
> Oh, yes. Thanks.
>
> >
> >> +#
> >> +# tprogs-y    := xdpsock
> >> +# xdpsock-objs := xdpsock_1.o xdpsock_2.o
> >> +# Will compile xdpsock_1.c and xdpsock_2.c, and then link the executable
> >> +# xdpsock, based on xdpsock_1.o and xdpsock_2.o
> >> +#
> >> +# Inherited from scripts/Makefile.host
> >
> >"Inspired by" or "Derived from" would be probably more appropriate term :)
> I will replace with "Derived from", looks better.
>

sounds good

> >
> >> +#
> >> +__tprogs := $(sort $(tprogs-y))
> >> +
> >> +# C code
> >> +# Executables compiled from a single .c file
> >> +tprog-csingle  := $(foreach m,$(__tprogs), \
> >> +                       $(if $($(m)-objs),,$(m)))
> >> +
> >> +# C executables linked based on several .o files
> >> +tprog-cmulti   := $(foreach m,$(__tprogs),\
> >> +                       $(if $($(m)-objs),$(m)))
> >> +
> >> +# Object (.o) files compiled from .c files
> >> +tprog-cobjs    := $(sort $(foreach m,$(__tprogs),$($(m)-objs)))
> >> +
> >> +tprog-csingle  := $(addprefix $(obj)/,$(tprog-csingle))
> >> +tprog-cmulti   := $(addprefix $(obj)/,$(tprog-cmulti))
> >> +tprog-cobjs    := $(addprefix $(obj)/,$(tprog-cobjs))
> >> +
> >> +#####
> >> +# Handle options to gcc. Support building with separate output directory
> >> +
> >> +_tprogc_flags   = $(TPROGS_CFLAGS) \
> >> +                 $(TPROGCFLAGS_$(basetarget).o)
> >> +
> >> +# $(objtree)/$(obj) for including generated headers from checkin source files
> >> +ifeq ($(KBUILD_EXTMOD),)
> >> +ifdef building_out_of_srctree
> >> +_tprogc_flags   += -I $(objtree)/$(obj)
> >> +endif
> >> +endif
> >> +
> >> +tprogc_flags    = -Wp,-MD,$(depfile) $(_tprogc_flags)
> >> +
> >> +# Create executable from a single .c file
> >> +# tprog-csingle -> Executable
> >> +quiet_cmd_tprog-csingle        = CC  $@
> >> +      cmd_tprog-csingle        = $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ $< \
> >> +               $(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
> >> +$(tprog-csingle): $(obj)/%: $(src)/%.c FORCE
> >> +       $(call if_changed_dep,tprog-csingle)
> >> +
> >> +# Link an executable based on list of .o files, all plain c
> >> +# tprog-cmulti -> executable
> >> +quiet_cmd_tprog-cmulti = LD  $@
> >> +      cmd_tprog-cmulti = $(CC) $(tprogc_flags) $(TPROGS_LDFLAGS) -o $@ \
> >> +                         $(addprefix $(obj)/,$($(@F)-objs)) \
> >> +                         $(TPROGS_LDLIBS) $(TPROGLDLIBS_$(@F))
> >> +$(tprog-cmulti): $(tprog-cobjs) FORCE
> >> +       $(call if_changed,tprog-cmulti)
> >> +$(call multi_depend, $(tprog-cmulti), , -objs)
> >> +
> >> +# Create .o file from a single .c file
> >> +# tprog-cobjs -> .o
> >> +quiet_cmd_tprog-cobjs  = CC  $@
> >> +      cmd_tprog-cobjs  = $(CC) $(tprogc_flags) -c -o $@ $<
> >> +$(tprog-cobjs): $(obj)/%.o: $(src)/%.c FORCE
> >> +       $(call if_changed_dep,tprog-cobjs)
> >> --
> >> 2.17.1
> >>
> >
> >tprogs is quite confusing, but overall looks good to me.
> I tend to leave it as tprogs, unless it's going to be progs and agreed with
> Yonghong.
>
> It follows logic:
> - tprogs for bins
> - bpfprogs or bojs or bprogs (could be) for bpf obj

as mentioned above, we never build "BPF programs", they are always
part of BPF objects. But as I mentioned, I'm fine with sticking to
tprog.

>
> --
> Regards,
> Ivan Khoronzhuk
