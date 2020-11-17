Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B20C2B6EEA
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgKQTkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:40:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbgKQTkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:40:35 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605642033;
        bh=1IpPGUBKgNMR37W7Z6qKG+Dmg5G4JxvcQSYVhg+wY+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=19AHDQoLrYU6yuiMDfN6PAibWsUkDhcfclHZcSuIk8mqhanos/RNFTAL7l/bKylCz
         Mit65pM03zs92VDvfSDB27K1NcnmMsdVcldgmwVBq9P+hmwj2ZqjUjuTVGOSo8mfC+
         tHAF+F+QyVKV0WTMByX5koTjghlxr2oL32uMLomc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next 00/18] net: phy: add support for shared
 interrupts (part 2)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160564203382.2721.8419154932238289208.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 19:40:33 +0000
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
In-Reply-To: <20201113165226.561153-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ioana.ciornei@nxp.com,
        alexandru.ardelean@analog.com, andre.edich@microchip.com,
        baruch@tkos.co.il, christophe.leroy@c-s.fr,
        kavyasree.kotagiri@microchip.com, linus.walleij@linaro.org,
        m.felsch@pengutronix.de, marex@denx.de, fido_max@inbox.ru,
        Nisar.Sayed@microchip.com, o.rempel@pengutronix.de,
        robert.hancock@calian.com, yuiko.oshino@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Nov 2020 18:52:08 +0200 you wrote:
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
  - [RESEND,net-next,01/18] net: phy: vitesse: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/b606ad8fa283
  - [RESEND,net-next,02/18] net: phy: vitesse: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/e96a0d977464
  - [RESEND,net-next,03/18] net: phy: microchip: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/e01a3feb8f69
  - [RESEND,net-next,04/18] net: phy: microchip: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/cf499391982d
  - [RESEND,net-next,05/18] net: phy: marvell: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/a0723b375f93
  - [RESEND,net-next,06/18] net: phy: marvell: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/1f6d0f267a14
  - [RESEND,net-next,07/18] net: phy: lxt: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/01c4a00bf347
  - [RESEND,net-next,08/18] net: phy: lxt: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/9a12dd6f186c
  - [RESEND,net-next,09/18] net: phy: nxp-tja11xx: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/52b1984a88ac
  - [RESEND,net-next,10/18] net: phy: nxp-tja11xx: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/45f52f123851
  - [RESEND,net-next,11/18] net: phy: amd: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/d995a36b7e96
  - [RESEND,net-next,12/18] net: phy: amd: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/347917c7e06a
  - [RESEND,net-next,13/18] net: phy: smsc: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/36b25c26e2ca
  - [RESEND,net-next,14/18] net: phy: smsc: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/824ef51f0871
  - [RESEND,net-next,15/18] net: phy: ste10Xp: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/80ca9ee741da
  - [RESEND,net-next,16/18] net: phy: ste10Xp: remove the use of .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/e1bc534df855
  - [RESEND,net-next,17/18] net: phy: adin: implement generic .handle_interrupt() callback
    https://git.kernel.org/netdev/net-next/c/66d7439e8360
  - [RESEND,net-next,18/18] net: phy: adin: remove the use of the .ack_interrupt()
    https://git.kernel.org/netdev/net-next/c/1d8300d3ce9d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


