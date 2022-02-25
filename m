Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42744C49E9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbiBYQAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236928AbiBYQA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:00:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D061D186475
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WqgCXn8vuzHcfzKiFFyx4oKV+8dGK3Sd5fBS6eNO7F0=; b=s2U5MEVhSB5McmwlBrgiok5PGh
        RXgqB7KOfBCJZs2rSMWsOKGoB1+M6IKV0XmGuS88EFuwlTqy2WXcn6fpgPbiZHegZQaU+tJF1hwRv
        zP79GHK4yBu7bQLhQ2m8CWSH08kY6csAOWPUwj60YasfrvzyRwAuYt1ZJvY173FLHNaInyQsIRXA3
        CGbKZ2e8CxCQ+FpGtvMU0qfiDaPVlMwNIJ4yLkhUX/q85DaHLnMO7i9TTZmMx2W0Lp8qzKUw05T69
        4XJmk+pGxtHrkK5a0vxX0CpiWv/9W7//JvrEGrWMmbANsoHA0taVzbryk/kNo2itDq7W6iOvICI11
        CRJireCw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57496)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNd0V-0005eN-8E; Fri, 25 Feb 2022 15:59:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNd0Q-0003CN-Cq; Fri, 25 Feb 2022 15:59:42 +0000
Date:   Fri, 25 Feb 2022 15:59:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek =?utf-8?B?QmVoxILImW4=?= <kabel@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 4/4] net: dsa: ocelot: mark as non-legacy
Message-ID: <Yhj87ncKgaYMXpzR@shell.armlinux.org.uk>
References: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
 <E1nNbgx-00Akj1-Sn@rmk-PC.armlinux.org.uk>
 <20220225154649.qi7rl6sfeq7g3n5i@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225154649.qi7rl6sfeq7g3n5i@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 03:46:50PM +0000, Vladimir Oltean wrote:
> On Fri, Feb 25, 2022 at 02:35:31PM +0000, Russell King (Oracle) wrote:
> > The ocelot DSA driver does not make use of the speed, duplex, pause or
> > advertisement in its phylink_mac_config() implementation, so it can be
> > marked as a non-legacy driver.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Hi Vladimir,

Shall I assume the tested-by applies to patch 2 and 3 as well?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
