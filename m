Return-Path: <netdev+bounces-5558-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 459317121B8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73D6D281699
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5E0A956;
	Fri, 26 May 2023 08:00:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F281AD22
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10147C433D2;
	Fri, 26 May 2023 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685088020;
	bh=hu6W9zW97QJlO3dSfOzQjWd8snr1H2TZDggywhutmRg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ia735RjCykPUJaNYYeaTYEr7VMTWbLmUBCWJhaHM5ZOz954/NXfaqen14EAdcOxmA
	 RPuQmBcaEP/U7nFS81cBFLECJzIos0o1WWu0TpfCJLI6/SXyvJdGwRGIHe0FlHpSbZ
	 oBPTbf5NuYjCNGmlmgw4pLPuRVM6nuUNWBgj9jPkseF6+TGDdi3hfd2DgaSXESnMDd
	 O4fDBocLuQ+nGnVczFf8NzlmFy3xXqSHGlyKiT3SlmrJciJ0S7/mHyN8DrqPgreLIU
	 y1S4hR6ljJSDlTOk1B/pBB1BBmRKkjPUNB0LCBBARE7lgmsTRjhaSUnJy3UWAdIdbm
	 cfwxFd7psA12w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB950E22B06;
	Fri, 26 May 2023 08:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/core: Enable socket busy polling on -RT
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168508801989.27133.16510786217140929718.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 08:00:19 +0000
References: <20230523111518.21512-1-kurt@linutronix.de>
In-Reply-To: <20230523111518.21512-1-kurt@linutronix.de>
To: Kurt Kanzenbach <kurt@linutronix.de>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, bigeasy@linutronix.de

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 May 2023 13:15:18 +0200 you wrote:
> Busy polling is currently not allowed on PREEMPT_RT, because it disables
> preemption while invoking the NAPI callback. It is not possible to acquire
> sleeping locks with disabled preemption. For details see commit
> 20ab39d13e2e ("net/core: disable NET_RX_BUSY_POLL on PREEMPT_RT").
> 
> However, strict cyclic and/or low latency network applications may prefer busy
> polling e.g., using AF_XDP instead of interrupt driven communication.
> 
> [...]

Here is the summary with links:
  - [net-next] net/core: Enable socket busy polling on -RT
    https://git.kernel.org/netdev/net-next/c/c857946a4e26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



