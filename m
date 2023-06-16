Return-Path: <netdev+bounces-11292-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D736F7326CF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCD341C20F61
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5BFC10F4;
	Fri, 16 Jun 2023 05:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43475EA4
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD033C433CA;
	Fri, 16 Jun 2023 05:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686894620;
	bh=vPvaMx7LQ5tK+7m2aafkX3FWMbfT4memLCs/OWWMj0k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ahUumr4ZTjdJ071pWpWg5d1VWOaJ0UgaciMrjALOcbNDyhYyiy5D3OsnX/ATgrXVa
	 NwJTe0h8oRww2xnzzmCeOTgkccjC8z7FOiyGaMHgqPEdWp66OawQZBbVT1V0NlN7Xx
	 icok10Am3xK+8B/0tmY8aejTzrI+WWkvFcjZ62Yg2XOhIfCSRAA8UaUiPfex+Ilovl
	 7Y8rmzVzdZ4AD0KGCVsH2NR24G8O5UVBzb1T2xzii7aIi+O9ZoNAqoHkgY/2BAAxOU
	 OBRrNZrGf1zP9D2BrV1ICFLUItKZ9A07gdi45B7kQCe9b7LF67ifvI0Pkc2euNZIDr
	 kRmgGPqTlECeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E718E49BBF;
	Fri, 16 Jun 2023 05:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: build failure after merge of the net-next tree
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168689462057.26047.14551601662113522861.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 05:50:20 +0000
References: <20230613164639.164b2991@canb.auug.org.au>
In-Reply-To: <20230613164639.164b2991@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 kuba@kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Jun 2023 16:46:39 +1000 you wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (sparc64
> defconfig) failed like this:
> 
> drivers/net/ethernet/sun/sunvnet_common.c: In function 'vnet_handle_offloads':
> drivers/net/ethernet/sun/sunvnet_common.c:1277:16: error: implicit declaration of function 'skb_gso_segment'; did you mean 'skb_gso_reset'? [-Werror=implicit-function-declaration]
>  1277 |         segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
>       |                ^~~~~~~~~~~~~~~
>       |                skb_gso_reset
> drivers/net/ethernet/sun/sunvnet_common.c:1277:14: warning: assignment to 'struct sk_buff *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>  1277 |         segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
>       |              ^
> 
> [...]

Here is the summary with links:
  - linux-next: build failure after merge of the net-next tree
    https://git.kernel.org/netdev/net-next/c/d9ffa069e006

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



