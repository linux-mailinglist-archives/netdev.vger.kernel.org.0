Return-Path: <netdev+bounces-9496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE8372971C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D90A92818BF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BFE1113;
	Fri,  9 Jun 2023 10:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BE423BB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E90DC4339C;
	Fri,  9 Jun 2023 10:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686307221;
	bh=HqRF6r8J75am0/TGz1JIrl9KjnRcfUrduSSaH/UbhKk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ioKa0004fqkfvxKyNFMCujzB8yWuxMq3APBai4E4xy9Le/wO9/LY/YoDVpUrYSLia
	 6uyfnzwqFFaopo/Hu1EKLwxbTEJdUqhZOPnoVwodzSepslh0IokHl3C8YjGx2ZAICM
	 6XESD3HNp1dKS+rN2RuVWdRRgRFmR3z/PgPsVouhMpOWhhwFzvU+HDc/kdogCYoKDp
	 QEspCMDcpi4MuuBHleAedA0VVjO3m0K1iUBsQis1gMcldlBoqMx89oBoM2u4k3ynOl
	 sgl13hwaiJn7SPHJ/DZhphk5MQJNE4O8LVeXw24ALLiVRvc1KbOoJTiIcf524bvrXq
	 jnZOCijYP8Dtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 016E2C43157;
	Fri,  9 Jun 2023 10:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 3/3] tools: ynl: Remove duplicated include in
 devlink-user.c
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630722099.15877.14513212480913480643.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 10:40:20 +0000
References: <20230609085249.131071-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20230609085249.131071-1-yang.lee@linux.alibaba.com>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: simon.horman@corigine.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 abaci@linux.alibaba.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 16:52:47 +0800 you wrote:
> ./tools/net/ynl/generated/devlink-user.c: stdlib.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5464
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  tools/net/ynl/generated/devlink-user.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next,3/3] tools: ynl: Remove duplicated include in devlink-user.c
    (no matching commit)
  - [net-next,2/3] tools: ynl: Remove duplicated include in handshake-user.c
    https://git.kernel.org/netdev/net-next/c/e7c5433c5aaa
  - [net-next,1/3] net: hv_netvsc: Remove duplicated include in rndis_filter.c
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



