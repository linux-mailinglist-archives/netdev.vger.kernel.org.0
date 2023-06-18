Return-Path: <netdev+bounces-11791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E368673476B
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CE641C20964
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237F37469;
	Sun, 18 Jun 2023 18:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9D563D3
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE990C433C0;
	Sun, 18 Jun 2023 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687111222;
	bh=T+Q4BZ9D0+iE45jS3B4txq2rb7DIPwo/veLaEF1QqrI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MtTht5MaulrRxfqUBgjRsSc+rJgLd7DNsvW34ZNinvzmU9PeY93rMT6lPZj6Zxan3
	 bi8B9dxn8/7ouQbIhfF3T/yJgnZH08+TAasO+c0kBmp7rx3u45MhkMikrJONXX2KP0
	 EP4AMZwmrp3jaYxa2F1WD2Tbv2p3CT5V77eMITruAMCcP8OHh0994sn4ALyfrjMOGM
	 sHv9cxstYpEtAn2maP3Nk/Dx+8D5XqyhbbaI8EQnsYLQHSYuFgmp/qqi+PWDncldQT
	 Aff9XqfMFHkpuPZd6VxLqh6Fv+Z9+4Ode0zo4LtHf0KmxOfY35fgnWZS9f6tY98t/K
	 2Gt03O7o+kOvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF770C1614E;
	Sun, 18 Jun 2023 18:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Ack on sync_reset_request only if PF can
 do reset_now
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168711122184.9548.14235548196455222898.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 18:00:21 +0000
References: <20230616201113.45510-2-saeed@kernel.org>
In-Reply-To: <20230616201113.45510-2-saeed@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
 tariqt@nvidia.com, moshe@nvidia.com, shayd@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri, 16 Jun 2023 13:10:59 -0700 you wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> Verify at reset_request stage that PF is capable to do reset_now. In
> case PF is not capable, notify the firmware that the sync reset can not
> happen and so firmware will abort the sync reset at early stage and will
> not send reset_now event to any PF.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Ack on sync_reset_request only if PF can do reset_now
    https://git.kernel.org/netdev/net-next/c/92501fa6e421
  - [net-next,02/15] net/mlx5: Expose timeout for sync reset unload stage
    https://git.kernel.org/netdev/net-next/c/8bb42ed4210e
  - [net-next,03/15] net/mlx5: Check DTOR entry value is not zero
    https://git.kernel.org/netdev/net-next/c/6f8551f8d9e4
  - [net-next,04/15] net/mlx5: Handle sync reset unload event
    https://git.kernel.org/netdev/net-next/c/7a9770f1bfea
  - [net-next,05/15] net/mlx5: Create eswitch debugfs root directory
    https://git.kernel.org/netdev/net-next/c/f405787a0aba
  - [net-next,06/15] net/mlx5: Bridge, pass net device when linking vport to bridge
    https://git.kernel.org/netdev/net-next/c/ade19f0d6a3a
  - [net-next,07/15] net/mlx5: Bridge, expose FDB state via debugfs
    https://git.kernel.org/netdev/net-next/c/791eb78285e8
  - [net-next,08/15] net/mlx5: E-Switch, remove redundant else statements
    https://git.kernel.org/netdev/net-next/c/8a955da230d3
  - [net-next,09/15] net/mlx5e: Remove mlx5e_dbg() and msglvl support
    https://git.kernel.org/netdev/net-next/c/559f4c32ebff
  - [net-next,10/15] net/mlx5: Expose bits for local loopback counter
    https://git.kernel.org/netdev/net-next/c/0bd2e6fc78fd
  - [net-next,11/15] net/mlx5e: Add local loopback counter to vport stats
    https://git.kernel.org/netdev/net-next/c/c8013a1f714f
  - [net-next,12/15] net/mlx5: Fix the macro for accessing EC VF vports
    https://git.kernel.org/netdev/net-next/c/b3bd68925ebb
  - [net-next,13/15] net/mlx5: DR, update query of HCA caps for EC VFs
    https://git.kernel.org/netdev/net-next/c/8bbe544e0380
  - [net-next,14/15] net/mlx5: Add header file for events
    https://git.kernel.org/netdev/net-next/c/2bd3b292955f
  - [net-next,15/15] net/mlx5: Remove unused ecpu field from struct mlx5_sf_table
    https://git.kernel.org/netdev/net-next/c/5f2cf757f9c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



