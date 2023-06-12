Return-Path: <netdev+bounces-10009-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2114A72BAE4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D8C71C20B05
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFDC569F;
	Mon, 12 Jun 2023 08:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0071FD8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FBBBC433D2;
	Mon, 12 Jun 2023 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686559220;
	bh=89ak23KuxmgNnQPMFU5iJGei6tr8rWqGIYeuVSAnKaE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZnQruuSUgodDxarX9ASl68F8uSE0iYW7oMPfGpckfoJebKCuVX5D29GxTyS+Mw1A+
	 HvMa0COqzmqAbFnUOOORtzdVczT2TtTKE+QXa/qQb8avxuGGhjCBhvWfF5sl1iPaxO
	 +q3tJ/AB4xWP3k17uB6JBvI43KLXxxXlF9L5tRjFuvfN7ZFL5nSn3dMM0a335b6xFu
	 qiVLKEriqkBqMYpPSZK54r/jrPKjRXHUCYcD/44QFMYKCZkFWTQ1RmMQlmtDqZRrG0
	 oECqJ8DSjLcF0+5SIqjlt15IGcgDBA9w4UAlmM+ITclcc3EnGj4fpf3yPd2M7Umll1
	 2do/wT5/JHeNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D788E29F37;
	Mon, 12 Jun 2023 08:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2 net] sctp: handle invalid error codes without calling
 BUG()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655922031.2912.11244679238666177727.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:40:20 +0000
References: <4629fee1-4c9f-4930-a210-beb7921fa5b3@moroto.mountain>
In-Reply-To: <4629fee1-4c9f-4930-a210-beb7921fa5b3@moroto.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 9 Jun 2023 14:04:43 +0300 you wrote:
> The sctp_sf_eat_auth() function is supposed to return enum sctp_disposition
> values but if the call to sctp_ulpevent_make_authkey() fails, it returns
> -ENOMEM.
> 
> This results in calling BUG() inside the sctp_side_effects() function.
> Calling BUG() is an over reaction and not helpful.  Call WARN_ON_ONCE()
> instead.
> 
> [...]

Here is the summary with links:
  - [1/2,net] sctp: handle invalid error codes without calling BUG()
    https://git.kernel.org/netdev/net/c/a0067dfcd941
  - [2/2,net] sctp: fix an error code in sctp_sf_eat_auth()
    https://git.kernel.org/netdev/net/c/75e6def3b267

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



