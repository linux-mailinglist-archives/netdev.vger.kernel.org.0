Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F82301043
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbhAVWoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730336AbhAVTnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 14:43:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B1823A6A;
        Fri, 22 Jan 2021 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611344589;
        bh=XimOf5HzWmXgSkGk2FLmJHRoZs4EdRWdqlzT9yWj2WA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jDA5ONXyO1MZAvQbXgumM6RmMwlwCJaRMkc0F0IIWS8yLsgWhzYcCWpgGVDLO5JNh
         fpjeorTL0bMFgzMYTpZP4W9O8L2iFGpUuvxLGpx2Q+VbsCZFtJuGpjTBrNHLiPjWcj
         cCMN6+ruwA+OgdJUXq7GqVVKUzCygnu1B2gMUzU89E+jfucZeBdyQtAP57EAjem9mT
         7CK9zqvh5ps9gPQM1srIuA1qGtPpe3/YywRFsgwt59cDolD7gyHyKUZokdDzpxp1ZN
         h4RRlva6l0dJbDOKYADhzlF9wioknCJ7oTOBkCS2l3APdxgWGIDc2j3MsKaTe2FZEn
         z6E/XMUEC99+Q==
Message-ID: <d166990f4e2e46dab4fccd66b95dad5641a744a2.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: free page before return
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>, Pan Bian <bianpan2016@163.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Moshe Tal <moshet@mellanox.com>, Joe Perches <joe@perches.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 22 Jan 2021 11:43:08 -0800
In-Reply-To: <20210121174938.GG320304@unreal>
References: <20210121045830.96928-1-bianpan2016@163.com>
         <20210121174938.GG320304@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-21 at 19:49 +0200, Leon Romanovsky wrote:
> On Wed, Jan 20, 2021 at 08:58:30PM -0800, Pan Bian wrote:
> > Instead of directly return, goto the error handling label to free
> > allocated page.
> > 
> > Fixes: 5f29458b77d5 ("net/mlx5e: Support dump callback in TX
> > reporter")
> > Signed-off-by: Pan Bian <bianpan2016@163.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Applied to net-mlx5,
Thanks!

