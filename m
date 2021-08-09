Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DED23E45F4
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhHIMzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233342AbhHIMzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 08:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D1160E93;
        Mon,  9 Aug 2021 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628513727;
        bh=goyNV0dh5z6ygkAwPBtdx6a291XVZbo5q+p9jLcUp5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o2YSQJxmqTiFnQhOxhRd0NLTq++v3XY+m7+7H5EsqgMaZDkDBlSYCgaZa/a0xBuip
         QUwP/NbzUmRKkZtwH0QT2egzf1NNaGqdUBlfrWX3AlGnwzz6sH2t6DnmJ+vuV9mUPs
         CkXV27g2HiXlsWcGJXI3q49zbxTErDycTaxGn3X6j1xLjBF38B19mhePKRp19ZC2G1
         /VdcvU47nGenoydRtgwE4GhHu9vpzJeJZWA9tK/n/CMwUl4p6PBGI3jeQAypugDbGK
         rINCdlOhKdtZmT+azQVcLtJnVDi8XZSZ4brReK9e47T0FEbOItLIGv8P2zUJUXX4pD
         pb+DQY+/6wd0A==
Date:   Mon, 9 Aug 2021 15:55:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH net-next] devlink: Fix port_type_set function pointer
 check
Message-ID: <YREluouPS6v5kpTP@unreal>
References: <97f68683b3b6c7ea8420c64817771cdedfded7ae.1628510543.git.leonro@nvidia.com>
 <162851280563.13993.17604581060971290077.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162851280563.13993.17604581060971290077.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 12:40:05PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):a

Dave, thanks a lot for your fast response.

> 
> On Mon,  9 Aug 2021 15:03:19 +0300 you wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Fix a typo when checking existence of port_type_set function pointer.
> > 
> > Fixes: 82564f6c706a ("devlink: Simplify devlink port API calls")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net-next] devlink: Fix port_type_set function pointer check
>     https://git.kernel.org/netdev/net-next/c/2a2b6e3640c4
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 
