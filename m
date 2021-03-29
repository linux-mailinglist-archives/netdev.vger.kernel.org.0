Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A361834DC7E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhC2XaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhC2XaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1167A61990;
        Mon, 29 Mar 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617060609;
        bh=EXL/V1f5671ULe9zTlOxtZG5RkbkvreQBcphjnUfHMQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ggJZNBiqZH6NUsVc3Oncw91AnDIVjjOWzkNsXcbf0jOE90Q5R/JXggMzvZWpfBwub
         S3cUr3nh9Sl480xDXZAZdF6PhD7bEy7YAT506MxCU3ajEkSyv4Xwt4MQloiW3lMPfH
         SGBOKbPTYnJU1FxFdYita1HypGsxD6cNP1T+QLOGIi+kG1rPNvE1Ds860HnDpm1an0
         g1QjR06eqLfCyTKoxBsQzlVHrtVnDoAQXN3Uu3SKlvyJByJcCZVhNKLtFceqnqW2f4
         IQqkQwEIL5e1lBw81foyZ7HmLkalduQQDow7TiPqjxvo7u3P5TcUPpHgpTzwYOW9bs
         IzIanOdvWpSEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00F3760A48;
        Mon, 29 Mar 2021 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:tipc: Fix a double free in tipc_sk_mcast_rcv
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706060899.18537.8994477724999069966.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:30:08 +0000
References: <20210328073029.4325-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210328073029.4325-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 28 Mar 2021 00:30:29 -0700 you wrote:
> In the if(skb_peek(arrvq) == skb) branch, it calls __skb_dequeue(arrvq) to get
> the skb by skb = skb_peek(arrvq). Then __skb_dequeue() unlinks the skb from arrvq
> and returns the skb which equals to skb_peek(arrvq). After __skb_dequeue(arrvq)
> finished, the skb is freed by kfree_skb(__skb_dequeue(arrvq)) in the first time.
> 
> Unfortunately, the same skb is freed in the second time by kfree_skb(skb) after
> the branch completed.
> 
> [...]

Here is the summary with links:
  - net:tipc: Fix a double free in tipc_sk_mcast_rcv
    https://git.kernel.org/netdev/net/c/6bf24dc0cc0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


