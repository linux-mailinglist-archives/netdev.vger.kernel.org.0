Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D65D400001
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 14:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349162AbhICMvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 08:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235336AbhICMvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 08:51:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 09C37610CF;
        Fri,  3 Sep 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630673407;
        bh=GCOJB9F6sCbHTvnV6mLZld+vtAI6/dHWzf6wEbaaJsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WBXKN8rGDn98bQcQVrrG1+Pk2JAu2I6BrEs1NbEULkrKokR47yDeGoblPvVGxbF59
         EH3PkrLnjjQiz3+/GNRFgme5nlWLhR1uRzjG+vx7mheL81gCHxTUwihaeVBdScY/48
         mQU8Q3hIprUuzWMjwyUNtbUdPRV8xIjGbC9oc2LAi069qhfK5YGmKPA6Rykj+CVC0Z
         B0KWscaN4XarQty8i8XxpQ9KK+5AiRorzityH7+9folONikMPecwFE/HPgTV1G/Fuj
         O26i1yg4RtazVTI91OEjIwgR99u8CjJKk/Imv2OXWJnQgI9caknq6QTIl/kWXfBxJS
         4DtMR7Klz6c4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 012FC609D9;
        Fri,  3 Sep 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cs89x0: disable compile testing on powerpc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163067340699.3998.16811546131332320324.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 12:50:06 +0000
References: <1630672147-29639-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1630672147-29639-1-git-send-email-arnd@arndb.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        sfr@canb.auug.org.au, linux@roeck-us.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 12:29:07 +0000 you wrote:
> The ISA DMA API is inconsistent between architectures, and while
> powerpc implements most of what the others have, it does not provide
> isa_virt_to_bus():
> 
> ../drivers/net/ethernet/cirrus/cs89x0.c: In function ‘net_open’:
> ../drivers/net/ethernet/cirrus/cs89x0.c:897:20: error: implicit declaration of function ‘isa_virt_to_bus’ [-Werror=implicit-function-declaration]
>      (unsigned long)isa_virt_to_bus(lp->dma_buff));
> ../drivers/net/ethernet/cirrus/cs89x0.c:894:3: note: in expansion of macro ‘cs89_dbg’
>    cs89_dbg(1, debug, "%s: dma %lx %lx\n",
> 
> [...]

Here is the summary with links:
  - net: cs89x0: disable compile testing on powerpc
    https://git.kernel.org/netdev/net/c/f1181e39d6ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


