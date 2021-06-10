Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502E43A3525
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhFJUwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhFJUwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1746613CB;
        Thu, 10 Jun 2021 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358205;
        bh=4lm2gkj1gqAzubqfoN1D2eCjFWwfYmAJAn5myTvpCBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FtUTHUtFjfTFYGZzgJgDVY4255wkVNkm9wZ1AQxrkb/MP1PTCD/8uqSM4YxLcxG/Q
         4pl76SYH6Cb2Lg/XIsijUpATyvoOswf1hhbnmM+TCuKHcslkeoxQKRTy/jh71yQosH
         NFUBOkrxtigRVyCQZpzdmg0JuoUvGq4jjY0lqLm9neXYZvB+r+QP+RfbNZCPVOREVO
         GjnAnhtm8G4Q5NLqZQ1OnyeI9JWH8K74xuNqgMW+RtiouqWqF3/Kp5N8yVjAsV6iUk
         P/w9Q8uUgWig6r40RErJwfe784CmYT9oajwfXejDJdppZgmQ5CgJNpZHzU+gU0mr9a
         TWjk3OBZRNkDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A5A7A60BE2;
        Thu, 10 Jun 2021 20:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/12] net/mlx5e: Fix an error code in
 mlx5e_arfs_create_tables()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335820567.975.7814515535905296436.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:50:05 +0000
References: <20210610002155.196735-2-saeed@kernel.org>
In-Reply-To: <20210610002155.196735-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, leonro@nvidia.com, yang.lee@linux.alibaba.com,
        abaci@linux.alibaba.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed,  9 Jun 2021 17:21:44 -0700 you wrote:
> From: Yang Li <yang.lee@linux.alibaba.com>
> 
> When the code execute 'if (!priv->fs.arfs->wq)', the value of err is 0.
> So, we use -ENOMEM to indicate that the function
> create_singlethread_workqueue() return NULL.
> 
> Clean up smatch warning:
> drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c:373
> mlx5e_arfs_create_tables() warn: missing error code 'err'.
> 
> [...]

Here is the summary with links:
  - [net,01/12] net/mlx5e: Fix an error code in mlx5e_arfs_create_tables()
    https://git.kernel.org/netdev/net/c/2bf8d2ae3480
  - [net,02/12] net/mlx5e: Fix use-after-free of encap entry in neigh update handler
    https://git.kernel.org/netdev/net/c/fb1a3132ee1a
  - [net,03/12] net/mlx5e: Remove dependency in IPsec initialization flows
    https://git.kernel.org/netdev/net/c/8ad893e516a7
  - [net,04/12] net/mlx5e: Fix page reclaim for dead peer hairpin
    https://git.kernel.org/netdev/net/c/a3e5fd9314df
  - [net,05/12] net/mlx5: Consider RoCE cap before init RDMA resources
    https://git.kernel.org/netdev/net/c/c189716b2a7c
  - [net,06/12] net/mlx5: DR, Don't use SW steering when RoCE is not supported
    https://git.kernel.org/netdev/net/c/4aaf96ac8b45
  - [net,07/12] net/mlx5e: Verify dev is present in get devlink port ndo
    https://git.kernel.org/netdev/net/c/11f5ac3e05c1
  - [net,08/12] net/mlx5e: Don't update netdev RQs with PTP-RQ
    https://git.kernel.org/netdev/net/c/9ae8c18c5e4d
  - [net,09/12] net/mlx5e: Fix select queue to consider SKBTX_HW_TSTAMP
    https://git.kernel.org/netdev/net/c/a6ee6f5f1082
  - [net,10/12] Revert "net/mlx5: Arm only EQs with EQEs"
    https://git.kernel.org/netdev/net/c/7a545077cb67
  - [net,11/12] net/mlx5e: Block offload of outer header csum for UDP tunnels
    https://git.kernel.org/netdev/net/c/6d6727dddc7f
  - [net,12/12] net/mlx5e: Block offload of outer header csum for GRE tunnel
    https://git.kernel.org/netdev/net/c/54e1217b9048

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


