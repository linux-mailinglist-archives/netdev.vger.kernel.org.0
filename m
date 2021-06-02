Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7EA39948D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFBUbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229568AbhFBUbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 16:31:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A11C60FF0;
        Wed,  2 Jun 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622665804;
        bh=2aqH9vPUZtBkfqNR6J3+fy9PWQmO0Cs/GR6igBW4M8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=evTqbaH7HpUQu+U7E1ZYhvBS9CUkpNU7JwtgxxDmfiYm0DdyHrVpKK2VLfc1rHzY0
         QJ//dTkZUr6cz9b+eqHpZSfSIZnej8GezoLmHr+yQrD/3gJw/ksAi2HQDwkGoggRKG
         RescVmCV5BG5IJmJC6394pw6VmRiYwHnqv8gmK6JkOHpdIyDIoUqWXCqkQPxHyrkFp
         2gqSBdDq+MMcPV2QFcWwmwUFT84lc7nf8elHJVi+4P9n0sgwUm1F2ytZIYoviS/vMU
         rl6Z79Czafo66mHjR39iH2W/c3ldxgqoLZeko358ZLtd+sZiMiigQPxNgwyf6+yy2V
         grfe8Rg/Q6cfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A871609D9;
        Wed,  2 Jun 2021 20:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/8] net/mlx5e: Fix incompatible casting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266580456.6825.5582815229746730103.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 20:30:04 +0000
References: <20210602013723.1142650-2-saeed@kernel.org>
In-Reply-To: <20210602013723.1142650-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, ayal@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  1 Jun 2021 18:37:16 -0700 you wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Device supports setting of a single fec mode at a time, enforce this
> by bitmap_weight == 1. Input from fec command is in u32, avoid cast to
> unsigned long and use bitmap_from_arr32 to populate bitmap safely.
> 
> Fixes: 4bd9d5070b92 ("net/mlx5e: Enforce setting of a single FEC mode")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,1/8] net/mlx5e: Fix incompatible casting
    https://git.kernel.org/netdev/net/c/d8ec92005f80
  - [net,2/8] net/mlx5e: Disable TLS offload for uplink representor
    https://git.kernel.org/netdev/net/c/b38742e41177
  - [net,3/8] net/mlx5: Check firmware sync reset requested is set before trying to abort it
    https://git.kernel.org/netdev/net/c/5940e64281c0
  - [net,4/8] net/mlx5e: Check for needed capability for cvlan matching
    https://git.kernel.org/netdev/net/c/afe93f71b5d3
  - [net,5/8] net/mlx5e: Fix adding encap rules to slow path
    https://git.kernel.org/netdev/net/c/2a2c84facd4a
  - [net,6/8] net/mlx5e: Fix HW TS with CQE compression according to profile
    https://git.kernel.org/netdev/net/c/256f79d13c1d
  - [net,7/8] net/mlx5e: Fix conflict with HW TS and CQE compression
    https://git.kernel.org/netdev/net/c/5349cbba754e
  - [net,8/8] net/mlx5: DR, Create multi-destination flow table with level less than 64
    https://git.kernel.org/netdev/net/c/216214c64a8c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


