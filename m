Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90F2170E29
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 03:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgB0CDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 21:03:35 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:43607 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbgB0CDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 21:03:35 -0500
Received: by mail-qv1-f67.google.com with SMTP id p2so808314qvo.10
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 18:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dj3JZX0q2OpOOXag2h/QC53oxoboWgqRwB4PESV/rCs=;
        b=Z0LRS+HYsvTxuPtTio2pS3YEoq0lCNakoa+EDNWzCCW+g1lx3tIlvDdZgCB/xNBzbu
         LHf84sMIx6A6LDZwglRupbC5lms0jk5REHmqUrQh+1el5/OqadRL7MwKqvdvUpaGJk4Y
         2+koVjB94HUPSMT3aSxID26J+HlsOBbVNpivWzj2mbBiOXYAWDoAYnbVIMRmy3/K4Nf4
         RoiXRnwra4EJLMG1JCnquLkIM41pLGkkoJvj8j5fbaMEL1+2g79rWByBH2zAmLbIkse0
         +epV9SOUCFRJ8lxXFKoD2q+UEZCFArHmq4/OGUIbcu52SMAccoW7HbiZZu5ydFFb8DPo
         9e9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dj3JZX0q2OpOOXag2h/QC53oxoboWgqRwB4PESV/rCs=;
        b=F/vtuGnxBZo6xoKOd0s7X2sDZo1mVP3wiQdcMtNnS+NwBUx2ze3FaCSfenlCv6HYBW
         vMFyb2PTRzwVLcZJPfluF//kJZl2CiiQjElJl+SwhyxavOJ4aGGfq5tHoPrPcs2VHzdJ
         W/48+GYgGwAX4TseaPcDLJzoR7y01yfSqWfMRlxe+reVmfVndmpNAYjsVnq+CmUVVG4W
         0G3MxdJODrlPjPWmXae1zhrWmj+thnj2+EGFS1orNN+j71Og0Y4FdleA3SC1efflR9yv
         xtCtRUS/s4u7rDp4PKOj6XLIGkCUCzycxwL8FwMExYga1TlzY+H60ckDvH/Ab2ZysM/M
         kivA==
X-Gm-Message-State: APjAAAWjzvSDshP0wMumHIYaKA0jdiUnPF/+1BikCm2mGo+ORcRwhsJP
        cvt4uKsQbFEcnHDg4nOOzawUT20PEQrvenfIf1c=
X-Google-Smtp-Source: APXvYqz342qU6CWnSjwTgN/IhtZAmssfGzfIp3hSvDhjR5YmHyCNzQ3O9R2dw4n4uBoej2Qb5xJZf5HwRq4oMrYxns8=
X-Received: by 2002:a0c:fe10:: with SMTP id x16mr2258531qvr.188.1582769013728;
 Wed, 26 Feb 2020 18:03:33 -0800 (PST)
MIME-Version: 1.0
References: <1582646588-91471-1-git-send-email-xiangxia.m.yue@gmail.com>
 <5361639fee997ea6239d6115978f86f26fb918b4.camel@mellanox.com> <5c4604cd-1cfc-6116-12e6-95054e77736a@mellanox.com>
In-Reply-To: <5c4604cd-1cfc-6116-12e6-95054e77736a@mellanox.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 27 Feb 2020 10:02:57 +0800
Message-ID: <CAMDZJNV1PVZ7NYp7KZiq_WsZrXOse5=sAHv=HAe_5mVtrGZSfA@mail.gmail.com>
Subject: Re: [net-next] net/mlx5e: Remove the unnecessary parameter
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 5:53 PM Paul Blakey <paulb@mellanox.com> wrote:
>
>
> On 2/26/2020 12:50 AM, Saeed Mahameed wrote:
> > On Wed, 2020-02-26 at 00:03 +0800, xiangxia.m.yue@gmail.com wrote:
> >> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>
> >> The parameter desired_size is always 0, and there is only one
> >> function calling the mlx5_esw_chains_get_avail_sz_from_pool.
> >> Deleting the parameter desired_size.
> > Paul, what is the reasoning behind desired size, i confirm that it  is
> > not actually used right now, do we have a pending patch that needs it
> > ?
> > if this is not going to happen in the near future i vote to apply this
> > patch and bring it back when needed.
>
> Right, it will be used in a following patch that reduces the size given for nft flow tables.
>
> I planned on submitting it after connection tracking offload is complete, but it can be sent now.
Hi, Paul, and Saeed
The function will be used, so my patch is unnecessary. Thanks for explaining.
> This is the patch:
>
> From 66d3cb9706ed09f00150a42f555a51404602bba4 Mon Sep 17 00:00:00 2001
> From: Paul Blakey <paulb@mellanox.com>
> Date: Wed, 8 Jan 2020 14:31:53 +0200
> Subject: [PATCH] net/mlx5: Allocate smaller size tables for ft offload
>
> Instead of giving ft tables one of the largest tables available - 4M,
> give it a more reasonable size - 64k. Especially since it will
> always be created as a miss hook in the following patch.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
> index 3990066..dabbc05 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
> @@ -39,6 +39,7 @@
>                                           1 * 1024 * 1024,
>                                           64 * 1024,
>                                           128 };
> +#define ESW_FT_TBL_SZ (64 * 1024)
>
>  struct mlx5_esw_chains_priv {
>         struct rhashtable chains_ht;
> @@ -205,7 +206,9 @@ static unsigned int mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
>                 ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
>                                   MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
>
> -       sz = mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
> +       sz = (chain == mlx5_esw_chains_get_ft_chain(esw)) ?
> +            mlx5_esw_chains_get_avail_sz_from_pool(esw, ESW_FT_TBL_SZ) :
> +            mlx5_esw_chains_get_avail_sz_from_pool(esw, POOL_NEXT_SIZE);
>         if (!sz)
>                 return ERR_PTR(-ENOSPC);
>         ft_attr.max_fte = sz;
> --
> 1.8.3.1
>
>
> >
> > Thanks,
> > Saeed.
> >
> >> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >> ---
> >>  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c | 11
> >> +++--------
> >>  1 file changed, 3 insertions(+), 8 deletions(-)
> >>
> >> diff --git
> >> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
> >> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
> >> index c5a446e..ce5b7e1 100644
> >> ---
> >> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
> >> +++
> >> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
> >> @@ -134,19 +134,14 @@ static unsigned int
> >> mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
> >>      return FDB_TC_LEVELS_PER_PRIO;
> >>  }
> >>
> >> -#define POOL_NEXT_SIZE 0
> >>  static int
> >> -mlx5_esw_chains_get_avail_sz_from_pool(struct mlx5_eswitch *esw,
> >> -                                   int desired_size)
> >> +mlx5_esw_chains_get_avail_sz_from_pool(struct mlx5_eswitch *esw)
> >>  {
> >>      int i, found_i = -1;
> >>
> >>      for (i = ARRAY_SIZE(ESW_POOLS) - 1; i >= 0; i--) {
> >> -            if (fdb_pool_left(esw)[i] && ESW_POOLS[i] >
> >> desired_size) {
> >> +            if (fdb_pool_left(esw)[i])
> >>                      found_i = i;
> >> -                    if (desired_size != POOL_NEXT_SIZE)
> >> -                            break;
> >> -            }
> >>      }
> >>
> >>      if (found_i != -1) {
> >> @@ -198,7 +193,7 @@ static unsigned int
> >> mlx5_esw_chains_get_level_range(struct mlx5_eswitch *esw)
> >>              ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
> >>                                MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
> >>
> >> -    sz = mlx5_esw_chains_get_avail_sz_from_pool(esw,
> >> POOL_NEXT_SIZE);
> >> +    sz = mlx5_esw_chains_get_avail_sz_from_pool(esw);
> >>      if (!sz)
> >>              return ERR_PTR(-ENOSPC);
> >>      ft_attr.max_fte = sz;
