Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BF02C053C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 13:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbgKWMLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 07:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbgKWMLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 07:11:09 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28747C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 04:11:08 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id f12so4211561oto.10
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 04:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=kNYD7tU2FkkDCamcofYBHHM0yWmu6sghfg0fn6PxKOQ=;
        b=P1fLZ4l9mW1lMjjA8DgQOt+DNvp6yejvlIz/BMIXKu1PovM1cAu1BQS1LbojeUNpEZ
         Iefb1JskwaaOJ3DFcFo/HcypFUnuLoZ+Op3+CfYvtXIz63v/xKRHGem47fZ6IS1Wp3GX
         iJimusFEjfOwuO9LYmawnr/rOlBJCTAggFeZfA5qsaz3S+DqKXF132in3RGNANggyIHC
         le3tz2dtqZbGhzaMbvQU+McesbCM44FPanBxGW95HA6Mff/cE/h88VWW0wSAYgDHEjdx
         VjlMH/jae+6qm7b4MF3Ysrc6ewjKe6pRa0nw8L2b+Y/pKd8Z3sgqSQ6NuKGxV/H0uuL1
         tlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=kNYD7tU2FkkDCamcofYBHHM0yWmu6sghfg0fn6PxKOQ=;
        b=DAkO1m7eB2v29SF2I/XgzkxNBf28sFZHO8OabamuTEhtLgZTw/UbRRfo/AvQTWTvDh
         JV2fX/mLFg+pZmC5Vm/3VlSIIeoQRjH+NAcZHLvuWM9F+CsNBBOk/Ue5FDTI7JoHXAY/
         3hAk8CDuj1lxPentaZzzQnFJp+exroJYq4ArW3YbDeVzB5ANF/ACNrn43pd4FtMfYJMp
         pitQcdfUtSlEVH3KJjitl9SHXLobyKG/BkU/tdi0Fs2f014vTyLsqhq3IuC/GdWKJr7R
         38g9WPR8vLJnn7hegbmZJCg6fYV8rPQ7hWyvlFElS9+R8LXvjczM1s0ay3DVcO5+UZoR
         fNhg==
X-Gm-Message-State: AOAM5308tsQl+FpU2yjUD3pMSOM2Wj5VOx9ZvTwI89ZhY7EjiKSzTh4c
        QaRuypxYWPXm1BpnoRWdlduxIl1uWbvp3UbmMHw=
X-Google-Smtp-Source: ABdhPJwHDEy6U7dUzJaDWh//ZBu9Q2Uwn1usG+ObJPk6jLpBEOYAXtI1r7QwVhPUIsWfAQ8XyJlOlOAxVnba8v/d1hM=
X-Received: by 2002:a05:6830:d7:: with SMTP id x23mr21910586oto.59.1606133467610;
 Mon, 23 Nov 2020 04:11:07 -0800 (PST)
MIME-Version: 1.0
References: <20201123120531.724963-1-zyjzyj2000@gmail.com>
In-Reply-To: <20201123120531.724963-1-zyjzyj2000@gmail.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Mon, 23 Nov 2020 20:10:56 +0800
Message-ID: <CAD=hENfysbUCNapfFZ6i0tOFo5Ge3QS+iQSt2ySBDb10zFdgwg@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] xdp: remove the function xsk_map_inc
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 8:05 PM <zyjzyj2000@gmail.com> wrote:
>
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
>
> The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> always returns zero. As such, replacing this function with bpf_map_inc
> and removing the test code.
>
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>


> ---
>  net/xdp/xsk.c    |  1 -
>  net/xdp/xsk.h    |  1 -
>  net/xdp/xskmap.c | 13 +------------
>  3 files changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index cfbec3989a76..c1b8a888591c 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -548,7 +548,6 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
>         node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
>                                         node);
>         if (node) {
> -               WARN_ON(xsk_map_inc(node->map));
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

Hi, Magnus

The function xsk_map_inc is replaced with bpf_map_inc.

Zhu Yanjun

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
