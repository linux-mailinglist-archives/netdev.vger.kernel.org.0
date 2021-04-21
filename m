Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9922367247
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245039AbhDUSKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242522AbhDUSKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 14:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 391EA61439;
        Wed, 21 Apr 2021 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619028609;
        bh=DMWMh302W2iGOjLpgW9u4BLfm43qFYWA9celLBEAZXw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lkz/jq92X2ctfw1/mYb7CBlAYjgK3J0ZticobT75RzwTw/vapfnouwSwwZgXNrr+c
         MQNGxJUkbQ68ZwUb1dyuMXdmNICBAFwwjacbvMqW9DUzJVmon1DXV5fsItTutFo0JE
         U8cOKSvYV/MyX7NlzzSRMytF35yCYJeZr4JHMPSPoUIZsGYX9uWlFB80vtrVLAr6DX
         WtL7SmI3VAHxqvwKOV3Ic1oHGX4us0ItF4C8/m5ODEF+EJwcy+D8yXp/49YSPqd0A3
         /Zx7TNjqYfDFa9aJX/aXOqGeoujS0ga6uqChisR1p9caj84CE5cRdUlc+N0HwXdnmM
         hYfCeYmdN0xsw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2EDD260A52;
        Wed, 21 Apr 2021 18:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902860918.28303.5159266984657312592.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 18:10:09 +0000
References: <20210421055047.22858-1-ms@dev.tdt.de>
In-Reply-To: <20210421055047.22858-1-ms@dev.tdt.de>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Apr 2021 07:50:47 +0200 you wrote:
> The Intel xway phys offer the possibility to deactivate the integrated
> LED function and to control the LEDs manually.
> If this was set by the bootloader, it must be ensured that the
> integrated LED function is enabled for all LEDs when loading the driver.
> 
> Before commit 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> the LEDs were enabled by a soft-reset of the PHY (using
> genphy_soft_reset). Initialize the XWAY_MDIO_LED with it's default
> value (which is applied during a soft reset) instead of adding back
> the soft reset. This brings back the default LED configuration while
> still preventing an excessive amount of soft resets.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: phy: intel-xway: enable integrated led functions
    https://git.kernel.org/netdev/net/c/357a07c26697

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


