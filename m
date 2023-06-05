Return-Path: <netdev+bounces-7921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F4FF7221AA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:00:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C8071C20BA1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16C8134BE;
	Mon,  5 Jun 2023 09:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98D7134BB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76D48C4339C;
	Mon,  5 Jun 2023 09:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685955620;
	bh=TtaUEKMWw8ambb/sX1bgtdrda+H14rdgfA1pAlkQipE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oJ6uVNP/kXc864l3FaQ13+xICdzfEG8kbSdGcpZrnFijUTQoLHrzNW+U2e9wUmQAH
	 J/WJh2ww3WYsrdklkI92n2EHO8bITJtAbpnweKlZO5VgZ+xLM653ZA6fRLTRNYXFBl
	 SzkX5PaiyEM06pYZU+0DIKuRNWePuTwI5+3Ixrjb6NzdqLOOSFaVXxQLnI6RdtphcR
	 HudID7iATMaKd57n5LbkgZQQPQZr8ncycmWQeY9UJraVmcCZUV1UkSeflh+8rWrk2S
	 JIlOIryOC4K2g5RdglfDxydjAONi5vQUQ9GqktfINdTT0GmZZggPDHsFx0/cvHZRih
	 2JGeKc0C61dMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 573FAE8723D;
	Mon,  5 Jun 2023 09:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: fq_pie: ensure reasonable TCA_FQ_PIE_QUANTUM
 values
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168595562035.28487.16005029123059967506.git-patchwork-notify@kernel.org>
Date: Mon, 05 Jun 2023 09:00:20 +0000
References: <20230602123747.2056178-1-edumazet@google.com>
In-Reply-To: <20230602123747.2056178-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
 eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Jun 2023 12:37:47 +0000 you wrote:
> We got multiple syzbot reports, all duplicates of the following [1]
> 
> syzbot managed to install fq_pie with a zero TCA_FQ_PIE_QUANTUM,
> thus triggering infinite loops.
> 
> Use limits similar to sch_fq, with commits
> 3725a269815b ("pkt_sched: fq: avoid hang when quantum 0") and
> d9e15a273306 ("pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM")
> 
> [...]

Here is the summary with links:
  - [net] net/sched: fq_pie: ensure reasonable TCA_FQ_PIE_QUANTUM values
    https://git.kernel.org/netdev/net/c/cd2b8113c2e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



