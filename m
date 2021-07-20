Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B560B3CFC77
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbhGTN6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239600AbhGTNt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:49:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3276A6120D;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791406;
        bh=vk/IdLePW8oE+tii9mDKfXXA2cqO777V7+xu1mplTIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iy7qH7h9JYrSM4l7BVWMgXIwtPhO956/6Pvv+mXE96PujxvRnChdAjVZ9kDDhSSKp
         ykxtgXizBUb/A3tJpZCzI4fZPy7Zaz+zuIFUuboqLSmIK84M2oggOPFzJGIHgDpOuD
         onzELdobyi7Lua02nCVFvtw4jjudOUTeZXyW8noI17RSGgsOAs2tfMJ+ADJ/bKDVR0
         TlTDQ7M9FbGYKUYVs9O3WswsFa9WldfC2MfecRxO1pxnxlZvgypilbyrluNoX7kO2c
         UD79feIzR3k3/xpeQlv8+iu+w3mTxDT8NFW2g2pgFKlLiPWn6y44agPVdwNkso/bFZ
         VbL4eRVFLEQ1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2770A60A19;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvpp2: deny disabling autoneg for 802.3z modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679140615.23944.10120334180878553405.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:30:06 +0000
References: <E1m5mVd-00033I-Sx@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1m5mVd-00033I-Sx@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, mw@semihalf.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 10:57:53 +0100 you wrote:
> The documentation for Armada 8040 says:
> 
>   Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
>   When <PortType> = 1 (1000BASE-X) this field must be set to 1.
> 
> We presently ignore whether userspace requests autonegotiation or not
> through the ethtool ksettings interface. However, we have some network
> interfaces that wish to do this. To offer a consistent API across
> network interfaces, deny the ability to disable autonegotiation on
> mvpp2 hardware when in 1000BASE-X and 2500BASE-X.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvpp2: deny disabling autoneg for 802.3z modes
    https://git.kernel.org/netdev/net-next/c/635a85ac7349

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


