Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C25235FCFA
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhDNVKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhDNVKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:10:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BE15761168;
        Wed, 14 Apr 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618434609;
        bh=3YMmu4qKyc4JzHe46Oop8QDhCvSPtfXvIeGwl9kC6gQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nuNF+fCX5mu9Fb1W6c1EQcMMtO9axF2Adku+fD91gSF/QLBagF4NkPaXot5nAjiw3
         vJ++Lkgfjqylb0HYiP+m/gDUONspdYRQYvbfO8s3ZCAxG8tLFJXrezVJuwvzj1s58l
         db7LTn5LSsTgKoU4yiUulqw8RLY4GpzVpQ6s+cVOTFUbPU1TYmmNad9uKWz/tGIxGN
         fz900DHVySuye2aspbMfq9a4YgmNd9zkjd0F1BYy3qxWnuZeDN7mTjrZyWiUeZk231
         qn/E/PJHakxwExWLrCk/nAj06h4uvtwldaaoNNemt0ATqmtXmB/OyxSdT/KF8e17ws
         IZIddFklHGCqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B22BC60CCF;
        Wed, 14 Apr 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [net] cavium/liquidio: Fix duplicate argument
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843460972.4219.16207477719874190617.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:10:09 +0000
References: <20210414113148.9777-1-wanjiabing@vivo.com>
In-Reply-To: <20210414113148.9777-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 19:31:48 +0800 you wrote:
> Fix the following coccicheck warning:
> 
> ./drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h:413:6-28:
> duplicated argument to & or |
> 
> The CN6XXX_INTR_M1UPB0_ERR here is duplicate.
> Here should be CN6XXX_INTR_M1UNB0_ERR.
> 
> [...]

Here is the summary with links:
  - [net] cavium/liquidio: Fix duplicate argument
    https://git.kernel.org/netdev/net/c/416dcc5ce9d2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


