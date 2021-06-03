Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903ED39AB06
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 21:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFCTng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 15:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCTng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 15:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0265860FF1;
        Thu,  3 Jun 2021 19:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622749311;
        bh=gfW2NBT1gmkyoXmJ7xTyURuZARAwmYV7uxm6d+hE5HY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hYoU7cf/Ov0qbg09AcNg8DhcO5RA6zYHrnGn0Xk5nQea7DYGI+vJQjwqufzGVjHxA
         zMToXSCTOQmH9Lp53Tmsjnj5Tc89JJ5hwIVoknHsj5ddXQzNJOCuxNJcolXc4IpQ/o
         SWKBRKQ+FMKY05dbaiDS8gQ0J9IgOVZlREE0A7bqMa9awjH2nx4wb5QlrQX+d4qu87
         Fa4oCpt051CCLDrFqIs1xc1HRQisl83BHAYeUNm6SVTToPZDFpSYi5nLoVTKD4ilbr
         8BiT0gZdIEYb7QJrJpXbvE3wp3VIEzRYZgJec7cg4o/28npDsJfIUa0mfBFWOKAh9+
         8v9U5xKpGDlHg==
Message-ID: <17516f064a19ca009aa5b512fef33eb2c267c8b0.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: Remove the repeated declaration
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>
Date:   Thu, 03 Jun 2021 12:41:50 -0700
In-Reply-To: <1622451130-58224-1-git-send-email-zhangshaokun@hisilicon.com>
References: <1622451130-58224-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-05-31 at 16:52 +0800, Shaokun Zhang wrote:
> Function 'mlx5e_deactivate_rq' is declared twice, so remove the
> repeated declaration.
> 
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index b636d63358d2..d966d5f40e78 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -974,7 +974,6 @@ int mlx5e_open_rq(struct mlx5e_params *params,
> struct mlx5e_rq_param *param,
>                   struct mlx5e_xsk_param *xsk, int node,
>                   struct mlx5e_rq *rq);
>  int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
> -void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
>  void mlx5e_close_rq(struct mlx5e_rq *rq);
>  int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param
> *param);
>  void mlx5e_destroy_rq(struct mlx5e_rq *rq);
 
applied to net-next-mlx5

