Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA1D417514
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346864AbhIXNOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346896AbhIXNMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C44F860F41;
        Fri, 24 Sep 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632489007;
        bh=CA9RjA7zSPgs+dGwqupvLrY+FxaqcmLl7xArQkSgUrE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mp/OHtOMQUrt1DKAO9T3OFdRNz51cCYOOP+y3Q8Hc8q3qF/6/+XW7r5er2zgcZkta
         biugDcQErutKV5baauKdXrXqKmMGtMv/oyBxIrNredyecbtoeWtuWq6McXlSIG0+Ed
         4/GYs9u1zllL55PGaubPz9sSjvxt9WDZsR8eS71iP0sDgYEy5ITH8+vYFTgQmDkD/l
         F4tXHG/U6TBygRAhfMMgGR9QnS7rKKfD5Z6R4a6Qo55nZTc6BbmCnvj03hJKaI3UUc
         OKBtnPtrbGKavdieRN17xTlVHpK8P1v+lTT4Kk113IyDceFyR/+2N1I9uaMclCNeCJ
         l6M/X972uufJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A927160A6B;
        Fri, 24 Sep 2021 13:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163248900768.23178.4654443647284577748.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:10:07 +0000
References: <20210923150319.974-1-shaw.leon@gmail.com>
In-Reply-To: <20210923150319.974-1-shaw.leon@gmail.com>
To:     Xiao Liang <shaw.leon@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, kafai@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 23 Sep 2021 23:03:19 +0800 you wrote:
> Multipath RTA_FLOW is embedded in nexthop. Dump it in fib_add_nexthop()
> to get the length of rtnexthop correct.
> 
> Fixes: b0f60193632e ("ipv4: Refactor nexthop attributes in fib_dump_info")
> Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> ---
>  include/net/ip_fib.h     |  2 +-
>  include/net/nexthop.h    |  2 +-
>  net/ipv4/fib_semantics.c | 16 +++++++++-------
>  net/ipv6/route.c         |  5 +++--
>  4 files changed, 14 insertions(+), 11 deletions(-)

Here is the summary with links:
  - [net,v3] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
    https://git.kernel.org/netdev/net/c/597aa16c7824

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


