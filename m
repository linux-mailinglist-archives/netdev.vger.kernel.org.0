Return-Path: <netdev+bounces-7798-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 447DA7218B9
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A7D31C20A9D
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF5B101FB;
	Sun,  4 Jun 2023 16:58:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A581DDBA
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 16:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B79ABC433EF;
	Sun,  4 Jun 2023 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685897926;
	bh=5nN02K2W4JaqvOzqHeM1LQ6Mr3+d2FfvlT3LaQF3nc8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qVsZFv/SArkF7y4/6lUWJUhgdNBkDdx1mxcFEm+64boAZ6uLpsetYU/JiUBcezikt
	 ZwztTgpG5JuoBZijmzicQYmD6g96rBBS98wvktVs4S/78ebYW09M1KsNBLl4WA1MPk
	 aJ35/B+qGKcPO9IW+Nv+qj1KymYqlv9o1vmDwYHmVdSWs/V3yemeUUQbWpS4rGfPxI
	 GOXSa/wBSDMjfvwJKa+RC/d8A7s+1o3BBZHjILWEjFcg7IETvMx3K0WnWDd+sj1PJz
	 ch7GUj1+/L3KpiwUQHhMO8NAIvwvald0l4F7MYsD0MZW8MK3yg4tRWBTl7WEKXtO9W
	 hNPM7CnVJlPeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91F33E52C02;
	Sun,  4 Jun 2023 16:58:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: wrap tc_skip_wrapper with CONFIG_RETPOLINE
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168589792659.18651.9066532001099296041.git-patchwork-notify@kernel.org>
Date: Sun, 04 Jun 2023 16:58:46 +0000
References: <20230602235210.91262-1-minhuadotchen@gmail.com>
In-Reply-To: <20230602235210.91262-1-minhuadotchen@gmail.com>
To: Min-Hua Chen <minhuadotchen@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat,  3 Jun 2023 07:52:09 +0800 you wrote:
> This patch fixes the following sparse warning:
> 
> net/sched/sch_api.c:2305:1: sparse: warning: symbol 'tc_skip_wrapper' was not declared. Should it be static?
> 
> No functional change intended.
> 
> Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: sched: wrap tc_skip_wrapper with CONFIG_RETPOLINE
    https://git.kernel.org/netdev/net/c/8cde87b007da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



