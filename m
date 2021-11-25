Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8088C45D37B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345367AbhKYDPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:15:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344081AbhKYDNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DDBC6108B;
        Thu, 25 Nov 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637809810;
        bh=B8txjbq1QFCPJHsZpsmUXy4I9I6nvAOoJ3r0FJ3ymOM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rDYUoDPZdB1hPtrxlmdtOJMdBjSSA7saX23hR2CjWsN8SJdQJ6yrzQjE5QpatTRhn
         9nB7TWMfSrCqVTT0mA4C6jGqlCQwRyoPHnDgSyG17yknP4Yc+qUykO989by/u2WHCJ
         gSMzWtlEttRH7tVMqf64A/R1lRYBeHK9F/1xuLoWnAYDzl7tV3E31TkDvRHPHAgKId
         O0/XVZ6ikQdv8UggU/6DPJS6kRfAQf7cpSKQaCNpPGCqEUbrSk4fC0lAXA9yR/pl4a
         JFilYDtTStz1frmB6B+rLtfwPW6JW/zec5PGjrJix9mzomyoU6h4MsywWIqIhRY2gm
         Vl+i4PDp6Yy3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48D4F60A0A;
        Thu, 25 Nov 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net-ipv6: do not allow IPV6_TCLASS to muck with tcp's ECN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780981029.14115.6055322513140573476.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 03:10:10 +0000
References: <20211123223154.1117794-1-zenczykowski@gmail.com>
In-Reply-To: <20211123223154.1117794-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, netdev@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 14:31:54 -0800 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This is to match ipv4 behaviour, see __ip_sock_set_tos()
> implementation at ipv4/ip_sockglue.c:579
> 
> void __ip_sock_set_tos(struct sock *sk, int val)
> {
>   if (sk->sk_type == SOCK_STREAM) {
>     val &= ~INET_ECN_MASK;
>     val |= inet_sk(sk)->tos & INET_ECN_MASK;
>   }
>   if (inet_sk(sk)->tos != val) {
>     inet_sk(sk)->tos = val;
>     sk->sk_priority = rt_tos2priority(val);
>     sk_dst_reset(sk);
>   }
> }
> 
> [...]

Here is the summary with links:
  - net-ipv6: do not allow IPV6_TCLASS to muck with tcp's ECN
    https://git.kernel.org/netdev/net-next/c/9f7b3a69c88d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


