Return-Path: <netdev+bounces-60-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C89816F4F24
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 292B9280DC3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 03:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DC581D;
	Wed,  3 May 2023 03:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321877F4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 03:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3392C433EF;
	Wed,  3 May 2023 03:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683084619;
	bh=WLePMFTzjehr9UevzId0j2OA0wYMyFASCHTHGYPPt2w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=M32UpwLrF0haRxJJu4+N6DyK2waPH0u80DX/t6PsuBzKMfQdHl5U1+guDJAaWr+pJ
	 P40yjI8fyWwShSe28I1r5pqFwtVnSk14s722dNoho9UE/iKltSn8ytt89ZTFO79OZZ
	 HQtcjEOzDtBVaZxnXiPlEp7MtOHtQIlTUWBwNAnf3YyyEWnP8PYYU/Qjb6xiGtzxJm
	 k0yYwbacdxQwvUuXfYD4ZqRKqOOk2LCTWpy1kT1QDB/hVCngOQ1XSx9HKFhscVbjWI
	 MaWoFnDUAETaE3yfec2NR2xAGfqFqze1Eher+sSLPDwORJJjvg/IFwOjm0GFMb8mkU
	 XjGC+rEVRZ6BA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E1BEC3959E;
	Wed,  3 May 2023 03:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v2] net: ethernet: mtk_eth_soc: drop generic vlan rx offload,
 only use DSA untagging
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168308461957.6433.6971778251909204791.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 03:30:19 +0000
References: <20230426172153.8352-1-linux@fw-web.de>
In-Reply-To: <20230426172153.8352-1-linux@fw-web.de>
To: Frank Wunderlich <linux@fw-web.de>
Cc: linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
 sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com, lorenzo@kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 linux@armlinux.org.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 frank-w@public-files.de, arinc.unal@arinc9.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Apr 2023 19:21:53 +0200 you wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> Through testing I found out that hardware vlan rx offload support seems to
> have some hardware issues. At least when using multiple MACs and when
> receiving tagged packets on the secondary MAC, the hardware can sometimes
> start to emit wrong tags on the first MAC as well.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging
    https://git.kernel.org/netdev/net/c/c6d96df9fa2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



