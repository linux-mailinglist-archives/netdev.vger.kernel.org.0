Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADC2493BEA
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbiASOaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:30:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38902 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbiASOaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D54E6133E;
        Wed, 19 Jan 2022 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB6A2C340E1;
        Wed, 19 Jan 2022 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642602610;
        bh=cqYXfpaFMP1VTeXlqw/vuOnER1tXJuFUpdLwPglyVZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uWaJUYr9prJyLDPfC2fa18jZNPJ7BKqNSqSwAWvcLCI8NRHbPLfwnCA52cy2ozI1G
         0vBXvtUZ7Z29OZ69GMdEpLxhBXb327Afi4I5cbS8UHSjs3Jb7OxWkAsoobTuv7wAOP
         QrmUlhgo2F1Pu08+P90cttLDewOGr+DivwxtNbFmClQEyL3ghertRdpWbGSJ60DTIm
         BtMeafAZHjZ9BpixAfQpovlxxC7slwk1ZxkTtWOWCmMBLXy1yr2PdHNTtxk4+gcjjl
         EGNl6NQHgmShT7bWJvYSg/+OoLgexOgVnhd6MutpEJlkgO+jZkWNETwqjRHGBSM6pW
         qim19LERW/lpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF0C2F60795;
        Wed, 19 Jan 2022 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq
 aware devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164260260984.9645.1800345294074661941.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Jan 2022 14:30:09 +0000
References: <20220118110812.1767997-1-claudiu.beznea@microchip.com>
In-Reply-To: <20220118110812.1767997-1-claudiu.beznea@microchip.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Jan 2022 13:08:12 +0200 you wrote:
> On a setup with KSZ9131 and MACB drivers it happens on suspend path, from
> time to time, that the PHY interrupt arrives after PHY and MACB were
> suspended (PHY via genphy_suspend(), MACB via macb_suspend()). In this
> case the phy_read() at the beginning of kszphy_handle_interrupt() will
> fail (as MACB driver is suspended at this time) leading to phy_error()
> being called and a stack trace being displayed on console. To solve this
> .suspend/.resume functions for all KSZ devices implementing
> .handle_interrupt were replaced with kszphy_suspend()/kszphy_resume()
> which disable/enable interrupt before/after calling
> genphy_suspend()/genphy_resume().
> 
> [...]

Here is the summary with links:
  - net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices
    https://git.kernel.org/netdev/net/c/f1131b9c23fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


