Return-Path: <netdev+bounces-10990-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BECE4730F17
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73ADE28166D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83655A52;
	Thu, 15 Jun 2023 06:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D64BA42
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A18AFC433C9;
	Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686809420;
	bh=qKc4Rd9HxjlwYyCz8O5eGzDWFNv8fcXap2wA0MjIx3g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Tfp1mbAfIbSnB+xPXQgP8lndiRvG64hX7RdZmczFnChWE0FsAEyTSDvJypoWIAzY8
	 6zTjZKPctPWe73IPaV+v1c8pbERzkTXM2drkeHGK5430i0XH1UhqdlOcTHHiOKpdD0
	 Xvxdzeh6L0w30nVVnnNRaf1aYOPEhMMpvxJ9+I+X40yRM3ZTKscpQJu2pnYGJBa241
	 nSfdeQ+iyOZow48CQMBM0FUYqL4zCmgrc/JlJWgwNZD4P0hSgVMOfTrdWXJs1OPiHU
	 /VpJTUb5QQLQw08uFNhl1Wk278/4H4IFE3BLdPrCalyxDnnHmQdUnCEdOKL1E40n3u
	 yhxZmWcXI3GrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 866F5C3274B;
	Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: cls_api: Fix lockup on flushing explicitly
 created chain
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168680942054.31160.1120307355113924275.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 06:10:20 +0000
References: <20230612093426.2867183-1-vladbu@nvidia.com>
In-Reply-To: <20230612093426.2867183-1-vladbu@nvidia.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, renmingshuai@huawei.com,
 netdev@vger.kernel.org, liaichun@huawei.com, caowangbao@huawei.com,
 yanan@huawei.com, liubo335@huawei.com, pctammela@mojatatu.com,
 simon.horman@corigine.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Jun 2023 11:34:26 +0200 you wrote:
> Mingshuai Ren reports:
> 
> When a new chain is added by using tc, one soft lockup alarm will be
>  generated after delete the prio 0 filter of the chain. To reproduce
>  the problem, perform the following steps:
> (1) tc qdisc add dev eth0 root handle 1: htb default 1
> (2) tc chain add dev eth0
> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
> (4) tc filter add dev eth0 chain 0 parent 1:
> 
> [...]

Here is the summary with links:
  - [net] net/sched: cls_api: Fix lockup on flushing explicitly created chain
    https://git.kernel.org/netdev/net/c/c9a82bec02c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



