Return-Path: <netdev+bounces-11291-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57FCF7326CA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CE4C1C20EA3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3F3EC7;
	Fri, 16 Jun 2023 05:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147B07C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C94DAC433CD;
	Fri, 16 Jun 2023 05:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686894620;
	bh=LPov3YQCQbEv06fEvnCxbmXNlsD4Q77Scv2JiXFLaso=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tpVWIAQ4jfGjU63blaQxP057CHXFaFTqgHzo0+znx+eopcxS7p+PILKTTazaBSsJ5
	 zjyGHmf9R6n7nNKBpNdTrCDu6NYeK2vsx49i++HwmpwryUcL6rNL6omJA//fURueUo
	 Iqftn1UfFkc/K7RUc8MgNh+u2d0yGCzTZYCguwRkLTiEbJsIq0JWH/my3CZvnj1mJt
	 bgobhNCpQhWKymO+tGUqHF6/RJglWEceyBjBfDv7WINq1KEZkSZpCoivV11zlelrl6
	 xb8jiEPgfxrDtwC8ABJ29YC8RkrP84tc+L1fFnB6OlSAAVcdpPMYhccg/i+BlooKP0
	 emsexoDgUg6XQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98D53E21EE5;
	Fri, 16 Jun 2023 05:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next] net: ena: Add dynamic recycling mechanism for rx
 buffers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168689462062.26047.642728221186195773.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 05:50:20 +0000
References: <20230612121448.28829-1-darinzon@amazon.com>
In-Reply-To: <20230612121448.28829-1-darinzon@amazon.com>
To: Arinzon@codeaurora.org, David <darinzon@amazon.com>
Cc: davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
 dwmw@amazon.com, zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
 msw@amazon.com, aliguori@amazon.com, nafea@amazon.com, alisaidi@amazon.com,
 benh@amazon.com, akiyano@amazon.com, ndagan@amazon.com, shayagr@amazon.com,
 itzko@amazon.com, osamaabb@amazon.com, amitbern@amazon.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Jun 2023 12:14:48 +0000 you wrote:
> From: David Arinzon <darinzon@amazon.com>
> 
> The current implementation allocates page-sized rx buffers.
> As traffic may consist of different types and sizes of packets,
> in various cases, buffers are not fully used.
> 
> This change (Dynamic RX Buffers - DRB) uses part of the allocated rx
> page needed for the incoming packet, and returns the rest of the
> unused page to be used again as an rx buffer for future packets.
> A threshold of 2K for unused space has been set in order to declare
> whether the remainder of the page can be reused again as an rx buffer.
> 
> [...]

Here is the summary with links:
  - [v1,net-next] net: ena: Add dynamic recycling mechanism for rx buffers
    https://git.kernel.org/netdev/net-next/c/f7d625adeb7b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



