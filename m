Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9DC2C4895
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgKYTkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgKYTkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 14:40:08 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606333207;
        bh=ABSYP+Qwt67OBQIkcK++2fhD6aqIUwJvXwnEs8pwQzU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KLZkZCokI8egDVKQM1qYZ9Siq7BCrl1RLj2YYKHX9RimpJldqI7WoDDV/w/QantrH
         cHheqmUghDtdNR0NypyKQZ9rel/5CsSd38lBOinbUhukCqfFzamgoMuruaZo9TpoK7
         l38HUHebtYbomIFknOirzmZRhaNZB4XRSKgO/4to=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] net: phy: add support for shared interrupts
 (part 3)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160633320756.7633.17210435422882890525.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Nov 2020 19:40:07 +0000
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ioana.ciornei@nxp.com,
        atenart@kernel.org, dmurphy@ti.com, Divya.Koppera@microchip.com,
        hauke@hauke-m.de, jbrunet@baylibre.com, marex@denx.de,
        martin.blumenstingl@googlemail.com, dev@kresin.me,
        narmstrong@baylibre.com, o.rempel@pengutronix.de,
        philippe.schenker@toradex.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 23 Nov 2020 17:38:02 +0200 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set aims to actually add support for shared interrupts in
> phylib and not only for multi-PHY devices. While we are at it,
> streamline the interrupt handling in phylib.
> 
> For a bit of context, at the moment, there are multiple phy_driver ops
> that deal with this subject:
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net: phy: intel-xway: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/1566db043952
  - [net-next,02/15] net: phy: intel-xway: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/16c9709a7504
  - [net-next,03/15] net: phy: icplus: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/25497b7f0bd9
  - [net-next,04/15] net: phy: icplus: remove the use .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/12ae7ba3c15a
  - [net-next,05/15] net: phy: meson-gxl: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/6719e2be0fcf
  - [net-next,06/15] net: phy: meson-gxl: remove the use of .ack_callback()
    https://git.kernel.org/netdev/net-next/c/84c8f773d2dc
  - [net-next,07/15] net: phy: micrel: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/59ca4e58b917
  - [net-next,08/15] net: phy: micrel: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/c0c99d0cd107
  - [net-next,09/15] net: phy: national: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/6571b4555dc9
  - [net-next,10/15] net: phy: national: remove the use of the .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/a4d7742149f6
  - [net-next,11/15] net: phy: ti: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/1d1ae3c6ca3f
  - [net-next,12/15] net: phy: ti: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/aa2d603ac8c0
  - [net-next,13/15] net: phy: qsemi: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/efc3d9de7fa6
  - [net-next,14/15] net: phy: qsemi: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/a1a4417458cd
  - [net-next,15/15] net: phy: remove the .did_interrupt() and .ack_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/6527b938426f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


