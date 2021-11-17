Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD2B453EDB
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhKQDXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:23:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhKQDXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 797E3613A3;
        Wed, 17 Nov 2021 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637119210;
        bh=8HcaAcvHa9H5MKjYumrJOh//iCPl6EUW8XUEl/uZJ1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gXor8oQ6mYfaZMHIDhWYDO3Cu9IN/uoc6Va6fxVanVbJuuWmdkJz58AENxpaHFg8H
         DJnaY9j5lcQxpYjj3cNISiPCxo3daSryel1ZT74xEEzRBr1OxB+jk1GxqIqfiqyOy2
         u72t6lioQJWm1BPanmUvnJ/6AR1U4QCgiQRcgEbb4XfeZZ4f4ou7ZhNaQ55BfW2uPv
         jQNooocm8WqmDRBx0Z/oCKK/reBnel+gk0ZnYN16M7/62Z12xE/KL+CFqEW3hD4DrP
         2rx6SZ4L7Pfh9R6yy4JKGGlKXmQtbpUbJz9aT9/PMQV3B127n9LtELRQwopRHIRWvZ
         7n407f/c9DJgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6BDD560A4E;
        Wed, 17 Nov 2021 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: better packing of global vars
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711921043.1664.17855637480155623636.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:20:10 +0000
References: <20211115172303.3732746-1-eric.dumazet@gmail.com>
In-Reply-To: <20211115172303.3732746-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 09:23:00 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> First two patches avoid holes in data section,
> and last patch makes sure some siphash keys are contained
> in a single cache line.
> 
> Eric Dumazet (3):
>   once: use __section(".data.once")
>   net: use .data.once section in netdev_level_once()
>   net: align static siphash keys
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] once: use __section(".data.once")
    https://git.kernel.org/netdev/net-next/c/c2c60ea37e5b
  - [net-next,2/3] net: use .data.once section in netdev_level_once()
    https://git.kernel.org/netdev/net-next/c/7071732c26fe
  - [net-next,3/3] net: align static siphash keys
    https://git.kernel.org/netdev/net-next/c/49ecc2e9c3ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


