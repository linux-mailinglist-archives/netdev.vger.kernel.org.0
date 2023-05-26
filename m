Return-Path: <netdev+bounces-5508-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9607711EE0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82C7728167D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDEA11361;
	Fri, 26 May 2023 04:30:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72135235
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A2C7C433D2;
	Fri, 26 May 2023 04:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685075425;
	bh=zGHvvAm5BTX5nrHI3spwI0z5Xh1A/ab94EjKZ3pKdCo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WCWjlArIpp72nOWcZ/PDRVoC5Rgsf6zOIyhN9IlzWZquQz4U45DQeaW6SaIZscftt
	 Tff4nLbs0rrPLbmbX4a4bSySzVMloK/UpsExA+rROqb8NoFCwHiMVut6Q12VnlThpI
	 jrZcr2LHGSGvGMTTz4kCqJxW4XLjMbVtwOfjuU0wt1sMlXeC1bn2Be17xRBrDtdlJj
	 floM6Xr9IqeoC+egczDNB0bZxS6QKU9L/eBtJERvkk7xCSh7bfXX46UoBxS6zdg5fq
	 u20vNhWImPsw/rhyCFqwfE78zx1sHIHKUk72fmd2ZRpCjIf8xTFTY59cI0bIENqCbU
	 gPIWygd0DbC6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B67FE22B06;
	Fri, 26 May 2023 04:30:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/17] net/mlx5e: Extract remaining tunnel encap code to
 dedicated file
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168507542523.31186.17614306766953956768.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 04:30:25 +0000
References: <20230525034847.99268-2-saeed@kernel.org>
In-Reply-To: <20230525034847.99268-2-saeed@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
 tariqt@nvidia.com, cmi@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed, 24 May 2023 20:48:31 -0700 you wrote:
> From: Chris Mi <cmi@nvidia.com>
> 
> Move set_encap_dests() and clean_encap_dests() to the tunnel encap
> dedicated file. And rename them to mlx5e_tc_tun_encap_dests_set()
> and mlx5e_tc_tun_encap_dests_unset().
> 
> No functional change in this patch. It is needed in the next patch.
> 
> [...]

Here is the summary with links:
  - [net,01/17] net/mlx5e: Extract remaining tunnel encap code to dedicated file
    https://git.kernel.org/netdev/net/c/e2ab5aa11f19
  - [net,02/17] net/mlx5e: Prevent encap offload when neigh update is running
    https://git.kernel.org/netdev/net/c/37c3b9fa7ccf
  - [net,03/17] net/mlx5e: Consider internal buffers size in port buffer calculations
    https://git.kernel.org/netdev/net/c/81fe2be06291
  - [net,04/17] net/mlx5e: Do not update SBCM when prio2buffer command is invalid
    https://git.kernel.org/netdev/net/c/623efc4cbd61
  - [net,05/17] net/mlx5: Drain health before unregistering devlink
    https://git.kernel.org/netdev/net/c/824c8dc4a470
  - [net,06/17] net/mlx5: SF, Drain health before removing device
    https://git.kernel.org/netdev/net/c/b4646da0573f
  - [net,07/17] net/mlx5: fw_tracer, Fix event handling
    https://git.kernel.org/netdev/net/c/341a80de2468
  - [net,08/17] net/mlx5e: Use query_special_contexts cmd only once per mdev
    https://git.kernel.org/netdev/net/c/1db1f21caebb
  - [net,09/17] net/mlx5: Fix post parse infra to only parse every action once
    https://git.kernel.org/netdev/net/c/5d862ec631f3
  - [net,10/17] net/mlx5e: Don't attach netdev profile while handling internal error
    https://git.kernel.org/netdev/net/c/bdf274750fca
  - [net,11/17] net/mlx5e: Move Ethernet driver debugfs to profile init callback
    https://git.kernel.org/netdev/net/c/c4c24fc30cc4
  - [net,12/17] net/mlx5: DR, Add missing mutex init/destroy in pattern manager
    https://git.kernel.org/netdev/net/c/fe5c2d3aef93
  - [net,13/17] net/mlx5: Fix check for allocation failure in comp_irqs_request_pci()
    https://git.kernel.org/netdev/net/c/d5972f1000c1
  - [net,14/17] Documentation: net/mlx5: Wrap vnic reporter devlink commands in code blocks
    https://git.kernel.org/netdev/net/c/c3acc46c602f
  - [net,15/17] Documentation: net/mlx5: Use bullet and definition lists for vnic counters description
    https://git.kernel.org/netdev/net/c/565b8c60e90f
  - [net,16/17] Documentation: net/mlx5: Add blank line separator before numbered lists
    https://git.kernel.org/netdev/net/c/92059da65d84
  - [net,17/17] Documentation: net/mlx5: Wrap notes in admonition blocks
    https://git.kernel.org/netdev/net/c/bb72b94c659f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



