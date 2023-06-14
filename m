Return-Path: <netdev+bounces-10636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E4572F807
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18C18281350
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4065417D9;
	Wed, 14 Jun 2023 08:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC168369
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DF20C433C0;
	Wed, 14 Jun 2023 08:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686732023;
	bh=ohGafOhz/k8lrTqI3s/xf/QqRX8/sFC70GYv3S6BuX0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J9rGV7RgGTnL12eyPFOohWllg4U+WPCeM9+Qep9SDvV1nKw71S4MmlIUJ2BczOMp2
	 25po0xRBldzcRhaGGl8ZK1NQhv2CZa85QCCykPsu2f2Dv6FgsDC7v9DrQJ4pavAMzL
	 CexgBw6k7XTbFfl7kvvt0oSXW3Xlo9D1AgIK1Lph0esZPEZVYv2LKM8/V6xDKQItLI
	 X3OCz0L5Qx0Ah79jRwcyfk6Pg/TdGrPi/yvwVyz99voCA4Q+ce07+0s3E0VKlZUcV+
	 OPc0UjsXeWm0AHc3xRI0z7r5p1LHTQAO71PQQnN1LzpAfpbetbC17OlJGZn2aJV4Ky
	 OItO/F80LfUVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 382A8C3274B;
	Wed, 14 Jun 2023 08:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/sched: Fix race conditions in
 mini_qdisc_pair_swap()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168673202322.7814.14751124253693940183.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 08:40:23 +0000
References: <cover.1686355297.git.peilin.ye@bytedance.com>
In-Reply-To: <cover.1686355297.git.peilin.ye@bytedance.com>
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 peilin.ye@bytedance.com, vladbu@mellanox.com, pctammela@mojatatu.com,
 john.fastabend@gmail.com, daniel@iogearbox.net, hdanton@sina.com,
 shaozhengchao@huawei.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, cong.wang@bytedance.com

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 10 Jun 2023 20:29:41 -0700 you wrote:
> Hi all,
> 
> These 2 patches fix race conditions for ingress and clsact Qdiscs as
> reported [1] by syzbot, split out from another [2] series (last 2 patches
> of it).  Per-patch changelog omitted.
> 
> Patch 1 hasn't been touched since last version; I just included
> everybody's tag.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
    https://git.kernel.org/netdev/net/c/2d5f6a8d7aef
  - [net,2/2] net/sched: qdisc_destroy() old ingress and clsact Qdiscs before grafting
    https://git.kernel.org/netdev/net/c/84ad0af0bccd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



