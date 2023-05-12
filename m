Return-Path: <netdev+bounces-1999-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52FE6FFE5B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 813EC2817B3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A46D7F0;
	Fri, 12 May 2023 01:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662967FA
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED2FEC4339C;
	Fri, 12 May 2023 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683854420;
	bh=jtkuxj0RsDX9Nxju4tVBpf0Rfy1EYHOwBGoibADX7Tk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PYuIFm5ROYryVW3gqmzmH3Df0qTCtRFxHHlq/xCnRX+OafQGBC+E2sG1H8OAr4DMg
	 cPOQKC+UrLEfkpe5lSQ6cPF1xcpF1swCmeKD9u2umPN3rhoOEQu2KiQdXk+GCqEVJH
	 vqTUO7ZoiEFcHnYln5K4HuJjW54ngaIflYmQj28bHQPj/eXR3M8k/tA3ScsSia+e99
	 bYRB4EauyQhweJQW9N2mCicwGDJgHkignSuX+mC/NqnIJLO6OvrN7PPCiDHlmSEKUG
	 yhakEbhudv85Pq9+8AxiJUtWPYw45mpkezm8lj8NwaN1nJXJuJgMRtAjIFfN4LgpDf
	 1dwYHZrskOPXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5482E26D4C;
	Fri, 12 May 2023 01:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: remove nexthop_fib6_nh_bh()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168385441987.17474.3320435878838158821.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 01:20:19 +0000
References: <20230510154646.370659-1-edumazet@google.com>
In-Reply-To: <20230510154646.370659-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 dsahern@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com,
 syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 May 2023 15:46:46 +0000 you wrote:
> After blamed commit, nexthop_fib6_nh_bh() and nexthop_fib6_nh()
> are the same.
> 
> Delete nexthop_fib6_nh_bh(), and convert /proc/net/ipv6_route
> to standard rcu to avoid this splat:
> 
> [ 5723.180080] WARNING: suspicious RCU usage
> [ 5723.180083] -----------------------------
> [ 5723.180084] include/net/nexthop.h:516 suspicious rcu_dereference_check() usage!
> [ 5723.180086]
> other info that might help us debug this:
> 
> [...]

Here is the summary with links:
  - [net] ipv6: remove nexthop_fib6_nh_bh()
    https://git.kernel.org/netdev/net/c/ef1148d44874

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



