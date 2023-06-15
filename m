Return-Path: <netdev+bounces-11022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 796997311CB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB6CD2816DE
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0881E53A8;
	Thu, 15 Jun 2023 08:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF941379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36909C433C8;
	Thu, 15 Jun 2023 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686816620;
	bh=dxjkm3m8O2MPTIeb0JTZ6ABjDl4Re4A0C0kPAOSbxGo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TDyAuschd+98vEaQDCdAtehhRpIOdLeqvZOiyUmxEg/knjIjchCtfZ9WTwbigQwGj
	 2jnU1D/OPI3FV+MHKlf/L1eJvTLHezdQQQxnBJGFTCu0VTEQsIfsXVA+EXMhb+xK1b
	 ES0Ojv1Q0RqlKr9GS533PG1m3IOPyTikUbFXLi03mrpck4+PiNq45zHUCAz7SMwU+x
	 4GzjqOpX13CWBhEfizQYSVmdmb7EOi2FzoDFw5OEezCISexscoZcabYVcYIOyVOo85
	 fnNoSdrgkpEvPuIRDZRlkl9UsczzKsWcLdrmvMf1G1YymfuyaPrO2VQ/5nCKBNX9bq
	 ReifaFZNv3ERw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1216DC395C7;
	Thu, 15 Jun 2023 08:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tls: make the offload check helper take skb not
 socket
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168681662007.2859.16638410006829594250.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 08:10:20 +0000
References: <20230613205006.1995873-1-kuba@kernel.org>
In-Reply-To: <20230613205006.1995873-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
 rajur@chelsio.com, ayush.sawal@chelsio.com, dmichail@fungible.com,
 borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
 simon.horman@corigine.com, john.fastabend@gmail.com,
 anirudh.venkataramanan@intel.com, maxtram95@gmail.com, tariqt@nvidia.com,
 gal@nvidia.com, raeds@nvidia.com, liorna@nvidia.com,
 louis.peens@corigine.com, yinjun.zhang@corigine.com, na.wang@corigine.com,
 linux-rdma@vger.kernel.org, oss-drivers@corigine.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 13 Jun 2023 13:50:06 -0700 you wrote:
> All callers of tls_is_sk_tx_device_offloaded() currently do
> an equivalent of:
> 
>  if (skb->sk && tls_is_skb_tx_device_offloaded(skb->sk))
> 
> Have the helper accept skb and do the skb->sk check locally.
> Two drivers have local static inlines with similar wrappers
> already.
> 
> [...]

Here is the summary with links:
  - [net-next] net: tls: make the offload check helper take skb not socket
    https://git.kernel.org/netdev/net-next/c/ed3c9a2fcab3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



