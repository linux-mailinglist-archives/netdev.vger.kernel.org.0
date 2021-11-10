Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D6944C30D
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhKJOh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231969AbhKJOh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:37:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E996112F;
        Wed, 10 Nov 2021 14:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636554911;
        bh=TOnxxz8GgNN2NO4MdQ81UlRwAWc6MK7a3d5+ZzVDMTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pS3evkkxDoV1tl//K1t4Tvdpvka+XcBYVlg/xdThsrhpMPf8jxKysQ6fHWJ6LHL3J
         CcL5hKYmqTRUvz7nKLT1Lpb3CBc3IU28iWUyPtauo9zPz966mzwhid4uuLuWoqN1rO
         eLEAXlTbW37WULTAdC/Vm0kMIUTZby8rc0WxwDTvvrfAC/6bGXbEYrINytTe2jDFz5
         tjwAG76ScdAPR+25Rt9Pbhyi8LHB6t7mJq2qNlH4db3eymS1oqODOf04jottD0p4SR
         dCyDqb8TXDG8uj9vnGnTP6AcIhMHD15y6ZWe0BidDvXUFVeC75gyfKTmFZz7xldszv
         gK/ebQoOlrxgw==
Date:   Wed, 10 Nov 2021 16:35:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: Lag, fix a potential Oops with
 mlx5_lag_create_definer()
Message-ID: <YYvYm/8xQkqP1cbD@unreal>
References: <20211110080706.GD5176@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110080706.GD5176@kili>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 11:07:06AM +0300, Dan Carpenter wrote:
> There is a minus character missing from ERR_PTR(ENOMEM) so if this
> allocation fails it will lead to an Oops in the caller.
> 
> Fixes: dc48516ec7d3 ("net/mlx5: Lag, add support to create definers for LAG")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
