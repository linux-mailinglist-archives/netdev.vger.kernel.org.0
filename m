Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2176A640E22
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiLBTA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbiLBTA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:00:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574B6DBF75;
        Fri,  2 Dec 2022 11:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=puCJUJoGWc1k1MtmNIlg9+Qut8lhdd9ExxZeA8q4JGg=; b=inoSArhwaHylvgj1yMO4JlVltv
        3D/CU6Rih1CgJCbfaQegvN+OdxnJi1dfX8qEMbMfYZdmK/PNQ2VM7LuWlLgAWgNOzfzLs6GPxAkhv
        gh/lIBjn6st/cTjWCbWaibwCk6OtV0FKEmy1dzYxlqkZWCm9CRfM0D0JouE503RmoVf9MTaCNjkFD
        aXdCjGadiwjVbhsV1k2z3CZH0DccqP4PYSTGDnr3bLYzPb25Dp17dFRxHJvyeor9JmTWcfIlGikQ8
        9LPhpyy8AhKBRVRiOxmRcbX78XH5gty53HOoeEsrXSxFhye5V/3Kb98w7TCIhLqQ66aOVGkLVyQ3G
        YKjbZ0XQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35536)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1BGl-0004U1-Oq; Fri, 02 Dec 2022 19:00:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1BGi-0004cx-Cw; Fri, 02 Dec 2022 19:00:16 +0000
Date:   Fri, 2 Dec 2022 19:00:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 1/3] net: phy: Move/rename
 phylink_interface_max_speed
Message-ID: <Y4pLQCCeDUkKPZga@shell.armlinux.org.uk>
References: <20221202181719.1068869-1-sean.anderson@seco.com>
 <20221202181719.1068869-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202181719.1068869-2-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 01:17:16PM -0500, Sean Anderson wrote:
> This is really a core phy function like phy_interface_num_ports. Move it
> to drivers/net/phy/phy-core.c and rename it accordingly.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
