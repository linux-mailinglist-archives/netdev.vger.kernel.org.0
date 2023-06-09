Return-Path: <netdev+bounces-9474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C826E729594
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDD1E1C20E88
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD81213AD1;
	Fri,  9 Jun 2023 09:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47813C8FF
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA976C433D2;
	Fri,  9 Jun 2023 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686303620;
	bh=MH/slqusJ0rHigURuXFXXGqA8bD++g8dcHKk4AkRc0s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=VJmOstqLupKtM8V/EqDoZVd4mtqeK5cQQGTU63kYm08JwwEQRLwaN16Za+yInvIvl
	 VHfQuOa8AkN6xbLSNNIxK9JiOUIZ87XfkZFxrh61v6HSbZVi87XCeikZDSmZLtCzYi
	 FbtwDMfF7a8pNw/IYYhZopkIqFsnwEC6PFvNt+jtHgqAzFrXacK5phgYl3nkEnyVYH
	 6r/IW4NFaiIaMfe8OjO4F0N4y6GDkkKu5Q+Gwai3Wq8y3zqqvlMjx6hFdPxuKaXJXP
	 eZCu0HF541833kc6/ZgApyWEpEGv8qbLbsvFye6pxTfTp2MGhGySfaCbPrMIl3EYwO
	 /4lFU5tMS1HHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98EA8C43157;
	Fri,  9 Jun 2023 09:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net/sched: act_pedit: Parse L3 Header for L4 offset
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630362062.15762.11087908182465443586.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 09:40:20 +0000
References: <20230607162353.3631199-1-mtottenh@akamai.com>
In-Reply-To: <20230607162353.3631199-1-mtottenh@akamai.com>
To: Max Tottenham <mtottenh@akamai.com>
Cc: netdev@vger.kernel.org, pctammela@mojatatu.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, amir@vadai.me, johunt@akamai.com,
 lkp@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 7 Jun 2023 12:23:54 -0400 you wrote:
> Instead of relying on skb->transport_header being set correctly, opt
> instead to parse the L3 header length out of the L3 headers for both
> IPv4/IPv6 when the Extended Layer Op for tcp/udp is used. This fixes a
> bug if GRO is disabled, when GRO is disabled skb->transport_header is
> set by __netif_receive_skb_core() to point to the L3 header, it's later
> fixed by the upper protocol layers, but act_pedit will receive the SKB
> before the fixups are completed. The existing behavior causes the
> following to edit the L3 header if GRO is disabled instead of the UDP
> header:
> 
> [...]

Here is the summary with links:
  - [v3] net/sched: act_pedit: Parse L3 Header for L4 offset
    https://git.kernel.org/netdev/net/c/6c02568fd1ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



