Return-Path: <netdev+bounces-3232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5093706266
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0247281273
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BBD156D5;
	Wed, 17 May 2023 08:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD5915494
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA2B8C4339B;
	Wed, 17 May 2023 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684311020;
	bh=iYboL9dX+41SulISH6YWXCP0H8wdk++oren2dVtLuTQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SHBSZSqjOST9D+Ja79MDsKNVarQrLmUZK+Qkpul1ZdeIsLZxuw36Ym7DsqUKPzNi3
	 fGhEq9un9qpedKrZGNWBQkHBydCEMfmJYa45IHS8AmROPtAgo0pkqzaesJi7Z24PIq
	 fScSHokoANzseruSnsObAvH9/THPjbPGI5WulfoUT9zd86DSbWxqV+DAs3keXhU/ZW
	 adsFE5d4JKeK17Z938ou12gwzhJjl/RH9iJkQl0by7QBwcjyg5tsHM4lK2Gx6OUYAJ
	 eysRvl6o2LWew925ecFQSBhQIqthIvB75Mga87fF//PkdgxXxB75T5Kvs9aeAGGyL1
	 w6sx/LrD3scJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0CEFE21EEC;
	Wed, 17 May 2023 08:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command
 offset
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431102065.18881.9563171509805168718.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:10:20 +0000
References: <20230516073854.91742-1-m.migliore@tiesse.com>
In-Reply-To: <20230516073854.91742-1-m.migliore@tiesse.com>
To: Marco Migliore <m.migliore@tiesse.com>
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 ashkan.boldaji@digi.com, pavana.sharma@digi.com, kabel@kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 09:38:54 +0200 you wrote:
> According to datasheet, the command opcode must be specified
> into bits [14:12] of the Extended Port Control register (EPC).
> 
> Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
> Signed-off-by: Marco Migliore <m.migliore@tiesse.com>
> ---
>  drivers/net/dsa/mv88e6xxx/port.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command offset
    https://git.kernel.org/netdev/net/c/1323e0c6e1d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



