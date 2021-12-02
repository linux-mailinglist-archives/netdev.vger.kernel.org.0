Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2A3465C9E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355167AbhLBDXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:23:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49552 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347449AbhLBDXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:23:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B211CE219E
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 03:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DC88C53FCF;
        Thu,  2 Dec 2021 03:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638415211;
        bh=PAd9cliNlebvohXJVCxZQ1JTuYA0qibnw9TVabe3//c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LzpmqfFYBI+ZSkchfJB5BtTH9nEUb3uSvqbXOF0upHOGAaHEwbz2jSqznOGgMfgGG
         fvkCLM8fiSmkq/KpMIUHUrumbJmqb7NSrnQAABqk4zZdzuhZA50eN4cIv6SfEy207B
         bPjewKraIZScHXPXPtGHTO+nivF1daWi7I1Ytad+THNoxtWBKdIa9fBN3Aznz+Glo0
         syhIAzpfGpiSxiX4X1TduqxRS5mPY+FdJPJAGT57+FWdeQMYCU69lSZT0b8rQYwv7G
         PllIxKRSCyVWxEv4LEZeh9WxGPciXvObrChWVuCKWoGAv3M5qa3ilXE5glzPfg+564
         rjx0IlvDXDlIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3443A60A88;
        Thu,  2 Dec 2021 03:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvneta: program 1ms autonegotiation clock
 divisor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841521120.978.3866151516820951137.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:20:11 +0000
References: <E1ms4WD-00EKLK-Ld@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1ms4WD-00EKLK-Ld@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 14:54:05 +0000 you wrote:
> Program the 1ms autonegotiation clock divisor according to the clocking
> rate of neta - without this, the 1ms clock ticks at about 660us on
> Armada 38x configured for 250MHz. Bring this into correct specification.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: mvneta: program 1ms autonegotiation clock divisor
    https://git.kernel.org/netdev/net-next/c/0dc1df059888

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


