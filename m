Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D95501934
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbiDNQz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241993AbiDNQys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:54:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19461DCAAA;
        Thu, 14 Apr 2022 09:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wc0zecBG9PRD3cpgt/xufo/bM6yKJdx0qFwKfforMTI=; b=v+po431oSVmhIPMHliuQ5LKFxp
        RNgGgiGdeoNsm2jcbw5ecs6cEh4G8JXDMzu/LX4V6XF8hcl6iddFIGYPhBY6WVdzHBWswq1x6s2l4
        oY4jkNMljzszrvkALkBiPzD+mf4CyQNA6NQ/5i/YmzoQDGQ01+vhcdIP32GHnrXS8Ecseb3c5LI24
        ZDzVJGs3r1HFLUhQ87odSw4fko9zJLSfNtNTpwD5kR8lpuzJCKAiWaNvxkUEcp2JPWr+yZ7Qb7QJc
        XIGyVCzX7xEuyX3hjfjB+EFpxXwt9UdRYM42ws/yiWHCMIPniDuxxyb7cMmmXbfOvplg9g0gisXEL
        KAJTSZnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58264)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nf2G5-0004lu-6D; Thu, 14 Apr 2022 17:23:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nf2G2-0004RX-HE; Thu, 14 Apr 2022 17:23:46 +0100
Date:   Thu, 14 Apr 2022 17:23:46 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
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
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <YlhKkriHziPsWBCV@shell.armlinux.org.uk>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-3-clement.leger@bootlin.com>
 <20220414142242.vsvv3vxexc7i3ukm@skbuf>
 <20220414163546.3f6c5157@fixe.home>
 <20220414151146.a2fncklswo6utiyd@skbuf>
 <20220414181815.5037651e@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414181815.5037651e@fixe.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 06:18:15PM +0200, Clément Léger wrote:
> Le Thu, 14 Apr 2022 18:11:46 +0300,
> Vladimir Oltean <olteanv@gmail.com> a écrit :
> 
> > On Thu, Apr 14, 2022 at 04:35:46PM +0200, Clément Léger wrote:
> > > > Please keep variable declarations sorted in decreasing order of line
> > > > length (applies throughout the patch series, I won't repeat this comment).  
> > > 
> > > Acked, both PCS and DSA driver are ok with that rule. Missed that one
> > > though.  
> > 
> > Are you sure? Because a5psw_port_stp_state_set() says otherwise.
> 
> Weeeeell, ok let's say I missed these two. Would be useful to have such
> checks in checkpatch.pl.

Note that it's a local networking coding-style issue, rather than being
kernel-wide.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
