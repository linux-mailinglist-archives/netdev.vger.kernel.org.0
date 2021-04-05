Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43B7353B6C
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 06:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhDEE4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 00:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhDEE4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 00:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DCBD61398;
        Mon,  5 Apr 2021 04:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617598592;
        bh=+mT7vLUpr0Gsv7CH1emi8bLbPh44eSZgYFXVqFmnrzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W5LWzUsySe1SPTt0KYwWzYadWe5Tivw20opmGDHCkg17QKYM+6dU90/65MN0ZRYiJ
         xYJh/0wt6TrvESQ0tGHQAVVPoolXCqLp83ZLvSTpKYzcUxjIZuD+QAqJp2hTnr5lT/
         LXbakAvGxGyVNmhHNWg6E/wjgXur0fYrLwTyQCG44fZLyMGG5U/NUcvqUzKZiIhHow
         dEqLEYKw43Dd54JBPngE4P0MJYsszzP/ruGH52OC7U0+gkJs2Fc/Vp4YlgLNM/P7l1
         AR+6xScOU3GK1UPkEg+n7RuRyZTh3oeBk2i+qpsVa2pif1DJUyVxkictJKQlMrEtKN
         etKmtjYR8Cz/A==
Date:   Mon, 5 Apr 2021 07:56:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, vladbu@nvidia.com,
        dlinkin@nvidia.com, saeedm@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, roid@nvidia.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        xiaoqian9@huawei.com
Subject: Re: [PATCH] net/mlx5: fix kfree mismatch in indir_table.c
Message-ID: <YGqYfcCMWTW8fN7U@unreal>
References: <20210405025339.86176-1-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405025339.86176-1-nixiaoming@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 10:53:39AM +0800, Xiaoming Ni wrote:
> Memory allocated by kvzalloc() should be freed by kvfree().
> 
> Fixes: 34ca65352ddf2 ("net/mlx5: E-Switch, Indirect table infrastructur")
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/esw/indir_table.c  | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
