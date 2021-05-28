Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D92393A41
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhE1Abl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234827AbhE1Abk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 20:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 85BC1613D1;
        Fri, 28 May 2021 00:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622161806;
        bh=QI3YYDL1u+DTIjbG4oMArcxXRpKWBJlQN3ofjc/rOqQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Otcvj/N1PU1KEggHZrOUlxaJ5Pl1zZa8cj5mF6VywBPAA6QTVtU1K8+tVtrk+1g0I
         u0ptZL4zdERu1mUqs0ajQZrXf4zBRFfKSRlHqfH5AESAoIOUTGBaAcoWEwnX71YB/k
         8TzCaxkXsJB6BpC7SzadG+u/DU4m+3axGsUYa+9rXGSkuQh6l9rKCGszmPOYopw0BQ
         3qjB9oDnAPOGLG56ROtQP53WjC00kNCuO2s1Ez9zGP+qWeOh/QU0Lny5sL3rNWgU2D
         evOIwEiRR/YteE9d6ap4O2c0E5qLv+b9mzmh1Ns39eP2ybd255zasgwlgh2tD03Z+F
         vyrqp/Cuel1JQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 76B6460BCF;
        Fri, 28 May 2021 00:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/15] net/mlx5e: CT, Remove newline from ct_dbg call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162216180648.24913.151372262887230116.git-patchwork-notify@kernel.org>
Date:   Fri, 28 May 2021 00:30:06 +0000
References: <20210527185624.694304-2-saeed@kernel.org>
In-Reply-To: <20210527185624.694304-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, roid@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 27 May 2021 11:56:10 -0700 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> ct_dbg() already adds a newline.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/15] net/mlx5e: CT, Remove newline from ct_dbg call
    https://git.kernel.org/netdev/net-next/c/74097a0dcd1e
  - [net-next,V2,02/15] net/mlx5: CT: Avoid reusing modify header context for natted entries
    https://git.kernel.org/netdev/net-next/c/7fac5c2eced3
  - [net-next,V2,03/15] net/mlx5e: TC: Use bit counts for register mapping
    https://git.kernel.org/netdev/net-next/c/ed2fe7ba7b9f
  - [net-next,V2,04/15] net/mlx5e: TC: Reserved bit 31 of REG_C1 for IPsec offload
    https://git.kernel.org/netdev/net-next/c/b973cf32453f
  - [net-next,V2,05/15] net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet
    https://git.kernel.org/netdev/net-next/c/c07274ab1ab2
  - [net-next,V2,06/15] net/mlx5e: RX, Remove unnecessary check in RX CQE compression handling
    https://git.kernel.org/netdev/net-next/c/2ef9c7c613cf
  - [net-next,V2,07/15] net/mlx5: DR, Remove unused field of send_ring struct
    https://git.kernel.org/netdev/net-next/c/b72ce870f57e
  - [net-next,V2,08/15] net/mlx5: Add case for FS_FT_NIC_TX FT in MLX5_CAP_FLOWTABLE_TYPE
    https://git.kernel.org/netdev/net-next/c/e01b58e9d5c4
  - [net-next,V2,09/15] net/mlx5: Move table size calculation to steering cmd layer
    https://git.kernel.org/netdev/net-next/c/04745afb2ae3
  - [net-next,V2,10/15] net/mlx5: Move chains ft pool to be used by all firmware steering
    https://git.kernel.org/netdev/net-next/c/4a98544d1827
  - [net-next,V2,11/15] net/mlx5: DR, Set max table size to 2G entries
    https://git.kernel.org/netdev/net-next/c/9e117998409c
  - [net-next,V2,12/15] net/mlx5: Cap the maximum flow group size to 16M entries
    https://git.kernel.org/netdev/net-next/c/71513c05a97f
  - [net-next,V2,13/15] net/mlx5: Remove unnecessary spin lock protection
    https://git.kernel.org/netdev/net-next/c/a546432f2f04
  - [net-next,V2,14/15] net/mlx5: Use boolean arithmetic to evaluate roce_lag
    https://git.kernel.org/netdev/net-next/c/2b1476752521
  - [net-next,V2,15/15] net/mlx5: Fix lag port remapping logic
    https://git.kernel.org/netdev/net-next/c/861364106361

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


