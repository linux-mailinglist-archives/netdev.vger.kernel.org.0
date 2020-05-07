Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B6A1C8CA9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgEGNk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgEGNk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 09:40:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E62F20838;
        Thu,  7 May 2020 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588858826;
        bh=UzgNBysLz9JDcczUZ51lWGSanKbRt1nx1DOdn7L8VLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B8+665/amOfqX+AZzAZpoNB1jVLERWcpZV1jfYbCdHkF+L2aGhzBxVvYSzuKHNeXq
         CCgYJlftZECYx90082DWfC/gKtdtQWHFOYdkuA45fOeWj8NMzpNpvQJnd9+BFI6ZpS
         Ty1hDWHYl/LnL7Px0At+ZxY5H/lmdRwonm7vzaeg=
Date:   Thu, 7 May 2020 16:40:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, saeedm@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: Re: [PATCH] net/mlx5e: Use IS_ERR() to check and simplify code
Message-ID: <20200507134021.GC104730@unreal>
References: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 07:50:10PM +0800, Tang Bin wrote:
> Use IS_ERR() and PTR_ERR() instead of PTR_ZRR_OR_ZERO()
> to simplify code, avoid redundant judgements.
>
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
