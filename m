Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5924649E010
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbiA0LCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiA0LB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:01:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33ABC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EL3Vde8ZW7e5iE+UkqXddGbJ+C+ur1at7fmAltNe0+Y=; b=VbFwOTkdBvSqU11qGxMklyZ63E
        meu3R3RovVTehoBJCc+YunNZrf7LIF+eqMgQVRXPYuGgQK9af6iUst9mUyF39UWYpuoo26aRyQ+Ng
        PPgKvQejieCe61x+nUOST87pyuw5PczlrnkYSgUSXbRLQ+UKw2hycOyKNhlY0y8OJZZITenbIpc6C
        O+m/p1eg6FhTlYni4IAuh3kGW4y0sryI66ht1UK4+81UCIdYpnvU3G/94+6DP+UMRijbQclherfHS
        H6F0eUxgbwJ/UTJcWDjcyNDj2DFVDVf8Q3B5IZMgHmzVn1A6u2SG0C/aBMGrsG3r5hbEHibnY2PiA
        offtoXzg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56902)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nD2XM-0004Lq-QH; Thu, 27 Jan 2022 11:01:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nD2XK-0005OL-NM; Thu, 27 Jan 2022 11:01:54 +0000
Date:   Thu, 27 Jan 2022 11:01:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH CFT net-next 0/5] Trivial DSA conversions to
 phylink_generic_validate()
Message-ID: <YfJ7omKUSF6BY+CL@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts five DSA drivers to use phylink_generic_validate().
I'd appreciate some reviews and tested-bys for this. Thanks.

 drivers/net/dsa/bcm_sf2.c           | 54 +++++++++---------------------
 drivers/net/dsa/microchip/ksz8795.c | 45 +++++++------------------
 drivers/net/dsa/qca/ar9331.c        | 45 ++++++-------------------
 drivers/net/dsa/qca8k.c             | 66 +++++++++++--------------------------
 drivers/net/dsa/xrs700x/xrs700x.c   | 29 +++++++---------
 5 files changed, 67 insertions(+), 172 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
