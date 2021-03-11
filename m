Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FC1336E5E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 09:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhCKI6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 03:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231759AbhCKI6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 03:58:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE55D64FAF;
        Thu, 11 Mar 2021 08:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615453111;
        bh=yYIE61zje/ydl7SY0eomGVI8O8IaPIjC/6GGNFKJhiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HaJCjeFTKvu48RIrTy3kqXigy72TXLGjJ5XU88/ljMzqNSFayZStuti6C0EZ4nlTs
         c/4Slo5fKClqm5w6bEFde7fWB72YTdKqUUQUurLSTDb9rAIIRPXi7Ys8cjW7cTGmTG
         qzseULJDnozMU/k7fWoZRCmkqqCpN1aAGyh5WHK9UbG4G8IexHka09nYty8+DJ0IHd
         bT6MrIspBazbiOpG4Ac6I0fryYPM/0g6LTNkXf7a8kx/uhDK63owgA6x4ywks1jPYy
         kHbTi+MYRz16IbEGUt9p99LmTpu63ZX2+y/njJJUU9yoq0jfITj7N9eYUce1j/dUnP
         w+dCtsRTp7HOg==
Date:   Thu, 11 Mar 2021 10:58:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 13/18] RDMA/mlx5: Fix timestamp default mode
Message-ID: <YEnbsx7aaIie1U0z@unreal>
References: <20210310190342.238957-1-saeed@kernel.org>
 <20210310190342.238957-14-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310190342.238957-14-saeed@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 11:03:37AM -0800, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
>
> 1. Don't set the ts_format bit to default when it reserved - device is
>    running in the old mode (free running).
> 2. XRC doesn't have a CQ therefore the ts format in the QP
>    context should be default / free running.
> 3. Set ts_format to WQ.
>
> Fixes: 2fe8d4b87802 ("RDMA/mlx5: Fail QP creation if the device can not support the CQE TS")
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>

I reviewed it too.

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
