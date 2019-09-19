Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD09B7603
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388589AbfISJQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:16:51 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:35990 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387637AbfISJQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 05:16:51 -0400
Received: by mail-yb1-f193.google.com with SMTP id p23so1077742yba.3;
        Thu, 19 Sep 2019 02:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oD/ca2L4quCAHVT/XtgQj3jQHJpMXh9BrfnzPChou1w=;
        b=RwaZ6u6rQoLWT5+RtOg4glunTq2Xp0LVwWBB7uadEnqMynriOk2ej52GCwBnSbp9eu
         4c4keHhzlYq68JMgtg/rbnxrdoeckp/qJIaUlhPGKBjwceXh73D7+zgjxlkbMMCpNzig
         A9Q8TQvgNS54Ge19BBL3YHVt5PoHPgdUQQS3ulQ8G28UxG/abjfJvJT4RjdFQm+ZSNY5
         gmLwLGGbhuxTqmo5K0oVQUqyNz1wdXxHKTAZIjwezUHCkMxf4etbnOiEWTNzWZ8ouJkr
         HDMhMlzOPJvh6Ui89BSb4DWXlcTTRSLyPzlzJK7SPkQJpTHSAqp5Bc5MX5Nfuqgc2+wJ
         f8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oD/ca2L4quCAHVT/XtgQj3jQHJpMXh9BrfnzPChou1w=;
        b=kiNI4cM4itb5YUnh+U8RgpvPw+4LQeNjvHR5nNXuaxgp/uwp7qPyyqNS6A2pVGzhWV
         +w9CQrGAKJcIzwtfaQRKY9myQUnQujqiFAjvIJcKW29YDNs7EkvCg7i8Ul1YyUUajygl
         ubliCNx0fCSJ8wBLbPDyAYGfEKOvx6lNSTGlraV9klqs3lp37cw3zd9HceW12Z3XZ7TM
         qOGhinchZmEnAAwXYPCz3KMIZoXSqEyVAY2dWPYsDi6Bavc60/kUFORMjnqUe3S7kfd1
         g5XJCCO9h/MrD9R2HnEDpCHSM0f7FIiP/5JpHDAab5mg6+5XNuA31WOH0s4oHtDKmV64
         UY+w==
X-Gm-Message-State: APjAAAVuko5m0XTKjU+gRHObL7b4CqFDNjOgVqb6e1lmyo0WUOIPzwMW
        vdxwcsHt4igffPz7C2ZEZCswbRciqqCzsH4p8g==
X-Google-Smtp-Source: APXvYqzkwfBbAqJ2fEs7GLbenea9oMI2oEN6oxZT3Ppej5T+0RSW1IlEHCTJz46TaSY6kzmDE75pVcOkz7bihAcQBvU=
X-Received: by 2002:a5b:f41:: with SMTP id y1mr5918215ybr.164.1568884609909;
 Thu, 19 Sep 2019 02:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190911190218.22628-1-danieltimlee@gmail.com>
 <CAEf4Bza7tFdDP0=Nk4UVtWn68Kr7oYZziUodN40a=ZKne4-dEQ@mail.gmail.com>
 <CAEKGpzjUu7Qr0PbU6Es=7J6KAsyr9K1qZvFoWxZ-dhPsD0_8Kg@mail.gmail.com> <CAEf4BzY_EAf9pH7YvL9XAXPUr9+g5Q7N_n45XBufdxkfDbf3aQ@mail.gmail.com>
In-Reply-To: <CAEf4BzY_EAf9pH7YvL9XAXPUr9+g5Q7N_n45XBufdxkfDbf3aQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 19 Sep 2019 18:16:33 +0900
Message-ID: <CAEKGpzjf22NpMapev7OnxSmU2HpHoEcGHjX81Pw4LDvOt58NRw@mail.gmail.com>
Subject: Re: [bpf-next,v3] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 3:00 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Sep 18, 2019 at 10:37 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > On Tue, Sep 17, 2019 at 1:04 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Sep 11, 2019 at 2:33 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > > >
> > > > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > > > to 600. To make this size flexible, a new map 'pcktsz' is added.
> > > >
> > > > By updating new packet size to this map from the userland,
> > > > xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
> > > >
> > > > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > > > will be 600 as a default.
> > > >
> > > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > >
> > > > ---
> > > > Changes in v2:
> > > >     - Change the helper to fetch map from 'bpf_map__next' to
> > > >     'bpf_object__find_map_fd_by_name'.
> > > >
> > > >  samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
> > > >  samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
> > > >  2 files changed, 41 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > > > index 411fdb21f8bc..d6d84ffe6a7a 100644
> > > > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > > > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > > > @@ -25,6 +25,13 @@
> > > >  #define ICMP_TOOBIG_SIZE 98
> > > >  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
> > > >
> > > > +struct bpf_map_def SEC("maps") pcktsz = {
> > > > +       .type = BPF_MAP_TYPE_ARRAY,
> > > > +       .key_size = sizeof(__u32),
> > > > +       .value_size = sizeof(__u32),
> > > > +       .max_entries = 1,
> > > > +};
> > > > +
> > >
> > > Hey Daniel,
> > >
> > > This looks like an ideal use case for global variables on BPF side. I
> > > think it's much cleaner and will make BPF side of things simpler.
> > > Would you mind giving global data a spin instead of adding this map?
> > >
> >
> > Sure thing!
> > But, I'm not sure there is global variables for BPF?
> > AFAIK, there aren't any support for global variables yet in BPF
> > program (_kern.c).
> >
> >     # when defining global variable at _kern.c
> >     libbpf: bpf: relocation: not yet supported relo for non-static
> > global '<var>' variable found in insns[39].code 0x18
>
> just what it says: use static global variable (also volatile to
> prevent compiler optimizations) :)
>
> static volatile __u32 pcktsz; /* this should work */
>

My apologies, but I'm not sure I'm following.
What you are saying is, should I define global variable to _kern,c
and access and modify this variable from _user.c?

For example,

<_kern.c>
static volatile __u32 pcktsz = 300;

<_user.c>
extern __u32 pcktsz;
// Later in code
pcktsz = 400;

Is this code means similar to what you've said?
AFAIK, 'static' keyword for global variable restricts scope to file itself,
so the 'accessing' and 'modifying' this variable from the <_user.c>
isn't available.

The reason why I've used bpf map for this 'pcktsz' option is,
I've wanted to run this kernel xdp program (xdp_adjust_tail_kern.o)
as it itself, not heavily controlled by user program (./xdp_adjust_tail).

When this 'pcktsz' option is implemented in bpf map, user can simply
modify 'map' to change this size. (such as bpftool prog map)

But when this variable comes to global data, it can't be changed
after the program gets loaded.

I really appreciate your time and effort for the review.
But I'm sorry that I seem to get it wrong.

Thanks,
Daniel

> >
> > By the way, thanks for the review.
> >
> > Thanks,
> > Daniel
> >
> >
> > > >  struct bpf_map_def SEC("maps") icmpcnt = {
> > > >         .type = BPF_MAP_TYPE_ARRAY,
> > > >         .key_size = sizeof(__u32),
> > > > @@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
> > > >         *csum = csum_fold_helper(*csum);
> > > >  }
> > > >
> > >
> > > [...]
