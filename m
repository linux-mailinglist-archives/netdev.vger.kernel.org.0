Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631113C62A3
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 20:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbhGLScz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 14:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235866AbhGLScw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 14:32:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD247611C0;
        Mon, 12 Jul 2021 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626114603;
        bh=R5nfbjGkj5/1ssa1y5Xn9m1CY9/WorGixyuSaJQ2lXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hhGDcOwuwFyb7e8JhiIfzk5GWIuRGcJZCt09L0dw7Y/AvbnfUeG7PsgVT0d6aESiO
         V4FRNx0z8uve4ovme4QC7TJr4FyRzU5Hvo9ilMMXfNj/iU0qgNcQJTRJhgZRUigufl
         rWx6bUm1LieQqX12/JYCITSLfXkD9JtAtS6PorHYEp6n4wX4F81G7qB8wbpgyywkDC
         IlJ7Sx87EtzhPdozxQ4wM/XShyZacfq6X6RFOxS8tAgSEifcBsdD68wEC7k6wfhcqd
         NRWCujsx1chUt4hGo7eE28J6uub9GZHUcKFmz6ipelbIe/DBGkWjl471Fwcf1pmqKG
         CrwnzmmC4E4ag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9DEA760A36;
        Mon, 12 Jul 2021 18:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH IPV6 v3 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162611460364.21721.17333274904461206785.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Jul 2021 18:30:03 +0000
References: <1b1efd52-dd34-2023-021c-c6c6df6fec5f@virtuozzo.com>
In-Reply-To: <1b1efd52-dd34-2023-021c-c6c6df6fec5f@virtuozzo.com>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 12 Jul 2021 09:45:06 +0300 you wrote:
> When TEE target mirrors traffic to another interface, sk_buff may
> not have enough headroom to be processed correctly.
> ip_finish_output2() detect this situation for ipv4 and allocates
> new skb with enogh headroom. However ipv6 lacks this logic in
> ip_finish_output2 and it leads to skb_under_panic:
> 
>  skbuff: skb_under_panic: text:ffffffffc0866ad4 len:96 put:24
>  head:ffff97be85e31800 data:ffff97be85e317f8 tail:0x58 end:0xc0 dev:gre0
> 
> [...]

Here is the summary with links:
  - [IPV6,v3,1/1] ipv6: allocate enough headroom in ip6_finish_output2()
    https://git.kernel.org/netdev/net/c/5796015fa968

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


