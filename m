Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6660336212D
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 15:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhDPNjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 09:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244220AbhDPNjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 09:39:10 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B607C061574;
        Fri, 16 Apr 2021 06:38:46 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id p3so9480338ybk.0;
        Fri, 16 Apr 2021 06:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0mHucleBm3GX7Z1SOPiFjIocZZ3cy927o5LfpjbehY0=;
        b=LHOOZCdmhtYRgZeIr5lEhO6KXFFYOEi/8AF39AtF41E0Kj5ox6YUrLbD1vh18P9Lgw
         sAVjw8PPsAkREA+eH+IscJhlq1h6M6yaFa7D2Ul9LpLgbbeOdwpmPXCeDFpcWsTP6nHq
         SCI7Oj+YXaVgCPpr7CLkYRTDlBDXPOunOileWzKluP9csVXr0LkmjxeyoNNj/y0KHa8o
         m1iDnTxmuwSUOqb9QqmuJjAcD1igAGYaIOj4rbRGNsMZcZ9Vp6C8Phtn32KKQWyVGS+x
         HZbKvd+3/cmY7P4s96LQpYPFB1lT9xTMKroDuLgw++dQkCoTbyaprK8bjyaAEOyDTD6R
         ve0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0mHucleBm3GX7Z1SOPiFjIocZZ3cy927o5LfpjbehY0=;
        b=avI6i2cLrkGRhuyQJsbwHAzrzNF8/W2Yl8whYx56hVm2gGVJEjih6hz2fSpC5ZLu2p
         y90prW8cLdFeLzhEh5Aq0cLbvx3IWMjd2PtD6Cqxd3gfcfepYY4VjW6OSfZL2FmgWSjU
         ZjQE3XHHJVcUOnwYcP0JzTljPfSmc59M8dZwfwk+7/6ahF/vXBwCzzp19iOYKwMEjSNW
         kCzGLnbY+Jf1bwq4YAYR6732HAFgcxSUQlTmllq/FbykQ/3ljLBsavH15OT/KQk+iJs2
         1OVB6e5gwvluNeJIrvoyJKra6RPJeIvvrCUJ14CqJ7vxMZNWmyQzf6VvQEOYUflPKl2b
         bDVQ==
X-Gm-Message-State: AOAM531CKZXVqg0Y5bQn/WMLg6+LAOCXkbwvLwQlZ3DR9+LoqCFCOKHl
        EwV2ZBjn0vjc1gUTiXEWxeorwDk2Z4QCD9yepuk=
X-Google-Smtp-Source: ABdhPJw5sY0mgMHNVNaARBdH4/XL7aCQwPNekTw5pB2njQeJlgreCNQsgFDRpI0R7ZiYJLGMXF7BF2idqTBCgkAwAiE=
X-Received: by 2002:a25:7004:: with SMTP id l4mr12503620ybc.304.1618580325409;
 Fri, 16 Apr 2021 06:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210415093250.3391257-1-Jianlin.Lv@arm.com> <9c4a78d2-f73c-832a-e6e2-4b4daa729e07@iogearbox.net>
In-Reply-To: <9c4a78d2-f73c-832a-e6e2-4b4daa729e07@iogearbox.net>
From:   Jianlin Lv <iecedge@gmail.com>
Date:   Fri, 16 Apr 2021 21:38:33 +0800
Message-ID: <CAFA-uR8H2MMy_vjQ_ZL96ifKcVg2goK3nozOFavN+gnJ+=V6Rw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Remove bpf_jit_enable=2 debugging mode
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf <bpf@vger.kernel.org>,
        corbet@lwn.net, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, illusionist.neo@gmail.com,
        linux@armlinux.org.uk, zlim.lnx@gmail.com, catalin.marinas@arm.com,
        Will Deacon <will@kernel.org>, paulburton@kernel.org,
        tsbogend@alpha.franken.de, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, luke.r.nels@gmail.com,
        xi.wang@gmail.com, bjorn@kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, iii@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        udknight@gmail.com, mchehab+huawei@kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Mahesh Bandewar <maheshb@google.com>, horms@verge.net.au,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>, quentin@isovalent.com,
        tklauser@distanz.ch, grantseltzer@gmail.com, irogers@google.com,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 10:38 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/15/21 11:32 AM, Jianlin Lv wrote:
> > For debugging JITs, dumping the JITed image to kernel log is discouraged,
> > "bpftool prog dump jited" is much better way to examine JITed dumps.
> > This patch get rid of the code related to bpf_jit_enable=2 mode and
> > update the proc handler of bpf_jit_enable, also added auxiliary
> > information to explain how to use bpf_jit_disasm tool after this change.
> >
> > Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> [...]
> > diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
> > index 0a7a2870f111..8d36b4658076 100644
> > --- a/arch/x86/net/bpf_jit_comp32.c
> > +++ b/arch/x86/net/bpf_jit_comp32.c
> > @@ -2566,9 +2566,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >               cond_resched();
> >       }
> >
> > -     if (bpf_jit_enable > 1)
> > -             bpf_jit_dump(prog->len, proglen, pass + 1, image);
> > -
> >       if (image) {
> >               bpf_jit_binary_lock_ro(header);
> >               prog->bpf_func = (void *)image;
> > diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> > index c8496c1142c9..990b1720c7a4 100644
> > --- a/net/core/sysctl_net_core.c
> > +++ b/net/core/sysctl_net_core.c
> > @@ -273,16 +273,8 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
> >
> >       tmp.data = &jit_enable;
> >       ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> > -     if (write && !ret) {
> > -             if (jit_enable < 2 ||
> > -                 (jit_enable == 2 && bpf_dump_raw_ok(current_cred()))) {
> > -                     *(int *)table->data = jit_enable;
> > -                     if (jit_enable == 2)
> > -                             pr_warn("bpf_jit_enable = 2 was set! NEVER use this in production, only for JIT debugging!\n");
> > -             } else {
> > -                     ret = -EPERM;
> > -             }
> > -     }
> > +     if (write && !ret)
> > +             *(int *)table->data = jit_enable;
> >       return ret;
> >   }
> >
> > @@ -389,7 +381,7 @@ static struct ctl_table net_core_table[] = {
> >               .extra2         = SYSCTL_ONE,
> >   # else
> >               .extra1         = SYSCTL_ZERO,
> > -             .extra2         = &two,
> > +             .extra2         = SYSCTL_ONE,
> >   # endif
> >       },
> >   # ifdef CONFIG_HAVE_EBPF_JIT
> > diff --git a/tools/bpf/bpf_jit_disasm.c b/tools/bpf/bpf_jit_disasm.c
> > index c8ae95804728..efa4b17ae016 100644
> > --- a/tools/bpf/bpf_jit_disasm.c
> > +++ b/tools/bpf/bpf_jit_disasm.c
> > @@ -7,7 +7,7 @@
> >    *
> >    * To get the disassembly of the JIT code, do the following:
> >    *
> > - *  1) `echo 2 > /proc/sys/net/core/bpf_jit_enable`
> > + *  1) Insert bpf_jit_dump() and recompile the kernel to output JITed image into log
>
> Hmm, if we remove bpf_jit_dump(), the next drive-by cleanup patch will be thrown
> at bpf@vger stating that bpf_jit_dump() has no in-tree users and should be removed.
> Maybe we should be removing bpf_jit_disasm.c along with it as well as bpf_jit_dump()
> itself ... I guess if it's ever needed in those rare occasions for JIT debugging we
> can resurrect it from old kernels just locally. But yeah, bpftool's jit dump should
> suffice for vast majority of use cases.
>
> There was a recent set for ppc32 jit which was merged into ppc tree which will create
> a merge conflict with this one [0]. So we would need a rebase and take it maybe during
> merge win once the ppc32 landed..
>
>    [0] https://lore.kernel.org/bpf/cover.1616430991.git.christophe.leroy@csgroup.eu/
>
> >    *  2) Load a BPF filter (e.g. `tcpdump -p -n -s 0 -i eth1 host 192.168.20.0/24`)
> >    *  3) Run e.g. `bpf_jit_disasm -o` to read out the last JIT code
> >    *
> > diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> > index 40a88df275f9..98c7eec2923f 100644
> > --- a/tools/bpf/bpftool/feature.c
> > +++ b/tools/bpf/bpftool/feature.c
> > @@ -203,9 +203,6 @@ static void probe_jit_enable(void)
> >               case 1:
> >                       printf("JIT compiler is enabled\n");
> >                       break;
> > -             case 2:
> > -                     printf("JIT compiler is enabled with debugging traces in kernel logs\n");
> > -                     break;
>
> This would still need to be there for older kernels ...

I will submit another version after ppc32 landed to remove
bpf_jit_disasm.c and restore bpftool/feature.c

Jianlin


>
> >               case -1:
> >                       printf("Unable to retrieve JIT-compiler status\n");
> >                       break;
> >
>
