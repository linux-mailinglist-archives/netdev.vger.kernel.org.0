Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73902B6A24
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfIRSAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:00:33 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33111 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbfIRSAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:00:33 -0400
Received: by mail-qk1-f195.google.com with SMTP id x134so423919qkb.0;
        Wed, 18 Sep 2019 11:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zhpRNFtQm1yjXMTnb8bMm5OpYtvJMh0HlV2y5blDtEM=;
        b=ZEzcoZSUtpui/fhDhrN54rdTpTGKwoZ6uX0rTdIss6sbb/VIX1/E3tDib1Y+PPgo0f
         +M45qjpffMJ9SDg7TBJvfEoRcg9khUYEOoX0gpmI8OEPdJqbXbKDLmuj8feSs7I662Sw
         7/OJamOMaeTLNO2iXh6OC+n+9w8APFjosyEOPYFd7H+4SxMWkPbIq7zOcSnpkXGOiVXe
         eKA5nufYabrQV+5KPb9ONV6rliJTUzP3xGdG4OwpoSM+sCeyiATQ6WvyJF70dHj+t/N5
         veCkCeeYDzPL4MG1q9Q/qNJGdn2x0R7bT5F79D5HpCiBaKz4jBss6jPAgZFH+Z8LyDkG
         uqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhpRNFtQm1yjXMTnb8bMm5OpYtvJMh0HlV2y5blDtEM=;
        b=N8shhbcZtON+6iDb2XMcCy1mU5rwhIJ7xxPtkT8VtV+M6K+YGW8j23MDnNuLEl6RBa
         k6aTOUFCwuWaJG1PebvgmwUb7cXZeyu+Y5YXZdcGwr0v/Ce58wTvpFTO/BjCqa58sBsz
         zh9uzlFMVy50N+h7UFAEbtXhzyep0v8qwViQPAPjhZTqcUdLaQZMQuszzVSmKFmnMiee
         hsDu4/sbB5KEusCD4Sgr9C29A5hYAg2WPHEYaKr3pBPAuUW6i8Brb39HXHsfeRUtqh4m
         5HteKeY7+YDAoKQVDA0QUFyEZPh5J8q2bBgBNiE3o9n6ZlCSJ4P0tb4m7cg5eCyaucK5
         2OJg==
X-Gm-Message-State: APjAAAUXALQXO4oszvzRRF0daCpIM3STL1atjqXpYIae5wU/M22fK0YY
        b5fAKPqYcLjlKZooRsmLGDEWocvdx3DKCCVkU8k=
X-Google-Smtp-Source: APXvYqyRjCfA/ckV6HS+0hfw515lkee38RTR3Ac9WQVztopTWGkRDkhy7exZbrWRAiEYWHh9OnpQc+CZoKbe/bdvOz8=
X-Received: by 2002:a37:4e55:: with SMTP id c82mr5515904qkb.437.1568829631963;
 Wed, 18 Sep 2019 11:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190911190218.22628-1-danieltimlee@gmail.com>
 <CAEf4Bza7tFdDP0=Nk4UVtWn68Kr7oYZziUodN40a=ZKne4-dEQ@mail.gmail.com> <CAEKGpzjUu7Qr0PbU6Es=7J6KAsyr9K1qZvFoWxZ-dhPsD0_8Kg@mail.gmail.com>
In-Reply-To: <CAEKGpzjUu7Qr0PbU6Es=7J6KAsyr9K1qZvFoWxZ-dhPsD0_8Kg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Sep 2019 11:00:20 -0700
Message-ID: <CAEf4BzY_EAf9pH7YvL9XAXPUr9+g5Q7N_n45XBufdxkfDbf3aQ@mail.gmail.com>
Subject: Re: [bpf-next,v3] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 10:37 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Tue, Sep 17, 2019 at 1:04 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Sep 11, 2019 at 2:33 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > > to 600. To make this size flexible, a new map 'pcktsz' is added.
> > >
> > > By updating new packet size to this map from the userland,
> > > xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
> > >
> > > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > > will be 600 as a default.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > >
> > > ---
> > > Changes in v2:
> > >     - Change the helper to fetch map from 'bpf_map__next' to
> > >     'bpf_object__find_map_fd_by_name'.
> > >
> > >  samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
> > >  samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
> > >  2 files changed, 41 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > > index 411fdb21f8bc..d6d84ffe6a7a 100644
> > > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > > @@ -25,6 +25,13 @@
> > >  #define ICMP_TOOBIG_SIZE 98
> > >  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
> > >
> > > +struct bpf_map_def SEC("maps") pcktsz = {
> > > +       .type = BPF_MAP_TYPE_ARRAY,
> > > +       .key_size = sizeof(__u32),
> > > +       .value_size = sizeof(__u32),
> > > +       .max_entries = 1,
> > > +};
> > > +
> >
> > Hey Daniel,
> >
> > This looks like an ideal use case for global variables on BPF side. I
> > think it's much cleaner and will make BPF side of things simpler.
> > Would you mind giving global data a spin instead of adding this map?
> >
>
> Sure thing!
> But, I'm not sure there is global variables for BPF?
> AFAIK, there aren't any support for global variables yet in BPF
> program (_kern.c).
>
>     # when defining global variable at _kern.c
>     libbpf: bpf: relocation: not yet supported relo for non-static
> global '<var>' variable found in insns[39].code 0x18

just what it says: use static global variable (also volatile to
prevent compiler optimizations) :)

static volatile __u32 pcktsz; /* this should work */

>
> By the way, thanks for the review.
>
> Thanks,
> Daniel
>
>
> > >  struct bpf_map_def SEC("maps") icmpcnt = {
> > >         .type = BPF_MAP_TYPE_ARRAY,
> > >         .key_size = sizeof(__u32),
> > > @@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
> > >         *csum = csum_fold_helper(*csum);
> > >  }
> > >
> >
> > [...]
