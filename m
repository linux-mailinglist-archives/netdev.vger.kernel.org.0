Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3292C520A
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 11:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgKZKaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 05:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbgKZKaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 05:30:16 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39E7C0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 02:30:16 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id y3so301264ooq.2
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 02:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OQDaXCxRoZVPALKDQ5nzwxzgt6TmLUJ12oVJQEShVpU=;
        b=rLfBY04NnMSLX+CobhGRdcSr9MDl9qwzpMIiIR5kURJ2EKi4cZcFeD1i0kPoqgoMp/
         u8iYNyOR59CS1sZdxDQ1bedG3XhpqMumz9rEgRkfJMfxjCcGHUKQigdB9qCDXU27T5xw
         GG6HiKgpk79fz4c8tyngGqtQh1tJ4Hg/KoQd/ebhXlIKS8SsXoDpvELArtitM/o/bgDK
         ec3FzY5lP5HCJIZUqh98EvLw6x3byVO58ERTNe2kOjaEL54a4ZCVQlmYgW7pycuvOAjm
         mzoozVYFYvbliacSeFcexa7X8yeWbmlNVHrsmex/kw/biUCUy0C8nEobYjNoDfdWCIUa
         0yWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OQDaXCxRoZVPALKDQ5nzwxzgt6TmLUJ12oVJQEShVpU=;
        b=QJN+YTfaYPCjBaSzDiqsUA+wgJ2BNVC5vjiKzlLgcmP9oO4jacRTOaW8nq0PWxYisR
         R37vIEA6FsG5ImLE36AyiZD5r2cofV5kEtEcswInzsGbOy4Iyt+x/wmwvthrpJ7dbAoY
         EK5xilsQTURcEEoP8jVg4PI4ZswmxQOtJIzMede+Jjr/A0t7gMM9wLYSE0KkNxtkXLcQ
         Gx5HiZ1yuGXBkXyPrjYV5LEnuY6msGarq+OzTGpLAWmQsOL9VgSZZfc0u9LRdVJyoAG7
         8mQG9uV8S4b1fv9BdMhbkfeAr11W1tL00fHtoawHmWYeaKTxQUuxJr+vIQ8mryS8iM0w
         cuvw==
X-Gm-Message-State: AOAM533nzc2WebiXRKt9D6zSQTn3pnmOBdtatMxvDV/kAshAUw5W4E7S
        rNJeoBDa15U8CXakXpnBCohR0AEEZaLig+aRSzU=
X-Google-Smtp-Source: ABdhPJwNYABz5MBP8Aj34z8IUQV/gTvcXpbwV5mnnp+RIDxF8jvnQBK8XYxvVxo3XK0QHf5VWhney04jrHsbtB0mlrs=
X-Received: by 2002:a4a:45c3:: with SMTP id y186mr1541306ooa.13.1606386616308;
 Thu, 26 Nov 2020 02:30:16 -0800 (PST)
MIME-Version: 1.0
References: <1606143915-25335-1-git-send-email-yanjunz@nvidia.com>
 <c3472d5f-54da-2e20-2c3c-3f6690de6f04@iogearbox.net> <CAJ8uoz3WssKhD_CRhJSHRQDAB7nrkjz1P8Uaozxy3UwLZWnNaw@mail.gmail.com>
In-Reply-To: <CAJ8uoz3WssKhD_CRhJSHRQDAB7nrkjz1P8Uaozxy3UwLZWnNaw@mail.gmail.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Thu, 26 Nov 2020 18:30:05 +0800
Message-ID: <CAD=hENd43YkPcdbtD=CFASUHxDcMsxi9nkS771t8cn+fTOCTvg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] xdp: remove the function xsk_map_inc
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Zhu Yanjun <yanjunz@nvidia.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 4:33 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Nov 25, 2020 at 1:02 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 11/23/20 4:05 PM, Zhu Yanjun wrote:
> > > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> > >
> > > The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> > > always returns zero. As such, replacing this function with bpf_map_inc
> > > and removing the test code.
> > >
> > > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> > > ---
> > >   net/xdp/xsk.c    |  2 +-
> > >   net/xdp/xsk.h    |  1 -
> > >   net/xdp/xskmap.c | 13 +------------
> > >   3 files changed, 2 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index cfbec3989a76..a3c1f07d77d8 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -548,7 +548,7 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
> > >       node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
> > >                                       node);
> > >       if (node) {
> > > -             WARN_ON(xsk_map_inc(node->map));
> > > +             bpf_map_inc(&node->map->map);
> > >               map = node->map;
> > >               *map_entry = node->map_entry;
> > >       }
> > > diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> > > index b9e896cee5bb..0aad25c0e223 100644
> > > --- a/net/xdp/xsk.h
> > > +++ b/net/xdp/xsk.h
> > > @@ -41,7 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
> > >
> > >   void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
> > >                            struct xdp_sock **map_entry);
> > > -int xsk_map_inc(struct xsk_map *map);
> > >   void xsk_map_put(struct xsk_map *map);
> > >   void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
> > >   int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> > > diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> > > index 49da2b8ace8b..6b7e9a72b101 100644
> > > --- a/net/xdp/xskmap.c
> > > +++ b/net/xdp/xskmap.c
> > > @@ -11,12 +11,6 @@
> > >
> > >   #include "xsk.h"
> > >
> > > -int xsk_map_inc(struct xsk_map *map)
> > > -{
> > > -     bpf_map_inc(&map->map);
> > > -     return 0;
> > > -}
> > > -
> > >   void xsk_map_put(struct xsk_map *map)
> > >   {
> >
> > So, the xsk_map_put() is defined as:
> >
> >    void xsk_map_put(struct xsk_map *map)
> >    {
> >          bpf_map_put(&map->map);
> >    }
> >
> > What is the reason to get rid of xsk_map_inc() but not xsk_map_put() wrapper?
> > Can't we just remove both while we're at it?
>
> Yes, why not. Makes sense.
>
> Yanjun, could you please send a new version that removes this too?

OK. I will.

Zhu Yanjun

>
> Thank you both!
>
> > Thanks,
> > Daniel
