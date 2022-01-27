Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06FB49E47B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbiA0OUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:20:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36532 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiA0OUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED4561CEA
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BA0DC340E8;
        Thu, 27 Jan 2022 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643293209;
        bh=fyZYLFJ8fCagaYqVu9JIAYAO9/j0Eds9yUSQeSE0iwA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uSSh3JOHtumZC97RUJqNmzGp7EkRyVTtwav7Hrs9F2xsKUHwFCSOIyrrdZXcAYr6u
         l21EEJ+KTfQiBjBTuV3AH4f45uRFRTsl9aoOeED0i5Z8QF70nbV/n+2p72NhtZqvb1
         rUIu84GAKyKDuFurE62McfgO0BzZTvGhen/g0pWiOZWGfDl1TRQi3HtmdMyGP4OJi1
         x06A3HVE+Fyp7XhbakaNCA6iNty/H7EpMCsSSwriGGVuHxRBNoxuNDx0WbxuvOpit4
         7skb/cXei6J4ixwozO5TCBw/YC8f+eqvOQkC8vfOVFQqCcdxJiomriGPivxWo7d/wR
         8lMESMHyjHnOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72773E5D08C;
        Thu, 27 Jan 2022 14:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: raw: lock the socket in raw_bind()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329320946.24382.9714626868081279512.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:20:09 +0000
References: <20220127005116.1268532-1-eric.dumazet@gmail.com>
In-Reply-To: <20220127005116.1268532-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 16:51:16 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For some reason, raw_bind() forgot to lock the socket.
> 
> BUG: KCSAN: data-race in __ip4_datagram_connect / raw_bind
> 
> write to 0xffff8881170d4308 of 4 bytes by task 5466 on cpu 0:
>  raw_bind+0x1b0/0x250 net/ipv4/raw.c:739
>  inet_bind+0x56/0xa0 net/ipv4/af_inet.c:443
>  __sys_bind+0x14b/0x1b0 net/socket.c:1697
>  __do_sys_bind net/socket.c:1708 [inline]
>  __se_sys_bind net/socket.c:1706 [inline]
>  __x64_sys_bind+0x3d/0x50 net/socket.c:1706
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Here is the summary with links:
  - [net] ipv4: raw: lock the socket in raw_bind()
    https://git.kernel.org/netdev/net/c/153a0d187e76

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


