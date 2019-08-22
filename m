Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6AE99893
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 17:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389635AbfHVPwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 11:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfHVPwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 11:52:30 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB962089E;
        Thu, 22 Aug 2019 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566489149;
        bh=LSJs+hg+Esa9XzSaNnvzaRu1U+LN0W0QrCA9FzqpRw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/ddtJSGCGY64F5bIzbo8y00yVAkluyt6InZJmYvOD57H5NenPHuJBEPEhkukZ8gc
         DvazXl9gd4ISH3deV5OMqkLBdu7VPs8kPJAB/ECWq2+CfFStcSiPz3osr89Mafdgbq
         cGRFujZP8uT8CAJUVuzbNadmzl2Hups9aAOhlryU=
Date:   Thu, 22 Aug 2019 18:50:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Use PTR_ERR_OR_ZERO in
 mlx5e_tc_add_nic_flow()
Message-ID: <20190822155001.GG29433@mtr-leonro.mtl.com>
References: <20190822065219.73945-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822065219.73945-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 06:52:19AM +0000, YueHaibing wrote:
> Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
