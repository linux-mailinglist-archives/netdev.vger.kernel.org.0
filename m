Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA27426CC6
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242228AbhJHOcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhJHOcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3732F61039;
        Fri,  8 Oct 2021 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633703408;
        bh=DaGZV6AFJUs/T944grixyFFFXbnnfuRqbrpOLl+rmQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UjorYjFfCejxACVAC5oac3mXhIfIWWI0simJIoYCKu48IJH09ZBFyA4pEjqX9Z6nE
         ECuMoaTItgF3FdE7Ty3be0oG07nZF2iDNfKNcdS2A8XXa+rN6twY8I7cEgpplMVRh1
         tC1L7+WcZaKFtM6HYagGXYSOrWm1siGALtzbbv0IO7axeyNdRuAgHeSAshnlDPlZo6
         yYmq+PkzddeZPzn7ty3Weglvi83E5/6uf0IZymOkvTaD6jguyK1BWDvbou1zA5IQje
         FlsQzH+kvGTQYM/xuMgQV3EDOrK0BM8wwh4SP0RmcE/fimEBY0TxPDNrv+mwxzgpju
         NbrwSKU2XrMIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 297AF60AA2;
        Fri,  8 Oct 2021 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylib: ensure phy device drivers do not match
 by DT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370340816.9336.4517484284289769602.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 14:30:08 +0000
References: <E1mYTMy-001hFh-W4@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mYTMy-001hFh-W4@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 07 Oct 2021 14:23:32 +0100 you wrote:
> PHYLIB device drivers must match by either numerical PHY ID or by their
> .match_phy_device method. Matching by DT is not permitted.
> 
> Link: https://lore.kernel.org/r/2b1dc053-8c9a-e3e4-b450-eecdfca3fe16@gmail.com
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylib: ensure phy device drivers do not match by DT
    https://git.kernel.org/netdev/net-next/c/2b12d51c4fa8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


