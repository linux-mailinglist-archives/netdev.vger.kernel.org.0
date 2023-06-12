Return-Path: <netdev+bounces-9993-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8375E72B985
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D246281176
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5850CF9DB;
	Mon, 12 Jun 2023 08:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F8F9CF
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60F01C433AC;
	Mon, 12 Jun 2023 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686556820;
	bh=VSbkpBAfnfCsDChrZZF0k+v1Wqyd9zHxrQ7tTLKGEgw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=U6dujUBmhu9ZlqYQL1sQGxcDw+GQs0y9uFJyKCMZ7El2Up6N6FqnZiCLgxDgfT4Lr
	 YCestSXns02ClWuCiqLCnMAx+EbHQWL0YN0gjAM0OkhfD4fhmCsfkVsd1vEuzQ3N0x
	 g/kN0LAegyQWxxJrUw6gMOwp2IhWxAE4HKHKGuaVybjVpNgjZT2I1NzPyaw+sRz7x1
	 6wR4Eygi5BPAxBHQ+ppt7tW8vcMSivFWEh/bDw53sgto2xDtREUaqSCpqLHtyeVePL
	 LK3xhTGYQuqx7/dIocKVL9XsDZH4+/xFi6DC9x1hDazDY+3mjlUU+OdNnN0DcqNge9
	 S0Zxg4BwZnfsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AE47E21EC0;
	Mon, 12 Jun 2023 08:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethtool: correct MAX attribute value for stats
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655682016.11914.16890533533752697129.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:00:20 +0000
References: <20230608162344.1210365-1-kuba@kernel.org>
In-Reply-To: <20230608162344.1210365-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 09:23:44 -0700 you wrote:
> When compiling YNL generated code compiler complains about
> array-initializer-out-of-bounds. Turns out the MAX value
> for STATS_GRP uses the value for STATS.
> 
> This may lead to random corruptions in user space (kernel
> itself doesn't use this value as it never parses stats).
> 
> [...]

Here is the summary with links:
  - [net] net: ethtool: correct MAX attribute value for stats
    https://git.kernel.org/netdev/net/c/52f79609c0c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



