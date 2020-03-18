Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9B018A315
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 20:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCRTXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 15:23:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44570 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgCRTXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 15:23:54 -0400
Received: by mail-qt1-f194.google.com with SMTP id y24so2028984qtv.11;
        Wed, 18 Mar 2020 12:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/XUFJ47TgEfd7gXFPZdqLeMwDzm7Hbmi456QyDExcmE=;
        b=qG2t+6jgFDj0Su9sh6vlsbhCez8SyT+4ZpAikd9xTRHCDTvUkj3GKBoVuamT68yiat
         dRpC9JYAScI0VUqH9uopte2+phBsAhr9LgZpV/SWjayWRQyXgc5XtkmfqZPDbWsFuOXB
         U7LgCtryTRtmtR4Tg6gVm4hDAMiPXFpmu8MQeA52Jw1KlloyxS/AvpepHw+4a5IKniMc
         0h5ZhWTTPNVCdI8F5JaeMACp39Ztnl8Vtrn29yy+xo4TtcxkFjfo1wWWMZe8v6c3KCDM
         4L+9qR8zMS36rETP6e+z79V0FRBJ4f2DET5089+muLfy08XxxF3IyV2dtdIu1eMxW0O7
         92HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/XUFJ47TgEfd7gXFPZdqLeMwDzm7Hbmi456QyDExcmE=;
        b=I9Bix36/KMc1zg0UBQE9ysPgcSdG4dJhEkDEh6bZGE1UWTwOqnC4Wq0KnjJMq6fxQM
         GIS+7TwXHh/uPvd2MGI9/pjK8FSKXx5WMQ/a9NqtKkPfO5ghYU5ScIm/GIk0pzPkjjTL
         DryKNkgoFnt6iKw2soUKq0tktSkEv8U8AAny3AL95t0eEUsFnnsGdzQV7H5uy0WZN/T6
         LDy7xLOFQYTyDHbYhpgZ0YlLAfqYpBkllopW425/OeKeI90l6qLdkHzAQn1ikLC3HswC
         2OFXR9HG6h5YDRypRTX//NTl6QumIyIKX6T/xzuHVHlTLRImOz5DqGbdduTVvWWYqgqO
         +tHw==
X-Gm-Message-State: ANhLgQ37IZPKI13uW2cVeuFzk7HKYOtGMKTODMFeF8kum//6lOnMemFi
        DhA57Z2w0P8Aw1htewiaU1mYrzDkkuvcNj/V+HK2niioGFA=
X-Google-Smtp-Source: ADFU+vtKVGXIVJmKolh6XR9QVxnQCcIv9HQhglliOfkFXDdGfk4JS5FuDK8qC8n+xe8qXz3xTCYeWFO0Wyme6Ib4w+g=
X-Received: by 2002:ac8:4e14:: with SMTP id c20mr6086074qtw.141.1584559432693;
 Wed, 18 Mar 2020 12:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200317033701.w7jwos7mvfnde2t2@google.com> <CAEf4BzYyimAo2_513kW6hrDWwmzSDhNjTYksjy01ugKKTPt+qA@mail.gmail.com>
 <20200317052120.diawg3a75kxl5hkn@google.com> <CAEf4BzYepRs4uB9vd1SCFY81H5S1kbvw2n9bKNeh-ORK_kutSg@mail.gmail.com>
 <20200317054359.snyyojyf6gjxufij@google.com> <20200317162405.GB2459609@mini-arch.hsd1.ca.comcast.net>
 <20200317205832.lna5phig2ed3bf2n@google.com> <CAEf4BzY8uzcpS8t0JW70V-DrrZ4MbeXOyEtCrpTtQyHW+uQcRg@mail.gmail.com>
 <20200318175918.ulpzopsao4sm6aei@google.com> <CAEf4BzYBgG4dyhL7Bj21CU4HO9qpm_N7SZkQekTTK6pJBA1ZJA@mail.gmail.com>
 <20200318185323.nkn76zamx5zamtbs@google.com>
In-Reply-To: <20200318185323.nkn76zamx5zamtbs@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Mar 2020 12:23:41 -0700
Message-ID: <CAEf4BzYa1mavW10iusAf+W-OZ9C5WNUUNcHPoHz+vuuuiu=XOA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: Support llvm-objcopy and llvm-objdump
 for vmlinux BTF
To:     Fangrui Song <maskray@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 11:53 AM Fangrui Song <maskray@google.com> wrote:
>
> On 2020-03-18, Andrii Nakryiko wrote:
> >On Wed, Mar 18, 2020 at 10:59 AM Fangrui Song <maskray@google.com> wrote:
> >>
> >>
> >> On 2020-03-17, Andrii Nakryiko wrote:
> >> >On Tue, Mar 17, 2020 at 1:58 PM Fangrui Song <maskray@google.com> wrote:
> >> >>
> >> >>
> >> >> On 2020-03-17, Stanislav Fomichev wrote:
> >> >> >On 03/16, Fangrui Song wrote:
> >> >> >> On 2020-03-16, Andrii Nakryiko wrote:
> >> >> >> > On Mon, Mar 16, 2020 at 10:21 PM Fangrui Song <maskray@google.com> wrote:
> >> >> >> > >
> >> >> >> > >
> >> >> >> > > On 2020-03-16, Andrii Nakryiko wrote:
> >> >> >> > > >On Mon, Mar 16, 2020 at 8:37 PM Fangrui Song <maskray@google.com> wrote:
> >> >> >> > > >>
> >> >> >> > > >> On 2020-03-16, Andrii Nakryiko wrote:
> >> >> >> > > >> >On Mon, Mar 16, 2020 at 6:17 PM Fangrui Song <maskray@google.com> wrote:
> >> >> >> > > >> >>

[...]

> >> >> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> >> >> index dd484e92752e..c0d2ecf1bff7 100755
> >> >> --- a/scripts/link-vmlinux.sh
> >> >> +++ b/scripts/link-vmlinux.sh
> >> >> @@ -122,16 +122,12 @@ gen_btf()
> >> >>         vmlinux_link ${1}
> >> >>         LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> >> >>
> >> >> -       # dump .BTF section into raw binary file to link with final vmlinux
> >> >> -       bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
> >> >> -               cut -d, -f1 | cut -d' ' -f2)
> >> >> -       bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> >> >> -               awk '{print $4}')
> >> >> -       ${OBJCOPY} --change-section-address .BTF=0 \
> >> >> -               --set-section-flags .BTF=alloc -O binary \
> >> >> -               --only-section=.BTF ${1} .btf.vmlinux.bin
> >> >> -       ${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> >> >> -               --rename-section .data=.BTF .btf.vmlinux.bin ${2}
> >> >> +       # Extract .BTF, add SHF_ALLOC, rename to BTF so that we can reference
> >> >> +       # it via linker synthesized __start_BTF and __stop_BTF. Change e_type
> >> >> +       # to ET_REL so that it can be used to link final vmlinux.
> >> >> +       ${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
> >> >> +               --rename-section .BTF=BTF ${1} ${2} 2>/dev/null && \
> >> >
> >> >You can't just rename .BTF into BTF. ".BTF" is part of BTF
> >> >specification, tools like bpftool rely on that specific name. Libbpf
> >> >relies on this name as well. It cannot be changed. Please stop making
> >> >arbitrary changes and breaking stuff, please.
> >>
> >> I can't find anything which really assumes ".BTF" under tools/bpf/bpftool
> >
> >It's in libbpf, which bpftool uses to load and work with BTF. See
> >tools/lib/bpf/btf.{c,h}. And at this point there are other tools and
> >apps that rely on .BTF section, so there is absolutely no way we are
> >going to rename this, I'm sorry.
>
> Stanislav informed me of the same. Thanks for the reminder.

Good, glad we figured that out.

>
> >>
> >> % grep -r '\.BTF'
> >> Documentation/bpftool-btf.rst:            .BTF section with well-defined BTF binary format data,
> >>
> >> >
> >> >> +               printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
> >> >
> >> >I wonder if there is any less hacky and more obvious way to achieve this?..
> >>
> >> No. As a maintainer of lld/ELF, I abandoned https://reviews.llvm.org/D76174 .
> >> Also as a maintainer of LLVM binary utilities, I have to complain the whole
> >> scheme is really hacky and did not get enough scrutiny when they were merged.
> >>
> >> A previous comment said pahole somehow relied on llvm-objcopy so LLVM_OBJCOPY
> >> is used, while llvm-objcopy/llvm-objdump are not really supported...  Note, on
> >
> >pahole relies on llvm-objcopy internally to add/replace .BTF section.
> >Instead of doubting everything I'm saying, you could just have grepped
> >for 'llvm-objcopy' in pahole sources. It can be done differently, I'm
> >sure, but we'll need to support old versions of pahole anyways, so
> >LLVM_OBJCOPY=${OBJCOPY} parts stays, however confusing it might look.
> >
> >> March 16, I just pushed https://reviews.llvm.org/D76046 to make llvm-objdump
> >> print bfdnames to some part of the existing hacks happy...
> >>
> >> I am trying my best to make this stuff better.
> >> BTF, when merged into LLVM in December 2018, was not really the best example demonstrating how a subproject should be merged...
> >> OK, I'll stop complaining here.
> >
> >We should make sure that we are not making it worse first, don't you
> >agree? I think it's more important, because there are many happy users
> >already and breaking them is not an option. It's v5 of your patch and
> >every single revision is broken, so I'm not sure you are the one to
> >complain here. The least you can do to test this is to build kernel
> >with BTF and run selftests/bpf, not just throw your patch out in hopes
> >that others will point out all the issues.
>
> I am late to the party. I am sorry that it has been v5 of my patch.
> There are plenty of my own reasons: I am a kernel newbie.  So I
> apologize for that. Though, it should still be brought up that the
> various previous fixes touching this area suggest that the whole scheme
> makes any adjustment really really difficult.

It certainly is tricky, no doubt about that. But coming in changing
things drastically without understanding all the consequences and no
proper testing (and building kernel is not proper testing), is not a
great approach. And in addition to that complaining how everything is
terrible, even though it's been working fine for quite some time for a
lot of use cases (even if it doesn't work for llvm-objcopy) :)

Anyways, let's stick to more productive approach. There are really two
hard requirements, as far as I'm concerned: .BTF section name and that
section being allocatable, so that kernel can use that data in
runtime. Everything else is pretty flexible.

>
> There are many subtle things affecting the best strategy here:
>
> * Before GNU ld 2.23 (more precisely, commit d9476c5a34043d72dd855cb03d124d4052b190ce),
>    __start_foo has the st_shndx field of SHN_ABS. arch/x86/tools/relocs.c
>    can be paranoid and reject it.
> * Before GNU objcopy 2.25, --dump-section was not available.
> * llvm-objdump<11 does not print bfdnames. I fixed it just a few days ago.
> * GNU objcopy<2.34 required useless -B for -I binary: https://sourceware.org/bugzilla/show_bug.cgi?id=24968
> * GNU ld makes use of an error-prone feature: linkable ET_EXEC. I rejected it as an lld feature a few days ago.
> * We need PROVIDE in lld to avoid unnecessary symbols, or we can use #ifdef CONFIG_DEBUG_INFO_BTF
> * ...
>
> An experienced kernel developer who does not play enoguh linker scripts
> and objcopy commands may not do better than I do.

I agree completely. My concern was with attitude of making changes and
just building kernel to verify everything still works. BTF is a
critical piece in many applications, tools and various kernel
features, so running selftests/bpf (test_progs and test_verifier would
be the minimum) is mandatory to ensure stuff still works.

>
>
> >>
> >> commit cb0cc635c7a9fa8a3a0f75d4d896721819c63add "powerpc: Include .BTF section"
> >> places .BTF somewhere in the writable section area, so if you insist on ".BTF",
> >> I'll make a similar change and add some stuff to arch/x86/kernel/vmlinux.lds.S
> >>
> >> >Also, this script has `set -e` at the top, so you don't have to chain
> >> >all command with &&, you put this on separate line with the same
> >> >effect, but it will look less confusing.
> >>
> >> Not using section "BTF" has the downside that we have to add
> >>
> >> .BTF : {
> >>    PROVIDE(__start_BTF = .);
> >>    *(.BTF)
> >>    PROVIDE(__stop_BTF = .);
> >> }
> >>
> >> to every arch/*/kernel/vmlinux.lds.S which can use BTF.
> >
> >It doesn't look all that terrible, so why not, I guess? But just
> >curious, why this is not required for "BTF", but required for ".BTF"?
> >Not very familiar with linker scripts setup in kernel.
>
> If every extension needing a section adds an output section description
> to vmlinux.lds.S, the linker script will be pretty much unmanageable.
>
> Note also that arch/powerpc/kernel/vmlinux.lds.S places .BTF in an
> undesired area (writable). We will fix it later.
>
> If a section name is a valid C identifier (not precisely, for example,
> Unicode is not really supported) will have magic __start_foo __stop_foo
> defined.

Yeah, so that's what I was curious about. But anyways, it has to be
.BTF, so maybe adding special instructions for .BTF isn't such a big
deal. Not sure what others think.

>
> _binary_* was never used before BTF added them.
>

__binary_* symbols are the ones produced by objcopy automatically, so
that's what was used initially. If we need to change that, it's not a
problem, because it's internal to kernel itself.

> >>
> >> >>   }
> >> >>
> >> >>   # Create ${2} .o file with all symbols from the ${1} object file
> >> >> --
> >> >> 2.25.1.481.gfbce0eb801-goog
> >> >>
>
> I am preparing a v6 and I need to take all the stuff into account.

Sure, just make sure to run selftest, thanks!
