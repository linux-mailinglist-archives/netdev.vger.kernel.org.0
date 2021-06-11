Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0012B3A4A0E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhFKUWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229572AbhFKUWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 68CD2613C6;
        Fri, 11 Jun 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623442808;
        bh=OPhKKZ9EI5WdYTjxBQvbuzDpEsBbg6gsdAFBfCDEUqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JoPGm/+30kbGRL3Utjq21jZK35G7R5wsRV7F8rrBccJnf3Sgm5Gv+RZ6KiZTtuYvP
         A1PnrSx1VW/I/7fKQvKgfwIJrSMcNSu/KVQ1gyQPe6TIIxf2vNss0xys9JzSoQglbV
         Y/S0Z/Epmx/ik5U8xEYIDIPnvpnEFalVgTj5cLseh5JTEPm3La+z2+GfeEQnE2+R6v
         wJykivIwKp7WC6IVFl3TQg2a/yGogprsW1CRj3m8Phul/k4bJOyB+ka3BiuXfNd4ji
         nlLjkCyoY2+jTflULzHQ3sMtRQ/OqjXhoP6jGh9CitVkyNqujnNRXPI18LXnw8JFKN
         /ecZAnrvFuiVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57DB760BE1;
        Fri, 11 Jun 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v9 00/15] ACPI support for dpaa2 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344280835.13501.16334655818490594799.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:20:08 +0000
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, grant.likely@arm.com, rafael@kernel.org,
        jeremy.linton@arm.com, andrew@lunn.ch, andy.shevchenko@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        heikki.krogerus@linux.intel.com, mw@semihalf.com,
        pieter.jansenvv@bamboosystems.io, jon@solid-run.com,
        saravanak@google.com, rdunlap@infradead.org,
        calvin.johnson@oss.nxp.com, cristian.sovaiala@nxp.com,
        florinlaurentiu.chiculita@nxp.com, madalin.bucur@nxp.com,
        linux-arm-kernel@lists.infradead.org, diana.craciun@nxp.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, laurentiu.tudor@nxp.com, lenb@kernel.org,
        rjw@rjwysocki.net, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 13:53:46 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set provides ACPI support to DPAA2 network drivers.
> 
> It also introduces new fwnode based APIs to support phylink and phy
> layers
>     Following functions are defined:
>       phylink_fwnode_phy_connect()
>       fwnode_mdiobus_register_phy()
>       fwnode_get_phy_id()
>       fwnode_phy_find_device()
>       device_phy_find_device()
>       fwnode_get_phy_node()
>       fwnode_mdio_find_device()
>       acpi_get_local_address()
> 
> [...]

Here is the summary with links:
  - [net-next,v9,01/15] Documentation: ACPI: DSD: Document MDIO PHY
    https://git.kernel.org/netdev/net-next/c/e71305acd81c
  - [net-next,v9,02/15] net: phy: Introduce fwnode_mdio_find_device()
    https://git.kernel.org/netdev/net-next/c/0fb169767651
  - [net-next,v9,03/15] net: phy: Introduce phy related fwnode functions
    https://git.kernel.org/netdev/net-next/c/425775ed31a6
  - [net-next,v9,04/15] of: mdio: Refactor of_phy_find_device()
    https://git.kernel.org/netdev/net-next/c/2d7b8bf1fa7a
  - [net-next,v9,05/15] net: phy: Introduce fwnode_get_phy_id()
    https://git.kernel.org/netdev/net-next/c/114dea60043b
  - [net-next,v9,06/15] of: mdio: Refactor of_get_phy_id()
    https://git.kernel.org/netdev/net-next/c/cf99686072a1
  - [net-next,v9,07/15] net: mii_timestamper: check NULL in unregister_mii_timestamper()
    https://git.kernel.org/netdev/net-next/c/b9926da003ca
  - [net-next,v9,08/15] net: mdiobus: Introduce fwnode_mdiobus_register_phy()
    https://git.kernel.org/netdev/net-next/c/bc1bee3b87ee
  - [net-next,v9,09/15] of: mdio: Refactor of_mdiobus_register_phy()
    https://git.kernel.org/netdev/net-next/c/8d2cb3ad3118
  - [net-next,v9,10/15] ACPI: utils: Introduce acpi_get_local_address()
    https://git.kernel.org/netdev/net-next/c/7ec16433cf1e
  - [net-next,v9,11/15] net: mdio: Add ACPI support code for mdio
    https://git.kernel.org/netdev/net-next/c/803ca24d2f92
  - [net-next,v9,12/15] net/fsl: Use [acpi|of]_mdiobus_register
    https://git.kernel.org/netdev/net-next/c/15e7064e8793
  - [net-next,v9,13/15] net: phylink: introduce phylink_fwnode_phy_connect()
    https://git.kernel.org/netdev/net-next/c/25396f680dd6
  - [net-next,v9,14/15] net: phylink: Refactor phylink_of_phy_connect()
    https://git.kernel.org/netdev/net-next/c/423e6e8946f5
  - [net-next,v9,15/15] net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver
    https://git.kernel.org/netdev/net-next/c/3264f599c1a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


