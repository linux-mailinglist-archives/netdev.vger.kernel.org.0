Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9A13FC674
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbhHaLLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241422AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6DD3D61008;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=65oiSWbfIGGoHoNB1+VTNWgZJJAW0WKGIkamrVmSC5Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e4NnaAHwaJzDml6RqMWCHX7YrQt/MsZOmY0U4vH6kkmFaI2MEebM0ghFimRUSuqXp
         Wgub6HVw2doE8OYM7PadzFs9qpm77HUjTew+VzrA1rsYaF5BjTuHlfXzmf9cGkddsz
         /omuvCexiqCbpgdPj+oh8S5+xmHg1owa3tLB7t6hss7Hypkg/h1TcWvCvHX+6XoUOe
         Zpu00Ja+1oUVboq5ENqdMurnfn1vw39OH6F9uPE6uRMctPwCGB5Hojwm9LRMykhg6A
         U4hJxa/FpLV6om4QVwoscO5sj1VCGjQGsg7+nc+0WrleAIR5sRUgA5d7eNtM4fe9RE
         rqCfGvLQTKmKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64E1E60A7D;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] fou: remove sparse errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820840.5377.12465802324666851427.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210831032608.932407-1-eric.dumazet@gmail.com>
In-Reply-To: <20210831032608.932407-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 20:26:08 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We need to add __rcu qualifier to avoid these errors:
> 
> net/ipv4/fou.c:250:18: warning: incorrect type in assignment (different address spaces)
> net/ipv4/fou.c:250:18:    expected struct net_offload const **offloads
> net/ipv4/fou.c:250:18:    got struct net_offload const [noderef] __rcu **
> net/ipv4/fou.c:251:15: error: incompatible types in comparison expression (different address spaces):
> net/ipv4/fou.c:251:15:    struct net_offload const [noderef] __rcu *
> net/ipv4/fou.c:251:15:    struct net_offload const *
> net/ipv4/fou.c:272:18: warning: incorrect type in assignment (different address spaces)
> net/ipv4/fou.c:272:18:    expected struct net_offload const **offloads
> net/ipv4/fou.c:272:18:    got struct net_offload const [noderef] __rcu **
> net/ipv4/fou.c:273:15: error: incompatible types in comparison expression (different address spaces):
> net/ipv4/fou.c:273:15:    struct net_offload const [noderef] __rcu *
> net/ipv4/fou.c:273:15:    struct net_offload const *
> net/ipv4/fou.c:442:18: warning: incorrect type in assignment (different address spaces)
> net/ipv4/fou.c:442:18:    expected struct net_offload const **offloads
> net/ipv4/fou.c:442:18:    got struct net_offload const [noderef] __rcu **
> net/ipv4/fou.c:443:15: error: incompatible types in comparison expression (different address spaces):
> net/ipv4/fou.c:443:15:    struct net_offload const [noderef] __rcu *
> net/ipv4/fou.c:443:15:    struct net_offload const *
> net/ipv4/fou.c:489:18: warning: incorrect type in assignment (different address spaces)
> net/ipv4/fou.c:489:18:    expected struct net_offload const **offloads
> net/ipv4/fou.c:489:18:    got struct net_offload const [noderef] __rcu **
> net/ipv4/fou.c:490:15: error: incompatible types in comparison expression (different address spaces):
> net/ipv4/fou.c:490:15:    struct net_offload const [noderef] __rcu *
> net/ipv4/fou.c:490:15:    struct net_offload const *
> net/ipv4/udp_offload.c:170:26: warning: incorrect type in assignment (different address spaces)
> net/ipv4/udp_offload.c:170:26:    expected struct net_offload const **offloads
> net/ipv4/udp_offload.c:170:26:    got struct net_offload const [noderef] __rcu **
> net/ipv4/udp_offload.c:171:23: error: incompatible types in comparison expression (different address spaces):
> net/ipv4/udp_offload.c:171:23:    struct net_offload const [noderef] __rcu *
> net/ipv4/udp_offload.c:171:23:    struct net_offload const *
> 
> [...]

Here is the summary with links:
  - [net-next] fou: remove sparse errors
    https://git.kernel.org/netdev/net-next/c/8d65cd8d25fa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


