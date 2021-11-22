Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A326458EAE
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbhKVMxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235989AbhKVMxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 07:53:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CB9F060F70;
        Mon, 22 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637585409;
        bh=O71uzdhfpiBU3QjDvPK18gmGWBt1NByjvHz62xswjR0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FeCKKpPTWUYUpWuQO4WnkCZDczX8yv3tE/aa5xpOM5Z4o1nZyofUnZLbh4TbNA9c4
         8axMA7rGIuwUVkGXswY3fB/h5XjZXUbHNC/h2//uFZHrYfpJQzUSKNQA5zx1GVGD7f
         1ATU2+gsMhV69OluKOjicga21PQMRNt9snCz4VSTzRbYAzvLXdynv9+rQE7yipkV8J
         udoRZ5R+NPfeuiJeuMbXYWJ9Z564A53C8bcF7b5TM64EJTLpt6896y1rf+ovdiUyhD
         /AMPyIEszLsxly4+8cBzcLEMXJknzDP6J6JekJ4QIZ3wyzSXkB+HW5TqOxY7X/8Q4y
         OyS12uxWdHtrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C099E60972;
        Mon, 22 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: fix typos in __ip6_finish_output()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758540978.16054.8173399425482310139.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 12:50:09 +0000
References: <20211119013758.2740195-1-eric.dumazet@gmail.com>
In-Reply-To: <20211119013758.2740195-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, tobias@strongswan.org,
        steffen.klassert@secunet.com, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 17:37:58 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We deal with IPv6 packets, so we need to use IP6CB(skb)->flags and
> IP6SKB_REROUTED, instead of IPCB(skb)->flags and IPSKB_REROUTED
> 
> Found by code inspection, please double check that fixing this bug
> does not surface other bugs.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: fix typos in __ip6_finish_output()
    https://git.kernel.org/netdev/net/c/19d36c5f2948

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


