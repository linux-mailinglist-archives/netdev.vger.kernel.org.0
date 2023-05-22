Return-Path: <netdev+bounces-4204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 253EF70BA2B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 038A01C209C3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515D26AC2;
	Mon, 22 May 2023 10:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89697BE4A
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37763C4339C;
	Mon, 22 May 2023 10:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684751420;
	bh=JTiks+kcY1MWMewWEMTlxAaRs2hUPpriYJrPHyoRqmU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=R9cDZyUU0F9YtUoS9FofbNH6ZW5Sxo4zTbEmths1dtk1Cvub838pBmc6Ee1r34iyv
	 yGbVizGTPV7lgPsk8+qteXS3U62HjLsVEV9FoF4vfPJrxV4DpHdY1DJHtOn3wHPMH9
	 v98oZUOqSuW8q5243WdJZ7vTsXtFw97uFuBFLcb+z4I7mW6RG/XlxgrddJJvDy/rrj
	 hZjeqlcQBJsW0S0dmhcLsGg1rXF7UCm1Ez0eMXq0VnK5yNHF8buYnyF1P96MSAOBRR
	 lshFSaTfqTq26vYX3IEuJhUnx+jZIFfNvOEnKmkJD+9rIDf2yRlx+ycNbyEdXOS9fC
	 lCbpDHUahMPKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14F8EE22AEC;
	Mon, 22 May 2023 10:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/tcp: refactor tcp_inet6_sk()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168475142008.15930.2990801662854882442.git-patchwork-notify@kernel.org>
Date: Mon, 22 May 2023 10:30:20 +0000
References: <16be6307909b25852744a67b2caf570efbb83c7f.1684502478.git.asml.silence@gmail.com>
In-Reply-To: <16be6307909b25852744a67b2caf570efbb83c7f.1684502478.git.asml.silence@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
 dsahern@kernel.org, pabeni@redhat.com, kuba@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 May 2023 14:30:36 +0100 you wrote:
> Don't keep hand coded offset caluclations and replace it with
> container_of(). It should be type safer and a bit less confusing.
> 
> It also makes it with a macro instead of inline function to preserve
> constness, which was previously casted out like in case of
> tcp_v6_send_synack().
> 
> [...]

Here is the summary with links:
  - [net-next] net/tcp: refactor tcp_inet6_sk()
    https://git.kernel.org/netdev/net-next/c/fe79bd65c819

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



