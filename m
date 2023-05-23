Return-Path: <netdev+bounces-4473-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C64670D11C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D8461C20C0D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F514C92;
	Tue, 23 May 2023 02:20:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914C41FAC
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 372D6C433D2;
	Tue, 23 May 2023 02:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684808422;
	bh=irQrHFouoBbJhFj82hKqXHXEs+qfgiB9+jJIHzOVfbk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OrioI9asKuXHj4oqfS7soux9QRTfvcb1vTIALbmiOzIgS7YZvMP+FHhEPGQH7U+Yt
	 mDYVh8liDw0VygTyF8KzlTBXODmgqw9M3r8AD6cXeYB/1/gQsgj6zq6vRDOTBeDaBO
	 m8pn+snPoezaQuSjNLKSiCCmFu8EJCfNj00CM4T+Sl80zCzbrtABg4YAiBEWjoVWGS
	 NfVymqElKik5eG7m5F09e4ze48fh4X4qgWqrMF/gH16D1rWzkzi+biVKoLAyEhsenR
	 1x4KOxwDPjMSpTMx21GorLx02Wholvpc+9qY4xp8eZpSCosfqpc2KNV0bBHmdlKcVz
	 95NhjgsOrD8ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17A50E22AEB;
	Tue, 23 May 2023 02:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Remove redundant esw multiport validate
 function
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168480842209.16910.5809234478647582258.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 02:20:22 +0000
References: <20230519175557.15683-2-saeed@kernel.org>
In-Reply-To: <20230519175557.15683-2-saeed@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
 tariqt@nvidia.com, roid@nvidia.com, maord@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri, 19 May 2023 10:55:43 -0700 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> The function didn't validate the value and doesn't require value
> validation as it will always be valid true or false values.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Remove redundant esw multiport validate function
    https://git.kernel.org/netdev/net-next/c/c511822fe2c9
  - [net-next,02/15] net/mlx5: E-Switch, Remove redundant check
    https://git.kernel.org/netdev/net-next/c/2abe501751ed
  - [net-next,03/15] net/mlx5e: E-Switch, Remove flow_source check for metadata matching
    https://git.kernel.org/netdev/net-next/c/edab80b89337
  - [net-next,04/15] net/mlx5e: Remove redundant __func__ arg from fs_err() calls
    https://git.kernel.org/netdev/net-next/c/806815bf3c1d
  - [net-next,05/15] net/mlx5e: E-Switch, Update when to set other vport context
    https://git.kernel.org/netdev/net-next/c/c97c9fe48ae3
  - [net-next,06/15] net/mlx5e: E-Switch, Allow get vport api if esw exists
    https://git.kernel.org/netdev/net-next/c/99db5669f663
  - [net-next,07/15] net/mlx5e: E-Switch, Use metadata for vport matching in send-to-vport rules
    https://git.kernel.org/netdev/net-next/c/29bcb6e4fe70
  - [net-next,08/15] net/mlx5: Remove redundant vport_group_manager cap check
    https://git.kernel.org/netdev/net-next/c/6cb9318a2534
  - [net-next,09/15] net/mlx5e: E-Switch, Check device is PF when stopping esw offloads
    https://git.kernel.org/netdev/net-next/c/bea416c7e970
  - [net-next,10/15] net/mlx5e: E-Switch: move debug print of adding mac to correct place
    https://git.kernel.org/netdev/net-next/c/292243d13b18
  - [net-next,11/15] net/mlx5e: E-Switch, Add a check that log_max_l2_table is valid
    https://git.kernel.org/netdev/net-next/c/3d7c5f78b8ce
  - [net-next,12/15] net/mlx5: E-Switch, Use RoCE version 2 for loopback traffic
    https://git.kernel.org/netdev/net-next/c/c24246d07a94
  - [net-next,13/15] net/mlx5: E-Switch, Use metadata matching for RoCE loopback rule
    https://git.kernel.org/netdev/net-next/c/7eb197fd83a3
  - [net-next,14/15] net/mlx5: devlink, Only show PF related devlink warning when needed
    https://git.kernel.org/netdev/net-next/c/0279b5454c0e
  - [net-next,15/15] net/mlx5e: E-Switch, Initialize E-Switch for eswitch manager
    https://git.kernel.org/netdev/net-next/c/f5d87b47a1d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



