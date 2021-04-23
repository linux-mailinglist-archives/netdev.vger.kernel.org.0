Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21C3369B4E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243930AbhDWUas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhDWUaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 16:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 517CF60FE6;
        Fri, 23 Apr 2021 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619209809;
        bh=8mMevMnIpN6L9ppNytiHiaF8PJqmIVCSVKr/0HU7o8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HEJBOs5U5OpQSkXWQmOM3mXBg39jBu7OxG7At3s9+D2eJUKiBp1AjLeV5fTQRKWo/
         fOEhAOfnKk5t2zquCO+Bu3UCKVdWOyL7ttxg3VDN+0I8+43N907NATNATr0spmBlvL
         C+LQTQNQLbJyXXY7wBZU4jXTdERxoDdFpLo36rZMqXtqR53dAPQxZmA4mXaEw39M3N
         HcRTKY2EDXhwIwFW0Nj1YCRWzHq7ywlAgJYOi1WRwY6PmFEFCsIYLrqI4eiPTtPZLp
         JsW1kRjhc2/E1b+YyZflqi/vsMOHnhlzbFQ8hBsGFEqIeXALmtjw10fnKmNdYVrFZ9
         s9j9vJB3md6lQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 490A760976;
        Fri, 23 Apr 2021 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: geneve: modify IP header check in geneve6_xmit_skb
 and geneve_xmit_skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161920980929.7001.16835676253305880901.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 20:30:09 +0000
References: <20210422234945.1190-1-phil@philpotter.co.uk>
In-Reply-To: <20210422234945.1190-1-phil@philpotter.co.uk>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sd@queasysnail.net,
        edumazet@google.com, fw@strlen.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Apr 2021 00:49:45 +0100 you wrote:
> Modify the header size check in geneve6_xmit_skb and geneve_xmit_skb
> to use pskb_inet_may_pull rather than pskb_network_may_pull. This fixes
> two kernel selftest failures introduced by the commit introducing the
> checks:
> IPv4 over geneve6: PMTU exceptions
> IPv4 over geneve6: PMTU exceptions - nexthop objects
> 
> [...]

Here is the summary with links:
  - [v2] net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb
    https://git.kernel.org/netdev/net/c/d13f048dd40e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


