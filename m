Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEC52C604C
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 08:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbgK0HEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 02:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbgK0HEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 02:04:04 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36652C0613D1
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 23:04:03 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w16so3577205pga.9
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 23:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=baQhyLwj1MJRQspOBVsq1kKjotoFau/osVwsNqiii14=;
        b=rymxIulH5oXDp1KTcSZSe/ep/T3Q6EMWZIQPrRk2II29yshS/9oiqULuxjSryEbpDi
         khLsZwxAP5uK77/XszkaXnMpmz6J//+eSY8xLEaAOJ/Z48uXtqJ1dC3+6YBj5MRgIF4P
         21m+5qW+AWdRv3ocP6HF1QbsY3BMW3HGa0i74drEeZsu9Oq8ogF65eK6+JyJvCwdDvEX
         3x7hmV8VCD5PgQUepW+tNGx+bBuZ4m+QlMFTNdUsILRxeKiEb4sDUDodMcnAzC6B6E28
         vC5dcYd+I7TVDijvLT3tN3GoPAuGbkKH34NHVQ89bZiYdlWZ7Uj9rSO3WvauHL+9GGA3
         QCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=baQhyLwj1MJRQspOBVsq1kKjotoFau/osVwsNqiii14=;
        b=Vo5kCnqjbe+lG3w2s8x30BBsWfQ5bgOeCeopKcY/qZ4Ju3ZB1vUGbBTjF9pVRIrE/i
         02AIUEBXdo82mp2jemAWLQmApGRCfyOEDFKZqfvPSOxlaeUB3uaC51BbT0y6qHldDOqe
         akVFsji9sDwW2oHHHNCUnOWaKDWcVsb3kcoSzjGBvMOtUTGh7Y73RE6QHKbdlarAkGc+
         aau4EZbYo0H0thEBExoLaKpgL5GnpmWDaRIZ/sIDKcdmxwX8fM0wZZESALv76wwr08PJ
         x2RkmwcnkAV+XqOpjU5Jc76swdEO2pE18ALyT+hLlMvE1TfQLMKS2S/2QH2ufSTUvW1N
         lQ8Q==
X-Gm-Message-State: AOAM530zsV4wagOoaCoBPLGD2Sg7Tp76zSJ5LXXx/sejXwYkwJC6CcfW
        W6UJ5nIpXufcoEHrY7ObML1tLmuxPZAu1Dbl9kEUJ+ZUHOBveDVI
X-Google-Smtp-Source: ABdhPJx/aqkiphfwgPPFhNDlZDVRB3VJKfj6HZ+ZsiUfj9VBYWKsTaMiimS7Oqdd0U9dhbyVfeH+lpZi5AGM34B/P7k=
X-Received: by 2002:a17:90a:8b8b:: with SMTP id z11mr4064283pjn.117.1606460642779;
 Thu, 26 Nov 2020 23:04:02 -0800 (PST)
MIME-Version: 1.0
References: <1606402998-12562-1-git-send-email-yanjunz@nvidia.com>
In-Reply-To: <1606402998-12562-1-git-send-email-yanjunz@nvidia.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 27 Nov 2020 08:03:51 +0100
Message-ID: <CAJ8uoz24Of3Ah_=ZyC2NOSC7RFTFCeCv5dEOxSZrWuTLvPOMbQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] xdp: remove the functions xsk_map_inc and xsk_map_put
To:     Zhu Yanjun <yanjunz@nvidia.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 4:05 PM Zhu Yanjun <yanjunz@nvidia.com> wrote:
>
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
>
> The functions xsk_map_put and xsk_map_inc are simple wrappers.
> As such, replacing these functions with the functions bpf_map_inc
> and bpf_map_put and removing some test codes.
>
> Fixes: d20a1676df7e ("xsk: Move xskmap.c to net/xdp/")
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> ---
>  net/xdp/xsk.c    |  4 ++--
>  net/xdp/xsk.h    |  2 --
>  net/xdp/xskmap.c | 20 ++------------------
>  3 files changed, 4 insertions(+), 22 deletions(-)

Thank you Yanjun for this cleanup!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index cfbec3989a76..4f0250f5d676 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -548,7 +548,7 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
>         node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
>                                         node);
>         if (node) {
> -               WARN_ON(xsk_map_inc(node->map));
> +               bpf_map_inc(&node->map->map);
>                 map = node->map;
>                 *map_entry = node->map_entry;
>         }
> @@ -578,7 +578,7 @@ static void xsk_delete_from_maps(struct xdp_sock *xs)
>
>         while ((map = xsk_get_map_list_entry(xs, &map_entry))) {
>                 xsk_map_try_sock_delete(map, xs, map_entry);
> -               xsk_map_put(map);
> +               bpf_map_put(&map->map);
>         }
>  }
>
> diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> index b9e896cee5bb..edcf249ad1f1 100644
> --- a/net/xdp/xsk.h
> +++ b/net/xdp/xsk.h
> @@ -41,8 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
>
>  void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>                              struct xdp_sock **map_entry);
> -int xsk_map_inc(struct xsk_map *map);
> -void xsk_map_put(struct xsk_map *map);
>  void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
>  int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
>                         u16 queue_id);
> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index 49da2b8ace8b..66231ba6c348 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -11,32 +11,16 @@
>
>  #include "xsk.h"
>
> -int xsk_map_inc(struct xsk_map *map)
> -{
> -       bpf_map_inc(&map->map);
> -       return 0;
> -}
> -
> -void xsk_map_put(struct xsk_map *map)
> -{
> -       bpf_map_put(&map->map);
> -}
> -
>  static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
>                                                struct xdp_sock **map_entry)
>  {
>         struct xsk_map_node *node;
> -       int err;
>
>         node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
>         if (!node)
>                 return ERR_PTR(-ENOMEM);
>
> -       err = xsk_map_inc(map);
> -       if (err) {
> -               kfree(node);
> -               return ERR_PTR(err);
> -       }
> +       bpf_map_inc(&map->map);
>
>         node->map = map;
>         node->map_entry = map_entry;
> @@ -45,7 +29,7 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
>
>  static void xsk_map_node_free(struct xsk_map_node *node)
>  {
> -       xsk_map_put(node->map);
> +       bpf_map_put(&node->map->map);
>         kfree(node);
>  }
>
> --
> 2.25.1
>
