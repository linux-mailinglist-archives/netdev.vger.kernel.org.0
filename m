Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0D85028A9
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 13:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349541AbiDOLFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 07:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbiDOLFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 07:05:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D701890CFC;
        Fri, 15 Apr 2022 04:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RuMOKVLo+ISZ3SyRd57vI0t4HZmEVbUYhd44dOnPaR8=; b=s/I9ZQdxvT/lPGV/5ydNBQGv6i
        7nufsgBd1oj70q8df9u/sPIBH4Ps5WD75kExEpOlzKPTvPmnTqaYCRTp7Urh0FY+IdglbOBXN8fUn
        I+3htZWuQucSN7+QcBCTVKDmKOx0tiR1F5pGShF8kt7PPIAPzj0KQxFhUV/ifX0MXOJ41b5YrNpVi
        Ghcx8z+JDdWha+2nyMHiDw8m36ApnAn7GvqAJAuJxLkevB+HWKBHvVW58EpGvaiWfyOtYkOmVLwoB
        iH6x5ln3QNptgdA69J25EQvpyWlFuEfF2PMpRUkH+u3dKulWqbrCKlGNNLhpns1n26XPRUYJRordG
        KsluwS+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58274)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nfJiV-0005Yw-AS; Fri, 15 Apr 2022 12:02:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nfJiQ-0005CF-Hk; Fri, 15 Apr 2022 12:02:14 +0100
Date:   Fri, 15 Apr 2022 12:02:14 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <YllQtjybAOF/ePfG@shell.armlinux.org.uk>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
 <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
 <20220415113453.1a076746@fixe.home>
 <20220415105503.ztl4zhoyua2qzelt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415105503.ztl4zhoyua2qzelt@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 01:55:03PM +0300, Vladimir Oltean wrote:
> I meant that for a DSA switch driver is mandatory to call dsa_switch_shutdown()
> from your ->shutdown method, otherwise subtle things break, sorry for being unclear.
> 
> Please blindly copy-paste the odd pattern that all other DSA drivers use
> in ->shutdown and ->remove (with the platform_set_drvdata(dev, NULL) calls),
> like a normal person :)

Those platform_set_drvdata(, NULL) calls should be killed - the
driver model will set the driver data to NULL after ->remove has
been called - so having drivers also setting the driver data to
NULL is mere duplication.

The only case it would matter is if someone is looking up the device
and then accessing the driver data - and one would hope that's done
with appropriate locking or other guarantees (e.g. driver can never
be unbound once the driver data has been set.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
