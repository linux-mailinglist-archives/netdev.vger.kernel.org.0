Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DAD2ACFC8
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgKJGfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:35:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKJGfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 01:35:50 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09C7A20731;
        Tue, 10 Nov 2020 06:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604990150;
        bh=Csm4wo04kR1Ui5qcsZwBMQttwacgnFppjmbbdnCPId4=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=MKM2qtAKESCYUnNlJ8VPPVt9ao8A3icQcESohPrMqqn/R4HsfVpJD84QnrEbTuCoo
         /0S6ml5H2g9vUkfAYjuaus3x8R8J54hykODyCLO9WoniC76RCCqUP5iGrSUTwDY7yz
         VGLLGQ+x4Bptz5Ob5RsiJQ6w3ZJN/UfJKdWlUrXc=
Message-ID: <48de4584fecb4dd9c2db3a1de1a754d8a0e079c7.camel@kernel.org>
Subject: Re: [PATCH 1/1] net/mlx5e: remove unnecessary memset
From:   Saeed Mahameed <saeed@kernel.org>
To:     Zhu Yanjun <yanjunz@nvidia.com>, leon@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 09 Nov 2020 22:35:48 -0800
In-Reply-To: <1604721272-23314-1-git-send-email-yanjunz@nvidia.com>
References: <1604721272-23314-1-git-send-email-yanjunz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-07 at 11:54 +0800, Zhu Yanjun wrote:
> Since kvzalloc will initialize the allocated memory, it is not
> necessary to initialize it once again.
> 
> Fixes: 11b717d61526 ("net/mlx5: E-Switch, Get reg_c0 value on CQE")
> Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git
> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 1bcf260..35c5629 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -1528,7 +1528,6 @@ static int esw_create_restore_table(struct
> mlx5_eswitch *esw)
>  		goto out_free;
>  	}
>  
> -	memset(flow_group_in, 0, inlen);
>  	match_criteria = MLX5_ADDR_OF(create_flow_group_in,
> flow_group_in,
>  				      match_criteria);
>  	misc = MLX5_ADDR_OF(fte_match_param, match_criteria,

applied to net-next-mlx5,
Thank you !

