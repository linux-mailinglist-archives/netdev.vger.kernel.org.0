Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602E13CFC7A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbhGTN72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239502AbhGTNt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:49:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 224C26120C;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791406;
        bh=5D88Sl3y3wHYhtcs3dc35jMj8Erc0sovwK0ykSIEy1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bzMdpXD2Z+9gnDMhzCNwRaQE6mInVkaz5CSOLmaqFpx6zmOhnqGK0me6P+yr/sRW1
         R+tt6JWdk9Deulmkqh6/RIenMYgj6W3dX76TO3JMSXpeldD7OBLuBBoPBCctmx8eQb
         G6EJ7sMgpQom4G5Wd9kanyBjaXo4eR2yKO/SRyfTwKuPKqNQLVV7cuOQsJVKCmZcoP
         KgcQ/3zgveOXDcudNy8ZLZmhZLmkv19V7k2wtU8xagA8TJ8Lp8DTc4FqwIMes7zR3S
         5TmeXU6fh75j4rq61Jsw224BKN/R62SPbIHlxRfuy5dMK22iX16XcE3/lPaxjEOQ5x
         AQwbSmU17aYDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C17E60CCF;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvneta: deny disabling autoneg for 802.3z modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679140611.23944.4263522679292349341.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:30:06 +0000
References: <E1m5mVY-00032z-Ok@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1m5mVY-00032z-Ok@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 10:57:48 +0100 you wrote:
> The documentation for Armada 38x says:
> 
>   Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
>   When <PortType> = 1 (1000BASE-X) this field must be set to 1.
> 
> We presently ignore whether userspace requests autonegotiation or not
> through the ethtool ksettings interface. However, we have some network
> interfaces that wish to do this. To offer a consistent API across
> network interfaces, deny the ability to disable autonegotiation on
> mvneta hardware when in 1000BASE-X and 2500BASE-X.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvneta: deny disabling autoneg for 802.3z modes
    https://git.kernel.org/netdev/net-next/c/c762b7fac1b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


