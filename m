Return-Path: <netdev+bounces-10011-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B743E72BAEA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 040D91C20A87
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4AF539D;
	Mon, 12 Jun 2023 08:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C55107A8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E3DFC433EF;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559222;
	bh=6q6K/ZSldiMBwb306CxjURo/TgUUC6WeXGv1VOPDG7w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=S9I4Os80qmax19hiJFQ9KqmzhmPnoAyBNVDAGFfPxKTBCh6HQ7c8XP9YymuAC8K8t
	 0DIEgNK7OeQzjo9xnTrMEeZTZrEQxDj2boQLDnP6yIYUWIQHFL9acTwBQTzIATwrCw
	 x+sJIKmcMhAxgtKAK7z/fKPj1A8sdIrkQbh153CLEp5sd6d+MnKIxqiaxQA6zeKFvb
	 ItIiKmfpu4QPhLHPEHL97WQGo0xLDa8MQIJV9IvOdtNCspj3dBkBqA/ixbm3+rFD7x
	 7o5M7RZ2Bh+5j3zGxWeS7zGj2nUq56HmPdvUjI+IgDenFOQya1x4LgQfPYKg6wc0Qg
	 dz0xNciFNf/VA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6478CE21EC0;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/sched: act_pedit: Use kmemdup() to replace kmalloc +
 memcpy
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655922240.2912.6853929575701794720.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:40:22 +0000
References: <20230609070117.100507-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20230609070117.100507-1-jiapeng.chong@linux.alibaba.com>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, abaci@linux.alibaba.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 15:01:17 +0800 you wrote:
> ./net/sched/act_pedit.c:245:21-28: WARNING opportunity for kmemdup.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5478
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  net/sched/act_pedit.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - net/sched: act_pedit: Use kmemdup() to replace kmalloc + memcpy
    https://git.kernel.org/netdev/net-next/c/26e35370b976

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



