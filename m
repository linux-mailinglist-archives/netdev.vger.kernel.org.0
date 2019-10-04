Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A141CC614
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbfJDWrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:47:41 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45785 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDWrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 18:47:41 -0400
Received: by mail-qk1-f196.google.com with SMTP id z67so7291525qkb.12;
        Fri, 04 Oct 2019 15:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dB4Pchx9uNq9uUtVaAPJB/6CFXRgdMN8QebXE1OPgBU=;
        b=sviOgCf1A0tRx8GWpr5lLvE26ul5lzOelntql2+rvGNJXXPdpuKegM+Mc5+AlnMDs8
         WkAAs9cYM+MxcwgFFzHNwR610VK9wyB4pUoxXLKvjWCf6+stC6vACZMly7NtEgvQKRPM
         Laf6YwZ6AMKcE1JavwACv53F6hL0zOoyfWBNLMHaYzlSoP9vcfyG+7TMYmY/W4dezoak
         hrt+l5sE+S6RcPdXp1MN086UVerOJcSBQ9HRoZ+7STtEH7sMOkP0xPBWj+6G7xOY05ZO
         jBMloATB3a1eNNSQbsq8JLNalEQ4HeFjYf5V6nxpCOl2ytaUsPi1gUEilj0cvWpMXctD
         dLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dB4Pchx9uNq9uUtVaAPJB/6CFXRgdMN8QebXE1OPgBU=;
        b=dYhR426U0A6LTvzV+T0X+sZFuCCmOyYuo+BXvwI4e5yPUXwQ6tNr1TlZXpHG1ht+ll
         WOlZ6H3aSvEpbPK3YjH9CWU72eAaE4SO6l4J5xNzUMrfjFLCcpzxQs0urUalP7l9obzW
         pnnJlDOTDS/anvoPa1/lOpLtDILA8uW1UzNto7s16sGPbGOfsFvibsy0JzUGpZKlKSCh
         ZvdvjBXwkPvEvNRICcWBLo0BO0TTNFFVfZcWMVU7pjYgj/uP4D6x/1r+t70XXY4tIFHZ
         0jH7o5y0l2gLJcUBwrooMMHBbEUAb2QbW/38cJbWo5CJ1y0qrSC1lP3b8Wb65DDreswZ
         cx9w==
X-Gm-Message-State: APjAAAWTOXa59QI5DH3HAVev2MM1tZblraX3Gzdjb5AU4uCNC2yXpUeI
        9hS1M0rckFOuVGGChMecVysPXvDX4WDesimuOAg=
X-Google-Smtp-Source: APXvYqz2d2uODD+U577s2Uc3ZBIwoZhjMYAt52osaU7Mu+7ldx0Dcg+n9SdZPAppBLn3ccFlx4Fo07V0AKvg8zz4bCM=
X-Received: by 2002:a37:98f:: with SMTP id 137mr13200262qkj.449.1570229259700;
 Fri, 04 Oct 2019 15:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-6-andriin@fb.com>
 <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com> <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
 <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com> <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
 <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net> <CAEf4Bzbw-=NSKMYpDcTY1Pw9NfeRJ5+KpScWg4wHfoDG18dKPQ@mail.gmail.com>
 <20191004210613.GA27307@pc-66.home> <20191004215809.GB27307@pc-66.home>
In-Reply-To: <20191004215809.GB27307@pc-66.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 15:47:28 -0700
Message-ID: <CAEf4BzZa5t9=2JZ-r1y01Dhp_a_ERSDiurbp6XcO-1ubyNcnnQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move bpf_{helpers,endian,tracing}.h
 into libbpf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 2:58 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Fri, Oct 04, 2019 at 11:06:13PM +0200, Daniel Borkmann wrote:
> > On Fri, Oct 04, 2019 at 01:21:55PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Oct 4, 2019 at 11:30 AM Jakub Kicinski
> > > <jakub.kicinski@netronome.com> wrote:
> > > > On Fri, 4 Oct 2019 09:00:42 -0700, Andrii Nakryiko wrote:
> > > > > On Fri, Oct 4, 2019 at 8:44 AM David Ahern <dsahern@gmail.com> wrote:
> > > > >> > I'm not following you; my interpretation of your comment seems like you
> > > > > > are making huge assumptions.
> > > > > >
> > > > > > I build bpf programs for specific kernel versions using the devel
> > > > > > packages for the specific kernel of interest.
> > > > >
> > > > > Sure, and you can keep doing that, just don't include bpf_helpers.h?
> > > > >
> > > > > What I was saying, though, especially having in mind tracing BPF
> > > > > programs that need to inspect kernel structures, is that it's quite
> > > > > impractical to have to build many different versions of BPF programs
> > > > > for each supported kernel version and distribute them in binary form.
> > > > > So people usually use BCC and do compilation on-the-fly using BCC's
> > > > > embedded Clang.
> > > > >
> > > > > BPF CO-RE is providing an alternative, which will allow to pre-compile
> > > > > your program once for many different kernels you might be running your
> > > > > program on. There is tooling that eliminates the need for system
> > > > > headers. Instead we pre-generate a single vmlinux.h header with all
> > > > > the types/enums/etc, that are then used w/ BPF CO-RE to build portable
> > > > > BPF programs capable of working on multiple kernel versions.
> > > > >
> > > > > So what I was pointing out there was that this vmlinux.h would be
> > > > > ideally generated from latest kernel and not having latest
> > > > > BPF_FUNC_xxx shouldn't be a problem. But see below about situation
> > > > > being worse.
> > > >
> > > > Surely for distroes tho - they would have kernel headers matching the
> > > > kernel release they ship. If parts of libbpf from GH only work with
> > > > the latest kernel, distroes should ship libbpf from the kernel source,
> > > > rather than GH.
> > > >
> > > > > > > Nevertheless, it is a problem and thanks for bringing it up! I'd say
> > > > > > > for now we should still go ahead with this move and try to solve with
> > > > > > > issue once bpf_helpers.h is in libbpf. If bpf_helpers.h doesn't work
> > > > > > > for someone, it's no worse than it is today when users don't have
> > > > > > > bpf_helpers.h at all.
> > > > > > >
> > > > > >
> > > > > > If this syncs to the github libbpf, it will be worse than today in the
> > > > > > sense of compile failures if someone's header file ordering picks
> > > > > > libbpf's bpf_helpers.h over whatever they are using today.
> > > > >
> > > > > Today bpf_helpers.h don't exist for users or am I missing something?
> > > > > bpf_helpers.h right now are purely for selftests. But they are really
> > > > > useful outside that context, so I'm making it available for everyone
> > > > > by distributing with libbpf sources. If bpf_helpers.h doesn't work for
> > > > > some specific use case, just don't use it (yet?).
> > > > >
> > > > > I'm still failing to see how it's worse than situation today.
> > > >
> > > > Having a header which works today, but may not work tomorrow is going
> > > > to be pretty bad user experience :( No matter how many warnings you put
> > > > in the source people will get caught off guard by this :(
> > > >
> > > > If you define the current state as "users can use all features of
> > > > libbpf and nothing should break on libbpf update" (which is in my
> > > > understanding a goal of the project, we bent over backwards trying
> > > > to not break things) then adding this header will in fact make things
> > > > worse. The statement in quotes would no longer be true, no?
> > >
> > > So there are few things here.
> > >
> > > 1. About "adding bpf_helpers.h will make things worse". I
> > > categorically disagree, bpf_helpers.h doesn't exist in user land at
> > > all and it's sorely missing. So adding it is strictly better
> > > experience already. Right now people have to re-declare those helper
> > > signatures and do all kinds of unnecessary hackery just to be able to
> > > use BPF stuff, and they still can run into the same problem with
> > > having too old kernel headers.
> >
> > Right, so apps tend to ship their own uapi bpf.h header and helper
> > signatures to avoid these issues. But question becomes once they
> > start using soley bpf_helper.h (also in non-tracing context which
> > is very reasonable to assume), then things might break with the patch
> > as-is once they have a newer libbpf with more signatures than their
> > linux/bpf.h defines (and yes, pulling from GH will have this problem),
> > so we'd need to have an answer to that in order to avoid breaking
> > compilation.
> >
> > [...]
> > > 2. As to the problem of running bleeding-edge libbpf against older
> > > kernel. There are few possible solutions:
> > >
> > > a. we hard-code all those BPF_FUNC_ constants. Super painful and not
> > > nice, but will work.
> > >
> > > b. copy/paste enum bpf_func_id definition into bpf_helpers.h itself
> > > and try to keep it in sync with UAPI. Apart from obvious redundancy
> > > that involves, we also will need to make sure this doesn't conflict
> > > with vmlinux.h, so enum name should be different and each value should
> > > be different (which means some wort of additional prefix or suffix).
> > >
> > > c. BPF UAPI header has __BPF_FUNC_MAPPER macro "iterating" over all
> > > defined values for a particular kernel version. We can use that and
> > > additional macro trickery to conditionally define helpers. Again, we
> > > need to keep in mind that w/ vmlinux.h there is no such macro, so this
> > > should work as well.
> > >
> > > I'm happy to hear opinions about these choices (maybe there are some
> > > other I missed), but in any case I'd like to do it in a follow up
> > > patch and land this one as is. It has already quite a lot packed in
> > > it. I personally lean towards c) as it will have a benefit of not
> > > declaring helpers that are not supported by kernel we are compiling
> > > against, even though it requires additional macro trickery.
> > >
> > > Opinions?
> >
> > Was thinking about something like c) as well. So I tried to do a quick
> > hack. Here is how it could work, but it needs a small change in the
> > __BPF_FUNC_MAPPER(), at least I didn't find an immediate way around it:

Well, we are stuck with this comma, so rather than have to support two
bpf.h headers, I'd solve the problem for existing one. It's annoying,
but you can do it with having "/* <your macro> /*" in each FN macro
and then before you apply everything you add /* and after all the
applications you add */.

I'm going to prototype something like what you have below, but will
see we I can minimize amount of extra declarations we need. Do you
think this needs to be done as part of this patch set, or I can defer
that to a follow up patch?

> >
> > static void (*__unspec)(void);
> > static void *(*__map_lookup_elem)(void *map, const void *key);
> > static int (*__map_update_elem)(void *map, const void *key, const void *value, unsigned long long flags);
> > static int (*__map_delete_elem)(void *map, const void *key);
> > static int (*__bpf_probe_read)(void *dst, int size, const void *unsafe_ptr);
> >

[...]
