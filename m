Return-Path: <netdev+bounces-1380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A8D6FDA6C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 214C62810EB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C74364;
	Wed, 10 May 2023 09:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8095D65C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47B48C433A1;
	Wed, 10 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683709821;
	bh=n4oSszFWlUuY/YW0504XowqtII/NgUTgi5DYFN4QvI4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pw8MWIbYbZatN6h/cMKlgC5DC5iJHN74BI200kR5jpqHfx/+c+2CL03iyzwrqIxoj
	 n53O+auqexaLzCwBwDfYaUMysdpTuLb3wacjxSQnvH58JYF2B5eASu50S3eLg3EDIB
	 J2ZC8cop4wkBTW98/TqKhoDkvH3X8XQDv275+0fDz7H11S8jFr8Fhsn6m0xb1VgZnU
	 88l1GM9R3xbfge0fZL95C9i7YPbhSI7WAeZA8XxEcAtTDOUYiyA5mYkfhAAX49uUR8
	 e3CxwLDa8W6M72XTy5g9g1FEjFOZ5j11XUY4+1mMrx+4Nvo0z9EN0ruyCzHdfA5IPp
	 oA0bs7nSpsWrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34275E270C4;
	Wed, 10 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: bonding: delete unnecessary line
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370982121.14294.17162229077706705346.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:10:21 +0000
References: <20230509090919.1100329-1-liali@redhat.com>
In-Reply-To: <20230509090919.1100329-1-liali@redhat.com>
To: Liang Li <liali@redhat.com>
Cc: netdev@vger.kernel.org, j.vosburgh@gmail.com, razor@blackwall.org,
 liuhangbin@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 09:09:19 +0000 you wrote:
> "ip link set dev "$devbond1" nomaster"
> This line code in bond-eth-type-change.sh is unnecessary.
> Because $devbond1 was not added to any master device.
> 
> Signed-off-by: Liang Li <liali@redhat.com>
> Acked-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: bonding: delete unnecessary line
    https://git.kernel.org/netdev/net-next/c/2f0f556713f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



