Return-Path: <netdev+bounces-11298-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE0FC732717
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFD1D1C20E92
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41FD1100;
	Fri, 16 Jun 2023 06:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADE07C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78507C433C8;
	Fri, 16 Jun 2023 06:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686895820;
	bh=jD3AU92UzyQ5ezkTkzaT1Fd5mSwYhBVbDdASoMQ+rPY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rYWY22Hs5TddIzVxqUKwh+DHiPhECmVwxuTZl/aiKpn4LnGgGycdY5VMDTE97IorZ
	 BQzApCs5Tv+yRSQMEEuj0Jv5DkKjYkldYBmSSl59aVC7Y6X1I7oo8BkUCQn58k4pV7
	 /Bio/HRshfSnYD9GqAfkuqETBW1rDgi+l0z02rs4JF8oJgOJCLP+5tZLapvMhmf1Ar
	 BDhDNChCLfhxI6VNz7Al5DnanNQN+3Cux9CdbxuUTf879K4RjSpuK6f4LKO1/T/IPr
	 OujNJgQYbe3P76mI+KexBpdW5F0iMe1KAF6++xy0pXr9Pd8QIGJvjwzn8PsuNrw7l/
	 d4E9nCPmMuuXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54002E49BBF;
	Fri, 16 Jun 2023 06:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: litex: add support for 64 bit stats
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168689582034.4933.8219800852271272267.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 06:10:20 +0000
References: <20230614162035.300-1-jszhang@kernel.org>
In-Reply-To: <20230614162035.300-1-jszhang@kernel.org>
To: Jisheng Zhang <jszhang@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kgugala@antmicro.com, mholenko@antmicro.com,
 gsomlo@gmail.com, joel@jms.id.au, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 00:20:35 +0800 you wrote:
> Implement 64 bit per cpu stats to fix the overflow of netdev->stats
> on 32 bit platforms. To simplify the code, we use net core
> pcpu_sw_netstats infrastructure. One small drawback is some memory
> overhead because litex uses just one queue, but we allocate the
> counters per cpu.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: ethernet: litex: add support for 64 bit stats
    https://git.kernel.org/netdev/net-next/c/18da174d865a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



