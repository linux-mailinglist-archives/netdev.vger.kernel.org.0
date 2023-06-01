Return-Path: <netdev+bounces-7188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A5C71F087
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC623281844
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0FD46FEC;
	Thu,  1 Jun 2023 17:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E73B4253B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AEE1C4339B;
	Thu,  1 Jun 2023 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685640022;
	bh=A+I/Sgtp+XSKdMdodi6keJFZYk2Til/LLRc8c/wtvmo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=d0LA4pZvcYb3SIZEF/NIzNCrKROaif+vgx2iTG4fkdpJgiXMbsHWrFBQKFXNd9T6R
	 bYRsgpKEoiWmQNJ4VAiEA6ykmFycsm/rkri6LC4Gi7UE5GzyeNdkL40rXVGw4xZ6vD
	 +70lA1/YesA7FupkS4xN9Xb37OWMzKdk+RdLk80Q26uiL1KDnDvsSOYd7hhLcuHunU
	 iYFX7vGqK0sfSa9B5Teun5rxbWw8dxf3jEOTSjwhI17GsjrRsD4j4rcesgsZx3+IFT
	 vPQ4HtgDb7Ynu5BpfhXOxG/5VJ0SKyrN/qsn9YW4kj43TDXgp22iH/jRhLrJ82rKZs
	 +NEUidDYoImqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 528BFC395E5;
	Thu,  1 Jun 2023 17:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/5] net/mlx5: Remove rmap also in case dynamic MSIX not
 supported
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168564002233.14862.10848012612929831667.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 17:20:22 +0000
References: <20230601031051.131529-2-saeed@kernel.org>
In-Reply-To: <20230601031051.131529-2-saeed@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
 tariqt@nvidia.com, shayd@nvidia.com, moshe@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed, 31 May 2023 20:10:47 -0700 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> mlx5 add IRQs to rmap upon MSIX request, and mlx5 remove rmap from
> MSIX only if msi_map.index is populated. However, msi_map.index is
> populated only when dynamic MSIX is supported. This results in freeing
> IRQs without removing them from rmap, which triggers the bellow
> WARN_ON[1].
> 
> [...]

Here is the summary with links:
  - [net,1/5] net/mlx5: Remove rmap also in case dynamic MSIX not supported
    https://git.kernel.org/netdev/net/c/1c4c769cdf68
  - [net,2/5] net/mlx5: Fix setting of irq->map.index for static IRQ case
    https://git.kernel.org/netdev/net/c/8764bd0fa5d4
  - [net,3/5] net/mlx5: Ensure af_desc.mask is properly initialized
    https://git.kernel.org/netdev/net/c/368591995d01
  - [net,4/5] net/mlx5e: Fix error handling in mlx5e_refresh_tirs
    https://git.kernel.org/netdev/net/c/b6193d7030e3
  - [net,5/5] net/mlx5: Read embedded cpu after init bit cleared
    https://git.kernel.org/netdev/net/c/bbfa4b58997e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



