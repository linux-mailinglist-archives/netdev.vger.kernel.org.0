Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC25338250
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhCLAaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhCLAaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0585F64FA0;
        Fri, 12 Mar 2021 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615509015;
        bh=ggTS/ELicy+Wvwfb3B6wHhcEivfIfOW9EY9YXj2SXOE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fa/MSYtxtiZL9cpcNl6ioKWpqkj92iLBB7f0kmZcC96agCrd+7pAV5QTZm9LaQJTv
         GlrJqAYJ1G7IYrZQ0qXzbmOgJJDcV+3u1Oiq2P67Pn+1Yo/qJkuSpVPVqZqfJyE+S5
         CPsqQteABVnAJoxbs9KX3xOhOijQc34UQrNsBUHG+3iscSqfuuV5VhVtpTLhowTZLO
         +iosRv2/f1GvBvZHMXrN3NLhwRsrvbAvF3mMxPFvWuLdSbd5g96KxAS8uu1PR1wCjQ
         cUTPSge9rIGPTeH4Db+PMRUE3UapTocgQKQtV9dkZh4xuqmc9zmWbEDu9s/ZujwaDy
         r9T1aDD9JER0A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F1E636096F;
        Fri, 12 Mar 2021 00:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Don't skip vport check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161550901498.18262.17694065791280917601.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 00:30:14 +0000
References: <20210311223723.361301-2-saeed@kernel.org>
In-Reply-To: <20210311223723.361301-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, elic@nvidia.com, leonro@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 14:37:09 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Users of mlx5_eswitch_get_vport() are required to check return value
> prior to passing mlx5_vport further. Fix all the places to do not skip
> that check.
> 
> Reviewed-by: Eli Cohen <elic@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Don't skip vport check
    https://git.kernel.org/netdev/net-next/c/7bef147a6ab6
  - [net-next,02/15] net/mlx5: Remove impossible checks of interface state
    https://git.kernel.org/netdev/net-next/c/d89edb360705
  - [net-next,03/15] net/mlx5: Separate probe vs. reload flows
    https://git.kernel.org/netdev/net-next/c/6dea2f7eff96
  - [net-next,04/15] net/mlx5: Remove second FW tracer check
    https://git.kernel.org/netdev/net-next/c/7e615b997802
  - [net-next,05/15] net/mlx5: Don't rely on interface state bit
    https://git.kernel.org/netdev/net-next/c/7ad67a20f28f
  - [net-next,06/15] net/mlx5: Check returned value from health recover sequence
    https://git.kernel.org/netdev/net-next/c/fe06992b04a9
  - [net-next,07/15] net/mlx5e: CT, Avoid false lock dependency warning
    https://git.kernel.org/netdev/net-next/c/76e68d950a17
  - [net-next,08/15] net/mlx5e: fix mlx5e_tc_tun_update_header_ipv6 dummy definition
    https://git.kernel.org/netdev/net-next/c/87f77a679797
  - [net-next,09/15] net/mlx5e: Add missing include
    https://git.kernel.org/netdev/net-next/c/5632817b144f
  - [net-next,10/15] net/mlx5: Fix indir stable stubs
    https://git.kernel.org/netdev/net-next/c/fbeab6be054c
  - [net-next,11/15] net/mlx5e: mlx5_tc_ct_init does not fail
    https://git.kernel.org/netdev/net-next/c/51ada5a52379
  - [net-next,12/15] net/mlx5: SF, Fix return type
    https://git.kernel.org/netdev/net-next/c/3094552bcd72
  - [net-next,13/15] net/mlx5e: rep: Improve reg_cX conditions
    https://git.kernel.org/netdev/net-next/c/03e219c4cf84
  - [net-next,14/15] net/mlx5: Avoid unnecessary operation
    https://git.kernel.org/netdev/net-next/c/61e9508f1e5e
  - [net-next,15/15] net/mlx5e: Alloc flow spec using kvzalloc instead of kzalloc
    https://git.kernel.org/netdev/net-next/c/9f4d9283388d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


