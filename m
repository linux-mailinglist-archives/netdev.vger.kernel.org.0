Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AF3488D8E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 01:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbiAJAuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 19:50:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46892 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiAJAuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 19:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFE20B81050;
        Mon, 10 Jan 2022 00:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C568C36AEF;
        Mon, 10 Jan 2022 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641775810;
        bh=PO7EGVGxZquF4FQkwG98p2MytiUwzHUeyTW++z/65Zs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l/DHUHb6WMJ1Z/2QtnTQoJBpSPxhTBmRCfiv2SJ/KYWgZQv4KuBPt1Sf9Ot2RFElP
         vy64iwauY7RbWMbj72ImceO9Lc1vjUqpgLGMYeONkNM1TxmCCzfOQP2Hzn8R2S4u6k
         2mmPRas/mztgwi60GCKayCnzlDsTDZF7PNdwmaaMESjagt1c0Sjo5mgRvL/FLqxri2
         TqvNyYdUHxzp5ZSn8KU98f5+eCwZHSea139jV90P+RV/NGIHdJWBfLxnV9tWFjJJv8
         ZTqiqxA8qxxcoTxIdbxFr+nGbncFazNu2W/9pY/smILKpjmqdPThlVjadTcEz4lmU+
         9/hQi4naz1hEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F96DF6078F;
        Mon, 10 Jan 2022 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/3] net: skb: introduce kfree_skb_with_reason()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177581045.14212.13471905867793638959.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 00:50:10 +0000
References: <20220109063628.526990-1-imagedong@tencent.com>
In-Reply-To: <20220109063628.526990-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     rostedt@goodmis.org, dsahern@kernel.org, mingo@redhat.com,
        davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org, alobakin@pm.me,
        willemb@google.com, cong.wang@bytedance.com, keescook@chromium.org,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        imagedong@tencent.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 14:36:25 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In this series patch, the interface kfree_skb_with_reason() is
> introduced(), which is used to collect skb drop reason, and pass
> it to 'kfree_skb' tracepoint. Therefor, 'drop_monitor' or eBPF is
> able to monitor abnormal skb with detail reason.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/3] net: skb: introduce kfree_skb_reason()
    https://git.kernel.org/netdev/net-next/c/c504e5c2f964
  - [v4,net-next,2/3] net: skb: use kfree_skb_reason() in tcp_v4_rcv()
    https://git.kernel.org/netdev/net-next/c/85125597419a
  - [v4,net-next,3/3] net: skb: use kfree_skb_reason() in __udp4_lib_rcv()
    https://git.kernel.org/netdev/net-next/c/1c7fab70df08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


