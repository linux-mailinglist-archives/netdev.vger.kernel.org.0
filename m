Return-Path: <netdev+bounces-8775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 745E7725B30
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD4E51C20D11
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691D735B25;
	Wed,  7 Jun 2023 10:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF429463
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C75F9C4339B;
	Wed,  7 Jun 2023 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686132020;
	bh=RjOUhPlW2/RQwL9a4q62g7zfgotHcLWXz439NIO4jw4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ONWBvD/dw8BjMvM+tvftd7vMhFPWkAXQtvagTeGwcVkS0iy+7/689DdAMQDHtGKSM
	 SNHfKBR8ewPNw7646RiwmM9lvlRnnoMtoOJBWi9I+8bI2XpYzVaU6xEgU2QUErk2GL
	 IhVh3WX6b2MxqOQED4nNSNhGqiRYUbyJgpUucw7N7mxJWK4/+igkR8b5Nky52/P4TR
	 I5LU1DKJs+Ooz0A+GHW7KQIxh2fmi9wQn9WeBRuIVyk0oEZiX43QnhtEdrtRQmGUa2
	 oyD76YxuS/ggG/JaJZDIWNKJBvy8zeiiRMZbPzRHQM0Za7W3otZ+9bsmoV53YgT2pW
	 EoOTxYv9EGrTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA3D7E4D016;
	Wed,  7 Jun 2023 10:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: add rcu annotations around
 qdisc->qdisc_sleeping
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613202069.15110.251555931266029182.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 10:00:20 +0000
References: <20230606111929.4122528-1-edumazet@google.com>
In-Reply-To: <20230606111929.4122528-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
 eric.dumazet@gmail.com, syzkaller@googlegroups.com, vladbu@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  6 Jun 2023 11:19:29 +0000 you wrote:
> syzbot reported a race around qdisc->qdisc_sleeping [1]
> 
> It is time we add proper annotations to reads and writes to/from
> qdisc->qdisc_sleeping.
> 
> [1]
> BUG: KCSAN: data-race in dev_graft_qdisc / qdisc_lookup_rcu
> 
> [...]

Here is the summary with links:
  - [net] net: sched: add rcu annotations around qdisc->qdisc_sleeping
    https://git.kernel.org/netdev/net/c/d636fc5dd692

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



