Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD68748765E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbiAGLUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 06:20:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50992 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347045AbiAGLUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 06:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 207D2B82587
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 11:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6E04C36AF4;
        Fri,  7 Jan 2022 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641554410;
        bh=c9AA4aeHQBOxn8PvoM8310S8VMA7fAQbPZMtpkKkr+w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pq5z1/xUahtuWYJV8LJpqFhq4X7oVGOkM6dK7+zuv0eV+stLAbIbj3FjAyne6v6+c
         pdrzFzCOyjLAiZyMmmH+r/S4cAWfcIDnP8xu/SNz5S7vvvpwy+0lLaQNSxZCQF2RVS
         3yBLDPJWdCH+hy+PqLWTjbYV9yAH3ZCXUgEtH90txOV5TzV4D/QdJCtMXmsXXiwiFT
         xgNkVkHTgIRM+Q4XAHnDRM7mcUvrjRFV1I14/5nmT3Cdnb59Y3MAj3StR7Ky4PEAKd
         QfyvuT7eS8w9rAudClY0lNC0peDfQ7wUbDxm3O/t/PZvQb6dUuevIjvvnPqgMpQMr2
         wIN6y98/W7KiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5719F79408;
        Fri,  7 Jan 2022 11:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/11] net/mlx5e: Fix page DMA map/unmap attributes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164155441067.31254.2635683820574088800.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 11:20:10 +0000
References: <20220107005831.78909-2-saeed@kernel.org>
In-Reply-To: <20220107005831.78909-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ayal@nvidia.com, gal@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu,  6 Jan 2022 16:58:21 -0800 you wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> Driver initiates DMA sync, hence it may skip CPU sync. Add
> DMA_ATTR_SKIP_CPU_SYNC as input attribute both to dma_map_page and
> dma_unmap_page to avoid redundant sync with the CPU.
> When forcing the device to work with SWIOTLB, the extra sync might cause
> data corruption. The driver unmaps the whole page while the hardware
> used just a part of the bounce buffer. So syncing overrides the entire
> page with bounce buffer that only partially contains real data.
> 
> [...]

Here is the summary with links:
  - [net,01/11] net/mlx5e: Fix page DMA map/unmap attributes
    https://git.kernel.org/netdev/net/c/0b7cfa4082fb
  - [net,02/11] net/mlx5e: Fix nullptr on deleting mirroring rule
    https://git.kernel.org/netdev/net/c/de31854ece17
  - [net,03/11] net/mlx5e: Fix wrong usage of fib_info_nh when routes with nexthop objects are used
    https://git.kernel.org/netdev/net/c/885751eb1b01
  - [net,04/11] net/mlx5e: Don't block routes with nexthop objects in SW
    https://git.kernel.org/netdev/net/c/9e72a55a3c9d
  - [net,05/11] Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"
    https://git.kernel.org/netdev/net/c/64050cdad098
  - [net,06/11] Revert "net/mlx5e: Block offload of outer header csum for GRE tunnel"
    https://git.kernel.org/netdev/net/c/01c3fd113ef5
  - [net,07/11] net/mlx5e: Fix matching on modified inner ip_ecn bits
    https://git.kernel.org/netdev/net/c/b6dfff21a170
  - [net,08/11] net/mlx5: Fix access to sf_dev_table on allocation failure
    https://git.kernel.org/netdev/net/c/a1c7c49c2091
  - [net,09/11] net/mlx5e: Sync VXLAN udp ports during uplink representor profile change
    https://git.kernel.org/netdev/net/c/07f6dc4024ea
  - [net,10/11] net/mlx5: Set command entry semaphore up once got index free
    https://git.kernel.org/netdev/net/c/8e715cd613a1
  - [net,11/11] Revert "net/mlx5: Add retry mechanism to the command entry index allocation"
    https://git.kernel.org/netdev/net/c/4f6626b0e140

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


