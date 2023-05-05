Return-Path: <netdev+bounces-522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 642E76F7F3B
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 033DA280F80
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E962B5394;
	Fri,  5 May 2023 08:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84364C94
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EFCBC4339C;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683276019;
	bh=8fXbeci8WYKmW3af+fjKatR4JfH4t7nFwFnFJBoZTPA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iv6kR8slYWL8t1iCLDS32c6addJ+miFQSlUk1gjDohzedqpF/FLosnNJ5YcBOUCk3
	 uu7rW057hGGy0ve6T4G/FRejgzRhPFLbNXrt6eZJKGpk69qIAy28u0W1ziMFo6QpUS
	 /5LVd5mSOzY8l25w2r495C7Lu+YPcrzxT6HjXmJqsiRq66ySnvZgIb4y/xRk76/RBG
	 WkEHp4PCcLu7pGykudBQLJ7+klDRe+mA+sk4wcXJlKbY4nI3gcYjepD+2pkG6pdPIR
	 H5CGcO/OHUco4+h3VR94LqgNXrRExz23E0xES+NE9IiIR757b+8T+fDk+OrWhriv0t
	 k3wnV36zxcMXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7DDB2E5FFCE;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327601951.11276.17799441179157918753.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 08:40:19 +0000
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
In-Reply-To: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
To: Wenliang Wang <wangwenliang.1995@bytedance.com>
Cc: mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 zhengqi.arch@bytedance.com, willemdebruijn.kernel@gmail.com,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 May 2023 10:27:06 +0800 you wrote:
> For multi-queue and large ring-size use case, the following error
> occurred when free_unused_bufs:
> rcu: INFO: rcu_sched self-detected stall on CPU.
> 
> Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [v4] virtio_net: suppress cpu stall when free_unused_bufs
    https://git.kernel.org/netdev/net/c/f8bb51043945

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



