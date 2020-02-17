Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D73E161953
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 19:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgBQSEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 13:04:07 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgBQSEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 13:04:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KBvfvthRTAHTakV8+xxFydSvjqVVrmxm/9il+ERwTbU=; b=BnuGyA1s7r2P7oP49/RtrqXVSQ
        keie8EtHezI6LfM1yAITkAUaxnRWcTxHGujEIQ4DadLGPjc+0iv5ICykU3o7kheh1mierIM/0trIR
        /CDKVRpw44nUeOTY8huhKEU7FN1Yc0L7YEymzQcSyXutwrdCUfIngtFhFa721El9e0+rsh2qMz+mR
        IOFXkY3XidPrMRMg0S8jR6pETj1DjbP//K01KP6ZXmF85U5C8B+ODA85fVvVnFXId2qo0s3Ic7Jki
        sG+SeJXVEwtwFya7PFN5i2SWy3GyAFMin6ixgW/O97WMmFeWc887FqWB4So1OdAlwcW3asFkX7fML
        1F9F2ZVw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3kkR-0003n7-Tk; Mon, 17 Feb 2020 18:03:59 +0000
Date:   Mon, 17 Feb 2020 10:03:59 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [CFT 1/8] net: phylink: propagate resolved link config via
 mac_link_up()
Message-ID: <20200217180359.GK7778@bombadil.infradead.org>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k7e-00071q-3R@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j3k7e-00071q-3R@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 05:23:54PM +0000, Russell King wrote:
> +   Please see :c:func:`mac_link_up` for more information on this.

FYI, Jon recently added the ability to specify functions as

+   Please see mac_link_up() for more information on this.

and it's now the preferred way to do this.  Nothing that should stand in
the way of this patch-set, of course.
