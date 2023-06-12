Return-Path: <netdev+bounces-10019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF23D72BB2B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:50:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9782E281126
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90ED111CBF;
	Mon, 12 Jun 2023 08:50:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159C011CA1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 988B1C433EF;
	Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559840;
	bh=b+bn7leRxDoiLBJRTdyK2xdyjGCVByaugJwrw4baSm8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZtlT3oW6O+0aWyhdGUkxSbE2ij+9u7rDtrmftaiLjBAS+cxIXqTnwz2w25aYFFmAB
	 Z4BL5BqUnT1oYE3HWF5nkWw4L8sBb7OYboeXQH5xJbrAfvcb8ooNJM3My+dyGlXEGf
	 CMBko6iEZTc2MXLc3zg13pjvaFVRE8/6ygjk0lAhKGleOoAXra+u0rR3x8+Kz0tW/Q
	 aXAu2ROwczNdF18UnhPXuTmsUAcVC49knZa/PlbGhABLkBBuoNhFKUVmlWfaewu4e/
	 4pMNp5cIFK9FtOWhGVw1gldQpsu9/WIKtedR2Myqppgl4coeuQi0HQ1NdlN4h5gofu
	 VzbwAk33h9l1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75965E29F37;
	Mon, 12 Jun 2023 08:50:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Fixes for taprio xstats
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655984047.8602.3715939689092508081.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:50:40 +0000
References: <20230609135917.1084327-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230609135917.1084327-1-vladimir.oltean@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, vinicius.gomes@intel.com,
 kurt@linutronix.de, xiaoliang.yang_1@nxp.com,
 mohammad.athari.ismail@intel.com, linux-kernel@vger.kernel.org,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 intel-wired-lan@lists.osuosl.org, muhammad.husaini.zulkifli@intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 16:59:15 +0300 you wrote:
> 1. Taprio classes correspond to TXQs, and thus, class stats are TXQ
>    stats not TC stats.
> 2. Drivers reporting taprio xstats should report xstats for *this*
>    taprio, not for a previous one.
> 
> Vladimir Oltean (2):
>   net/sched: taprio: report class offload stats per TXQ, not per TC
>   net: enetc: reset taprio stats when taprio is deleted
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/sched: taprio: report class offload stats per TXQ, not per TC
    https://git.kernel.org/netdev/net-next/c/2b84960fc5dd
  - [net-next,2/2] net: enetc: reset taprio stats when taprio is deleted
    https://git.kernel.org/netdev/net-next/c/f1e668d29c57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



