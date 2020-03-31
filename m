Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31920199C8F
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbgCaRJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:09:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCaRJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:09:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A70315D0E503;
        Tue, 31 Mar 2020 10:09:40 -0700 (PDT)
Date:   Tue, 31 Mar 2020 10:09:39 -0700 (PDT)
Message-Id: <20200331.100939.678979437919298393.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, f.fainelli@gmail.com,
        ioana.ciornei@nxp.com, olteanv@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next] net: dsa: fix oops while probing Marvell DSA
 switches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jJHhw-0004UO-OJ@rmk-PC.armlinux.org.uk>
References: <E1jJHhw-0004UO-OJ@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 31 Mar 2020 10:09:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 31 Mar 2020 15:17:36 +0100

> Fix an oops in dsa_port_phylink_mac_change() caused by a combination
> of a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA
> ports unless needed") and the net-dsa-improve-serdes-integration
> series of patches 65b7a2c8e369 ("Merge branch
> 'net-dsa-improve-serdes-integration'").
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000124
> pgd = c0004000
> [00000124] *pgd=00000000
> Internal error: Oops: 805 [#1] SMP ARM
> Modules linked in: tag_edsa spi_nor mtd xhci_plat_hcd mv88e6xxx(+) xhci_hcd armada_thermal marvell_cesa dsa_core ehci_orion libdes phy_armada38x_comphy at24 mcp3021 sfp evbug spi_orion sff mdio_i2c
> CPU: 1 PID: 214 Comm: irq/55-mv88e6xx Not tainted 5.6.0+ #470
> Hardware name: Marvell Armada 380/385 (Device Tree)
> PC is at phylink_mac_change+0x10/0x88
> LR is at mv88e6352_serdes_irq_status+0x74/0x94 [mv88e6xxx]
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks.
