Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5595F2C0DAB
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388915AbgKWO3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730778AbgKWO3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:29:01 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431A7C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 06:29:01 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id t143so19822364oif.10
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 06:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4mcRSXYs1vrWXulW8YwQHNxHKdDhl92/5ZWv138dA/s=;
        b=lRGC4gi+IH70XKzlDP2CJSAFox/xLpaus9xeyq1Wzyig+NUtwQnIMYcKsfmGtUH36i
         sjk0GBhcggtsZ4F+TpE6r5kqdVLMCw1m4cdeUP0IWYCm/zMcIW9wfzu4DGhJ1deerM9p
         lqMsqb2/FMQWKVZXM2c3aB272rdCg5UOMdI8TQP6S6mcNeVhiAX1LiZsbpMbENef02wq
         T3jb0aeXZW81IfHScf5YJx1mcHmlo8LqfStmske1Qrw/rT+e1xB0N5kY/cu/taFEdc48
         VAkkNH2bv8pn6vIXEY15W8jyS6uAMU5cWb4Nluc+gmx8DzD/nJx2ITCJ1x7vnKmNSWnj
         dSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4mcRSXYs1vrWXulW8YwQHNxHKdDhl92/5ZWv138dA/s=;
        b=EqiDntKNnYR8pz8nv8f4+8tVfpSG0mj7N8AmhewPbdlfaeXUPt8HbLg5MjhSIC59Gs
         itWDvnpJVxjlCo16FMLta0vjSTrbAK+v0XSUOccv0AsnGYSrfbA5eXPYELxQ6Wruxxgg
         UBOcTODyl3iNVW1D1SE8jMI2wys0MRIwzL1SFSw9pm8WkwyosiuCrm5BBSpjHfmCXQSe
         7dO4I6MLz6cs0rT494CcTjFHjImfKmSvpN2ggcV3gW6F0O/lA7rMTBDWC7Pk7mRGatx6
         5XclDUaRNbkGeT3hhSW0i8lU317g/Y/5NeKwiDbL/2tjQStHTRX6Fb77cFgfTSpoUl8C
         v/rA==
X-Gm-Message-State: AOAM531cag0s77ap5xEGeoi6P+1KMRFytcNG0+cLWOx3qkhnzsApe7Rf
        vzO6E4vyM1NHtZih++MTG9jfas8cLXPlS3+H6tVU6GjzDd9o5g==
X-Google-Smtp-Source: ABdhPJyND/g0RplSG05QqDAi9Mqihkb9jKwOmo8KKik/oyoShg407GNS4oqEjTAdk6Kr6+PZOTt42ox44Us1he5Bphg=
X-Received: by 2002:aca:ec97:: with SMTP id k145mr15242334oih.163.1606141740654;
 Mon, 23 Nov 2020 06:29:00 -0800 (PST)
MIME-Version: 1.0
References: <20201123142743.750971-1-zyjzyj2000@gmail.com>
In-Reply-To: <20201123142743.750971-1-zyjzyj2000@gmail.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Mon, 23 Nov 2020 22:28:49 +0800
Message-ID: <CAD=hENe2Ky391gFKSWu0dC9oYZUkYRGr+H2BsoHFemKctH0vKQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] xdp: remove the function xsk_map_inc
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 10:27 PM <zyjzyj2000@gmail.com> wrote:
>
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
>
> The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> always returns zero. As such, replacing this function with bpf_map_inc
> and removing the test code.
>
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> ---
>  net/xdp/xsk.c    |  2 +-
>  net/xdp/xsk.h    |  1 -
>  net/xdp/xskmap.c | 13 +------------
>  3 files changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index cfbec3989a76..a3c1f07d77d8 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -548,7 +548,7 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
>         node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
>                                         node);
>         if (node) {
> -               WARN_ON(xsk_map_inc(node->map));
> +               bpf_map_inc(&node->map->map);

Thanks. This is the latest version.

Zhu Yanjun

>                 map = node->map;
>                 *map_entry = node->map_entry;
>         }
> diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> index b9e896cee5bb..0aad25c0e223 100644
> --- a/net/xdp/xsk.h
> +++ b/net/xdp/xsk.h
> @@ -41,7 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
>
>  void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>                              struct xdp_sock **map_entry);
> -int xsk_map_inc(struct xsk_map *map);
>  void xsk_map_put(struct xsk_map *map);
>  void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
>  int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index 49da2b8ace8b..6b7e9a72b101 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -11,12 +11,6 @@
>
>  #include "xsk.h"
>
> -int xsk_map_inc(struct xsk_map *map)
> -{
> -       bpf_map_inc(&map->map);
> -       return 0;
> -}
> -
>  void xsk_map_put(struct xsk_map *map)
>  {
>         bpf_map_put(&map->map);
> @@ -26,17 +20,12 @@ static struct xsk_map_node *xsk_map_node_alloc(struct xsk_map *map,
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
> --
> 2.25.1
>
