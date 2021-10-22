Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67C8437FA2
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbhJVUxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 16:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234762AbhJVUw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 16:52:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1CA626112F;
        Fri, 22 Oct 2021 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634935808;
        bh=WzFIkROSOvcx8vAah0t16FwP5HOCXV861KXkcTr4KvE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RPWDnXbI940iDaJDcJKIQB46dFbU78FV9quNriKrI0G9w89Mo+HqD/wrncINNTFg8
         Lz2EH7hTxSGqB6rtnuaBYgkapNC5kzLlKuB2VOv3Ok5R/tM1q/BlbDQM8sVE7Tdmnu
         B5LODtYexp61cCo4G8PWf3ngCNvs7aoU+o2U1aJF7iQ4ZNPAFmou/m8DT4l4B8fBQr
         9mJcoQdbQDSQg3J+5FJGMXBIIjG9rGBbaijCgZp5gGucSN9sWTsECHO1KDGL17OxO6
         kRBh7wedriYFmgpNF4hgnC0SWm0CSR9Rd11LsONSFh15783tifOL6gndt+KzRBbYCY
         6KUcKUp/S+HgQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D19F60A2A;
        Fri, 22 Oct 2021 20:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v10] skb_expand_head() adjust skb->truesize incorrectly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163493580804.25307.5781274493026198048.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 20:50:08 +0000
References: <644330dd-477e-0462-83bf-9f514c41edd1@virtuozzo.com>
In-Reply-To: <644330dd-477e-0462-83bf-9f514c41edd1@virtuozzo.com>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     eric.dumazet@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        jwi@linux.ibm.com, christoph.paasch@gmail.com,
        linux-kernel@vger.kernel.org, kernel@openvz.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Oct 2021 13:28:37 +0300 you wrote:
> Christoph Paasch reports [1] about incorrect skb->truesize
> after skb_expand_head() call in ip6_xmit.
> This may happen because of two reasons:
> - skb_set_owner_w() for newly cloned skb is called too early,
> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
> In this case sk->sk_wmem_alloc should be adjusted too.
> 
> [...]

Here is the summary with links:
  - [net,v10] skb_expand_head() adjust skb->truesize incorrectly
    https://git.kernel.org/netdev/net/c/7f678def99d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


