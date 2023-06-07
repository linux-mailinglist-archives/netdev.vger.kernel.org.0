Return-Path: <netdev+bounces-8776-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D5F725B35
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 551A5281240
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E2435B2E;
	Wed,  7 Jun 2023 10:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909B135B22
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F06CC433A8;
	Wed,  7 Jun 2023 10:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686132021;
	bh=0dfSi5baOwHge9oLciETd/jRWuJxysOaO/ixbP9BOFc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WF50fkmTOwnZuoU8rSKlfG/SD64BuiVu839/bBxCe1UZtWn0BTJ7bofE4LT5KFtWe
	 LIiHu2jM1fzuUEO9BfX3zfPVFks/Ma/lc8XnQf/mcjvtPvjgTshjLZZayr9biKFJsd
	 yi/Rp/2hUPasFUB9g94dhVNhppLYiQW5nhspgvDGFXYPXQswnZko7LwR4rH0psOBp+
	 ChLR4VXJKLmpDgB0w8heygZqG7Wa2aPEVQ9mp2gf/4+7wNW8PmwP76lvYa5oy3y0j3
	 dBQ9ndvh9QBUXjWx+eJn0Q1c2MwnJMmrvbhD6UIHOkpPIUyjgKFagbwA9uHwEf7yS7
	 xnbb55K5JOtWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08D6AE29F3C;
	Wed,  7 Jun 2023 10:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: fix formatting in sysctl_net_ipv4.c
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613202103.15110.247541167202634558.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 10:00:21 +0000
References: <20230606181233.373319-1-morleyd.kernel@gmail.com>
In-Reply-To: <20230606181233.373319-1-morleyd.kernel@gmail.com>
To: David Morley <morleyd.kernel@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 netdev@vger.kernel.org, morleyd@google.com, ncardwell@google.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Jun 2023 18:12:33 +0000 you wrote:
> From: David Morley <morleyd@google.com>
> 
> Fix incorrectly formatted tcp_syn_linear_timeouts sysctl in the
> ipv4_net_table.
> 
> Fixes: ccce324dabfe ("tcp: make the first N SYN RTO backoffs linear")
> Signed-off-by: David Morley <morleyd@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Tested-by: David Morley <morleyd@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: fix formatting in sysctl_net_ipv4.c
    https://git.kernel.org/netdev/net-next/c/0824a987a580

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



