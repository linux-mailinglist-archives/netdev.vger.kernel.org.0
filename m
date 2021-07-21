Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C80C3D11CD
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbhGUOWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239445AbhGUOTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9ACBF61249;
        Wed, 21 Jul 2021 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626879604;
        bh=Dno6DBZNx9K5C24Q1ufPPKusD1XABRmwgNfcHWzgeKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hvfCVRuQsDRJWJn0H5fvxubeDYqpUGGtuwx0tBFhj1lRISU9V40Lg1Wek00ZbTt90
         peipXB9oqFUkQQqwWMvX//Zp3Eq8tkzN0tt4FYInDUcszUoxNzrDvcPewoXu9+PpAO
         qGC3F8PZk0ScZSl+xdRWbJkpeXJfJDwcsV0PkHLnLGSvrMbqweDPGVujG/i2uLjrDT
         g2byBAjE9RXhNXMyL9oW6OFI3PMIL8ZWC1GkZzC787eGm+KvXpsK+Ep6UNB+dx4exL
         zE2fm1w0JcFjRl4ILdPWCIwm5fE3km4ynZTtfrXKX9820pG2/IEUM2egX4Fd5YxMzR
         CZnVEZDGfklHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9421260A4E;
        Wed, 21 Jul 2021 15:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: cleanup ksettings_set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162687960460.27043.14699625720287757152.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 15:00:04 +0000
References: <E1m5nig-0003N1-1f@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1m5nig-0003N1-1f@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 12:15:26 +0100 you wrote:
> We only need to fiddle about with the supported mask after we have
> validated the user's requested parameters. Simplify and streamline the
> code by moving the linkmode copy and update of the autoneg bit after
> validating the user's request.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: cleanup ksettings_set
    https://git.kernel.org/netdev/net-next/c/7cefb0b0e911

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


