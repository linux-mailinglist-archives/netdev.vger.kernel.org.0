Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7CC3DD239
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhHBIom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232433AbhHBIol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:44:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6EF860F36;
        Mon,  2 Aug 2021 08:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627893872;
        bh=a0Ol5FJYZBzvBSF9YKlHzeUAeulWHdHeemhy3uNTjrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pBUo81o9OOSOUC0vY6YZmcipzwLrswYka5Q7J+jswL9VfoiLzsJsHnqbR5VzDuapi
         NjDyHtsXBPgvLcuUSMWBei15L/6oCmhEMcIIRvHg2yztbvN+qdgsg+NSKZVefAJGh0
         fPrvrDpMJcBhPv7qzzwdjEzz6VFSLeSAb85sSEdVfOoDVssjkhzrj26gP1lgwI3N3S
         aomd3IuCeJAUn+rcF7K8vumPosmKyDfJ8vwK3q82tN/UDu6dH/eVV+6IOBy7R7XHsj
         T7HO00Sld1CLTYV6n9cjCOlLH0+r1mshenBoGTSYXryUX6M6PR0r2NMEHbjCNBGLHp
         jlrhpJmDtF8RQ==
Date:   Mon, 2 Aug 2021 11:44:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx4: make the array states static const, makes
 object smaller
Message-ID: <YQewbbja21ZhIMSb@unreal>
References: <20210801153742.147304-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210801153742.147304-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 01, 2021 at 04:37:42PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array states on the stack but instead it
> static const. Makes the object code smaller by 79 bytes.
> 
> Before:
>    text   data   bss    dec    hex filename
>   21309   8304   192  29805   746d drivers/net/ethernet/mellanox/mlx4/qp.o
> 
> After:
>    text   data   bss    dec    hex filename
>   21166   8368   192  29726   741e drivers/net/ethernet/mellanox/mlx4/qp.o
> 
> (gcc version 10.2.0)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
