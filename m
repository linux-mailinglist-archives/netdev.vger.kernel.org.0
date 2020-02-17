Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6488161AD4
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 19:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBQSsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 13:48:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40740 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729896AbgBQSs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 13:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GZnbZhFy+lu7UoJn/uqADUzy5uOIWmqyjmegoMJD5DU=; b=XQkKRMghvaybOVtjeWzCIfAFj
        79Pl+ZqFkk9k5pm6T0vp9t5AfT7YaPQznK9puDEjmS3gmoATKi7DxblvVje/UvYw7dAUcK/fNzSds
        IHSdyrA/J+2A7LWOZV1HjHvpCByPVnNNiovaH1bMq7zrIA9h+geUE2K3rQiPE3+15nu10S7ikAbZ/
        q+H8SSr+EpoIhr9Jksv4OULdGc0hGAkBUG0MEryCj21Kr0+CGqcYyElmMFRF4A0ZRbD26Fm7ZAaw6
        BQMJxd9fRmVDs8/caQWCHjds/DfQHWlyOKrLA7VR5DSrya/NziLrRTnV8O4oBGTaEvFQKd9E/fRZj
        iRg271EQQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49148)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j3lRK-0002We-Hs; Mon, 17 Feb 2020 18:48:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j3lRE-0006XW-5L; Mon, 17 Feb 2020 18:48:12 +0000
Date:   Mon, 17 Feb 2020 18:48:12 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-doc@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Felix Fietkau <nbd@openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [CFT 1/8] net: phylink: propagate resolved link config via
 mac_link_up()
Message-ID: <20200217184812.GB25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k7e-00071q-3R@rmk-PC.armlinux.org.uk>
 <20200217180359.GK7778@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217180359.GK7778@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 10:03:59AM -0800, Matthew Wilcox wrote:
> On Mon, Feb 17, 2020 at 05:23:54PM +0000, Russell King wrote:
> > +   Please see :c:func:`mac_link_up` for more information on this.
> 
> FYI, Jon recently added the ability to specify functions as
> 
> +   Please see mac_link_up() for more information on this.
> 
> and it's now the preferred way to do this.  Nothing that should stand in
> the way of this patch-set, of course.

Thanks for letting me know - it sounds like the subject of a future
patch to convert all instances.  In the mean time, I suggest keeping
to the current style in the file for consistency...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
