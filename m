Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987DD4464F4
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 15:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhKEOcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232865AbhKEOcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 10:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C8A7961183;
        Fri,  5 Nov 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636122607;
        bh=dA7OYIX2+nXNF2QTVUlqEI2nIRmUtU7HAXldzr4pEQ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K3bB1LwDVlPetK7Z8RDTrUwZvj7/N+gIvckVE1OAhKuaNC9PmilMgOM3SJ40DJ06W
         xFmr3yp6hwf/z8HS0UVj/GpCcEOuRSFQrMlJ6qrNcW5Dy8YEtbfWjAGsDw1RtRJFY3
         9fCTF052xO0gyBgQgQtTacPrd4P+DvWr9E6VkGwBvvNbdDaQRi9X5Cbq1ugiePsfAk
         FeggFWRzHTKV7GtHI+us1d0mYWVgO2Qpqd3il8k1TsWIkyQIPj/GX6WsdZc4lFcPuu
         /g80BidKDkf7INKGqlVGfCFiOUCBG+Ffzgz6FcjqdmOgGwtOPXpfKfVFb6aWXYema/
         fMV5H6aBSMBUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BBF6E60A02;
        Fri,  5 Nov 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] ax88796c: fix ioctl callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163612260776.32748.4456572271474269770.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 14:30:07 +0000
References: <20211105092954.1771974-1-arnd@kernel.org>
In-Reply-To: <20211105092954.1771974-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     l.stelmach@samsung.com, davem@davemloft.net, kuba@kernel.org,
        jgg@ziepe.ca, arnd@arndb.de, nathan@kernel.org, alobakin@pm.me,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 10:29:39 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The timestamp ioctls are now handled by the ndo_eth_ioctl() callback,
> not the old ndo_do_ioctl(), but oax88796 introduced the
> function for the old way.
> 
> Move it over to ndo_eth_ioctl() to actually allow calling it from
> user space.
> 
> [...]

Here is the summary with links:
  - [1/2] ax88796c: fix ioctl callback
    https://git.kernel.org/netdev/net/c/9dcc00715a7c
  - [2/2] octeontx2-nicvf: fix ioctl callback
    https://git.kernel.org/netdev/net/c/a6785bd7d83c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


