Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C914536CDC8
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbhD0VXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236965AbhD0VXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C61461401;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619558567;
        bh=ZNP0gCXv+iujvi9c1rnDXdInI8VG4d03VTD/cDU3IVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tH7XCAuVc+U0H4MJeUClYQJkngjoz47vkBdmrYVtJUDNvWiFdFvvEEZxJGV8+EkKn
         sUQ1QiV21JXRWy0ttZ8FbxPYbt6ppnpzDVz1wxGHrehhe5QEjW4Wlk20GZXRtKQ4Aj
         UJfGr95uAhySKHSuyfpGbOIdND+sUso34KiuZ5y3T3t96+Wc28v7DSQ5pg58rwcM6I
         pPHhXutkq64FVqQJ20A3UwBMWrCPT+blTTNa5m9AbkRWaIWH41tkrhcGGB5inveUV9
         NVff3tE6n4/Uh8zx2gDiJgptE2OcYGJV/LhWKIY4uAbB/8P1secppuSbxWnv9lQ3ll
         x+vPZp8Bmm1Lg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8409160A36;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/9] microchip: add support for ksz88x3 driver
 family
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955856753.21098.6416016746427796139.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:22:47 +0000
References: <20210427070909.14434-1-o.rempel@pengutronix.de>
In-Reply-To: <20210427070909.14434-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        m.grzeschik@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 09:09:00 +0200 you wrote:
> changes v8:
> - add Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> - fix build issue on "net: dsa: microchip: ksz8795: move register
>   offsets and shifts to separate struct"
> 
> changes v7:
> - Reverse christmas tree fixes
> - remove IS_88X3 and use chip_id instead
> - drop own tag and use DSA_TAG_PROTO_KSZ9893 instead
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/9] net: dsa: microchip: ksz8795: change drivers prefix to be generic
    https://git.kernel.org/netdev/net-next/c/4b5baca0403e
  - [net-next,v8,2/9] net: dsa: microchip: ksz8795: move cpu_select_interface to extra function
    https://git.kernel.org/netdev/net-next/c/c2ac4d2ac534
  - [net-next,v8,3/9] net: dsa: microchip: ksz8795: move register offsets and shifts to separate struct
    https://git.kernel.org/netdev/net-next/c/9f73e11250fb
  - [net-next,v8,4/9] net: dsa: microchip: ksz8795: add support for ksz88xx chips
    https://git.kernel.org/netdev/net-next/c/4b20a07e103f
  - [net-next,v8,5/9] net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support
    https://git.kernel.org/netdev/net-next/c/cc13e52c3a89
  - [net-next,v8,6/9] dt-bindings: net: dsa: document additional Microchip KSZ8863/8873 switch
    https://git.kernel.org/netdev/net-next/c/61df0e7bbb90
  - [net-next,v8,7/9] net: phy: Add support for microchip SMI0 MDIO bus
    https://git.kernel.org/netdev/net-next/c/800fcab8230f
  - [net-next,v8,8/9] net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support
    https://git.kernel.org/netdev/net-next/c/60a364760002
  - [net-next,v8,9/9] dt-bindings: net: mdio-gpio: add compatible for microchip,mdio-smi0
    https://git.kernel.org/netdev/net-next/c/61b405985a6b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


