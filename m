Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419BE334CB1
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhCJXkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:40:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhCJXkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:40:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EDF064F82;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615419611;
        bh=Wa80y7JpSfKvTo+Cki3vY4xfCBNl8Z6DFZVhW1yvDT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QwMN5DcCGyLqwYPVJuX/ykPWJ7bzy1DzED7XiGg1l44LT7FHro2V0icb6I5CCVIYM
         AliEarWZeNePYc7fngb6C3qi1LQ48s7KI8mkyQA9rdW2huwwCwJmJAss8AeCHRjDK/
         pvVNxy2SeZnPogQd0qvqDjrxvo9hN3adq+n1OYm/GWsDyUn9n2QicQ5u4aGxvmWsUc
         /+Usp9YtUb8o8makFkUus3Q/mcUtLCMYnQYMHyXVYP6ozx+2oHfGWgY7+FBmnr8sFk
         17z4LBQvW4iUkygDn8auVFFFgr4ngiteH0miIZVGiX+Zj3BoYjTMpH2X/mbzTRCIHc
         CrJ9xckvaCylA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A649609D0;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/18] net/mlx5e: Enforce minimum value check for ICOSQ size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541961156.10035.4511466471713524860.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 23:40:11 +0000
References: <20210310190342.238957-2-saeed@kernel.org>
In-Reply-To: <20210310190342.238957-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, tariqt@nvidia.com,
        maximmi@mellanox.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 11:03:25 -0800 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> The ICOSQ size should not go below MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE.
> Enforce this where it's missing.
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,01/18] net/mlx5e: Enforce minimum value check for ICOSQ size
    https://git.kernel.org/netdev/net/c/5115daa675cc
  - [net,02/18] net/mlx5e: RX, Mind the MPWQE gaps when calculating offsets
    https://git.kernel.org/netdev/net/c/d5dd03b26ba4
  - [net,03/18] net/mlx5e: Accumulate port PTP TX stats with other channels stats
    https://git.kernel.org/netdev/net/c/354521eebd02
  - [net,04/18] net/mlx5e: Set PTP channel pointer explicitly to NULL
    https://git.kernel.org/netdev/net/c/1c2cdf0b603a
  - [net,05/18] net/mlx5e: When changing XDP program without reset, take refs for XSK RQs
    https://git.kernel.org/netdev/net/c/e5eb01344e9b
  - [net,06/18] net/mlx5e: Revert parameters on errors when changing PTP state without reset
    https://git.kernel.org/netdev/net/c/74640f09735f
  - [net,07/18] net/mlx5e: Don't match on Geneve options in case option masks are all zero
    https://git.kernel.org/netdev/net/c/385d40b042e6
  - [net,08/18] net/mlx5: Fix turn-off PPS command
    https://git.kernel.org/netdev/net/c/55affa97d675
  - [net,09/18] net/mlx5e: Check correct ip_version in decapsulation route resolution
    https://git.kernel.org/netdev/net/c/1e74152ed065
  - [net,10/18] net/mlx5: Disable VF tunnel TX offload if ignore_flow_level isn't supported
    https://git.kernel.org/netdev/net/c/f574531a0b77
  - [net,11/18] net/mlx5e: Fix error flow in change profile
    https://git.kernel.org/netdev/net/c/469549e4778a
  - [net,12/18] net/mlx5: Set QP timestamp mode to default
    https://git.kernel.org/netdev/net/c/4806f1e2fee8
  - [net,13/18] RDMA/mlx5: Fix timestamp default mode
    https://git.kernel.org/netdev/net/c/8256c69b2d9c
  - [net,14/18] net/mlx5e: E-switch, Fix rate calculation division
    https://git.kernel.org/netdev/net/c/8b90d897823b
  - [net,15/18] net/mlx5: SF, Correct vhca context size
    https://git.kernel.org/netdev/net/c/6a3717544ce9
  - [net,16/18] net/mlx5: SF: Fix memory leak of work item
    https://git.kernel.org/netdev/net/c/6fa37d66ef2d
  - [net,17/18] net/mlx5: SF: Fix error flow of SFs allocation flow
    https://git.kernel.org/netdev/net/c/dc694f11a759
  - [net,18/18] net/mlx5: DR, Fix potential shift wrapping of 32-bit value in STEv1 getter
    https://git.kernel.org/netdev/net/c/84076c4c800d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


