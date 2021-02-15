Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7766F31B404
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 02:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhBOBkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 20:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhBOBku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 20:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E46CC64E52;
        Mon, 15 Feb 2021 01:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613353209;
        bh=3TMAIqGWTrrBa12J1ZkVeN7fkcCO3ay2xFQYo8CQay8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dTmrykGv9TgQ1iWBxJvLbiczcaYmdK0x2Wui744EgN8cvLbbMFIiu1ikZEs2JBoqP
         Bewv+ZZOfMr7VhWUbHnCusq8pG47LZRCaXVrWiQE32NIjJ9JCcNFq3Z3HJw+eosX7E
         gQpJhZspPmdA1QPtErJYphdzypJfxxGPttqzucVnDYJB0bIhpLNI1tP4hw15Z7J76v
         8bTP95a2DoQXTCtvncw2TzhP+ysbp02F2h4zGalw/AiKyQLG0DHMd5eBBYyzFt4g/f
         S9+XdiYBRSaQb6iJRORB68qHPx4oe3+R6NztJPNacOfr6Uo2bpYzpc8mcJatcpyjtB
         wC6QxIV1mBGvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3C2B60971;
        Mon, 15 Feb 2021 01:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/12] PTP for DSA tag_ocelot_8021q
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161335320986.7007.1351261205447665075.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 01:40:09 +0000
References: <20210213223801.1334216-1-olteanv@gmail.com>
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        richardcochran@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        fido_max@inbox.ru, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Feb 2021 00:37:49 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Changes in v2:
> Add stub definition for ocelot_port_inject_frame when switch driver is
> not compiled in.
> 
> This is part two of the errata workaround begun here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210129010009.3959398-1-olteanv@gmail.com/
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/12] net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
    https://git.kernel.org/netdev/net-next/c/f833ca293dd1
  - [v2,net-next,02/12] net: mscc: ocelot: only drain extraction queue on error
    https://git.kernel.org/netdev/net-next/c/d7795f8f26d9
  - [v2,net-next,03/12] net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
    https://git.kernel.org/netdev/net-next/c/a94306cea56f
  - [v2,net-next,04/12] net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
    https://git.kernel.org/netdev/net-next/c/5f016f42d342
  - [v2,net-next,05/12] net: mscc: ocelot: refactor ocelot_port_inject_frame out of ocelot_port_xmit
    https://git.kernel.org/netdev/net-next/c/137ffbc4bb86
  - [v2,net-next,06/12] net: dsa: tag_ocelot: avoid accessing ds->priv in ocelot_rcv
    https://git.kernel.org/netdev/net-next/c/8a678bb29bd2
  - [v2,net-next,07/12] net: mscc: ocelot: use common tag parsing code with DSA
    https://git.kernel.org/netdev/net-next/c/40d3f295b5fe
  - [v2,net-next,08/12] net: dsa: tag_ocelot: single out PTP-related transmit tag processing
    https://git.kernel.org/netdev/net-next/c/62bf5fde5e14
  - [v2,net-next,09/12] net: dsa: tag_ocelot: create separate tagger for Seville
    https://git.kernel.org/netdev/net-next/c/7c4bb540e917
  - [v2,net-next,10/12] net: mscc: ocelot: refactor ocelot_xtr_irq_handler into ocelot_xtr_poll
    https://git.kernel.org/netdev/net-next/c/924ee317f724
  - [v2,net-next,11/12] net: dsa: felix: setup MMIO filtering rules for PTP when using tag_8021q
    https://git.kernel.org/netdev/net-next/c/c8c0ba4fe247
  - [v2,net-next,12/12] net: dsa: tag_ocelot_8021q: add support for PTP timestamping
    https://git.kernel.org/netdev/net-next/c/0a6f17c6ae21

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


