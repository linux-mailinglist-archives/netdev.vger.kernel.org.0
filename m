Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C921134B1F7
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 23:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCZWKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 18:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhCZWKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 18:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F1A92619E4;
        Fri, 26 Mar 2021 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616796617;
        bh=+VzW2HUmCN+MCTOL3D4+ygRqe318y4yxjNpfkGMjJXk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vBlNdZyaw6y/e2mQz43gSLfq37nYpsfUn3wScrblBnQuHSwDto2QTMARll1mrUWgi
         HRKiaEKcUnC7bhqaX+VXQI4tevvjkyJIWHFnyXptHeRwojjew3Ua+TyU+7APQEJDV/
         9bR2gYLEF74qecOYL6BBzD8/z5YkzhPJtzo1oWWu8DKV9f56ksOH3YMIuiojbMR+31
         u6sZ8bYd3hiIaieF05SYmfEI+Np+xd/Kz51lKi/C0qySmiNtgdpNLwNUnvPHRyDW+1
         n1mBf+abvpG2tSAon5j3Dpf8A8+vXPu0nJH+IlTCNGOZt1smj1jJkj2bO96bP4SH4N
         S4EThjd+S5g8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B02A060970;
        Fri, 26 Mar 2021 22:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/13] net/mlx5e: alloc the correct size for
 indirection_rqt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679661671.26244.10005078830938861176.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 22:10:16 +0000
References: <20210326025345.456475-2-saeed@kernel.org>
In-Reply-To: <20210326025345.456475-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, arnd@arndb.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 19:53:33 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> The cited patch allocated the wrong size for the indirection_rqt table,
> fix that.
> 
> Fixes: 2119bda642c4 ("net/mlx5e: allocate 'indirection_rqt' buffer dynamically")
> CC: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/13] net/mlx5e: alloc the correct size for indirection_rqt
    https://git.kernel.org/netdev/net-next/c/6def6e47e24f
  - [net-next,V2,02/13] net/mlx5e: Pass q_counter indentifier as parameter to rq_param builders
    https://git.kernel.org/netdev/net-next/c/6debae2a9d11
  - [net-next,V2,03/13] net/mlx5e: Move params logic into its dedicated file
    https://git.kernel.org/netdev/net-next/c/b3a131c2a160
  - [net-next,V2,04/13] net/mlx5e: Restrict usage of mlx5e_priv in params logic functions
    https://git.kernel.org/netdev/net-next/c/895649201845
  - [net-next,V2,05/13] net/mlx5e: Allow creating mpwqe info without channel
    https://git.kernel.org/netdev/net-next/c/ea886000a8ac
  - [net-next,V2,06/13] net/mlx5: Add helper to set time-stamp translator on a queue
    https://git.kernel.org/netdev/net-next/c/183532b77ddc
  - [net-next,V2,07/13] net/mlx5e: Generalize open RQ
    https://git.kernel.org/netdev/net-next/c/869c5f926247
  - [net-next,V2,08/13] net/mlx5e: Generalize RQ activation
    https://git.kernel.org/netdev/net-next/c/a8dd7ac12fc3
  - [net-next,V2,09/13] net/mlx5e: Generalize close RQ
    https://git.kernel.org/netdev/net-next/c/e078e8df4224
  - [net-next,V2,10/13] net/mlx5e: Generalize direct-TIRs and direct-RQTs API
    https://git.kernel.org/netdev/net-next/c/42212d997155
  - [net-next,V2,11/13] net/mlx5e: Generalize PTP implementation
    https://git.kernel.org/netdev/net-next/c/b0d35de441ab
  - [net-next,V2,12/13] net/mlx5e: Cleanup PTP
    https://git.kernel.org/netdev/net-next/c/e569cbd72924
  - [net-next,V2,13/13] net/mlx5: Fix spelling mistakes in mlx5_core_info message
    https://git.kernel.org/netdev/net-next/c/31a91220a27d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


