Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4FD43E0B6
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhJ1MWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbhJ1MWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BB359610FF;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635423612;
        bh=sOxtZwtlc+ZqLWh+S1485m0WKOuGd/0C1NOZ1BHkm/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gfN2PfDjDr4ynNJ8/qjiwvjcXVpad125kFX1A1AtyVVRHwqnfYZTS6RZQ5MLrWTjq
         Iyyv15Foh6yvbAN9A/IGGm3/3TmiVBTqBFxhVOsQSExU3P0+2ebV47NHel53HM+mCd
         /loefx7g30w36mP5sJEsdIdkADmZGVTWVkt50hgf8FSupmRivqs6V4UhVnTMdZxiwI
         pkoCB1vrkrz7mPZjVQXlMRcSUAndqwV3a6HQZshrJvxGaWsBWFFi1g4r+DOqai7kCy
         9pDrNo2bfLSWiSWqEAzWYYfKdGJqWnCa6+q6+PGUwh6d1msUJshOT99bidjtUsBfBT
         9CIKYNtnh6wjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADDC460A17;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] tcp: tx side cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542361270.29870.14738748195494250486.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:20:12 +0000
References: <20211027201923.4162520-1-eric.dumazet@gmail.com>
In-Reply-To: <20211027201923.4162520-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 13:19:16 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We no longer need to set skb->reserved_tailroom because
> TCP sendmsg() do not put payload in skb->head anymore.
> 
> Also do some cleanups around skb->ip_summed/csum,
> and CP_SKB_CB(skb)->sacked for fresh skbs.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] tcp: remove dead code from tcp_sendmsg_locked()
    https://git.kernel.org/netdev/net-next/c/3ded97bc41a1
  - [net-next,2/7] tcp: cleanup tcp_remove_empty_skb() use
    https://git.kernel.org/netdev/net-next/c/27728ba80f1e
  - [net-next,3/7] tcp: remove dead code from tcp_collapse_retrans()
    https://git.kernel.org/netdev/net-next/c/bd4463147171
  - [net-next,4/7] tcp: no longer set skb->reserved_tailroom
    https://git.kernel.org/netdev/net-next/c/f401da475f98
  - [net-next,5/7] tcp: factorize ip_summed setting
    https://git.kernel.org/netdev/net-next/c/a52fe46ef160
  - [net-next,6/7] tcp: do not clear skb->csum if already zero
    https://git.kernel.org/netdev/net-next/c/4f2266748eab
  - [net-next,7/7] tcp: do not clear TCP_SKB_CB(skb)->sacked if already zero
    https://git.kernel.org/netdev/net-next/c/8b7d8c2bdb76

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


