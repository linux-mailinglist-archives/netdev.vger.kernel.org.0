Return-Path: <netdev+bounces-7369-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC1E71FE74
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6537281777
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0941182B6;
	Fri,  2 Jun 2023 10:00:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446881801C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C17F3C433A4;
	Fri,  2 Jun 2023 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685700019;
	bh=axHxZl+xvYbV4nLySvgLP8O+nf+S05oPIYqnPsD2AzA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=RwoJqXmJM2tZC2TQwgLw65lh9QPZQULEJUMQdX3FO1TaO569muh0asFusO4XCjWCB
	 3rrYubkBz5SWBdc5G8zHxPSlcJDU23YdSWqLuX2MAlQuHAkSBzGOUPhYM8FREKVO9x
	 ZRFFjqWWLQ04F7xd1OSEh1O+ID9hGQ1DJgzbnzLSJ3hU9DQr03fai+kUaHZpalZ1fz
	 u26RTZ15gGqCL4JpsXhLHZgo2XPPOLsOPVXneVQCxXNJkmIDKaQnMSVruBUfb19f6c
	 TsytIHJBimazJA6Bie/Ii4PYcv0WmcyQnWieCvUNALPhHQmALmjv3y668HpwU4Yo9V
	 Qh5b8wCTzNpXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AADC0C395E0;
	Fri,  2 Jun 2023 10:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv4: Drop tos parameter from flowi4_update_output()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168570001969.17073.4452978864455433117.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 10:00:19 +0000
References: <f9e28cf551d9efb9278ac80d34d458295d8c845a.1685637136.git.gnault@redhat.com>
In-Reply-To: <f9e28cf551d9efb9278ac80d34d458295d8c845a.1685637136.git.gnault@redhat.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org,
 horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org,
 fw@strlen.de, marcelo.leitner@gmail.com, lucien.xin@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 1 Jun 2023 18:37:46 +0200 you wrote:
> Callers of flowi4_update_output() never try to update ->flowi4_tos:
> 
>   * ip_route_connect() updates ->flowi4_tos with its own current
>     value.
> 
>   * ip_route_newports() has two users: tcp_v4_connect() and
>     dccp_v4_connect. Both initialise fl4 with ip_route_connect(), which
>     in turn sets ->flowi4_tos with RT_TOS(inet_sk(sk)->tos) and
>     ->flowi4_scope based on SOCK_LOCALROUTE.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv4: Drop tos parameter from flowi4_update_output()
    https://git.kernel.org/netdev/net-next/c/3f06760c00f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



