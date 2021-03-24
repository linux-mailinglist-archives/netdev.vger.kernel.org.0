Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7452348472
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhCXWS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232286AbhCXWSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 18:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 885E9619BB;
        Wed, 24 Mar 2021 22:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616624322;
        bh=iA6i6r2UQHk+W1NdA/U5j6cKVWYnHcV6RQbV8Dze9/o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YBwF5E4dK4We9Y28Is1bG5pTcGrlIn0/ahGBonIFARyh8YWrcnXvjag3u3rJH8wrC
         dOK1YKd97xrLRWRxXgUN3T7qt+j5G1qKqS0MbOZKgMOytN3HmWP5HQNpE8F1QD0v43
         5z8RJVuDNolFKH0ye/fnROak4HyngjNmvwfOwA7rIetSY8r7q8BmDux+9lbhRMQ4Y/
         2D6vLqY3Gm558oPtnD8cZOZdjAPY63yERJY3f56ffK5GmSchAMQHjEexhLLy3/jEiS
         9BxV8k1q8ZN3tUJbCTCrAyYW3zMjp8viDVhmlh/NmTcC/6fGVtG6QXSeBCSvMt+I2j
         elTuHkEUkg8Fg==
Message-ID: <ec77b59eefe91545d9aa74d3a19f931a0a23ad8e.camel@kernel.org>
Subject: Re: [PATCH][next] net/mlx5: Fix spelling mistakes in mlx5_core_info
 message
From:   Saeed Mahameed <saeed@kernel.org>
To:     Colin King <colin.king@canonical.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 24 Mar 2021 15:18:40 -0700
In-Reply-To: <20210315123004.9957-1-colin.king@canonical.com>
References: <20210315123004.9957-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-15 at 12:30 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are two spelling mistakes in a mlx5_core_info message. Fix
> them.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> index a0a851640804..9ff163c5bcde 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -340,7 +340,7 @@ static int mlx5_health_try_recover(struct
> mlx5_core_dev *dev)
>                 return -EIO;
>         }
>  
> -       mlx5_core_info(dev, "health revovery succeded\n");
> +       mlx5_core_info(dev, "health recovery succeeded\n");
>         return 0;
>  }
>  

Applied to net-next-mlx5, sorry for the delay.


