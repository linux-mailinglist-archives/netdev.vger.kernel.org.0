Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5A92C0DDA
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgKWOkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbgKWOkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:40:22 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7DBC061A4D
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 06:40:22 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b63so15058729pfg.12
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 06:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RhsMsld6ZOuyU4qU9Pu0Vrf1rnaehlg/dlRuPByBFw0=;
        b=JIk+W3rmptqTqn49GRfXxEKEZbVtPZwAKUURPZeQH5IGuS5lm9/36j3NQ1gEfKqk69
         78rk4LQ7GFgTiNgMCcUwro5mUqT0aREGVI1S0giUDZenO+szKDm0qqvgSP4isZH9fdRB
         BV51ItQlxoYxEL8d4T2Thn7w6F5srR0l/fIlljTeb2Z2TE1i1N8KZLLZ9XyH63Zf0EcM
         YuFSS9uLJ0JdmIktc4q6weiWXlTwgkl4tB1qL9kVjVwhC9kvdGwu+GKRkqHurxUP7qxG
         1f3Ndyg2nr17stdKpV90Cll3ALc8STAazDS/lvvu8KZFGfRs0Ma9GXLvhcJ4oLTZbtz9
         GGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RhsMsld6ZOuyU4qU9Pu0Vrf1rnaehlg/dlRuPByBFw0=;
        b=K9HcC41orWaQ3G+P5hJAyaZicr5sQmqurL1UzFfZ1HTHbJwTRB+rRBSGNW87+NdZYz
         Q49syWXhXnEaedHUr0eef+xXu0IhRUuTqIHSTIUbqA5wgEEfz+NMgP+6lQXREBFkFRDL
         +qjRcDTydIKgh6sJHIk3ihPXoZbvjuwFYaIMJ/iAxJjychcLDaO3vMkxidChJlIWXC8S
         xw0bt9IB7JqgBmCddgtqArv86dPaI6kgAy4JFDJQk3qOCWHDRHMshuazsoge7n1LFlMt
         +MX5KYWISyzJ/woUUtA+VXI0deNby6g+o2jUE/liLBO1pxTbZkfC0JAa7hwh/lchmzTd
         BkmQ==
X-Gm-Message-State: AOAM530/V48LMG/1TMIwtwkytL+B7I2gVOjFRy0phRkM5gRtNWEPKDSn
        N1GIg15RBLPiYBinAYl2h8xpb4MTE7FWbK97kg12WUt8F3q6IxFW
X-Google-Smtp-Source: ABdhPJxXQ1p4VkOas+3LvgPeWIaD6Gjj3yt9wzrd/aq5JpuGrsMiE7i+pw3DRs57SeYjl0MAmZWaUqF6PWOsdedMwgM=
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr48170pjy.204.1606142422031;
 Mon, 23 Nov 2020 06:40:22 -0800 (PST)
MIME-Version: 1.0
References: <20201123142743.750971-1-zyjzyj2000@gmail.com> <CAD=hENe2Ky391gFKSWu0dC9oYZUkYRGr+H2BsoHFemKctH0vKQ@mail.gmail.com>
In-Reply-To: <CAD=hENe2Ky391gFKSWu0dC9oYZUkYRGr+H2BsoHFemKctH0vKQ@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 23 Nov 2020 15:40:11 +0100
Message-ID: <CAJ8uoz1sQ35p8o+iWt6PErUJHu-G=eOicsN-68vKajcUfgx_xw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] xdp: remove the function xsk_map_inc
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 3:30 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>
> On Mon, Nov 23, 2020 at 10:27 PM <zyjzyj2000@gmail.com> wrote:
> >
> > From: Zhu Yanjun <zyjzyj2000@gmail.com>
> >
> > The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> > always returns zero. As such, replacing this function with bpf_map_inc
> > and removing the test code.
> >
> > Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> > ---
> >  net/xdp/xsk.c    |  2 +-
> >  net/xdp/xsk.h    |  1 -
> >  net/xdp/xskmap.c | 13 +------------
> >  3 files changed, 2 insertions(+), 14 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index cfbec3989a76..a3c1f07d77d8 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -548,7 +548,7 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
> >         node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
> >                                         node);
> >         if (node) {
> > -               WARN_ON(xsk_map_inc(node->map));
> > +               bpf_map_inc(&node->map->map);
>
> Thanks. This is the latest version.
>
> Zhu Yanjun

Thank you. The code now looks good, but could you please resend this
without any of your replies in it (like the comments above). Something
that can be applied as a patch to source code. Use git format-patch
followed by git send-email (without any editing in between). It will
produce a clean patch.

Have you run "checkpatch.pl -strict" on it?

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
