Return-Path: <netdev+bounces-6240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD647154E2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:21:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1534281074
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB694A1A;
	Tue, 30 May 2023 05:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A56063A4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E03CEC433A7;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685424019;
	bh=6bKQaZ/ZUra5smpbm/rupPBRuMJY1J+XoHNt2xRN+5o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gszw9Xw6GujbrrhAWsJZ14MabYoIxtb+OF08puQy7GdyFYQ1AeWJ8ca3zAe/rlREp
	 V3shUiV2E6GjArvyqMDSYLYvhqpbmrAf7piT1sKblpOaZ2XQ5p+9g+l7NOn+uBl4aj
	 VjDvWpuvi4/IL6dRQdB3WUdeqNweaGgwRzjtsIVNqOWixHgyU7QNIjWbWxcJVoVwRw
	 ttYQf56GqDVjWMuG6Qe9OybhkRi7qe4CTEJxPtHLuhKtTSoGdhV08FWB/SRyO7YKPG
	 b2hTrqpQrb5Q56RSUgN9HAA0ur2c5Yv1a6lLpgoxyTaOoZgkse3SLCq5bYnVy8DW2i
	 DCkBmjG7jwAeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFF83E52BF8;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] tcp: Return user_mss for TCP_MAXSEG in CLOSE/LISTEN
 state if user_mss set
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542401978.30709.235910784896316889.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:20:19 +0000
References: <20230527040317.68247-1-cambda@linux.alibaba.com>
In-Reply-To: <20230527040317.68247-1-cambda@linux.alibaba.com>
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 kerneljasonxing@gmail.com, davem@davemloft.net, dsahern@kernel.org,
 kuba@kernel.org, xuanzhuo@linux.alibaba.com, dust.li@linux.alibaba.com,
 tonylu@linux.alibaba.com, mingliang@linux.alibaba.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 27 May 2023 12:03:17 +0800 you wrote:
> This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
> with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
> tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
> it's zero is probably a bug.
> 
> With this change, getting TCP_MAXSEG before connecting will return
> default MSS normally, and return user_mss if user_mss is set.
> 
> [...]

Here is the summary with links:
  - [net,v3] tcp: Return user_mss for TCP_MAXSEG in CLOSE/LISTEN state if user_mss set
    https://git.kernel.org/netdev/net/c/34dfde4ad87b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



