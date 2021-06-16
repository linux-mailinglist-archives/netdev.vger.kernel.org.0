Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11BE3A91CB
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhFPGVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhFPGVn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 02:21:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78144613BF;
        Wed, 16 Jun 2021 06:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623824357;
        bh=BFEK30sTNGFcJp3RIsT5M5bMegNIg9neaNx3+8EdaIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qjLUpX2fF+Q3ihTJ9FOQc1Hcw9cy3Wf+zwnnyseYPYs5yh5KLhDv+T34MngYN6SPe
         g5ELxK/aWo64jspizP08eNANqORKispINDLVlFV/YP28JcMzitESF0d6oS1xe3IkYp
         cFN/EwKZcOBwGLW9eU8l6XRklrVzPReKcb81qhGXxdn6z1mFVmT8qZyHZSFhXc0zWX
         nahx0Zcam0Ryq9LtAsadtx0Hlax2PyDNoqKpSvxvxW9afN8LYHdD0dgaKCfTfVWNbP
         dn+RknkCTw96+LzYq/sh4KvOpZr5ZjtLnPHd6qvb00/7XYN4+NChYw9vrk2rcrfO4p
         i6lqb/T3wvMDA==
Date:   Wed, 16 Jun 2021 09:19:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     saeedm@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Fix missing error code in mlx5_init_fs()
Message-ID: <YMmX4ZvDfODFHUx2@unreal>
References: <1623754695-86508-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623754695-86508-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 06:58:15PM +0800, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-ENOMEM' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:2973 mlx5_init_fs()
> warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Can you please add fixes lines to your patches like all fix patches should?

Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all firmware steering")

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
