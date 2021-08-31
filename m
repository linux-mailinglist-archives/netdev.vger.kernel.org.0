Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA223FC669
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbhHaLLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234255AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0EB8260F6B;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=64b2EWe0R3NZ5AZEWJNIXaiQOAWrhJkVLJ1UmaNuyJM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kt4BlTCnJY7+v9NZ56KuoQTxh6Lxx2ap3yDCbn5+u0PXCqEU+zB9vUhbgGKd7MCpG
         /qPzyksTNI6/B57hR10sLMopH7LD9okZ8JGQU/J2ofFsbgpnyw+/z02zBCiFDnU7R6
         HX6icOUAX4NJ+W2r17fjNBuCtoshQSR3uKFMer7qzbLgIR9gxcsNSelu4EpbqUkis3
         3LdnAytubVGAQc1MMhfivP2W9aIoxLYAghBuRKBVxvQwUABEaHGrKW0ZHRYesk+4JY
         dHYeOHgwL3rMyooISEQQxB0TfZgmN5kNwPGwVFqxu1fwwAw9hQ+988IuUSAyFtfqeM
         zJrOzG4Aw6zQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 079BE60A7D;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] af_unix: fix potential NULL deref in
 unix_dgram_connect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820802.5377.18368659895787211993.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210830172137.325718-1-eric.dumazet@gmail.com>
In-Reply-To: <20210830172137.325718-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, cong.wang@bytedance.com, ast@kernel.org,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 10:21:37 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot was able to trigger NULL deref in unix_dgram_connect() [1]
> 
> This happens in
> 
> 	if (unix_peer(sk))
> 		sk->sk_state = other->sk_state = TCP_ESTABLISHED; // crash because @other is NULL
> 
> [...]

Here is the summary with links:
  - [net-next] af_unix: fix potential NULL deref in unix_dgram_connect()
    https://git.kernel.org/netdev/net-next/c/dc56ad7028c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


