Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58492C0562
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 13:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgKWMTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 07:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729270AbgKWMTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 07:19:31 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227C2C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 04:19:31 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id m9so14110986pgb.4
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 04:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pVI+N1FMbYf8eOWMx62FiQ7FrS7V4kw0rtHUnYPHBCc=;
        b=KjaXqcPC1U/3XG7HH7wGxJS9SsXvSPKs29b/Gf90Lxdj67jnPnUlTtVZSx2xK95Y8w
         sSH+Czmhk/8skqHPKYYNirRBuPBYEMOXGxCBzK3rwQfWSdKsh+R/97L9rUAZ770/L0bU
         yAtGpzKZwCtPwQ0WPtRq6BbFfX31ZZoumdG6Tx3aHdgWnf2W6LmP30KPOXgYwxv7i7tT
         8rsIUM+UPvP6vfIPqq21OGme8/3Z9q8wC7HB+nJVzkHUfcvAaeU1xww7PaUxRPR+/aO6
         z1u+rysP2JmLrBt+5CW6GDby1R0fcy5wxGUmq3Md+GU/GjbY/3Sd+z/CBUjoKXn2iZ3M
         J8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pVI+N1FMbYf8eOWMx62FiQ7FrS7V4kw0rtHUnYPHBCc=;
        b=IDYsWcHH5TM0PrE8M7z53V0TEv6TlZWLgAzhxnTdLjyxvV0Nx55i8m/7QLkboFQEMO
         OUdWNjEJrprl4uUhj554cu5IYK8vivCmGaIxKonoSkoYOYad8raSeQWmk7+/PfC3nuNl
         RXaRmJ/QMVZJPywiuKpowMaG5qNakZp/hyALiUgbb4c88KPtYzsafcXMUgHpL42zCeO4
         6WwwRaOmPi4gWGmxSZAAbPUhQeYIrZdHGOndGastv2ClHIcfUUHjb4Uf15Iei+8SEsm4
         c/u58xOst+prsGGTAAUdCgyW0w6pMiTMOAgkM90apwQ+6AZp6JOggp30p2xDQKXyjjI2
         u+vQ==
X-Gm-Message-State: AOAM530y+uPPp9r3a/AcgYwJreIbLfQu8DXH/FhbL/PIgojm5dnc57Wy
        SFyO53WbDvsNsjV00x9rFRAteUK2wA9NGoOp668ZOv3wbR5pVEva
X-Google-Smtp-Source: ABdhPJyk++ujNVWBZ+DONQMV864RMKG/PW9sfSjph9k5W1zjd8VRwWsZD6+saq/AnefvGcgVj9hiiq3x768G7nBQSpg=
X-Received: by 2002:a62:2bd0:0:b029:18a:df0f:dd61 with SMTP id
 r199-20020a622bd00000b029018adf0fdd61mr24065137pfr.19.1606133970568; Mon, 23
 Nov 2020 04:19:30 -0800 (PST)
MIME-Version: 1.0
References: <20201123120531.724963-1-zyjzyj2000@gmail.com> <CAD=hENfysbUCNapfFZ6i0tOFo5Ge3QS+iQSt2ySBDb10zFdgwg@mail.gmail.com>
In-Reply-To: <CAD=hENfysbUCNapfFZ6i0tOFo5Ge3QS+iQSt2ySBDb10zFdgwg@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 23 Nov 2020 13:19:19 +0100
Message-ID: <CAJ8uoz1TO7ULPDTK0ajyrjVFqB2REw=ncgT1c-NDhTciDeNfNg@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] xdp: remove the function xsk_map_inc
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 1:11 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>
> On Mon, Nov 23, 2020 at 8:05 PM <zyjzyj2000@gmail.com> wrote:
> >
> > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> >
> > The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> > always returns zero. As such, replacing this function with bpf_map_inc
> > and removing the test code.
> >
> > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
>
>
> > ---
> >  net/xdp/xsk.c    |  1 -
> >  net/xdp/xsk.h    |  1 -
> >  net/xdp/xskmap.c | 13 +------------
> >  3 files changed, 1 insertion(+), 14 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index cfbec3989a76..c1b8a888591c 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -548,7 +548,6 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
> >         node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
> >                                         node);
> >         if (node) {
> > -               WARN_ON(xsk_map_inc(node->map));

This should be bpf_map_inc(&node->map->map); Think you forgot to
convert this one.

> >                 map = node->map;
> >                 *map_entry = node->map_entry;
> >         }
> > diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> > index b9e896cee5bb..0aad25c0e223 100644
> > --- a/net/xdp/xsk.h
> > +++ b/net/xdp/xsk.h
> > @@ -41,7 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
> >
> >  void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
> >                              struct xdp_sock **map_entry);
> > -int xsk_map_inc(struct xsk_map *map);
> >  void xsk_map_put(struct xsk_map *map);
> >  void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
> >  int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> > diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> > index 49da2b8ace8b..6b7e9a72b101 100644
> > --- a/net/xdp/xskmap.c
> > +++ b/net/xdp/xskmap.c
> > @@ -11,12 +11,6 @@
> >
> >  #include "xsk.h"
> >
> > -int xsk_map_inc(struct xsk_map *map)
> > -{
> > -       bpf_map_inc(&map->map);
> > -       return 0;
> > -}
>
> Hi, Magnus
>
> The function xsk_map_inc is replaced with bpf_map_inc.
>
> Zhu Yanjun
>
> > -
> >  void xsk_map_put(struct xsk_map *map)
> >  {
> >         bpf_map_put(&map->map);
> > @@ -26,17 +20,12 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
> >                                                struct xdp_sock **map_entry)
> >  {
> >         struct xsk_map_node *node;
> > -       int err;
> >
> >         node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
> >         if (!node)
> >                 return ERR_PTR(-ENOMEM);
> >
> > -       err = xsk_map_inc(map);
> > -       if (err) {
> > -               kfree(node);
> > -               return ERR_PTR(err);
> > -       }
> > +       bpf_map_inc(&map->map);
> >
> >         node->map = map;
> >         node->map_entry = map_entry;
> > --
> > 2.25.1
> >
