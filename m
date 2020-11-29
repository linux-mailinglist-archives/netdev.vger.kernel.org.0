Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6502C78D6
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 12:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgK2LbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 06:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2LbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 06:31:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BB0C0613CF;
        Sun, 29 Nov 2020 03:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QGqxcbLsjyEPen3iQTZ0RxUUyFbEosqdtxEiZVBNOQY=; b=o9DSjXLisplQ2VS/byxKhdRhg
        f64c0/IAuqUvnOfYh4lpgkFcWki0xPSDe8JwjUuYYeIAYiH5IcoifyYuQG4whccYbRrDMHu1xfd2o
        CGljGi+Ibdtia5qC3ZrHBrzcEZKz4ptgH3p1B45NirUXdbCO7+o20ej5RpoJR1o+EK7bcfVRbpp+0
        pSCl8CW3GYnZIudVxaCt3qK5cbszBOmZO1xe4PJTvEj3yeVPp69JjTuUDVNyHKkL3iu/X6NeSADZT
        sShDZU8Z3rXt5SrbTMNVilSf2W3F2pqReO7+qahwjhdHBaIP2Ss+4dOIwVwA8bURXqSrgKqWYjcYB
        cTU8+METw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37554)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kjKuJ-0005YX-5I; Sun, 29 Nov 2020 11:30:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kjKuI-0003y6-TH; Sun, 29 Nov 2020 11:30:18 +0000
Date:   Sun, 29 Nov 2020 11:30:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201129113018.GI1605@shell.armlinux.org.uk>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128222828.GQ1551@shell.armlinux.org.uk>
 <20201129105245.GG1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201129105245.GG1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 10:52:45AM +0000, Russell King - ARM Linux admin wrote:
> There are other issues too.

This is also wrong:

+               if (port->ndev && port->ndev->phydev)
+                       status->link = port->ndev->phydev->link;

phylink already deals with that situation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
