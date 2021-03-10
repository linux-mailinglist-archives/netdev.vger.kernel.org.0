Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6653334922
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhCJUu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhCJUuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 15:50:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E211164FB3;
        Wed, 10 Mar 2021 20:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615409407;
        bh=W0QBUQXXsVOtLCFmpCkP5WWs3UzfBldFvw7zbDIg/3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hbU/CHEz52/N8DoQR+ulfMVf1Ynx9VbUoLZuP4H3ggb/jNDrlpUBwiM5Qou3LMytw
         g9HHUsqLIbz0T1ez/nxMGn5vvVAk5mEvj1SQbno6a5ygAv268umzcVu9DxLT8NDXCI
         OcGiiIaICMRbQ5ZaeoycBEIgdMNyb0E01R98IR8xbpbHYLQF3I3ujG+PN3CQd7OTHm
         ELCf8IRnatp7lJynxWU2BH5DhnH6c7gAewr3K7P3jAWEMbNiYPboOddhgU/YMDinGQ
         R8TPVZ+Mjx6omBnMN/YkJh021/92kpA8Sx4NLgeVfN3M5JNw7Xiu926P0/2zhnPPa7
         02mmmiD4+75EQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7BD2609BB;
        Wed, 10 Mar 2021 20:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ipv6: fix suspecious RCU usage warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161540940787.31712.2042539896494623964.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 20:50:07 +0000
References: <20210310022035.2908294-1-weiwan@google.com>
In-Reply-To: <20210310022035.2908294-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        syzkaller@googlegroups.com, dsahern@kernel.org, idosch@idosch.org,
        petrm@nvidia.com, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  9 Mar 2021 18:20:35 -0800 you wrote:
> Syzbot reported the suspecious RCU usage in nexthop_fib6_nh() when
> called from ipv6_route_seq_show(). The reason is ipv6_route_seq_start()
> calls rcu_read_lock_bh(), while nexthop_fib6_nh() calls
> rcu_dereference_rtnl().
> The fix proposed is to add a variant of nexthop_fib6_nh() to use
> rcu_dereference_bh_rtnl() for ipv6_route_seq_show().
> 
> [...]

Here is the summary with links:
  - [net,v2] ipv6: fix suspecious RCU usage warning
    https://git.kernel.org/netdev/net/c/28259bac7f1d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


