Return-Path: <netdev+bounces-4888-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA28970EFE4
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94ECA281239
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAFFC147;
	Wed, 24 May 2023 07:50:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BF91FA2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A45A2C4339B;
	Wed, 24 May 2023 07:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684914622;
	bh=bVpio6PzGQyQVs77Te6EMaxzOPI0zNz4x4en9a0dH4M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SMgk5r6xJuF0yG0qtBs+p6AC/3CAmCw55sZ/kWZLbh3lXnHjr/T1lfIx+s/t3Nj4S
	 ZgeIZQsKjAiCBBNQWuUSan7orCmDi8HkwLZ4zWYBHax/7OLfD7Lt7/unGAZBHgB5ea
	 PojKGd//zijzqKufR3jpA/CrNWiX7sJ1Ew7XY2AEBFOF9U4XA8KG+2T3uHb8w9K9cQ
	 EaHJl0d+8u3Ma+Gv1KSEbiZsoLeVgeE7uPfFV38EYXGdj3ZqmCgvvGxyw+jjwFR6hc
	 qAAEV6dPw28vPhuWZ4/ZnMMewSR1zWGYaFtku+l2gJ+ym8KScA8n3PiBsIgicRy8fJ
	 vye6lfBP5FLqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8213FC4166F;
	Wed, 24 May 2023 07:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: Fix out-of-bounds access in ipv6_find_tlv()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168491462252.4606.14185635484952180767.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 07:50:22 +0000
References: <20230523082903.117626-1-Ilia.Gavrilov@infotecs.ru>
In-Reply-To: <20230523082903.117626-1-Ilia.Gavrilov@infotecs.ru>
To: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, vyasevic@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 May 2023 08:29:44 +0000 you wrote:
> optlen is fetched without checking whether there is more than one byte to parse.
> It can lead to out-of-bounds access.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 3c73a0368e99 ("ipv6: Update ipv6 static library with newly needed functions")
> Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
> 
> [...]

Here is the summary with links:
  - [net] ipv6: Fix out-of-bounds access in ipv6_find_tlv()
    https://git.kernel.org/netdev/net/c/878ecb0897f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



