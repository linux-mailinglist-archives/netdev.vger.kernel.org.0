Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6280D306BAB
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhA1Daz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229748AbhA1Dax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 22:30:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B22860C3D;
        Thu, 28 Jan 2021 03:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611804612;
        bh=pFswRmaJO3wfs7d9hRAuNWxce+ovqODxhR7NImbh3Ro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fjptVe/HODWVet8CwDSAqPERqnOevS03VQfN6SBQD59w/Tw7ayWbgnlF1Yx3I73Oq
         2iWIXOeDQKUqKraM3G5qEQspPF4NVdbi2SJ4mWuZLqJowwFu0DL0muBdKLvDMxySFE
         j4T2+hF2eCCv9ytDZ76GM4q3c35vFceeWYFpMoBZVdLjVVBPIVjuvkcQsaolE5dPwp
         W+fkTJQY3UBN1mTaTSuXKo8B1+q3nyaX91fS2M19I/rPqVw18e/R5NmGhPxrejXXs7
         Z18Cx0pSPTLG1vBS72PKMHQgkHqLJr0Hgt7PQQu22opHlwFrPibD6kIhXL5GzzWpRY
         eLzsa7sJAkueA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 89BF565307;
        Thu, 28 Jan 2021 03:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/12] net/mlx5: Fix memory leak on flow table creation error
 flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180461255.10551.14683896693302400823.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 03:30:12 +0000
References: <20210126234345.202096-2-saeedm@nvidia.com>
In-Reply-To: <20210126234345.202096-2-saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        roid@nvidia.com, maord@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 26 Jan 2021 15:43:34 -0800 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> When we create the ft object we also init rhltable in ft->fgs_hash.
> So in error flow before kfree of ft we need to destroy that rhltable.
> 
> Fixes: 693c6883bbc4 ("net/mlx5: Add hash table for flow groups in flow table")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,01/12] net/mlx5: Fix memory leak on flow table creation error flow
    https://git.kernel.org/netdev/net/c/487c6ef81eb9
  - [net,02/12] net/mlx5e: E-switch, Fix rate calculation for overflow
    https://git.kernel.org/netdev/net/c/1fe3e3166b35
  - [net,03/12] net/mlx5e: free page before return
    https://git.kernel.org/netdev/net/c/258ed19f075f
  - [net,04/12] net/mlx5e: Reduce tc unsupported key print level
    https://git.kernel.org/netdev/net/c/48470a90a42a
  - [net,05/12] net/mlx5e: Fix IPSEC stats
    https://git.kernel.org/netdev/net/c/45c9a30835d8
  - [net,06/12] net/mlx5: Maintain separate page trees for ECPF and PF functions
    https://git.kernel.org/netdev/net/c/0aa128475d33
  - [net,07/12] net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is disabled
    https://git.kernel.org/netdev/net/c/156878d0e697
  - [net,08/12] net/mlx5e: Fix CT rule + encap slow path offload and deletion
    https://git.kernel.org/netdev/net/c/89e394675818
  - [net,09/12] net/mlx5e: Correctly handle changing the number of queues when the interface is down
    https://git.kernel.org/netdev/net/c/57ac4a31c483
  - [net,10/12] net/mlx5e: Revert parameters on errors when changing trust state without reset
    https://git.kernel.org/netdev/net/c/912c9b5fcca1
  - [net,11/12] net/mlx5e: Revert parameters on errors when changing MTU and LRO state without reset
    https://git.kernel.org/netdev/net/c/8355060f5ec3
  - [net,12/12] net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable
    https://git.kernel.org/netdev/net/c/e2194a1744e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


