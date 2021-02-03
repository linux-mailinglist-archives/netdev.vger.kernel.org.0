Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE6E30D654
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhBCJa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbhBCJ27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:28:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF05C06174A;
        Wed,  3 Feb 2021 01:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9pKfQLzGDfiHkv25ELUL+D+4rxPV5CYIYvFqvp4UiW8=; b=tZ+xmQu9f87AUuQc59llyy43x
        dY0c5j+53CzB6gAEoU/TAQBBu+JvM+MDXxMAS104iAm9cy/nBT5qsPDUF1Dm4XNZyoZD3Xv7kUJ3k
        LmTRX0RhMQ5zMo8zgWYQD/3G4h1FE/wWQUmyxEgFQbBG1e/GmeOT3UK9VUHpck8sW9UuBiYtzth9l
        u9M7ZCpKPtmkBe+HvGhDpisxhmL8NWFjmM0vDZr813lQORMIMCAdcG+xLfKp6I1WIBtWEjiQEeQ59
        acgnwtdWAsZ8gP1WsgPcSWc272yHafOwdZ/YdQhxvwtBAB2CYxa5I+ZKLRsdYO+1ALme69PfBuIVt
        wr0f2sQOg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38574)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l7ESK-0005Q8-3u; Wed, 03 Feb 2021 09:28:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l7ESI-0003vg-2e; Wed, 03 Feb 2021 09:28:10 +0000
Date:   Wed, 3 Feb 2021 09:28:10 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v1 0/7] remove different PHY fixups
Message-ID: <20210203092809.GO1463@shell.armlinux.org.uk>
References: <20210203091857.16936-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203091857.16936-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 10:18:50AM +0100, Oleksij Rempel wrote:
> This patch series tries to remove most of the imx6 and imx7 board
> specific PHY configuration via fixup, as this breaks the PHYs when
> connected to switch chips or USB Ethernet MACs.
> 
> Each patch has the possibility to break boards, but contains a
> recommendation to fix the problem in a more portable and future-proof
> way.

Please wait a cycle for the changes I've submitted through net-next
to be merged, so we don't end up with stuff breaking during the merge
window because these changes have been merged before the changes in
net-next.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
