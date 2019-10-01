Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215A8C4454
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfJAXbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:31:40 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42807 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbfJAXbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:31:40 -0400
Received: by mail-qk1-f196.google.com with SMTP id f16so13062547qkl.9;
        Tue, 01 Oct 2019 16:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=opvvCq7FyGEOZEZOSA0Xxs8MF/6oz/KDHXows+LTOOI=;
        b=LSYttXi3sDIHWa+q0NxYqDdubONtIlOcXfr48SaENw3mOEELNVeW2+gwvoT8gPhVh9
         IjHLXHNfw83QXxDwQGVRQOixztexC87ZzLGs8vcmvH3jXLm6byqUHD6Ol2H115NeTA2k
         G3/d/N//5Kggc6jlo3gnT3LEu9oUimjEvlj/cbEHG9HHZzoUoV8PZ66Uzdmhopi1bO3b
         iQQiuBLst3jjmTkM2OaSlJreGqNvpYV1Mg4cWfaCc/ROMRSnWhRo3DbKyRna0ny254EQ
         9enYrB7zu4upks+3XF7S5uOgE1+YOuvb9K90SK1o2BgwuQbDqyYezUPPaVEE4xhoAP1q
         dg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=opvvCq7FyGEOZEZOSA0Xxs8MF/6oz/KDHXows+LTOOI=;
        b=nO4dFPCw1/YtXlw45aUWIAZk5yPDiepEgHgeFrvsk/UD5dQMqTQ5S+3kt/Xf7kxqwS
         AW3pTY7f9P5KwUztQy2+9uPE9da5rShUFGs1zJ79xcdRfkh8SfjkCkjL3Ed9JEV8aHXx
         2HDrqzc9SV6Iu59iirMkvhIjj0QFJHixKGpnk5YyW5FpEXjbusCzdO7LZicgqbozf4oT
         PoG/khDM7Tfs+eAQs3s1q+pnXosmV26btLNk1vIXaWflEkYXIsTYG3wPUZrZ5kQG18Ui
         0ChNJH8DbmNe4PeuD2aBiIw5g8m2SuXm7kIOnTAs7sy0/y+FgaRJpOb/hfjSYeig1BNX
         chLw==
X-Gm-Message-State: APjAAAU/3xOxcUcR72kLFHcTptzZzBwaPKaOazVlt1uelpRq478CDL8L
        Ks27gcC/HnqzArcHkvfQreg96FUJh8t8ZYaTVRjVGoTO
X-Google-Smtp-Source: APXvYqyt/GlPpaipE4GD8rbnb0CzNbOc0GPk+GHiP8iF3RauWFEooYdwjU8bZwrBtRjk0JKOpfQo540zFmXNCpXJFOA=
X-Received: by 2002:a37:9fcd:: with SMTP id i196mr848014qke.92.1569972698919;
 Tue, 01 Oct 2019 16:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
 <20191001224535.GB10044@pc-63.home>
In-Reply-To: <20191001224535.GB10044@pc-63.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 16:31:27 -0700
Message-ID: <CAEf4BzZQ=NNK42yOu7_H+yuqZ_1npBxDaTuQwsrmJoQUiMfd7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 3:45 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Mon, Sep 30, 2019 at 11:58:51AM -0700, Andrii Nakryiko wrote:
> > Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> > are installed along the other libbpf headers.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> [...]
> > new file mode 100644
> > index 000000000000..fbe28008450f
> > --- /dev/null
> > +++ b/tools/lib/bpf/bpf_endian.h
> > @@ -0,0 +1,72 @@
> > +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> > +#ifndef __BPF_ENDIAN__
> > +#define __BPF_ENDIAN__
> > +

[...]

> > +#define bpf_cpu_to_be64(x)                   \
> > +     (__builtin_constant_p(x) ?              \
> > +      __bpf_constant_cpu_to_be64(x) : __bpf_cpu_to_be64(x))
> > +#define bpf_be64_to_cpu(x)                   \
> > +     (__builtin_constant_p(x) ?              \
> > +      __bpf_constant_be64_to_cpu(x) : __bpf_be64_to_cpu(x))
>
> Nit: if we move this into a public API for libbpf, we should probably
> also define for sake of consistency a bpf_cpu_to_be{64,32,16}() and
> bpf_be{64,32,16}_to_cpu() and have the latter two point to the existing
> bpf_hton{l,s}() and bpf_ntoh{l,s}() macros.

I think these deserve better tests before we add more stuff, both from
BPF-side and userland-side (as they are supposed to be includeable
from both, right)? I'm hesitant adding new unfamiliar macro/builtins
without tests, but I don't want to get distracted with that right now,
especially this patch set already becomes bigger than I'd hope.

Given we are talking about adding new stuff which is not breaking
change, we can add it later after we move this as is, agree?

>
> > +#endif /* __BPF_ENDIAN__ */
>
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > new file mode 100644
> > index 000000000000..a1d9b97b8e15
> > --- /dev/null
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -0,0 +1,527 @@
> > +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> > +#ifndef __BPF_HELPERS__
> > +#define __BPF_HELPERS__
> > +
> > +#define __uint(name, val) int (*name)[val]
> > +#define __type(name, val) val *name
> > +
> > +/* helper macro to print out debug messages */
> > +#define bpf_printk(fmt, ...)                         \
> > +({                                                   \
> > +     char ____fmt[] = fmt;                           \
> > +     bpf_trace_printk(____fmt, sizeof(____fmt),      \
> > +                      ##__VA_ARGS__);                \
> > +})
>
> Did you double check if by now via .rodata we can have the fmt as
> const char * and add __attribute__ ((format (printf, 1, 2))) to it?
> If that works we should avoid having to copy the string as above in
> the API.

This doesn't work still, unfortunately. Eventually, though, we'll be
able to essentially nop it out with direct call to bpf_trace_printk,
so I'm not concerned about future API burden.

>
> > +/* helper macro to place programs, maps, license in
> > + * different sections in elf_bpf file. Section names
> > + * are interpreted by elf_bpf loader
> > + */
> > +#define SEC(NAME) __attribute__((section(NAME), used))
> > +
> > +/* helper functions called from eBPF programs written in C */
>
> As mentioned earlier, the whole helper function description below
> should get a big cleanup in here when moved into libbpf API.

Right, I just recalled that today, sorry I didn't do it for this version.

There were two things you mentioned on that thread that you wanted to clean up:
1. using __u32 instead int and stuff like that
2. using macro to hide some of the ugliness of (void *) = BPF_FUNC_xxx

So with 1) I'm concerned that we can't just assume that __u32 is
always going to be defined. Also we need bpf_helpers.h to be usable
both with including system headers, as well as auto-generated
vmlinux.h. In first case, I don't think we can assume that typedef is
always defined, in latter case we can't really define it on our own.
So I think we should just keep it as int, unsigned long long, etc.
Thoughts?

For 2), I'm doing that right now, but it's not that much cleaner, let's see.

Am I missing something else?

>
> > +static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
> > +     (void *) BPF_FUNC_map_lookup_elem;
> > +static int (*bpf_map_update_elem)(void *map, const void *key, const void *value,
> > +                               unsigned long long flags) =
> [...]
> > +
> > +/* llvm builtin functions that eBPF C program may use to
> > + * emit BPF_LD_ABS and BPF_LD_IND instructions
> > + */
> > +struct sk_buff;
> > +unsigned long long load_byte(void *skb,
> > +                          unsigned long long off) asm("llvm.bpf.load.byte");
> > +unsigned long long load_half(void *skb,
> > +                          unsigned long long off) asm("llvm.bpf.load.half");
> > +unsigned long long load_word(void *skb,
> > +                          unsigned long long off) asm("llvm.bpf.load.word");
>
> These should be removed from the public API, no point in adding legacy/
> deprecated stuff in there.

Oh, cool, never knew what that stuff is anyway :)

>
> > +/* a helper structure used by eBPF C program
> > + * to describe map attributes to elf_bpf loader
> > + */
> > +struct bpf_map_def {
> > +     unsigned int type;
> > +     unsigned int key_size;
> > +     unsigned int value_size;
> > +     unsigned int max_entries;
> > +     unsigned int map_flags;
> > +     unsigned int inner_map_idx;
> > +     unsigned int numa_node;
> > +};
> > +
> > +#define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)               \
> > +     struct ____btf_map_##name {                             \
> > +             type_key key;                                   \
> > +             type_val value;                                 \
> > +     };                                                      \
> > +     struct ____btf_map_##name                               \
> > +     __attribute__ ((section(".maps." #name), used))         \
> > +             ____btf_map_##name = { }
>
> Same here.

We still use it in few selftests, I'll move it into selftests-only header.

>
> > +static int (*bpf_skb_load_bytes)(void *ctx, int off, void *to, int len) =
> > +     (void *) BPF_FUNC_skb_load_bytes;
> [...]
>
> Given we already move bpf_endian.h to a separate header, I'd do the
> same for all tracing specifics as well, e.g. bpf_tracing.h.

You mean all the stuff below, right? I'll extract it into separate
header, no problem.

What about CO-RE stuff. It's not strictly for tracing, so does it make
sense to keep it here?

>
> > +/* Scan the ARCH passed in from ARCH env variable (see Makefile) */
> > +#if defined(__TARGET_ARCH_x86)
> > +     #define bpf_target_x86
> > +     #define bpf_target_defined
> > +#elif defined(__TARGET_ARCH_s390)

[...]

> > --
> > 2.17.1
> >
