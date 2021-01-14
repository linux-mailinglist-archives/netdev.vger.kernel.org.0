Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965E72F6A52
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbhANTAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbhANTAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 14:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2215923B3E;
        Thu, 14 Jan 2021 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610650811;
        bh=3uD+zw5WjRT+UXhWU6MwDd/4MC1Ah95iGzn5ZptYdNc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jex03xzcyVMTY0AlK2BymqSktKpBrxF+3KERVh2+vlPJPc3BQihPGi1ufZymUYeLW
         Pa+u8hVbAPFYBR0t4PQFYeTd/T3uyFoThnBP6M+efVOOUdGdVg6k2uJyhTgPBHA2wJ
         u/8nN344eWU70p2jAOz7blImVqDTz8HwdOz3qFSQG23zMIv8eaX0Q+pTxKnULi78aU
         nkSD1NcNmbEibN8vZCkx8/nqiH0nn32fOgqiBTDwIb4K72BvzQSkZT0L2L3VZ7Zj99
         LQhFD6aqz3zTHaIty3RYT43FclTaOuse1n8Dv+8Ml+65cprr1Kv1rA/gAkLSZ3Kotz
         rV3I8g43BRnMg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 12F58605AB;
        Thu, 14 Jan 2021 19:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161065081107.20848.13580439873087234539.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 19:00:11 +0000
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
In-Reply-To: <20210113161819.1155526-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, alexanderduyck@fb.com, pabeni@redhat.com,
        mst@redhat.com, gthelen@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 13 Jan 2021 08:18:19 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Both virtio net and napi_get_frags() allocate skbs
> with a very small skb->head
> 
> While using page fragments instead of a kmalloc backed skb->head might give
> a small performance improvement in some cases, there is a huge risk of
> under estimating memory usage.
> 
> [...]

Here is the summary with links:
  - [net] net: avoid 32 x truesize under-estimation for tiny skbs
    https://git.kernel.org/netdev/net/c/3226b158e67c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


