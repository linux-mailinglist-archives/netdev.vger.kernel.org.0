Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C82ACC41B
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 22:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbfJDUWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 16:22:10 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43484 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729079AbfJDUWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 16:22:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id c3so10256555qtv.10;
        Fri, 04 Oct 2019 13:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JC3ma0OKEnyMNv3UP8MGEvLAd5BJ0FUC4qhbqMtGUro=;
        b=HGW/3IDyWUn0UvOy4alk5b3TZylZsQpnY3XvMEAzDIDjidccbWnAexqeKRCbKyRUOj
         a52GFKAAT1EQcjrVaScFv4ftpaaAONY9Z67+AJmmkWnbYFFFjD9735M/L1LB9YqE2MOS
         z5L9vkyNg+qb8B5/TdwaKOYgs0lqdN0bpLiyFVc5d6Z2Dg60vkuOlsogwCnGUFP9y1Bc
         6gT594KMbIjMHdhibmWBU3vE0er5B8JJ4dHv76ariXjQ+ZD1sF3bTMGRjO9w+DjZDJc2
         MDsEwObgrYC6D2Oop5r7x2lGzA1G6LDO584+5FTsHkE00Dtcq5cunkD3nYGiiJynGYKQ
         FgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JC3ma0OKEnyMNv3UP8MGEvLAd5BJ0FUC4qhbqMtGUro=;
        b=DpCF52/YIPJok8bMcGjRF+n5CJVXRIDeG7B5FjDdA6lCuHNYUkPSOdnylXor3soGKk
         L74vZrmel70BA7IWyJoPd88LmFHfu8xTgTXZbpv4b3l3lUkYfYYdcS4TIdVMgQP3MKS/
         byY7eN+V2NE6Cr/5NfUZ2FeDAUJAtzrhwwgM0ATfmGKf/oqD2eim/Z6lvPcZDaMt17zd
         ox3U9om6BTGvQJoKsS1tIiV2F/N5MMc3+oLjErm1OLInhj37Cy8e1oj4LMqFutHkwPLV
         fS/KaaNGzvOAqu9rLWdygCMZNxtpjIkfH9DhA9LFuM7091qVbNX+VE2s+Jenkk5BzN2o
         2FUA==
X-Gm-Message-State: APjAAAXm35bGd4tqSfOL8tGj+Nez46M/x44WxumbZsHwuPsHpI55K60b
        1nwQcGzhlnGzmcfPiJORQxA5oO0pZuQNr3r5mH4=
X-Google-Smtp-Source: APXvYqz7vFZy4XyjgvvkjzQHqwKTt4Qx230iN6Y8wy8vXHygCVMoloonHL8W9K+ThfmPBkheaCDhL7CC7Y9LsaRRqns=
X-Received: by 2002:a05:6214:1401:: with SMTP id n1mr16114017qvx.196.1570220526547;
 Fri, 04 Oct 2019 13:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-6-andriin@fb.com>
 <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com> <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
 <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com> <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
 <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 13:21:55 -0700
Message-ID: <CAEf4Bzbw-=NSKMYpDcTY1Pw9NfeRJ5+KpScWg4wHfoDG18dKPQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move bpf_{helpers,endian,tracing}.h
 into libbpf
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Ahern <dsahern@gmail.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 11:30 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 4 Oct 2019 09:00:42 -0700, Andrii Nakryiko wrote:
> > On Fri, Oct 4, 2019 at 8:44 AM David Ahern <dsahern@gmail.com> wrote:
> >> > I'm not following you; my interpretation of your comment seems like you
> > > are making huge assumptions.
> > >
> > > I build bpf programs for specific kernel versions using the devel
> > > packages for the specific kernel of interest.
> >
> > Sure, and you can keep doing that, just don't include bpf_helpers.h?
> >
> > What I was saying, though, especially having in mind tracing BPF
> > programs that need to inspect kernel structures, is that it's quite
> > impractical to have to build many different versions of BPF programs
> > for each supported kernel version and distribute them in binary form.
> > So people usually use BCC and do compilation on-the-fly using BCC's
> > embedded Clang.
> >
> > BPF CO-RE is providing an alternative, which will allow to pre-compile
> > your program once for many different kernels you might be running your
> > program on. There is tooling that eliminates the need for system
> > headers. Instead we pre-generate a single vmlinux.h header with all
> > the types/enums/etc, that are then used w/ BPF CO-RE to build portable
> > BPF programs capable of working on multiple kernel versions.
> >
> > So what I was pointing out there was that this vmlinux.h would be
> > ideally generated from latest kernel and not having latest
> > BPF_FUNC_xxx shouldn't be a problem. But see below about situation
> > being worse.
>
> Surely for distroes tho - they would have kernel headers matching the
> kernel release they ship. If parts of libbpf from GH only work with
> the latest kernel, distroes should ship libbpf from the kernel source,
> rather than GH.
>
> > > > Nevertheless, it is a problem and thanks for bringing it up! I'd say
> > > > for now we should still go ahead with this move and try to solve with
> > > > issue once bpf_helpers.h is in libbpf. If bpf_helpers.h doesn't work
> > > > for someone, it's no worse than it is today when users don't have
> > > > bpf_helpers.h at all.
> > > >
> > >
> > > If this syncs to the github libbpf, it will be worse than today in the
> > > sense of compile failures if someone's header file ordering picks
> > > libbpf's bpf_helpers.h over whatever they are using today.
> >
> > Today bpf_helpers.h don't exist for users or am I missing something?
> > bpf_helpers.h right now are purely for selftests. But they are really
> > useful outside that context, so I'm making it available for everyone
> > by distributing with libbpf sources. If bpf_helpers.h doesn't work for
> > some specific use case, just don't use it (yet?).
> >
> > I'm still failing to see how it's worse than situation today.
>
> Having a header which works today, but may not work tomorrow is going
> to be pretty bad user experience :( No matter how many warnings you put
> in the source people will get caught off guard by this :(
>
> If you define the current state as "users can use all features of
> libbpf and nothing should break on libbpf update" (which is in my
> understanding a goal of the project, we bent over backwards trying
> to not break things) then adding this header will in fact make things
> worse. The statement in quotes would no longer be true, no?

So there are few things here.

1. About "adding bpf_helpers.h will make things worse". I
categorically disagree, bpf_helpers.h doesn't exist in user land at
all and it's sorely missing. So adding it is strictly better
experience already. Right now people have to re-declare those helper
signatures and do all kinds of unnecessary hackery just to be able to
use BPF stuff, and they still can run into the same problem with
having too old kernel headers.

Also, I think we should have informal notion of "experimental"
features and APIs which we add to get real-world experience of using
it, before we crystalize it to something that we have to maintain
backwards compatibility and never-breaking user experience for. Its
sometimes impossible to finesse all the tiny issues before we get
prolonged enough experience w/ real applications in a real set up. If
we are going to wait to resolve all the tiny possible problems, we'll
cripple outselves very significantly. I think bpf_helpers.h move walls
into this "experimental" thing, which we obviously will try to
"stabilize" ASAP, but we need it to be part of libbpf first to start
using it in production. So in that sense it's a huge improvement
already and I think we should land it as is and keep improving it, not
stall progress right now.

2. As to the problem of running bleeding-edge libbpf against older
kernel. There are few possible solutions:

a. we hard-code all those BPF_FUNC_ constants. Super painful and not
nice, but will work.

b. copy/paste enum bpf_func_id definition into bpf_helpers.h itself
and try to keep it in sync with UAPI. Apart from obvious redundancy
that involves, we also will need to make sure this doesn't conflict
with vmlinux.h, so enum name should be different and each value should
be different (which means some wort of additional prefix or suffix).

c. BPF UAPI header has __BPF_FUNC_MAPPER macro "iterating" over all
defined values for a particular kernel version. We can use that and
additional macro trickery to conditionally define helpers. Again, we
need to keep in mind that w/ vmlinux.h there is no such macro, so this
should work as well.

I'm happy to hear opinions about these choices (maybe there are some
other I missed), but in any case I'd like to do it in a follow up
patch and land this one as is. It has already quite a lot packed in
it. I personally lean towards c) as it will have a benefit of not
declaring helpers that are not supported by kernel we are compiling
against, even though it requires additional macro trickery.

Opinions?
