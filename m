Return-Path: <netdev+bounces-4203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E5D70B9F1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7B7B280ECF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4108CAD55;
	Mon, 22 May 2023 10:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CD4AD5A
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE9F6C4339E;
	Mon, 22 May 2023 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684750819;
	bh=h03m6soAV+h3GUoc3/t/hNO1ViBXrCNtWN99bv0Qm6k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Kn7dLDaJlkUl/ZShPV9DnFLWXwwd/GZLb/Aj3qU//UD2HGxzc5PjTWN0ywhCYqce5
	 ztmniwrr4TGp7apkBvnVqNjuDXRVnjjPfhcgfB2bigkP7iB7Scl4+bzkHAOeHdoPTl
	 VADwOUp6U23SjO7e2FcYYgAsmqiXNe2UOY71N80QoJFopWiqloMpF+CnMZluCu7/ZD
	 A+cyusn/dFJhQTNACDYk/nh7r56SFzrW9odOeMxNYAtKX+XKlGd1JGsSQzio5ogVu4
	 vV89k6QMzEvBivLn+fW4ERhUjqKTSN8chi1OcTX9wYWZzCAj/0LeQBrfBE4D1i5bw8
	 AX6/u33wNt9aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0C0DE22B08;
	Mon, 22 May 2023 10:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: fec: remove useless fec_enet_reset_skb()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168475081978.10880.9020985051472472031.git-patchwork-notify@kernel.org>
Date: Mon, 22 May 2023 10:20:19 +0000
References: <20230519020113.1670786-1-wei.fang@nxp.com>
In-Reply-To: <20230519020113.1670786-1-wei.fang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, Frank.Li@freescale.com, shenwei.wang@nxp.com,
 xiaoning.wang@nxp.com, simon.horman@corigine.com, netdev@vger.kernel.org,
 linux-imx@nxp.com, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 May 2023 10:01:13 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> This patch is a cleanup for fec driver. The fec_enet_reset_skb()
> is used to free skb buffers for tx queues and is only invoked in
> fec_restart(). However, fec_enet_bd_init() also resets skb buffers
> and is invoked in fec_restart() too. So fec_enet_reset_skb() is
> redundant and useless.
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: fec: remove useless fec_enet_reset_skb()
    https://git.kernel.org/netdev/net-next/c/2ae9c66b0455

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



