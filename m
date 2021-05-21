Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5073E38CF13
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhEUUbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhEUUbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 16:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 98F626135A;
        Fri, 21 May 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621629010;
        bh=olZ6Dv/4y7IaMPDGSdmYOR5cp3HIHCsZNVGtlsb0Dow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HBg6SbTQCwZ9GGK17PA1aa6Wh9Klxf0nTAlXV2kE3iOCJ/a3TSM57nzteikG6M0Vi
         MY5UKA/Ey302qsKIY6UB7ZipsPAqvQbMilkhxf/OB9bIPsEMcJ2t6cAm4DzB+DktDT
         92lSmi5ZpdAugyPMdQzj9g0553Ma+ckkfG6Pq8+CmdocLe/+bZ+KA+qPKaY1y3xN0S
         WjQmE1Ccv5GllQPxar5L3neLlY+HYiST3fwZ26zaDiVDvu7jbvPl/snz/s6F/+O0rc
         eF8YvZdi3TpqWj78fuwfixuSX+jjGp4JnltmH5uFX1GEwlkkL416sh97ReEs93x1To
         Sy77UouL044Wg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 85F3B6096D;
        Fri, 21 May 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: phy: add driver for Motorcomm yt8511 phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162162901054.11427.16053858331878438071.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 20:30:10 +0000
References: <20210520163230.3788942-1-pgwipeout@gmail.com>
In-Reply-To: <20210520163230.3788942-1-pgwipeout@gmail.com>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 12:32:30 -0400 you wrote:
> Add a driver for the Motorcomm yt8511 phy that will be used in the
> production Pine64 rk3566-quartz64 development board.
> It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
> 
> Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> ---
> Changes v4:
> - Set fast ethernet delays as well
> - Use __phy_modify for delay setting
> - Enable PLL in sleep instead of disabling sleep
> - Don't set genphy functions that are defaults
> - Tested downshift and duplex detection
> 
> [...]

Here is the summary with links:
  - [v4] net: phy: add driver for Motorcomm yt8511 phy
    https://git.kernel.org/netdev/net-next/c/48e8c6f1612b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


