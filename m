Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655D81B3964
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 09:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgDVHvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 03:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725786AbgDVHvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 03:51:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F99C03C1A6;
        Wed, 22 Apr 2020 00:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KWg+XuhGzP1BBFs/gHc4oZn4yxp0P4XqZNSIS4Th3Qc=; b=0a/pZ1EExYsog3tfKvmCp22h/
        RhiepO8ZTm5hZm7PLVWb7ZG0C4jU+jQkbGGy4aN3DOiS2ndWNKzPX7qBEMsmNi9KT7yLFpbDREuoi
        xSMifzC5Kud+OMTyxp1SrDitwWb/JlNouTzA3VTVfGgCppTPTQ2VB2TcPE9LZYiUVbsJSkhh4knWm
        RpVxrWcRgXW4VwtVhsVHrGW5m1C4quEDWIy671Z5KpqVqIsz5Bghoyx9GCkMfBqjJPCr7LgKblJb0
        uPBL599FAhFNAm+g/IkhDA+Z0qHIVadw4KYAMhX/kw+E5YV2XEW1E63/vxEdhQd4gx0JiYPagVan/
        j6BmTvElA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49512)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jRAAL-0006kT-Oi; Wed, 22 Apr 2020 08:51:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jRAAG-0007yR-GD; Wed, 22 Apr 2020 08:51:24 +0100
Date:   Wed, 22 Apr 2020 08:51:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Xilinx axienet 1000BaseX support (was: Re: [PATCH 07/14] net:
 axienet: Fix SGMII support)
Message-ID: <20200422075124.GJ25745@shell.armlinux.org.uk>
References: <20200110142038.2ed094ba@donnerap.cambridge.arm.com>
 <20200110150409.GD25745@shell.armlinux.org.uk>
 <20200110152215.GF25745@shell.armlinux.org.uk>
 <20200110170457.GH25745@shell.armlinux.org.uk>
 <20200118112258.GT25745@shell.armlinux.org.uk>
 <3b28dcb4-6e52-9a48-bf9c-ddad4cf5e98a@arm.com>
 <20200120154554.GD25745@shell.armlinux.org.uk>
 <20200127170436.5d88ca4f@donnerap.cambridge.arm.com>
 <20200127185344.GA25745@shell.armlinux.org.uk>
 <bf2448d0-390c-5045-3503-885240829fbf@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf2448d0-390c-5045-3503-885240829fbf@sedsystems.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 07:45:47PM -0600, Robert Hancock wrote:
> Hi Andre/Russell,
> 
> Just wondering where things got to with the changes for SGMII on Xilinx
> axienet that you were discussing (below)? I am looking into our Xilinx setup
> using 1000BaseX SFP and trying to get it working "properly" with newer
> kernels. My understanding is that the requirements for 1000BaseX and SGMII
> are somewhat similar. I gathered that SGMII was working somewhat already,
> but that not all link modes had been tested. However, it appears 1000BaseX
> is not yet working in the stock kernel.
> 
> The way I had this working before with a 4.19-based kernel was basically a
> hack to phylink to allow the Xilinx PCS/PMA PHY to be configured
> sufficiently as a PHY for it to work, and mostly ignored the link status of
> the SFP PHY itself, even though we were using in-band signalling mode with
> an SFP module. That was using this patch:
> 
> https://patchwork.ozlabs.org/project/netdev/patch/1559330285-30246-5-git-send-email-hancock@sedsystems.ca/
> 
> Of course, that's basically just a hack which I suspect mostly worked by
> luck. I see that there are some helpers that were added to phylink to allow
> setting PHY advertisements and reading PHY status from clause 22 PHY
> devices, so I'm guessing that is the way to go in this case? Something like:
> 
> axienet_mac_config: if using in-band mode, use
> phylink_mii_c22_pcs_set_advertisement to configure the Xilinx PHY.
> 
> axienet_mac_pcs_get_state: use phylink_mii_c22_pcs_get_state to get the MAC
> PCS state from the Xilinx PHY
> 
> axienet_mac_an_restart: if using in-band mode, use
> phylink_mii_c22_pcs_an_restart to restart autonegotiation on Xilinx PHY
> 
> To use those c22 functions, we need to find the mdio_device that's
> referenced by the phy-handle in the device tree - I guess we can just use
> some of the guts of of_phy_find_device to do that?

Please see the code for DPAA2 - it's changed slightly since I sent a
copy to the netdev mailing list, and it still isn't clear whether this
is the final approach (DPAA2 has some fun stuff such as several
different PHYs at address 0.) NXP basically didn't like the approach
I had in the patches I sent to netdev, we had a call, they presented
an alternative appraoch, I implemented it, then they decided my
original approach was the better solution for their situation.

See http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=cex7

specifically the patches from:

  "dpaa2-mac: add 1000BASE-X/SGMII PCS support"

through to:

  "net: phylink: add interface to configure clause 22 PCS PHY"

You may also need some of the patches further down in the net-queue
branch:

  "net: phylink: avoid mac_config calls"

through to:

  "net: phylink: rejig link state tracking"

> One concern I have is that there may be things that the PHY subsystem would
> configure on the device that may need to be replicated in order to get it to
> actually work - things like setting auto-negotiate enable/disable, the
> BMCR_ISOLATE bit, etc - is that something that belongs in our mac_config or
> in the phylink core in phylink_mii_c22_pcs_set_advertisement etc?

I think some of that is addressed in the above patches, except for
the isolate bit - do your PHYs come up with the isolate bit set?
Under what circumstances would you need to set it?

Let me know how you get on.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
