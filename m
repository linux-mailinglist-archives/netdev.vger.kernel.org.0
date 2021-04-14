Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F435FCFE
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhDNVKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhDNVKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A14F061222;
        Wed, 14 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618434610;
        bh=VjGmBCLCXtM966/bE4C19rl5+T+vGE0t8B1d6i0ZNig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gN4lFHAjklXPcXgg0eLfJUNSJic9s0oSxtoaS7P59P1rQdQwNdd7qTN0AZmuKKrWq
         7uqzHkZlY3/WJYM7MIp9U18YttJ+nVj6iCwGPSgEgRU/LQnc1M/tAovFUVnkrR78nX
         jt+/PsZUB/GgCRbF9guJyavKpQooHpu0Za+eOMHCP+r2XdI3r5qmAf3K71K56DNPY8
         8WQFkXUF7ZUIPiVSKf40bvMrpAjFqXBGHFEwzBY3s1IFPMCU3ZJ5Q100j0bvuZleAQ
         Y+yGVrty7B0MOhyARCyxD1+r9OweAmhez+mAN++ugYY63RVhE7u4CVFvklqimK6DYa
         dg/L/I3CkpQIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C4F7609B9;
        Wed, 14 Apr 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] skbuff: revert "skbuff: remove some unnecessary
 operation in skb_segment_list()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843461063.4219.11828406452249254320.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:10:10 +0000
References: <f092ecf89336221af04310c9feac800e49d4647f.1618397249.git.pabeni@redhat.com>
In-Reply-To: <f092ecf89336221af04310c9feac800e49d4647f.1618397249.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linyunsheng@huawei.com,
        dseok.yi@samsung.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 12:48:48 +0200 you wrote:
> the commit 1ddc3229ad3c ("skbuff: remove some unnecessary operation
> in skb_segment_list()") introduces an issue very similar to the
> one already fixed by commit 53475c5dd856 ("net: fix use-after-free when
> UDP GRO with shared fraglist").
> 
> If the GSO skb goes though skb_clone() and pskb_expand_head() before
> entering skb_segment_list(), the latter  will unshare the frag_list
> skbs and will release the old list. With the reverted commit in place,
> when skb_segment_list() completes, skb->next points to the just
> released list, and later on the kernel will hit UaF.
> 
> [...]

Here is the summary with links:
  - [net-next] skbuff: revert "skbuff: remove some unnecessary operation in skb_segment_list()"
    https://git.kernel.org/netdev/net-next/c/17c3df7078e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


