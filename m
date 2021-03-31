Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80E634F598
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhCaAuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232882AbhCaAuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 98B87619CD;
        Wed, 31 Mar 2021 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617151808;
        bh=2c3nHvtfL79oD9AY6dOckYUpKumJUp3EWlMrIZzz+wc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V0p3FeR9/0vrjE7Xxc8dRQn81ebAy7M6WDuKoBmwM8tgazLUWaJBEiN8f1KJoPkYG
         5H/qenvvMBRFX1lbPwF1ypRyL5uh0tLrAhlz1A3moRfgmn6TuYKWJBFIzePu0mvMGq
         qbg4q57OWdTMfgQF3rvmFDANYSm0e1RPO+4En1fRVnm9v7UtoHGgtsqxcraKiGaqBu
         KvXynWIqnEvciWpQ+vJZ9gDhL+pU91LtllooT/yuG/S9JPnephElNyTuv3+2iR35UB
         alJ+FhmBVkg7DN61e9UNIVldD9myjPp1bKI7SlEJ2V0+WiC9xDkTZ3SgDozotJ3WDV
         e8yOFWD6JDJCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D15960A56;
        Wed, 31 Mar 2021 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: broadcom: Only advertise EEE for supported
 modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715180857.15741.13316214682722934868.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:50:08 +0000
References: <20210330220024.1459286-1-f.fainelli@gmail.com>
In-Reply-To: <20210330220024.1459286-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 30 Mar 2021 15:00:24 -0700 you wrote:
> We should not be advertising EEE for modes that we do not support,
> correct that oversight by looking at the PHY device supported linkmodes.
> 
> Fixes: 99cec8a4dda2 ("net: phy: broadcom: Allow enabling or disabling of EEE")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/phy/bcm-phy-lib.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net] net: phy: broadcom: Only advertise EEE for supported modes
    https://git.kernel.org/netdev/net/c/c056d480b40a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


