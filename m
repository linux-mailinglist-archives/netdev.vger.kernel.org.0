Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A785B454562
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhKQLNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236664AbhKQLNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:13:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C27361B51;
        Wed, 17 Nov 2021 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637147413;
        bh=CmXPr3/y8ez3GCZP/JgrVG9JmygJW6/r/rjnfbJ1xFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QKbC3sC9B21MUKbsNz5QHp9Q8tJyyGrSy11Hx+XIWc8g1wHPiniB6CBO5HUALek/0
         +ArTZPLtIwH5yNKd9XXSbRp2964h2cNKTPjWhwDyv6rbjrQFpJL6KppnVcATTvKHOq
         bld7tQp8bE1W7SlOKRikrbdI/8qhWI5dBASvO22s8oGn4PjDfOOAuGLzxUx8vbfNGq
         j0t3/4lzB3icKKDORhlZpfvnH7OFeeYH0+xnMj6krgnncJikGrXoZ71C7Jni5/AaDn
         zKZ8/DAJf5AI3zD3XdHBMrlZfJfZ4KkMoPGP7PzEiCjqAOcJvEpD8Z8LnMgGm3QlJK
         bDs98IRwu+tnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 86AA760A54;
        Wed, 17 Nov 2021 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v0 01/15] net/mlx5e: Support ethtool cq mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163714741354.4387.4778396623018819645.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 11:10:13 +0000
References: <20211117043357.345072-2-saeed@kernel.org>
In-Reply-To: <20211117043357.345072-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, tariqt@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 16 Nov 2021 20:33:43 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Add support for ethtool coalesce cq mode set and get.
> 
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v0,01/15] net/mlx5e: Support ethtool cq mode
    https://git.kernel.org/netdev/net-next/c/bc541621f8ba
  - [net-next,v0,02/15] net/mlx5: Fix format-security build warnings
    https://git.kernel.org/netdev/net-next/c/aef0f8c67d75
  - [net-next,v0,03/15] net/mlx5: Avoid printing health buffer when firmware is unavailable
    https://git.kernel.org/netdev/net-next/c/f28a14c1dcb0
  - [net-next,v0,04/15] net/mlx5e: Refactor mod header management API
    https://git.kernel.org/netdev/net-next/c/2c0e5cf5206e
  - [net-next,v0,05/15] net/mlx5: CT: Allow static allocation of mod headers
    https://git.kernel.org/netdev/net-next/c/1cfd3490f278
  - [net-next,v0,06/15] net/mlx5: TC, using swap() instead of tmp variable
    https://git.kernel.org/netdev/net-next/c/0164a9bd9d63
  - [net-next,v0,07/15] net/mlx5e: TC, Destroy nic flow counter if exists
    https://git.kernel.org/netdev/net-next/c/972fe492e847
  - [net-next,v0,08/15] net/mlx5e: TC, Move kfree() calls after destroying all resources
    https://git.kernel.org/netdev/net-next/c/88d974860412
  - [net-next,v0,09/15] net/mlx5e: TC, Move comment about mod header flag to correct place
    https://git.kernel.org/netdev/net-next/c/fc3a879aea35
  - [net-next,v0,10/15] net/mlx5e: Specify out ifindex when looking up decap route
    https://git.kernel.org/netdev/net-next/c/819c319c8c91
  - [net-next,v0,11/15] net/mlx5: E-switch, Remove vport enabled check
    https://git.kernel.org/netdev/net-next/c/fcf8ec54b047
  - [net-next,v0,12/15] net/mlx5: E-switch, Reuse mlx5_eswitch_set_vport_mac
    https://git.kernel.org/netdev/net-next/c/b22fd4381d15
  - [net-next,v0,13/15] net/mlx5: E-switch, move offloads mode callbacks to offloads file
    https://git.kernel.org/netdev/net-next/c/e9d491a64755
  - [net-next,v0,14/15] net/mlx5: E-switch, Enable vport QoS on demand
    https://git.kernel.org/netdev/net-next/c/d7df09f5e7b4
  - [net-next,v0,15/15] net/mlx5: E-switch, Create QoS on demand
    https://git.kernel.org/netdev/net-next/c/85c5f7c9200e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


