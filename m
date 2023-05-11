Return-Path: <netdev+bounces-1646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9A86FE9CC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CC651C20EB1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA0951F198;
	Thu, 11 May 2023 02:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A2E1F193
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EB72C4339C;
	Thu, 11 May 2023 02:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683771622;
	bh=G5w6X4nD4fXq+qzyTqhQ2DlNAeUgqrPKtzSgg6OOteg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ojEjz6V64OEMCkyqW8olFACe6n/tbDldxiHakNbn3I17m+8dlWD6Chh8o5OMaSdtx
	 OCc/qGk2T56lHICG4yCLOZlL7rck1ftFfiYXRW6knszpSoLweZa8wf8Vd9hBB5KOPf
	 YmcPxbG8YUx/ipFJ2mZgEsqzDTuORD/x/nqKwa5qx3nWzxvI6SVHUNHXCeb7miytub
	 0AeLJtjpuBIg1pNqZkp7c10St6oEEoBK9+R/wn4q2MeI1dBqABGqaosG4PtLHOmWVa
	 4pU/61br2y150lYqGElUEsorPilLNE3O2mwFtpPHnxVilKcpT+8Uaus+jtlpLJiWIL
	 flA07hYJNw+7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6034FE26D21;
	Thu, 11 May 2023 02:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: nf_tables: always release netdev hooks
 from notifier
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168377162238.11094.15038235357887196732.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 02:20:22 +0000
References: <20230510083313.152961-2-pablo@netfilter.org>
In-Reply-To: <20230510083313.152961-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 10 May 2023 10:33:07 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> This reverts "netfilter: nf_tables: skip netdev events generated on netns removal".
> 
> The problem is that when a veth device is released, the veth release
> callback will also queue the peer netns device for removal.
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: nf_tables: always release netdev hooks from notifier
    https://git.kernel.org/netdev/net/c/dc1c9fd4a8bb
  - [net,2/7] netfilter: conntrack: fix possible bug_on with enable_hooks=1
    https://git.kernel.org/netdev/net/c/e72eeab542db
  - [net,3/7] selftests: nft_flowtable.sh: use /proc for pid checking
    https://git.kernel.org/netdev/net/c/0a11073e8e33
  - [net,4/7] selftests: nft_flowtable.sh: no need for ps -x option
    https://git.kernel.org/netdev/net/c/0749d670d758
  - [net,5/7] selftests: nft_flowtable.sh: wait for specific nc pids
    https://git.kernel.org/netdev/net/c/1114803c2da9
  - [net,6/7] selftests: nft_flowtable.sh: monitor result file sizes
    https://git.kernel.org/netdev/net/c/90ab51226d52
  - [net,7/7] selftests: nft_flowtable.sh: check ingress/egress chain too
    https://git.kernel.org/netdev/net/c/3acf8f6c14d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



