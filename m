Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6E4DF8D
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 06:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfFUEUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 00:20:11 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41808 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfFUEUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 00:20:10 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so5561647qtj.8;
        Thu, 20 Jun 2019 21:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NgSwGQEeHOudZ1qFUBe6TLCBMg+TinguYDiWjG0t+2w=;
        b=tAQKS6YJqLjw0go4KsJrGdDd3IXYTSE5r+N4qdf7VYjICLZTJMFWVF9zmnKz/mSQVc
         qgykd8RGUaKiQhdClcW2g1T8RXB7pZOpX8+GCQIHztI/G5TkzDPm/VRRRbuuqou2pLT8
         A8cCjyYG/GTn4gOOQCJmiIJVdSHUtgc6UhI5Z2BYlxiweTuUsRyiDAO4fxFXss3pypMP
         YDuh1ZaiqmND2SxgZh2jdKwvEkdY5+LqTnN9aBzyyxjeoJYWyED/eDUQDo2ZgTTuYkGo
         K7rtJD98tcRWJu9RbHN8gMwNr8VQCZ4yhiB1w9i4Aw1Oqn5UTBeq+eSksZX/jjj9l1xA
         HX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NgSwGQEeHOudZ1qFUBe6TLCBMg+TinguYDiWjG0t+2w=;
        b=mF2Ol6NvFVUHwN/zBRDkIOja0Blt2Bh3Q2QU6avF8hTObIJHOCIgZ3JmEinsU4b17R
         +HBsXA1b4QRhD3AzQbMVNhB++lgsyH4ouQ6Am1ojYhix3gu/FtFtGZLcUHPEL2fTBVei
         5+K/TnYCO7jpu1uTsEtLtv8REIeuWB3B9ywc2RLfotpNGQIHgRLWVZ4+Pt1D0Sro7Kgh
         TBmpK0zJ4Y2r2YGe1oLQATKsGjSOUaWIQEwC3HNQWDcLcOWri4JA+p2mzjQGXMr0QiIs
         zBhTQRp/+92WMFhx0OidxWTjTsVTUr0KqSOrAvuHCFLLRj4YULQpP7kkidwNcP1Y39VN
         HKvA==
X-Gm-Message-State: APjAAAWE9KAW0AI/qVOOsHaCSWdYy1fYYGTpuquC2tsSFstkir1p238P
        Q1sJJtyMYOAQggEV1p18kamyDo3tJoqmFfyUFUI=
X-Google-Smtp-Source: APXvYqyuetXcQ4NPV5oN7dX6OMuMswz/+X5g2CN+++RXswNt+JqKYxqC8oPPc/GfuuDp4E/LfQj+srUpOLf9qnvIqME=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr26208613qty.141.1561090809219;
 Thu, 20 Jun 2019 21:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190617192700.2313445-1-andriin@fb.com> <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
 <CAEf4Bzae1CPDkhPrESa2ZmiOH8Mqf0KA_4ty9z=xnYn=q7Frhw@mail.gmail.com> <CACAyw9-L0qx8d9O66SaYhJGjsyKo_6iozqLAQHEVa1AW-U=2Tg@mail.gmail.com>
In-Reply-To: <CACAyw9-L0qx8d9O66SaYhJGjsyKo_6iozqLAQHEVa1AW-U=2Tg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jun 2019 21:19:58 -0700
Message-ID: <CAEf4BzYaHG9Z_eFQCtwxA7t5GwQq2wr=AEeFWZpqx9vdQqKv1g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/11] BTF-defined BPF map definitions
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 7:49 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 18 Jun 2019 at 22:37, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > > I would just drop the object-scope pinning. We avoided using it and I'm not
> > > aware if anyone else make use. It also has the ugly side-effect that this
> > > relies on AF_ALG which e.g. on some cloud provider shipped kernels is disabled.
> > > The pinning attribute should be part of the standard set of map attributes for
> > > libbpf though as it's generally useful for networking applications.
> >
> > Sounds good. I'll do some more surveying of use cases inside FB to see
> > if anyone needs object-scope pinning, just to be sure we are not
> > short-cutting anyone.
>
> I'm also curious what the use cases for declarative pinning are. From my
> limited POV it doesn't seem that useful? There are a couple of factors:

Cilium is using it pretty extensively, so there are clearly use cases.
The most straigtforward use case is using a map created and shared by
another BPF program (to communicate, read stats, what have you).

>
> * Systemd mounts the default location only accessible to root, so I have to
>   used my own bpffs mount.
> * Since I don't want to hard code that, I put it in a config file.
> * After loading the ELF we pin maps from the daemon managing the XDP.

So mounting root would be specified per bpf_object, before maps are
created, so user-land driving application will have an opportunity to
tune everything. Declarative is only the per-map decision of whether
that map should be exposed to outer world (for sharing) or not.

>
> How do other people work around this? Hard coding it in the ELF seems
> suboptimal.
>
> > > And the loader should figure this out and combine everything in the background.
> > > Otherwise above 'struct inner_map_t value' would be mixing convention of using
> > > pointer vs non-pointer which may be even more confusing.
> >
> > There are two reasons I didn't want to go with that approach:
> >
> > 1. This syntax makes my_inner_map usable as a stand-alone map, while
> > it's purpose is to serve as a inner map prototype. While technically
> > it is ok to use my_inner_map as real map, it's kind of confusing and
> > feels unclean.
>
> I agree, avoiding this problem is good.
>
> > So we came up with a way to "encode" integer constants as part of BTF
> > type information, so that *all* declarative information is part of BTF
> > type, w/o the need to compile-time initialization. We tried to go the
> > other way (what Jakub was pushing for), but we couldn't figure out
> > anything that would work w/o more compiler hacks. So here's the
> > updated proposal:
> >
> > #define __int(name, val) int (*name)[val]
>
> Consider my mind blown: https://cdecl.org/?q=int+%28*foo%29%5B10%5D

Then check tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
for more crazy syntax ;)

typedef char * (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));


>
> > #define __type(name, val) val (*foo)
>
> Maybe it's enough to just hide the pointer-ness?
>
>   #define __member(name) (*name)
>   struct my_value __member(value);
>
> > struct my_inner_map {
> >         __int(type, BPF_MAP_TYPE_ARRAY);
> >         __int(max_entries, 1000);
> >         __type(key, int);
> >         __type(value, struct my_value);
>
> What if this did
>
>   __type(value, struct my_value)[1000];
>   struct my_value __member(value)[1000]; // alternative
>
> instead, and skipped max_entries?

I considered that, but decided for now to keep all those attributes
orthogonal for more flexibility and uniformity. This syntax might be
considered a nice "syntax sugar" and can be added in the future, if
necessary.

>
> > static struct {
> >         __int(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
> >         __int(max_entries, 1000);
> >         __type(key, int);
> >         __type(value, struct my_inner_map);
> >         struct my_inner_map *values[];
> > } my_initialized_outer_map SEC(".maps") = {
> >         .values = {
> >                 &imap1,
> >                 [500] = &imap2,
> >         },
> > };
> >
> > Here struct my_inner_map is complete definition of array map w/ 1000
> > elements w/ all the type info for k/v. That struct is used as a
> > template for my_outer_map map-in-map. my_initialized_outer_map is the
> > case of pre-initialization of array-of-maps w/ instances of existing
> > maps imap1 and imap2.
>
> For my_initialized_outer_map, which section does .values end up in the
> generated ELF? How much space is going to be allocated? 501 * 4 bytes?

Yes, if you want to pre-initialize it with values, you'll use
sizeof(void *) * max_entries ELF space.

>
> > The idea is that we encode integer fields as array dimensions + use
> > pointer to an array to save space. Given that syntax in plain C is a
> > bit ugly and hard to remember, we hide that behind __int macro. Then
> > in line with __int, we also have __type macro, that hides that hateful
> > pointer for key/value types. This allows map definition to be
> > self-describing w/o having to look at initialized ELF data section at
> > all, except for special cases of explicitly initializing map-in-map or
> > prog_array.
> >
> > What do you think?
>
> I think this is an interesting approach. One thing I'm not sure of is handling
> these types from C. For example:
>
>   sizeof(my_outer_map.value)
>
> This compiles, but doesn't produce the intended result. Correct would be:
>
>   sizeof(my_outer_map.value[0])
>
> At that point you have to understand that value is a pointer so all of
> our efforts
> are for naught. I suspect there is other weirdness like this, but I need to play
> with it a little bit more.

Yes, C can let you do crazy stuff, if you wish, but I think that
shouldn't be a blocker for this proposal. I haven't seen any BPF
program doing that, usually you duplicate the type of inner value
inside your function anyway, so there is no point in taking
sizeof(map.value) from BPF program side. From outside, though, all the
types will make sense, as expected.

>
> > Yeah I can definitely see some confusion here. But it seems like this
> > is more of a semantics of map sharing, and maybe it should be some
> > extra option for when we have automatic support for extern (shared)
> > maps. E.g., something like
> >
> > __int(sharing, SHARE_STRATEGY_MERGE) vs __int(sharing, SHARE_STRATEGY_OVERWRITE)
> >
> > Haven't though through exact syntax, naming, semantics, but it seems
> > doable to support both, depending on desired behavior.
> >
> > Maybe we should also unify this w/ pinning? E.g., there are many
> > sensible ways to handle already existing pinned map:
> >
> > 1. Reject program (e.g., if BPF application is the source of truth for that map)
> > 2. Use pinned as is (e.g., if BPF application wants to consume data
> > from source of truth app)
> > 3. Merge (what you described above)
> > 4. Replace/reset - not sure if useful/desirable.
>
> From my experience, trying to support many use cases in a purely declarative
> fashion ends up creating many edge cases, and quirky behaviour that is hard to
> fix later on. It's a bit like merging dictionaries in $LANGUAGE,
> which starts out simple and then gets complicated because sometimes you
> want to override a key, but lists should be concatenated, except in
> that one case...

I think if we can identify few robust common-sense strategies,
supporting them declaratively would eliminate 90% of need to writing
custom glue code for real-world use cases, so I think it's worth it.
For the rest, you'll have to do it in user-land app with custom glue
code. It's a non-goal to support any possible quirky way of sharing
maps declaratively.

>
> I wonder: are there many use cases where writing some glue code isn't
> possible? With libbpf getting more mature APIs that should become easier and
> easier. We could probably support existing iproute2 features that way as well.
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
