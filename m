Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0742DB56
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhJNOWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhJNOWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 10:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46DB4610CC;
        Thu, 14 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634221207;
        bh=NDTSxb14xO73sN25tCERdoV++ozHnresvMGHMCEE5Fo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jB+RG0ItyqL9/f/Pz/0UBSSJLpGPWA4nPrNiF/RkmkLkBHYX3zLm9BR+o4A7a7tnY
         aVnmbvCRXxAUEoGdE3Dr/KWJ0InTUbOZmfDL6taYNVKy+QihLxFfZZivkcxV1xw5tq
         WyPYIPmHY1UG37Ytn94J31+f4bdJSfyjIzCc/3bm27NzsjMcj7VsMMQHqUALX5Lcc5
         m6pDHLo7iOzM1mzn6wc5UqmKuo7ssSeJJiOjXN70/t5JCMEe/6wKnWS457fNH3m3iC
         FUxUtezKpkv9dzC1jP5p4sINdotPJXuY0oJFgDa/y+c5PBE4n1kGxjTYm2tLeEs96o
         2i67Y/d0RPZUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3BCE6609ED;
        Thu, 14 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: s2io: fix setting mac address during resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163422120724.29699.2814286544000918647.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 14:20:07 +0000
References: <20211013143613.2049096-1-arnd@kernel.org>
In-Reply-To: <20211013143613.2049096-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        sreenivasa.honnur@neterion.com, jeff@garzik.org, arnd@arndb.de,
        jgg@ziepe.ca, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 16:35:49 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> After recent cleanups, gcc started warning about a suspicious
> memcpy() call during the s2io_io_resume() function:
> 
> In function '__dev_addr_set',
>     inlined from 'eth_hw_addr_set' at include/linux/etherdevice.h:318:2,
>     inlined from 's2io_set_mac_addr' at drivers/net/ethernet/neterion/s2io.c:5205:2,
>     inlined from 's2io_io_resume' at drivers/net/ethernet/neterion/s2io.c:8569:7:
> arch/x86/include/asm/string_32.h:182:25: error: '__builtin_memcpy' accessing 6 bytes at offsets 0 and 2 overlaps 4 bytes at offset 2 [-Werror=restrict]
>   182 | #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/netdevice.h:4648:9: note: in expansion of macro 'memcpy'
>  4648 |         memcpy(dev->dev_addr, addr, len);
>       |         ^~~~~~
> 
> [...]

Here is the summary with links:
  - ethernet: s2io: fix setting mac address during resume
    https://git.kernel.org/netdev/net/c/40507e7aada8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


