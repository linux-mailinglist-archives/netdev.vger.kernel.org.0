Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BD243AA38
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhJZCWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhJZCWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 22:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3DB4661057;
        Tue, 26 Oct 2021 02:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635214809;
        bh=2Bl/4rWPheyMHUOBqddzvx0706ZOWLqvYaHYjAxoNow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NKNHZTlgpAK9RXGoHSwNshfk8ZkLZrhbfKO9A+JshGMNX6a5CE1EY2g8+46APlxjS
         05XrmxwqIVpHx9vEJmOvLiPJe1ucIpZZ8CKcTzNh1djIwFL9tZslFIYkBVn7WPdZNr
         COl1M3OBOrnqLkbo2V4iJND5WuS7vzYPuicON3+5n98xGO22NtXA8h+6JFt8k0wIEP
         2WEXskRY85DNB7m+igKc8UV7tckIMJChLRu8BwWdt/Z6mhzeKkI1aKwc7RTgJQk/MG
         7NwLGc5Tyw6Gy8pz7/6e34nhAENZafWOfXCqUUzwhmUEEFB7KFFpwjsTDKlMIwXTz+
         QVN8fISesGyEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 38B7960A17;
        Tue, 26 Oct 2021 02:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/10] tcp: receive path optimizations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163521480922.2466.4678242838255310115.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 02:20:09 +0000
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, soheil@google.com, ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 25 Oct 2021 09:48:15 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This series aims to reduce cache line misses in RX path.
> 
> I am still working on better cache locality in tcp_sock but
> this will wait few more weeks.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/10] tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
    https://git.kernel.org/netdev/net-next/c/0c0a5ef809f9
  - [v2,net-next,02/10] ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
    https://git.kernel.org/netdev/net-next/c/ef57c1610dd8
  - [v2,net-next,03/10] net: avoid dirtying sk->sk_napi_id
    https://git.kernel.org/netdev/net-next/c/2b13af8ade38
  - [v2,net-next,04/10] net: avoid dirtying sk->sk_rx_queue_mapping
    https://git.kernel.org/netdev/net-next/c/342159ee394d
  - [v2,net-next,05/10] net: annotate accesses to sk->sk_rx_queue_mapping
    https://git.kernel.org/netdev/net-next/c/09b898466792
  - [v2,net-next,06/10] ipv6: annotate data races around np->min_hopcount
    https://git.kernel.org/netdev/net-next/c/cc17c3c8e8b5
  - [v2,net-next,07/10] ipv6: guard IPV6_MINHOPCOUNT with a static key
    https://git.kernel.org/netdev/net-next/c/790eb67374d4
  - [v2,net-next,08/10] ipv4: annotate data races arount inet->min_ttl
    https://git.kernel.org/netdev/net-next/c/14834c4f4eb3
  - [v2,net-next,09/10] ipv4: guard IP_MINTTL with a static key
    https://git.kernel.org/netdev/net-next/c/020e71a3cf7f
  - [v2,net-next,10/10] ipv6/tcp: small drop monitor changes
    https://git.kernel.org/netdev/net-next/c/12c8691de307

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


