Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9782E4209B2
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 13:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhJDLEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 07:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbhJDLEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 07:04:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BCCC061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 04:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TE6UrnKMmbN+T61NZLbmgx7WzXfm3ZXte0nywv4KKnc=; b=dgKlhL7f9VnKB1fpaMoMv4llU6
        XMXQ57RyYbr0wadKU9uBbHYrQpPwBpQUUhl4lV+g8euakJmX0JeuXcjzSX6rg+WA7S9mMdvGtePzw
        GgWVvBqwsWfpj0oPHfUCo9d9pU5P44+nBSr9uaW4U3JgVMLOSWUp3xAK0IjMi5y/dm6SbDcBC7d47
        NjWohUcI2t3ETbX/esJvb37om2r+nLztfIwK4FjvJ4nEz90Yo4pnAI39n01r447Khx2gw+AZ2LLhL
        WK66Tt+JfQbh4aDhn8x7Bu183jiLtQZsYKfOmrjsY51A+LlFPXEQ48SWPkjTxM3IKF6c4CMjbu+0Y
        t7IwNo5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54924)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXLjz-0007V4-7x; Mon, 04 Oct 2021 12:02:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXLjw-0007SO-P2; Mon, 04 Oct 2021 12:02:36 +0100
Date:   Mon, 4 Oct 2021 12:02:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH net-next 0/2] Add phylink helper for 10G modes
Message-ID: <YVrfTBYg7cHLzNXM@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

During the last cycle, there was discussion about adding a helper
to set the 10G link modes for phylink, which resulted in these two
patches introduce such a helper.

 drivers/net/ethernet/cadence/macb_main.c         |  7 +------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |  7 +------
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  |  7 +------
 drivers/net/phy/phylink.c                        | 11 +++++++++++
 include/linux/phylink.h                          |  1 +
 5 files changed, 15 insertions(+), 18 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
