Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93C2318443
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 05:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBKESf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 23:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhBKES2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 23:18:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16CAF64D74;
        Thu, 11 Feb 2021 04:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613017067;
        bh=eSjD+9pdm7SNENusCDAKtJYA6Md0ExzGn2FWLqgp1Zw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K2DuBuYe9yGCbebb+aoj+OybG8SLEIEBbb5U3QtI5+S+SRZzcNlKgQrZeI1izk7R6
         mo1G1X5inl0A0R9OrSaAS+nDhQvLKnR1JUtwLHkDtKDw3CsCNhgLtPHiZX9CPtrx7S
         7SuBS+nrb5zMZRUylMGNxtQ0prqGfXyr344OygNQT8F+6lDKyQpuBgmSCo7LX/9YYP
         h22OLaEtdyv0QhcEgw9NR8ZGFp3DHLFjiSzysH/ooiZH5VvSqtycxXRs04MRZs97To
         swknSucyLtdPbHDjmGzeX5pugNOebCcvCqeJm3Fz+XUaZjD4JeFu6LgaKB4tgzzf4K
         mkYWBpiaZwgQw==
Message-ID: <e31fa9d634fc53ee806f4a59b9c0a5164c76122b.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Fix a NULL vs IS_ERR() check
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Wed, 10 Feb 2021 20:17:46 -0800
In-Reply-To: <ygnhczx8gngw.fsf@nvidia.com>
References: <YCO+NCjissLTG1H6@mwanda> <ygnhczx8gngw.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-10 at 13:40 +0200, Vlad Buslov wrote:
> On Wed 10 Feb 2021 at 13:06, Dan Carpenter <dan.carpenter@oracle.com>
> wrote:
> > The mlx5_chains_get_table() function doesn't return NULL, it
> > returns
> > error pointers so we need to fix this condition.
> > 
> > Fixes: 34ca65352ddf ("net/mlx5: E-Switch, Indirect table
> > infrastructure")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Thanks, Dan!
> 
> Reviewed-by: Vlad Buslov <vladbu@nvidia.com>

Applied to net-next-mlx5

Thanks!

