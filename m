Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B843B4A6E94
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 11:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiBBKWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 05:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240469AbiBBKWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 05:22:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27885C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 02:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XwUxtnKYG2jArWYF92TkBdTO8kZwuDfFJDjdNO7fptg=; b=1+TZxzs1b2CaM6TZgM8/MD/EUQ
        CA9F1J6LOAtLAN2LIMieDlYzLhBWdi/k9gtZOPD0e+twmbHfObEVFznujN3NLGp+ZiZ8JD4ZxTRl+
        5fa18YUZd4CHR2Da3aWXIadqHmw+eq8IMSw+/XMnr3RdB/Z5XyasJoh3THl95XdgOw/TbOFrEvFeY
        X2/uuV9Ss7x/giVe69Ekvus7SXm634xSqRxzm9DhYrrekAjPVWkHs/J+zsPsj7l6LUvgwmF1ac9fq
        JwKOEd7nsQpP+uv5bJ2dLqZ5aW+Rr8q8IM1zbvPt/eV+neto8rJeTn6lQIg12/DuahKFD232DQNZH
        YhXnxcGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56994)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFCmA-0001TM-E9; Wed, 02 Feb 2022 10:22:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFCm7-0002xt-JP; Wed, 02 Feb 2022 10:22:07 +0000
Date:   Wed, 2 Feb 2022 10:22:07 +0000
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
Subject: [PATCH net-next 0/5] Trivial DSA conversions to
 phylink_generic_validate()
Message-ID: <YfpbTzsE1MWz5Lr/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts five DSA drivers to use phylink_generic_validate().
No feedback or testing reports were received from the CFT posting.

 drivers/net/dsa/bcm_sf2.c           | 54 +++++++++---------------------
 drivers/net/dsa/microchip/ksz8795.c | 45 +++++++------------------
 drivers/net/dsa/qca/ar9331.c        | 45 ++++++-------------------
 drivers/net/dsa/qca8k.c             | 66 +++++++++++----------------------=
----
 drivers/net/dsa/xrs700x/xrs700x.c   | 29 +++++++---------
 5 files changed, 67 insertions(+), 172 deletions(-)

--=20
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
