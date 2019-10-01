Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8E6C42A6
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfJAVZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:25:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36648 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbfJAVZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:25:35 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so12814188qkc.3;
        Tue, 01 Oct 2019 14:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fLgYqpzYgoP08/vk5we7GIRfpP2xhs4jo+5oERIw0Zc=;
        b=FF3eKc/CG/DROX21/gTsGHzGsyeQ4BWgV8+dheL35FF7FRcPEM0Y7okDiHetYP1t4n
         Ed7hmM4gDF6wljL2LXbpQn6Wz/FOfEoNIXYgAentENVt+84vwc/GwzYYqpgCSpf9FA4P
         QyrfvG8eBaRMcG015Tua6G6BHRyhxBmOcziQ6ZKSSYGqOmCvdDDnri7QnsA0lco6Revl
         j+OTsR0c31lyUXxyWBfF775IzNNaW1U2OYvv2rBsWKGk7CEUDI46uAP+xwBuT2KkFNNT
         BMitagG+OmTAjbKGXUHXZKxn3Zlrdkq4LOAiihTv4BT1GfEJr/x1HTWn4vlyjijQgDK0
         razA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fLgYqpzYgoP08/vk5we7GIRfpP2xhs4jo+5oERIw0Zc=;
        b=DCIt2JHliEvUPAGOz2e+LQoQDTEjuec7JxbispuaolhSUVEB/7oCuElt/PA3kmEMEK
         WDV2ZF6dvRXTQnUTjN/hpp2TjomcHcMzHIw97ya7YMFjCCYK6KVauafotvBilsSTA0jc
         Rub2OD3SnMhFTlpdh9s4wuul2H7ffGKYdIvAL3V627AznetBYnBdZPnEETiJZZuJCZH3
         9RqEMi+HtaKvcCTS53hDORzBM1V/Bp+n+5dENprE9xKg8rnJcfXtAVfAKkX29/f4dRsP
         4bEsxW4nx9ieBh361xbReXKGB1Ap2PngNDJGYlCySZ28NqvBOHvzAA3rHY58zq0+1rkW
         Eu4g==
X-Gm-Message-State: APjAAAX6Kk9vfxLArDhrfYcybCxCui596dTCt3XfmIGM2x9kGkk3IEWc
        Ec1ILUBYK0CAsracldc5taiGq50CGJBc2B2MKVs=
X-Google-Smtp-Source: APXvYqyMnW2Av9FwbJKNDdEcTOGu52FPOG6INFeae1XlGmIANURyu6fL1E1PXKdaY6Gass+qIrNXWm8PPtC/ba1N4h4=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr223089qkk.39.1569965134104;
 Tue, 01 Oct 2019 14:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-5-andriin@fb.com>
 <346DCE18-FA64-40CA-86BD-C095935AC089@fb.com>
In-Reply-To: <346DCE18-FA64-40CA-86BD-C095935AC089@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 14:25:22 -0700
Message-ID: <CAEf4BzYyh8TTtw1F+F0zw9ksCqGKFogfAgwK+_CEZ25ASoarVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO helpers
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 2:14 PM Song Liu <songliubraving@fb.com> wrote:
>
>
> > On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add few macros simplifying BCC-like multi-level probe reads, while also
> > emitting CO-RE relocations for each read.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/bpf_helpers.h | 151 +++++++++++++++++++++++++++++++++++-
> > 1 file changed, 147 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index a1d9b97b8e15..51e7b11d53e8 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -19,6 +19,10 @@
> >  */
> > #define SEC(NAME) __attribute__((section(NAME), used))
> >
> > +#ifndef __always_inline
> > +#define __always_inline __attribute__((always_inline))
> > +#endif
> > +
> > /* helper functions called from eBPF programs written in C */
> > static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
> >       (void *) BPF_FUNC_map_lookup_elem;
> > @@ -505,7 +509,7 @@ struct pt_regs;
> > #endif
> >
> > /*
> > - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> > + * bpf_core_read() abstracts away bpf_probe_read() call and captures field
> >  * relocation for source address using __builtin_preserve_access_index()
> >  * built-in, provided by Clang.
> >  *
> > @@ -520,8 +524,147 @@ struct pt_regs;
> >  * actual field offset, based on target kernel BTF type that matches original
> >  * (local) BTF, used to record relocation.
> >  */
> > -#define BPF_CORE_READ(dst, src)                                              \
> > -     bpf_probe_read((dst), sizeof(*(src)),                           \
> > -                    __builtin_preserve_access_index(src))
> > +#define bpf_core_read(dst, sz, src)                                      \
> > +     bpf_probe_read(dst, sz,                                             \
> > +                    (const void *)__builtin_preserve_access_index(src))
> > +
> > +/*
> > + * bpf_core_read_str() is a thin wrapper around bpf_probe_read_str()
> > + * additionally emitting BPF CO-RE field relocation for specified source
> > + * argument.
> > + */
> > +#define bpf_core_read_str(dst, sz, src)                                          \
> > +     bpf_probe_read_str(dst, sz,                                         \
> > +                        (const void *)__builtin_preserve_access_index(src))
> > +
> > +#define ___concat(a, b) a ## b
> > +#define ___apply(fn, n) ___concat(fn, n)
> > +#define ___nth(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, __11, N, ...) N
>
> We are adding many marcos with simple names: ___apply(), ___nth. So I worry
> they may conflict with macro definitions from other libraries. Shall we hide
> them in .c files or prefix/postfix them with _libbpf or something?

Keep in mind, this is the header that's included from BPF code.

They are prefixed with three underscores, I was hoping it's good
enough to avoid accidental conflicts. It's unlikely someone will have
macros with the same names **in BPF-side code**.
Prefixing with _libbpf is an option, but it will make it super ugly
and hard to follow (I've spent a bunch of time to even get it to the
current state), so I'd like to avoid that.

>
> Thanks,
> Song
>
