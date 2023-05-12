Return-Path: <netdev+bounces-2057-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 155FE700210
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 309D51C21154
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E093A7483;
	Fri, 12 May 2023 08:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0182E1FA6
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA243C4339C;
	Fri, 12 May 2023 08:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683878422;
	bh=fBaMfmcbsUKmMdeQ5+CmH2D58HzAP/yuwrookUAJBdQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MzS36ExN4zRNDgErNDx0J596uPD5CEz55B8dnqcomI6arR5fnJmNfa3AEnfPyx/NK
	 vlopbOj89buQxlSGehmgBBYRHdIV7yN7JX+7SWDFPQvHAg0r+KI1OwjD/pHvTslqOE
	 By5iKIdP8CcZVAiKAEdguc19NdfzQ7lhKWc0+caTVm3qYIjw0SaQCUBjEZBe3+TcT6
	 M8ZB07WImkMXUwAc1ajGHGbsR6xrxyT07M6UPkRRW8FRnKxvQ6k5AK5TmHwNdorI4p
	 u7DIzbG3qNirBEDCdonwHTuwuaOIygiSVE52Fo69nL8feo5b28cpwN8hv8OA8eY/52
	 Haqn5e1VsTv5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9023EE26D2A;
	Fri, 12 May 2023 08:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: exclude wireless drivers from netdev
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168387842258.16770.3098709499722350042.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:00:22 +0000
References: <20230511160310.979113-1-kuba@kernel.org>
In-Reply-To: <20230511160310.979113-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, kvalo@kernel.org, johannes@sipsolutions.net,
 linux-wireless@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 09:03:10 -0700 you wrote:
> It seems that we mostly get netdev CCed on wireless patches
> which are written by people who don't know any better and
> CC everything that get_maintainers spits out. Rather than
> patches which indeed could benefit from general networking
> review.
> 
> Marking them down in patchwork as Awaiting Upstream is
> a bit tedious.
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: exclude wireless drivers from netdev
    https://git.kernel.org/netdev/net/c/47af4291711f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



