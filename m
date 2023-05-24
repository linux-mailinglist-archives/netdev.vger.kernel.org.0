Return-Path: <netdev+bounces-4887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D3E270EFDF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FC8C1C20B39
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CA2C12C;
	Wed, 24 May 2023 07:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C2CC123
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FC9BC433D2;
	Wed, 24 May 2023 07:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684914622;
	bh=hxeu2EvmrYDm2jEGcvHtpPvdgJHOOAy/bTgv4kejpxw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ADhsbG4kVoavouRzSb1PSMfEphYenTGyFX4LJh14Bcu0XRl26EQjTHYBoR81+cgaK
	 kF8Uc5Gbt5oHaI634dpMMz4njtkduMlU+I4/Rj1QPN1TrmjOd/xUbxgACoH/hpfao6
	 j/JQWK2ZKHf1c9Dee3QdQcAie8dNFSN4bFPCqFNVKbnfvWxdlCrN07HYEtbjojLMMC
	 AqXkNOWXvai2ljUMA+MBc1w53y7VoVRKb6iR+g3foW5jLFFrYKB08ZopMyi0ToZq+5
	 1F2WYNm3QQT0EPeHerQYAWWJXyiD2iWpGwNy84J/Zgc8rTlgm/oh/ORR/mHqf+xcnL
	 mwniPvDkHI1Vw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 766A5E21ECD;
	Wed, 24 May 2023 07:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/15] net/mlx5: Collect command failures data only for known
 commands
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168491462248.4606.14521009670777988480.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 07:50:22 +0000
References: <20230523054242.21596-2-saeed@kernel.org>
In-Reply-To: <20230523054242.21596-2-saeed@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
 tariqt@nvidia.com, shayd@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Mon, 22 May 2023 22:42:28 -0700 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> DEVX can issue a general command, which is not used by mlx5 driver.
> In case such command is failed, mlx5 is trying to collect the failure
> data, However, mlx5 doesn't create a storage for this command, since
> mlx5 doesn't use it. This lead to array-index-out-of-bounds error.
> 
> [...]

Here is the summary with links:
  - [net,01/15] net/mlx5: Collect command failures data only for known commands
    https://git.kernel.org/netdev/net/c/2a0a935fb64e
  - [net,02/15] net/mlx5: Handle pairing of E-switch via uplink un/load APIs
    https://git.kernel.org/netdev/net/c/2be5bd42a5bb
  - [net,03/15] net/mlx5: DR, Fix crc32 calculation to work on big-endian (BE) CPUs
    https://git.kernel.org/netdev/net/c/1e5daf5565b6
  - [net,04/15] net/mlx5: DR, Check force-loopback RC QP capability independently from RoCE
    https://git.kernel.org/netdev/net/c/c7dd225bc224
  - [net,05/15] net/mlx5e: Use correct encap attribute during invalidation
    https://git.kernel.org/netdev/net/c/be071cdb167f
  - [net,06/15] net/mlx5: Fix error message when failing to allocate device memory
    https://git.kernel.org/netdev/net/c/a65735148e03
  - [net,07/15] net/mlx5e: Fix deadlock in tc route query code
    https://git.kernel.org/netdev/net/c/691c041bf208
  - [net,08/15] net/mlx5e: Fix SQ wake logic in ptp napi_poll context
    https://git.kernel.org/netdev/net/c/7aa503801916
  - [net,09/15] net/mlx5e: TC, Fix using eswitch mapping in nic mode
    https://git.kernel.org/netdev/net/c/dfa1e46d6093
  - [net,10/15] net/mlx5: E-switch, Devcom, sync devcom events and devcom comp register
    https://git.kernel.org/netdev/net/c/8c253dfc89ef
  - [net,11/15] net/mlx5: Devcom, fix error flow in mlx5_devcom_register_device
    https://git.kernel.org/netdev/net/c/af87194352ca
  - [net,12/15] net/mlx5: Devcom, serialize devcom registration
    https://git.kernel.org/netdev/net/c/1f893f57a3bf
  - [net,13/15] net/mlx5: Free irqs only on shutdown callback
    https://git.kernel.org/netdev/net/c/9c2d08010963
  - [net,14/15] net/mlx5: Fix irq affinity management
    https://git.kernel.org/netdev/net/c/ef8c063cf88e
  - [net,15/15] net/mlx5: Fix indexing of mlx5_irq
    https://git.kernel.org/netdev/net/c/1da438c0ae02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



