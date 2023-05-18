Return-Path: <netdev+bounces-3770-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FE8708BE9
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 00:50:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF3B0281A8A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 22:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC01D1FA4;
	Thu, 18 May 2023 22:50:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E4A394
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 22:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAC7EC4339C;
	Thu, 18 May 2023 22:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684450241;
	bh=XBzaD6wH2ijzFauwtjvQaywIbYwuSye5kmy0OGBzF9Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BZaRVK6Gm4dbVmtDewa4JF3mDpGsO77kzzfcDaLc+J8CvsBRdlGNVeKaipI8bCV3u
	 uJ0q7qDzPrydB9eNNwyP66UJeHDw7N49PXzhgcut9P4JRdncpJLNQsDeYnEscyxtDA
	 AgVLblAQ6EWkY+G606tfqslmer1hh+5F3Q+zE2H1qTFoINyyY89Ge1sxiLZFeeU+TC
	 z/PqeLaLzC4IJl4bpW5emVXKM3c7p8IDRCLdDbpWRH6XRJXFbqUhlKquGt6axU+i23
	 WHH3Zf2mcF1RnnDH0T232JRjk5SPRD0Nqt3q4jFnbvAatYJwRQ4PSeBPZuHT5Xxgcx
	 RF/X8uHaUYFnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E74FC73FE0;
	Thu, 18 May 2023 22:50:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/9] netfilter: nf_tables: relax set/map validation
 checks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168445024164.8786.12740421596180511620.git-patchwork-notify@kernel.org>
Date: Thu, 18 May 2023 22:50:41 +0000
References: <20230518100759.84858-2-fw@strlen.de>
In-Reply-To: <20230518100759.84858-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
 pabeni@redhat.com, davem@davemloft.net, netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu, 18 May 2023 12:07:51 +0200 you wrote:
> Its currently not allowed to perform queries on a map, for example:
> 
> table t {
> 	map m {
> 		typeof ip saddr : meta mark
> 		..
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] netfilter: nf_tables: relax set/map validation checks
    https://git.kernel.org/netdev/net-next/c/a4878eeae390
  - [net-next,2/9] netfilter: nf_tables: always increment set element count
    https://git.kernel.org/netdev/net-next/c/d4b7f29eb85c
  - [net-next,3/9] netfilter: nft_exthdr: add boolean DCCP option matching
    https://git.kernel.org/netdev/net-next/c/b9f9a485fb0e
  - [net-next,4/9] netfilter: Reorder fields in 'struct nf_conntrack_expect'
    https://git.kernel.org/netdev/net-next/c/61e03e912da8
  - [net-next,5/9] netfilter: nft_set_pipapo: Use struct_size()
    https://git.kernel.org/netdev/net-next/c/a2a0ffb08468
  - [net-next,6/9] netfilter: conntrack: allow insertion clash of gre protocol
    https://git.kernel.org/netdev/net-next/c/d671fd82eaa9
  - [net-next,7/9] netfilter: flowtable: simplify route logic
    https://git.kernel.org/netdev/net-next/c/fa502c865666
  - [net-next,8/9] netfilter: flowtable: split IPv4 datapath in helper functions
    https://git.kernel.org/netdev/net-next/c/a10fa0b489d6
  - [net-next,9/9] netfilter: flowtable: split IPv6 datapath in helper functions
    https://git.kernel.org/netdev/net-next/c/e05b5362166b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



