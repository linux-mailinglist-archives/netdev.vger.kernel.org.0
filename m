Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3D7485582
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241256AbiAEPKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241229AbiAEPKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:10:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FA2C0611FF;
        Wed,  5 Jan 2022 07:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03B58B81BA3;
        Wed,  5 Jan 2022 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9872C36AE0;
        Wed,  5 Jan 2022 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641395413;
        bh=ShuZ2ubvbNH23UzurYrca8nBarY06fYZ17hQMbe0VQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mn/kNCBQ1Q94+orhw52Upf7MaI42hzhKL0x96etA+sCshYrhL7lc5tRCtacvsoGsL
         d41v+vX4HpXOfl2I6rSdUV936so+1skm+fJFQ5v0B3VNbGzgexM5qYz3AdaDOnD0/n
         HywhAR7KsIk0jZ79/Mb/EGuK451BQDBCKe7ZfB/JjUG4PoIH6/za4axX84zLM07wcj
         i/2lm8LJRcTbbFS6Cjbr4Qmh0ROio5myvH0Qep1c0GrDLFGt/JX92xCOPfqREFIQVD
         o03fe8sEh/QxRg1sef6puzVgQ6SZhdjohB2zhwRBFD3jTOifGiSOLgTf4BvxY8d5AG
         Fl3Gnz5v6zn2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F0E6F79405;
        Wed,  5 Jan 2022 15:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/15] can: usb_8dev: remove unused member echo_skb
 from struct usb_8dev_priv
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164139541358.14483.4626502285231611166.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 15:10:13 +0000
References: <20220105144402.1174191-2-mkl@pengutronix.de>
In-Reply-To: <20220105144402.1174191-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed,  5 Jan 2022 15:43:48 +0100 you wrote:
> This patch removes the unused memberecho_skb from the struct
> usb_8dev_priv.
> 
> Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
> Link: https://lore.kernel.org/all/20220104230753.956520-1-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] can: usb_8dev: remove unused member echo_skb from struct usb_8dev_priv
    https://git.kernel.org/netdev/net-next/c/617dbee5c7ac
  - [net-next,02/15] can: mcp251x: mcp251x_gpio_setup(): Get rid of duplicate of_node assignment
    https://git.kernel.org/netdev/net-next/c/68fa39ea9124
  - [net-next,03/15] can: kvaser_usb: make use of units.h in assignment of frequency
    https://git.kernel.org/netdev/net-next/c/b8f91799687e
  - [net-next,04/15] can: ti_hecc: ti_hecc_probe(): use platform_get_irq() to get the interrupt
    https://git.kernel.org/netdev/net-next/c/eff104cf3cf3
  - [net-next,05/15] can: sja1000: sp_probe(): use platform_get_irq() to get the interrupt
    https://git.kernel.org/netdev/net-next/c/decdcaeedce4
  - [net-next,06/15] can: etas_es58x: es58x_init_netdev: populate net_device::dev_port
    https://git.kernel.org/netdev/net-next/c/e233640cd303
  - [net-next,07/15] can: do not increase rx statistics when generating a CAN rx error message frame
    https://git.kernel.org/netdev/net-next/c/676068db69b8
  - [net-next,08/15] can: kvaser_usb: do not increase tx statistics when sending error message frames
    https://git.kernel.org/netdev/net-next/c/0b0ce2c67795
  - [net-next,09/15] can: do not copy the payload of RTR frames
    https://git.kernel.org/netdev/net-next/c/f68eafeb9759
  - [net-next,10/15] can: do not increase rx_bytes statistics for RTR frames
    https://git.kernel.org/netdev/net-next/c/8e674ca74244
  - [net-next,11/15] can: do not increase tx_bytes statistics for RTR frames
    https://git.kernel.org/netdev/net-next/c/cc4b08c31b5c
  - [net-next,12/15] can: dev: replace can_priv::ctrlmode_static by can_get_static_ctrlmode()
    https://git.kernel.org/netdev/net-next/c/c9e1d8ed304c
  - [net-next,13/15] can: dev: add sanity check in can_set_static_ctrlmode()
    https://git.kernel.org/netdev/net-next/c/7d4a101c0bd3
  - [net-next,14/15] can: dev: reorder struct can_priv members for better packing
    https://git.kernel.org/netdev/net-next/c/5fe1be81efd2
  - [net-next,15/15] can: netlink: report the CAN controller mode supported flags
    https://git.kernel.org/netdev/net-next/c/383f0993fc77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


