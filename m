Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F822FF266
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389167AbhAURub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388179AbhAURuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 12:50:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18DA7207C5;
        Thu, 21 Jan 2021 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611251381;
        bh=q47TsziiuHREj7VxUa6dHIThjn23RfAisk8X3eojDac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fq2MhBjBUSfg/khaKz8XaxgTaHt1FEfg5aQjkg9PftqoTLWHKrvCHSsOPdOB39XBd
         kDj4m/IqIzFpangxVOnOeQY2ybrLM9TKZ5MXgenmSBmdX/4llLbKmyjke1b+lpgwPp
         3ChmBj4iVg//8FqL2p/VQ/EHmZ0eu8IBQgmH3g/bxlUg2sav6oNNelDxkrJZqj10it
         xxiJhfIyVJiah3FygFYRJsDU0Tp59bahmLAgMdcO5BLuuzD/po8eOuYcEwFi9GLP3P
         vxBAhgajYtrVZRRspOrTgsHArvtiXVJJf3mbDWI6v6IW9hNyPmQl3QMWTAa5NESckZ
         OXPgTC7yoXj1A==
Date:   Thu, 21 Jan 2021 19:49:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Pan Bian <bianpan2016@163.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Moshe Tal <moshet@mellanox.com>, Joe Perches <joe@perches.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: free page before return
Message-ID: <20210121174938.GG320304@unreal>
References: <20210121045830.96928-1-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121045830.96928-1-bianpan2016@163.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 08:58:30PM -0800, Pan Bian wrote:
> Instead of directly return, goto the error handling label to free
> allocated page.
>
> Fixes: 5f29458b77d5 ("net/mlx5e: Support dump callback in TX reporter")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
