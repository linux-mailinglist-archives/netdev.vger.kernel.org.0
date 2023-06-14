Return-Path: <netdev+bounces-10637-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B410472F80D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F32E281343
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768EF3D6C;
	Wed, 14 Jun 2023 08:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDC07FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6463EC433AD;
	Wed, 14 Jun 2023 08:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686732023;
	bh=w7r/Vy2RBgUGguVLqB/vtm9DdBD26hBrdfNnOcrlkOE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sTVizSWFb/tzgy5+wTBvprejqGJcc4Ww/FCrXSMdhUC+0j7FGaWBicvTiHvgwzTlX
	 tMQvF6uLXVhh9x8SGKUmd2LHBO5/FRNn30wzr6OXbfmLV3amJbPAJ82oV2LhIpo/1n
	 xourXznT9H9cli0svwAOkSPODn8ZcxeiiqVEiXLJhuK0ZtpE9Jr5vB4LTvlIJ+DKm2
	 hPi7VhJjCiYq4WaEJnZRxKDNU7wyBP4TgHHY5AX6NKSxcWKRj5kvrBfDQN+5CtAw/P
	 lqgEr9laYn27OOCKEM+p6r0zevQjnqc8eBpt+mK2TvIoXvWQiNzH9rFsplNgORfGjs
	 b0NQMnmfL4RVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 449DDE2A048;
	Wed, 14 Jun 2023 08:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix promotion of offloaded
 unreplied tuple
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168673202327.7814.1952400928675625882.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 08:40:23 +0000
References: <1686313379-117663-1-git-send-email-paulb@nvidia.com>
In-Reply-To: <1686313379-117663-1-git-send-email-paulb@nvidia.com>
To: Paul Blakey <paulb@nvidia.com>
Cc: vladbu@nvidia.com, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 ozsh@nvidia.com, roid@nvidia.com, saeedm@nvidia.com, pablo@netfilter.org,
 kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 9 Jun 2023 15:22:59 +0300 you wrote:
> Currently UNREPLIED and UNASSURED connections are added to the nf flow
> table. This causes the following connection packets to be processed
> by the flow table which then skips conntrack_in(), and thus such the
> connections will remain UNREPLIED and UNASSURED even if reply traffic
> is then seen. Even still, the unoffloaded reply packets are the ones
> triggering hardware update from new to established state, and if
> there aren't any to triger an update and/or previous update was
> missed, hardware can get out of sync with sw and still mark
> packets as new.
> 
> [...]

Here is the summary with links:
  - [net,1/1] net/sched: act_ct: Fix promotion of offloaded unreplied tuple
    https://git.kernel.org/netdev/net/c/41f2c7c342d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



