Return-Path: <netdev+bounces-8793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CCC725D1F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D24C28123A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BDD30B73;
	Wed,  7 Jun 2023 11:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8702E6AB4
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0707CC433D2;
	Wed,  7 Jun 2023 11:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686137421;
	bh=kW5Gh94b6D34f0zWR2zmd7ZyrG4ZdsBBEc6aVrZCfos=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MjdUnd9Z5LGtdfpaXe3Fm96ZNeJgy29KQ1CELvK3Px2Hr652FXxAmUbhvko5qoovt
	 CeNOb9MHgY+23Q1aOEQuUtTeYzHoR38Z0MSXRRobqVdAR75yd6r77AF8+R16qqVWRY
	 JGnrnR16pSeI9nQoiZBqlI1xEM1EcFVHoT5ZhlqESP3gLe0KzoKSaal2tTPGhTGYej
	 1mQXlfM0nQyrW8pGP5Cn1ixPLFIe0y2C7Nv1lzTLseCY8XjI7XATxNDQQB7iH6hUMB
	 aCGPZbxfw3hvQ9fyVWgXYsXGBclURweU6wvpfbLpcvzN/anfDr5RzkgdKIBQaTds7K
	 nvsh5QLV8uBQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF15CE4F13A;
	Wed,  7 Jun 2023 11:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: act_police: fix sparse errors in
 tcf_police_dump()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613742091.29815.7165661965376671329.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 11:30:20 +0000
References: <20230606131304.4183359-1-edumazet@google.com>
In-Reply-To: <20230606131304.4183359-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
 eric.dumazet@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Jun 2023 13:13:04 +0000 you wrote:
> Fixes following sparse errors:
> 
> net/sched/act_police.c:360:28: warning: dereference of noderef expression
> net/sched/act_police.c:362:45: warning: dereference of noderef expression
> net/sched/act_police.c:362:45: warning: dereference of noderef expression
> net/sched/act_police.c:368:28: warning: dereference of noderef expression
> net/sched/act_police.c:370:45: warning: dereference of noderef expression
> net/sched/act_police.c:370:45: warning: dereference of noderef expression
> net/sched/act_police.c:376:45: warning: dereference of noderef expression
> net/sched/act_police.c:376:45: warning: dereference of noderef expression
> 
> [...]

Here is the summary with links:
  - [net] net: sched: act_police: fix sparse errors in tcf_police_dump()
    https://git.kernel.org/netdev/net/c/682881ee45c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



