Return-Path: <netdev+bounces-8766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ACFD7259FB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7BDA1C20D43
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B798F73;
	Wed,  7 Jun 2023 09:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04658F47
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BF86C4339B;
	Wed,  7 Jun 2023 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686129620;
	bh=BsPpq6k/DMlb/eBjeEkwLTKSEpf71rAbIgIw5hQzz9w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jLvL9aKxWwtitiCgOOyMV3R87QP/yCBKu7TEpDbjpjr2Bk8l4cmLyI3fA9ld8kXwl
	 t7iftsmYroXjecjR8dRengYUEy4frvWaQ41RoIox0i3Q5rSVTzIj7f4/hpVq/a8oWj
	 S9iy/PABYP4JzJe2gr2wgFT+NN2IWk8XMx7avp+BVjJWRASS2stU5e0+1bfXN2PBZw
	 TPr76ZVcyfCs8CE88EGXVt+kXeouVwANeMuhPLpvNzRJ/CYZRf9Tl3JG1/MEOutqXu
	 tx5ZWfyMJJO5xvGayOrVWXrJCtVmC4kbPJjcQkYcoezdXMtvDlb1IQf15oTeLN7cTD
	 Dg/pmVheaOiKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09BBFE29F3C;
	Wed,  7 Jun 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/2] rfs: annotate lockless accesses
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168612962003.23613.15655727280367173106.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 09:20:20 +0000
References: <20230606074115.3789733-1-edumazet@google.com>
In-Reply-To: <20230606074115.3789733-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 simon.horman@corigine.com, netdev@vger.kernel.org, eric.dumazet@gmail.com

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Jun 2023 07:41:13 +0000 you wrote:
> rfs runs without locks held, so we should annotate
> read and writes to shared variables.
> 
> It should prevent compilers forcing writes
> in the following situation:
> 
>   if (var != val)
>      var = val;
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] rfs: annotate lockless accesses to sk->sk_rxhash
    https://git.kernel.org/netdev/net/c/1e5c647c3f6d
  - [v2,net,2/2] rfs: annotate lockless accesses to RFS sock flow table
    https://git.kernel.org/netdev/net/c/5c3b74a92aa2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



