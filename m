Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBEE3E459C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbhHIM3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235212AbhHIM3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 08:29:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA9260FE3;
        Mon,  9 Aug 2021 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628512131;
        bh=LLg51HRIq7Mmpxmm8W2DeimrABUyMecgOPajN6zVOXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RlHnQy4KEBfJ3yxtNjdG7cfdLg3DB2ctqY+Kek8emQ/uRwPALI91BYDG+dVKPHU/O
         AkYCsJC7qStogt2A7juq5ww8Bmf6fGrlZw9h2EdQv7QnMLLiHF7xYo9VJMfuJoUjyM
         ZQdtAxwgTXBW/fAe4TXVJVFR3JvhfCHTT8dsg/ecvwIJtVDVQRzZxbRKLwJ26p2gzx
         D/QcO51a/7fIHGZhYRhyQF+pCdQL+YVgHPmt88FjqH4K91PPEaCAHsV2pkO9UGnzg2
         NFUtfyvSBpCgkRgVAr0SiiU9etGm6fNyNOc2PJsjpN3zixyc+lN0ReYzKKBHDROjU7
         fvh+opKdJ/8bQ==
Date:   Mon, 9 Aug 2021 15:28:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5e: Make use of mlx5_core_warn()
Message-ID: <YREff0Sb1tuwBbaS@unreal>
References: <20210809121931.2519-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809121931.2519-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 08:19:31PM +0800, Cai Huoqing wrote:
> to replace printk(KERN_WARNING ...) with mlx5_core_warn() kindly
> if we use mlx5_core_warn(), the prefix "mlx5:" not needed
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
