Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F0D34F2B5
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhC3VAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232596AbhC3VAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A59B6619D0;
        Tue, 30 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617138009;
        bh=4Wn+eOai9UHEBmGcms+i8SFVtJe+OIm3uG5lCqUJcpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JVKck8PDGYIGvi1RaATGS5e5Y1A14UlrJSc/RTaFNtBKBYwbCnghGdU4jToPj+44K
         NxfCGzvPaa9JBk74clm4u+1R60scPI20NzZZSWYO4mW7MngmdkfiCazEWLXeKEMQXy
         grC+wpLr3hRtaWFiks36/hApPgNiLj9OXeUEtbizQY28VqKbPXktWR41quh2hXw8PU
         OrTkaI4LKOVfySy47Txu25w5eteUwySvQVZwIBhnrTH6UaQX7IPJtzU5TMCg+9bjiy
         7gFE4E5KSTyD3Gmu4H0NViI2AM36G0GkLLrGmY6w4W2uoCqWcT1caiwJ7rfd0CD9ZF
         Tc5k8qplSJHNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 99D4560A6D;
        Tue, 30 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: let skb_orphan_partial wake-up waiters.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713800962.19867.17506387176921755732.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 21:00:09 +0000
References: <532014d8a99966da5fbcee528abe56356899f04a.1617121851.git.pabeni@redhat.com>
In-Reply-To: <532014d8a99966da5fbcee528abe56356899f04a.1617121851.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 30 Mar 2021 18:43:54 +0200 you wrote:
> Currently the mentioned helper can end-up freeing the socket wmem
> without waking-up any processes waiting for more write memory.
> 
> If the partially orphaned skb is attached to an UDP (or raw) socket,
> the lack of wake-up can hang the user-space.
> 
> Even for TCP sockets not calling the sk destructor could have bad
> effects on TSQ.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: let skb_orphan_partial wake-up waiters.
    https://git.kernel.org/netdev/net/c/9adc89af724f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


