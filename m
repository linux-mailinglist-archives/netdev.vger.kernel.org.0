Return-Path: <netdev+bounces-10085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE13A72C1C8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE57A2810DC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96980154A4;
	Mon, 12 Jun 2023 11:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FC6134D6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D0AFC433D2;
	Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686567624;
	bh=5dsxcUuoS7D1eiXPBGUMqnvnNsIiEVm4u0tHY1ZAabE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BSP934xV5690GcOh2LShcVeh8TogMQ6fZ2CtjgOgweC2LdG17eo/JYPAIAp8sNQhJ
	 pVHXeaKs4tWVvA8u057VsF002i+bXS9+hLcNPpT4fwrO8mBi9y9uZ+vN+sXRWr4T/1
	 7+E0usDV8pEcUh6goXtL8PI5x4Dalic3527+jxRuw04781amN738bqEHDKmSShzzfJ
	 K2DVy8MnOWsnMP2bNjuw/YfSDov4l6w5sT+vC/GCuHwWqCXog8gtu8kD8Rnzcd1YQ+
	 MUoEC+1VYzRZZ0w7t1eG9hFMPqx4jcT5ENqV4Y8Cvgn7LXp8QaRbicjQX7XL/iEqq+
	 gTnQnoJ+GU7FQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A049C395EC;
	Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Simplify unload all rep code
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168656762410.2644.7169706063027415752.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 11:00:24 +0000
References: <20230610014254.343576-2-saeed@kernel.org>
In-Reply-To: <20230610014254.343576-2-saeed@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
 tariqt@nvidia.com, danielj@nvidia.com, witu@nvidia.com, parav@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Fri,  9 Jun 2023 18:42:40 -0700 you wrote:
> From: Daniel Jurgens <danielj@nvidia.com>
> 
> Instead of using type specific iterators which are only used in one place
> just traverse the xarray. It will provide suitable ordering based on the
> vport numbers. This will also eliminate the need for changes here when
> new types are added.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Simplify unload all rep code
    https://git.kernel.org/netdev/net-next/c/18a92b054254
  - [net-next,02/15] net/mlx5: mlx5_ifc updates for embedded CPU SRIOV
    https://git.kernel.org/netdev/net-next/c/93b36d0f2892
  - [net-next,03/15] net/mlx5: Enable devlink port for embedded cpu VF vports
    https://git.kernel.org/netdev/net-next/c/dc13180824b7
  - [net-next,04/15] net/mlx5: Update vport caps query/set for EC VFs
    https://git.kernel.org/netdev/net-next/c/9ac0b128248e
  - [net-next,05/15] net/mlx5: Add management of EC VF vports
    https://git.kernel.org/netdev/net-next/c/a7719b29a821
  - [net-next,06/15] net/mlx5: Add/remove peer miss rules for EC VFs
    https://git.kernel.org/netdev/net-next/c/fa3c73eee641
  - [net-next,07/15] net/mlx5: Add new page type for EC VF pages
    https://git.kernel.org/netdev/net-next/c/395ccd6eb49a
  - [net-next,08/15] net/mlx5: Use correct vport when restoring GUIDs
    https://git.kernel.org/netdev/net-next/c/2ee3db806e85
  - [net-next,09/15] net/mlx5: Query correct caps for min msix vectors
    https://git.kernel.org/netdev/net-next/c/42a84a430931
  - [net-next,10/15] net/mlx5: Update SRIOV enable/disable to handle EC/VFs
    https://git.kernel.org/netdev/net-next/c/6d98f314bfca
  - [net-next,11/15] net/mlx5: Set max number of embedded CPU VFs
    https://git.kernel.org/netdev/net-next/c/7057fe561988
  - [net-next,12/15] net/mlx5: Split function_setup() to enable and open functions
    https://git.kernel.org/netdev/net-next/c/2059cf51f318
  - [net-next,13/15] net/mlx5: Move esw multiport devlink param to eswitch code
    https://git.kernel.org/netdev/net-next/c/3f90840305e2
  - [net-next,14/15] net/mlx5: Light probe local SFs
    https://git.kernel.org/netdev/net-next/c/e71383fb9cd1
  - [net-next,15/15] net/mlx5e: Remove a useless function call
    https://git.kernel.org/netdev/net-next/c/978015f7ef92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



