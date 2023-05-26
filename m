Return-Path: <netdev+bounces-5643-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED16F7124F3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 547D62817CD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3F7742C8;
	Fri, 26 May 2023 10:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777EE742C2
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28B3BC4339B;
	Fri, 26 May 2023 10:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685097620;
	bh=EnIfIg2ObHHnWVhckHfZ1sBUuKPbSqDQHvgscHhqrtk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=i6tqvyv0HdrKHMQ6XaE4t64RRsGCEB34bdWKMORHCgFUNFy+EpXUNh6ZcnmdAJQIz
	 ktlMf/eUSHVlS5htUA1OoyRIjVMSom+w+5f95ILoMcg94R3JWhJhVD2uY1ArgygHkO
	 PhcyeUu6+Y6QTSj9JYwn8ttkQ1EgzNlk32B7JHHO94F3aDam6EtYu3277xCCYDlJVG
	 +dm6AscYp+A1mIUnsAL5x/mPwB7PHh4U1RLUFoFImiBpKqWI+C8G6wkRXiNGKLlI9R
	 2koAZPF1ZZjc1+CuhW84afOfBlReWzaNGzlNbEtOCB3IrlBONPx6elynNLwh0eBW8U
	 3lJtJ8k8ka4cg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D79AC4166F;
	Fri, 26 May 2023 10:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: remove unused TCP_SYNQ_INTERVAL definition
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168509762005.28748.7704629943495222271.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 10:40:20 +0000
References: <20230525145736.2151925-1-ncardwell.sw@gmail.com>
In-Reply-To: <20230525145736.2151925-1-ncardwell.sw@gmail.com>
To: Neal Cardwell <ncardwell.sw@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
 netdev@vger.kernel.org, ncardwell@google.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 25 May 2023 10:57:36 -0400 you wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> Currently TCP_SYNQ_INTERVAL is defined but never used.
> 
> According to "git log -S TCP_SYNQ_INTERVAL net-next/main" it seems
> the last references to TCP_SYNQ_INTERVAL were removed by 2015
> commit fa76ce7328b2 ("inet: get rid of central tcp/dccp listener timer")
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: remove unused TCP_SYNQ_INTERVAL definition
    https://git.kernel.org/netdev/net-next/c/f26f03b30319

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



