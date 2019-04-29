Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025E8E919
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 19:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfD2RcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 13:32:13 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44495 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbfD2RcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 13:32:12 -0400
Received: by mail-lf1-f65.google.com with SMTP id h18so8494687lfj.11
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 10:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=posk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JxbME+6kz84W6nacZPFDEplfjpmOWtd/7s+6IAHbBWw=;
        b=AecfYbiSRXAQ2s5dzwkhiwjZX3Bg4Cqg/xRLdlFAqAv7D+0LP+ivMERUiqQ1FRwNLt
         ZlTLPrbDVpouFLbVNoF5RcL0jVJ/cm41nZivxvU4AM2/v9vt44cGQqEJ2ld/+v6glxdU
         Wgg450um02tnYphkFN1mFrNiO3FYH8acmZzN1zec9sF736z4ahSJEv11FhYbHtD2IbAw
         c/su3rwxkdVNR3D7Y/a78xv/bvD6b0g6Lhq2sWWrbdUyPAN1RWJolibHoujw3TnFtk4R
         7GbWZ06nZ4OXV6KEgAckt8EUkoRbJQOH4uweGKh4bYCeFCUEzqkOroIShvsP78XGM2nW
         r7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JxbME+6kz84W6nacZPFDEplfjpmOWtd/7s+6IAHbBWw=;
        b=OfuyXFjUNui2/aaUQ83vquSgWypGtLhS4QLdXoSn487YaCmnp8Y/P6kgIXTa3KeRZ8
         zdj+TkVhEFpxd9SHK7wvzZkj4/PVnFEfbAE2mWjLWzim8DYFYB5YQUtVd/Ahzztifjky
         7ZFhQ4YGFWpl6fB6Gxu33alJj6tKILWy97TVLXWcR5WUd3Rna0HE6U9RJj4fY93wGXjT
         56STbPkXxvvPHLokemNBvnVbuadRnSpBgcp/+VEP0rXjl8bv5mqk/a8tjOP29mlM9m5V
         2eY/GRNsbnfQLlHg2Y1eszrElGjhxxrk631ZBPUIn4quaXcn++lNEuQppLpO4w5mduIo
         VW2g==
X-Gm-Message-State: APjAAAVo2zsKHexAfVGNfnL1C02RKzEEE6bf2Jnyfm8HM3A+0WYiwrE5
        9vWM9pvdwsaaBHWunTso7IZeqMeZZYqlQug4xgC58A==
X-Google-Smtp-Source: APXvYqwACfiu3vEEqeVSR0QGX7qVVUKx9LXi4s8j+iO/x/ebQIs429yNQdyQWBMo4dPsO7eqjh+IDH7MkqRC0vq6JWs=
X-Received: by 2002:a19:cb09:: with SMTP id b9mr33535166lfg.55.1556559130258;
 Mon, 29 Apr 2019 10:32:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190426154108.52277-1-posk@google.com> <CAB=W+o=rNc9R0L+e23xox0m-g3q2YWO7Wd-MsGDpU7DUPqV5kw@mail.gmail.com>
 <CAB=W+ok+7MrPovbFnBtkkSU3LS9MBF4fmJb9MR_j5w4KG+pOEQ@mail.gmail.com>
In-Reply-To: <CAB=W+ok+7MrPovbFnBtkkSU3LS9MBF4fmJb9MR_j5w4KG+pOEQ@mail.gmail.com>
From:   Peter Oskolkov <posk@posk.io>
Date:   Mon, 29 Apr 2019 10:31:59 -0700
Message-ID: <CAFTs51WyohCSeX37KixNuicz=c9yX-E1AQJKgLomfjiwsHKD_A@mail.gmail.com>
Subject: Re: [PATCH 4.9 stable 0/5] net: ip6 defrag: backport fixes
To:     Captain Wiggum <captwiggum@gmail.com>
Cc:     Peter Oskolkov <posk@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>, Lars Persson <lists@bofh.nu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 10:24 AM Captain Wiggum <captwiggum@gmail.com> wrote:
>
> Hi Peter,
>
> I forgot to mention one thing about the 4.9 patch set.
> When patching against 4.9.170, I had to remove a couple of snippets
> that were already in release:

Hi John, I see these checks still present in 4.4.171. Maybe you had
them removed in
your local branch?

>
> Patch #604 (linux-4.9-4-ip6-defrag-use-rbtrees.patch):
> + /usr/bin/cat /home/admin/WORK/os/PACKAGES/kernel49/WORK/linux-4.9-4-ip6-defrag-use-rbtrees.patch
> + /usr/bin/patch -p1 -b --suffix .ip6-4 --fuzz=0
> patching file include/net/ipv6_frag.h
> patching file net/ipv6/reassembly.c
> Hunk #10 FAILED at 357.
> Hunk #11 succeeded at 374 (offset -4 lines).
> 1 out of 11 hunks FAILED -- saving rejects to file net/ipv6/reassembly.c.rej
>
> --- net/ipv6/reassembly.c
> +++ net/ipv6/reassembly.c
> @@ -357,10 +258,6 @@
>                 return 1;
>         }
>
> -       if (skb->len - skb_network_offset(skb) < IPV6_MIN_MTU &&
> -           fhdr->frag_off & htons(IP6_MF))
> -               goto fail_hdr;
> -
>         iif = skb->dev ? skb->dev->ifindex : 0;
>         fq = fq_find(net, fhdr->identification, hdr, iif);
>         if (fq) {
>
> Patch #605 (linux-4.9-5-ip6-defrag-use-rbtrees-in-nf_conntrack_reasm.patch):
> + /usr/bin/cat /home/admin/WORK/os/PACKAGES/kernel49/WORK/linux-4.9-5-ip6-defrag-use-rbtrees-in-nf_conntrack_reasm.patch
> + /usr/bin/patch -p1 -b --suffix .ip6-5 --fuzz=0
> patching file net/ipv6/netfilter/nf_conntrack_reasm.c
> Hunk #8 FAILED at 464.
> Hunk #9 succeeded at 475 (offset -4 lines).
> 1 out of 9 hunks FAILED -- saving rejects to file
> net/ipv6/netfilter/nf_conntrack_reasm.c.rej
>
> --- net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -464,10 +363,6 @@
>         hdr = ipv6_hdr(skb);
>         fhdr = (struct frag_hdr *)skb_transport_header(skb);
>
> -       if (skb->len - skb_network_offset(skb) < IPV6_MIN_MTU &&
> -           fhdr->frag_off & htons(IP6_MF))
> -               return -EINVAL;
> -
>         skb_orphan(skb);
>         fq = fq_find(net, fhdr->identification, user, hdr,
>                      skb->dev ? skb->dev->ifindex : 0);
>
> On Mon, Apr 29, 2019 at 10:57 AM Captain Wiggum <captwiggum@gmail.com> wrote:
> >
> > I have run the 4.9 patch set on the full TAHI test sweet.
> > Similar to 4.14, it does fix all the IPv6 frag header issues.
> > But the "change MTU" mesg routing is still broken.
> > Overall, it fixes what it was intended to fix, so I suggest it move
> > toward release.
> > Thanks Peter!
> >
> > --John Masinter
> >
> > On Fri, Apr 26, 2019 at 9:41 AM Peter Oskolkov <posk@google.com> wrote:
> > >
> > > This is a backport of a 5.1rc patchset:
> > >   https://patchwork.ozlabs.org/cover/1029418/
> > >
> > > Which was backported into 4.19:
> > >   https://patchwork.ozlabs.org/cover/1081619/
> > >
> > > and into 4.14:
> > >   https://patchwork.ozlabs.org/cover/1089651/
> > >
> > >
> > > This 4.9 patchset is very close to the 4.14 patchset above
> > > (cherry-picks from 4.14 were almost clean).
> > >
> > >
> > > Eric Dumazet (1):
> > >   ipv6: frags: fix a lockdep false positive
> > >
> > > Florian Westphal (1):
> > >   ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module
> > >
> > > Peter Oskolkov (3):
> > >   net: IP defrag: encapsulate rbtree defrag code into callable functions
> > >   net: IP6 defrag: use rbtrees for IPv6 defrag
> > >   net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c
> > >
> > >  include/net/inet_frag.h                   |  16 +-
> > >  include/net/ipv6.h                        |  29 --
> > >  include/net/ipv6_frag.h                   | 111 +++++++
> > >  net/ieee802154/6lowpan/reassembly.c       |   2 +-
> > >  net/ipv4/inet_fragment.c                  | 293 ++++++++++++++++++
> > >  net/ipv4/ip_fragment.c                    | 295 +++---------------
> > >  net/ipv6/netfilter/nf_conntrack_reasm.c   | 273 +++++-----------
> > >  net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |   3 +-
> > >  net/ipv6/reassembly.c                     | 361 ++++++----------------
> > >  net/openvswitch/conntrack.c               |   1 +
> > >  10 files changed, 631 insertions(+), 753 deletions(-)
> > >  create mode 100644 include/net/ipv6_frag.h
> > >
> > > --
> > > 2.21.0.593.g511ec345e18-goog
> > >
