Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018FE43CB2C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242296AbhJ0Nwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhJ0Nwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 125BA60E74;
        Wed, 27 Oct 2021 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635342612;
        bh=o9oJpYmx7OVTXN8gpSvifBXe/VTXOm1jMDqZSR1Z5Mw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kLmTIMW+3R5nx0AKdTpSwqFG2iYDu8bkzvMcNv/6OL4igxtOUin1DaZBn7Xxo8vSb
         pO/efAmpA/y6tfMV3u2TQEtCXYOo9HzaJN5L8QHLGQvlATrqeT3iMatDDbgDSMqAaO
         DXiF6c7MklQsqWOOLAkr8H+9ufRLp5OyqLVl9vW4CvEFyRemhrG8Dk3hLy8tb+uNqh
         S8CP7xdZ2yrzdsZ5x8d6Il4qcFF7DHXGdxXpxQ/83xRcSsckWRQuzBmPlQp92CrLMm
         4XdPNeU87f0hZ88tGK63VjNblZo/xk8MZVtAT+HZYUszVp71BiYfe/AbPb3BzwaJVQ
         CKulkm2xM0B1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C25960986;
        Wed, 27 Oct 2021 13:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/14] lib: bitmap: Introduce node-aware alloc API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163534261204.9048.9555385409919109785.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 13:50:12 +0000
References: <20211027023347.699076-2-saeed@kernel.org>
In-Reply-To: <20211027023347.699076-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 26 Oct 2021 19:33:34 -0700 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> Expose new node-aware API for bitmap allocation:
> bitmap_alloc_node() / bitmap_zalloc_node().
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] lib: bitmap: Introduce node-aware alloc API
    https://git.kernel.org/netdev/net-next/c/7529cc7fbd9c
  - [net-next,02/14] net: Prevent HW-GRO and LRO features operate together
    https://git.kernel.org/netdev/net-next/c/54b2b3eccab6
  - [net-next,03/14] net/mlx5e: Rename lro_timeout to packet_merge_timeout
    https://git.kernel.org/netdev/net-next/c/50f477fe9933
  - [net-next,04/14] net/mlx5: Add SHAMPO caps, HW bits and enumerations
    https://git.kernel.org/netdev/net-next/c/7025329d208c
  - [net-next,05/14] net/mlx5e: Rename TIR lro functions to TIR packet merge functions
    https://git.kernel.org/netdev/net-next/c/eaee12f04692
  - [net-next,06/14] net/mlx5e: Add support to klm_umr_wqe
    https://git.kernel.org/netdev/net-next/c/d7b896acbdcb
  - [net-next,07/14] net/mlx5e: Add control path for SHAMPO feature
    https://git.kernel.org/netdev/net-next/c/e5ca8fb08ab2
  - [net-next,08/14] net/mlx5e: Add handle SHAMPO cqe support
    https://git.kernel.org/netdev/net-next/c/f97d5c2a453e
  - [net-next,09/14] net/mlx5e: Add data path for SHAMPO feature
    https://git.kernel.org/netdev/net-next/c/64509b052525
  - [net-next,10/14] net/mlx5e: HW_GRO cqe handler implementation
    https://git.kernel.org/netdev/net-next/c/92552d3abd32
  - [net-next,11/14] net/mlx5e: Add HW_GRO statistics
    https://git.kernel.org/netdev/net-next/c/def09e7bbc3d
  - [net-next,12/14] net/mlx5e: Add HW-GRO offload
    https://git.kernel.org/netdev/net-next/c/83439f3c37aa
  - [net-next,13/14] net/mlx5e: Prevent HW-GRO and CQE-COMPRESS features operate together
    https://git.kernel.org/netdev/net-next/c/ae3452995bd4
  - [net-next,14/14] net/mlx5: Lag, Make mlx5_lag_is_multipath() be static inline
    https://git.kernel.org/netdev/net-next/c/8ca9caee851c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


