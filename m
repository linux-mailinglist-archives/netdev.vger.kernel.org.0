Return-Path: <netdev+bounces-8792-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF33725D1B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 882FA281215
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B2613ADE;
	Wed,  7 Jun 2023 11:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F3912B98
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0031BC4339B;
	Wed,  7 Jun 2023 11:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686137421;
	bh=uVbtAy0x/dVCXLUyFCOPrRWwjtY3jhYCA7mZoOR65vg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NRGMwO2e1FhaPKn//iwyxv9AoYP0jzU0YTc6nssJXaEvE2N5mQ40pX45W3m8OapEa
	 bwWk6rLKOgcMDpbj/GiLKlI0eGA7gL7Vq6utntBAOUa/lx16TicNYH9w40bE6SVSyg
	 C/NXiBpbT2AMffp4qQ0kGl1PgHZVhK4efj/fn4o/TfI9ycONprpq7CYEeAaO+K3SSP
	 l/GtqZPhTS6RwgQJ4JEPNcE2icddczrNhGSDJkH0ovz+X1OHTJtwPzUEVtGwfUo6lf
	 hebbnFhxGX8sJqU7Je0i8PuPdUMZlkpElILjXKtBYgSy+RtWeTyZjA5YsRP5R20Dhe
	 Hva6S5D1wkBhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4103E29F39;
	Wed,  7 Jun 2023 11:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: move rtm_tca_policy declaration to include
 file
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613742086.29815.681497213780750432.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 11:30:20 +0000
References: <20230606114233.4160703-1-edumazet@google.com>
In-Reply-To: <20230606114233.4160703-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
 eric.dumazet@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Jun 2023 11:42:33 +0000 you wrote:
> rtm_tca_policy is used from net/sched/sch_api.c and net/sched/cls_api.c,
> thus should be declared in an include file.
> 
> This fixes the following sparse warning:
> net/sched/sch_api.c:1434:25: warning: symbol 'rtm_tca_policy' was not declared. Should it be static?
> 
> Fixes: e331473fee3d ("net/sched: cls_api: add missing validation of netlink attributes")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sched: move rtm_tca_policy declaration to include file
    https://git.kernel.org/netdev/net/c/886bc7d6ed33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



