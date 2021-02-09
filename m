Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200AD3144CA
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 01:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhBIAUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 19:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229615AbhBIAUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 19:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D9F364E54;
        Tue,  9 Feb 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612830010;
        bh=+aijUeb2BPFTV5qIqqEcluGzW7BH5Bzs2IwcoAAUpAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePijIMKFZw5D4/EQdZRouGXcalvE6aFoasg/wkm7nAF/oBx6BS52WwUtLnwZUr2bw
         ygquDeJr/0+9MRWyW8NcBXizFtqWXT1fnf5ui5ttbgmTmc0wLL5ZiAR88b23iM+wwz
         Fw2FwPbzg75pLUGmErFB//BY/GgwQy5Ik2eFEqodyRy7j65sNk94TLeYwQVQJu4Inc
         ppCbwxJm81PBtcbUVBSJcacsnRNnp5DH/vWtmyvpVoku2UA3JarwBVVcHTHh1CILJD
         Zq2qxHDOqgkIF1bkLPrZpNz53XMtJCEElg26054B8gFFSvYkGSB9esPDAXmJ2izVph
         JteQVHNjAPnng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7EC25609D6;
        Tue,  9 Feb 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161283001051.26681.5623565979716838336.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 00:20:10 +0000
References: <20210206050240.48410-2-saeed@kernel.org>
In-Reply-To: <20210206050240.48410-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        mbloch@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  5 Feb 2021 21:02:24 -0800 you wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> Setting the source port requires only the E-Switch and vport number.
> Refactor the function to get those parameters instead of passing the full
> attribute.
> 
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/17] net/mlx5: E-Switch, Refactor setting source port
    https://git.kernel.org/netdev/net-next/c/b055ecf5827d
  - [net-next,V2,02/17] net/mlx5e: E-Switch, Maintain vhca_id to vport_num mapping
    https://git.kernel.org/netdev/net-next/c/84ae9c1f29c0
  - [net-next,V2,03/17] net/mlx5e: Always set attr mdev pointer
    https://git.kernel.org/netdev/net-next/c/275c21d6cbe2
  - [net-next,V2,04/17] net/mlx5: E-Switch, Refactor rule offload forward action processing
    https://git.kernel.org/netdev/net-next/c/9e51c0a62492
  - [net-next,V2,05/17] net/mlx5e: VF tunnel TX traffic offloading
    https://git.kernel.org/netdev/net-next/c/10742efc20a4
  - [net-next,V2,06/17] net/mlx5e: Refactor tun routing helpers
    https://git.kernel.org/netdev/net-next/c/6717986e15a0
  - [net-next,V2,07/17] net/mlx5: E-Switch, Indirect table infrastructure
    https://git.kernel.org/netdev/net-next/c/34ca65352ddf
  - [net-next,V2,08/17] net/mlx5e: Remove redundant match on tunnel destination mac
    https://git.kernel.org/netdev/net-next/c/4ad9116c84ed
  - [net-next,V2,09/17] net/mlx5e: VF tunnel RX traffic offloading
    https://git.kernel.org/netdev/net-next/c/a508728a4c8b
  - [net-next,V2,10/17] net/mlx5e: Refactor reg_c1 usage
    https://git.kernel.org/netdev/net-next/c/48d216e5596a
  - [net-next,V2,11/17] net/mlx5e: Match recirculated packet miss in slow table using reg_c1
    https://git.kernel.org/netdev/net-next/c/8e404fefa58b
  - [net-next,V2,12/17] net/mlx5e: Extract tc tunnel encap/decap code to dedicated file
    https://git.kernel.org/netdev/net-next/c/0d9f96471493
  - [net-next,V2,13/17] net/mlx5e: Create route entry infrastructure
    https://git.kernel.org/netdev/net-next/c/777bb800c696
  - [net-next,V2,14/17] net/mlx5e: Refactor neigh update infrastructure
    https://git.kernel.org/netdev/net-next/c/2221d954d984
  - [net-next,V2,15/17] net/mlx5e: TC preparation refactoring for routing update event
    https://git.kernel.org/netdev/net-next/c/c7b9038d8af6
  - [net-next,V2,16/17] net/mlx5e: Rename some encap-specific API to generic names
    https://git.kernel.org/netdev/net-next/c/021905f8067d
  - [net-next,V2,17/17] net/mlx5e: Handle FIB events to update tunnel endpoint device
    https://git.kernel.org/netdev/net-next/c/8914add2c9e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


