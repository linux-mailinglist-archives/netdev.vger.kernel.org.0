Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218D2691D8F
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjBJLF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbjBJLFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:05:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631CA126E6;
        Fri, 10 Feb 2023 03:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=roQL55HfASwJ/D7RYoexw2Ppn195nynj40tTiHKJ6uk=; b=kwvfhE2IfDmZE6PGWhVajbCN5g
        KhTu0qTEMEkVeKS5r2HAV3/hVD89ctPS44ZBL1FVlooGeSJ1QsLSV2rFcZX6Op0L3eZbCRviL6nci
        5CY9V3HHGjSixxSItVQadKs5INI3Hx8fUAZNgCZhx/6jbGg+4xxSCA4Icwv95+qSVCsN+nJC/WOlA
        a4hucLG4KomEDkhQoT3oDR+SSWqnW5DNI3UU8ec+bCGKzYr6K5esVEFNW+BP1hESWcY0AquTP+4EY
        6LvYK5ZJ+8qFOjMmDKton9oSsm6hm1zI9b1dsU7KE6P2yx7RqQrRaoEYFieLWTo1YteQINDOZi9hX
        1/IdE7EA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36514)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQRDU-0001NA-Hv; Fri, 10 Feb 2023 11:05:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQRDT-0005WK-Ga; Fri, 10 Feb 2023 11:05:19 +0000
Date:   Fri, 10 Feb 2023 11:05:19 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: pcs: rzn1-miic: remove unused struct
 members and use miic variable
Message-ID: <Y+Yk7+Yqd3z3aXQE@shell.armlinux.org.uk>
References: <20230208161249.329631-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230208161249.329631-1-clement.leger@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 05:12:49PM +0100, Clément Léger wrote:
> Remove unused bulk clocks struct from the miic state and use an already
> existing miic variable in miic_config().
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
