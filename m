Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020FB2C1FD2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgKXI0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730479AbgKXI0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 03:26:30 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959FFC0613CF
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 00:26:29 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 131so17757935pfb.9
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 00:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xGxPFU7HmUNTL7v9rR1KKUCp1Qoz4dTjclFZr76Whc=;
        b=oG+NK7YiDL3f+UEh4bd1sNm6Ba+ZQvdxB9Vb0hEbs8c/ViUfcKA1flrP2fldAa7APS
         IZfVxYNYD1opKEZunGU8oEdM/BoDkFOrztWQakVbRRGboTFZaI9qWxlO+hkiMwqFxrPA
         g/OQvbo7ufL+feMyudwp2R7RPOUzR0uYdNjJ2k3DRNRJrXdjjsmT8kcBgvxzryB7iEsH
         DPEsuOKcKSQAg3Z/fr7rYn7FeeWaNJr/IS1zar0lUqcM0a8YcSHrDU/t5gfW51foCpWL
         6S56d7uw6mwYvAJJT+5Z+KcwbFMbnl7v715YjghVFmdCBU6N0xS3VTxhQ4DNwEJh8Mua
         M65Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xGxPFU7HmUNTL7v9rR1KKUCp1Qoz4dTjclFZr76Whc=;
        b=fNQM/p+fxWoElKidnjoeBPkD6S6LTlCQqvx13g8Ef5V87oXMT824cbamZBsScKCk+5
         qhgNhYLLQP6Z6vGkU/N1+Z+RODqwuu2yqL+5zM7PE16Acl2gvrXrYycS5wouoJngAKe8
         Zzi5WYM25GVUdwT+bofPoGFyPFuK3akEYIctx3tqmo3qN86bB5VRtkmvqCPyS1rQe47g
         Q1zBSJOIymIN2KF1swDMpbE573x2qUeRo0nKluvcrwCDhH5OZqGleaBiauGzf36Ifuqc
         MHqGG3LKlWEXRGAgYuRHxoIjy4KCkT7JCqpNHo/PSaLk7bRfUS5FrfadBR/2esj8sR8f
         oqCA==
X-Gm-Message-State: AOAM531REjn2G8BkaWZ/3OWc4zMy0tS+PxA7B+GU/Bu8jLVVjOWCOjsi
        QoVzROF2XHL1hjAcsFgTMi0cUF6IBFLHloClMBhQkXAhTyK/eE7EmIY=
X-Google-Smtp-Source: ABdhPJzY6SMk0Xm0x+zWmhj/XD/O1Ty40O5s+M7a3WArOFAT7J5vkF/PSWVBEe7iCAP88IfCAfIfePfvls0s1xmWG3c=
X-Received: by 2002:a62:445:0:b029:196:61fc:2756 with SMTP id
 66-20020a6204450000b029019661fc2756mr3159092pfe.12.1606206389121; Tue, 24 Nov
 2020 00:26:29 -0800 (PST)
MIME-Version: 1.0
References: <1606143915-25335-1-git-send-email-yanjunz@nvidia.com>
In-Reply-To: <1606143915-25335-1-git-send-email-yanjunz@nvidia.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 24 Nov 2020 09:26:18 +0100
Message-ID: <CAJ8uoz0wMroBhRig1uoSO0vXkpms+E6B7LwTK-HXd821XDZrbg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] xdp: remove the function xsk_map_inc
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

On Mon, Nov 23, 2020 at 4:07 PM Zhu Yanjun <yanjunz@nvidia.com> wrote:
>
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
>
> The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> always returns zero. As such, replacing this function with bpf_map_inc
> and removing the test code.

Applied it to bpf-next, compiled it and tested it and it passed. Thank
you Yanjun!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

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
