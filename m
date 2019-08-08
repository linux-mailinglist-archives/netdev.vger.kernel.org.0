Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9B985E27
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 11:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbfHHJXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 05:23:19 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38002 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730678AbfHHJXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 05:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CPHlKMY+T7C61QHBdlcreXci365LR57qc6SkDunX9Ro=; b=M2j18xeASTQ24sr6n0jUGYi0c
        OLAbv5JnINBX657s1fUUoA/zCTZPrOLsLWQEHJ2HgYxZVhFGwwRKUS+wECJydSQwSs+ma5KMntyEQ
        N47F0/9Ompwf124fGdrxjWHnFj0WGXert1RRfc20S84vSgjCCvobJxuw4lowmvk25UQ/uoZHWktu7
        0+ZHEPzTeDrFY8g0h7KclaV5MruNPhlYPgAeoVZKToGlWg6qXDaCmoySiyl5mnvjgajus5jAQ/qgC
        u2ONNQMft+PXz+YQzbWvJ3gdS2NDzr7jdIIfRXv8Uqay1wcU8tCjxok9d6zdtGfQvxYvV3AGR4mdJ
        14M3ErGDw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49912)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hvedf-0002yW-GZ; Thu, 08 Aug 2019 10:23:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hvedd-0002Kq-DT; Thu, 08 Aug 2019 10:23:13 +0100
Date:   Thu, 8 Aug 2019 10:23:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Clause 73 and USXGMII
Message-ID: <20190808092313.GC5193@shell.armlinux.org.uk>
References: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB3266A710111427071814D371D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808082626.GB5193@shell.armlinux.org.uk>
 <BN8PR12MB32665E5465A83D5E11C7B5D6D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32665E5465A83D5E11C7B5D6D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 09:02:57AM +0000, Jose Abreu wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Aug/08/2019, 09:26:26 (UTC+00:00)
> 
> > Hi,
> > 
> > Have you tried enabling debug mode in phylink (add #define DEBUG at the
> > top of the file) ?
> 
> Yes:
> 
> [ With > 2.5G modes removed ]
> # dmesg | grep -i phy
> libphy: stmmac: probed
> stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 10G]
> stmmaceth 0000:04:00.0 enp4s0: phy: setting supported 
> 00,00000000,0002e040 advertising 00,00000000,0002e040
> stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mode
> stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config: 
> mode=phy/usxgmii/Unknown/Unknown adv=00,00000000,0002e040 pause=10 
> link=0 an=1
> stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknown

This shows that the PHY isn't reporting that the link came up.  Did
the PHY negotiate link?  If so, why isn't it reporting that the link
came up?  Maybe something is mis-programming the capability bits in
the PHY?  Maybe disabling the 10G speeds disables everything faster
than 1G?

> [ Without any limit ]
> # dmesg | grep -i phy
> libphy: stmmac: probed
> stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 10G]
> stmmaceth 0000:04:00.0 enp4s0: phy: setting supported 
> 00,00000000,000ee040 advertising 00,00000000,000ee040
> stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mode
> stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config: 
> mode=phy/usxgmii/Unknown/Unknown adv=00,00000000,000ee040 pause=10 
> link=0 an=1
> stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknown
> stmmaceth 0000:04:00.0 enp4s0: phy link up usxgmii/2.5Gbps/Full
> stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config: 
> mode=phy/usxgmii/2.5Gbps/Full adv=00,00000000,00000000 pause=0f link=1 
> an=0
> 
> I'm thinking on whether this can be related with USXGMII. As link is 
> operating in 10G but I configure USXGMII for 2.5G maybe autoneg outcome 
> should always be 10G ?

As I understand USXGMII (which isn't very well, because the spec isn't
available) I believe that it operates in a similar way to SGMII where
data is replicated the appropriate number of times to achieve the link
speed.  So, the USXGMII link always operates at a bit rate equivalent
to 10G, but data is replicated twice for 5G, four times for 2.5G, ten
times for 1G, etc.

I notice that you don't say that you support any copper speeds, which
brings up the question about what the PHY's media is...

> > On Thu, Aug 08, 2019 at 08:17:29AM +0000, Jose Abreu wrote:
> > > ++ PHY Experts
> > > 
> > > From: Jose Abreu <joabreu@synopsys.com>
> > > Date: Aug/07/2019, 16:46:23 (UTC+00:00)
> > > 
> > > > Hello,
> > > > 
> > > > I've some sample code for Clause 73 support using Synopsys based XPCS 
> > > > but I would like to clarify some things that I noticed.
> > > > 
> > > > I'm using USXGMII as interface and a single SERDES that operates at 10G 
> > > > rate but MAC side is working at 2.5G. Maximum available bandwidth is 
> > > > therefore 2.5Gbps.
> > > > 
> > > > So, I configure USXGMII for 2.5G mode and it works but if I try to limit 
> > > > the autoneg abilities to 2.5G max then it never finishes:
> > > > # ethtool enp4s0
> > > > Settings for enp4s0:
> > > > 	Supported ports: [ ]
> > > > 	Supported link modes:   1000baseKX/Full 
> > > > 	                        2500baseX/Full 
> > > > 	Supported pause frame use: Symmetric Receive-only
> > > > 	Supports auto-negotiation: Yes
> > > > 	Supported FEC modes: Not reported
> > > > 	Advertised link modes:  1000baseKX/Full 
> > > > 	                        2500baseX/Full 
> > > > 	Advertised pause frame use: Symmetric Receive-only
> > > > 	Advertised auto-negotiation: Yes
> > > > 	Advertised FEC modes: Not reported
> > > > 	Speed: Unknown!
> > > > 	Duplex: Unknown! (255)
> > > > 	Port: MII
> > > > 	PHYAD: 0
> > > > 	Transceiver: internal
> > > > 	Auto-negotiation: on
> > > > 	Supports Wake-on: ug
> > > > 	Wake-on: d
> > > > 	Current message level: 0x0000003f (63)
> > > > 			       drv probe link timer ifdown ifup
> > > > 	Link detected: no
> > > > 
> > > > When I do not limit autoneg and I say that maximum limit is 10G then I 
> > > > get Link Up and autoneg finishes with this outcome:
> > > > # ethtool enp4s0
> > > > Settings for enp4s0:
> > > > 	Supported ports: [ ]
> > > > 	Supported link modes:   1000baseKX/Full 
> > > > 	                        2500baseX/Full 
> > > > 	                        10000baseKX4/Full 
> > > > 	                        10000baseKR/Full 
> > > > 	Supported pause frame use: Symmetric Receive-only
> > > > 	Supports auto-negotiation: Yes
> > > > 	Supported FEC modes: Not reported
> > > > 	Advertised link modes:  1000baseKX/Full 
> > > > 	                        2500baseX/Full 
> > > > 	                        10000baseKX4/Full 
> > > > 	                        10000baseKR/Full 
> > > > 	Advertised pause frame use: Symmetric Receive-only
> > > > 	Advertised auto-negotiation: Yes
> > > > 	Advertised FEC modes: Not reported
> > > > 	Link partner advertised link modes:  1000baseKX/Full 
> > > > 	                                     2500baseX/Full 
> > > > 	                                     10000baseKX4/Full 
> > > > 	                                     10000baseKR/Full 
> > > > 	Link partner advertised pause frame use: Symmetric Receive-only
> > > > 	Link partner advertised auto-negotiation: Yes
> > > > 	Link partner advertised FEC modes: Not reported
> > > > 	Speed: 2500Mb/s
> > > > 	Duplex: Full
> > > > 	Port: MII <- Never mind this, it's a SW issue
> > > > 	PHYAD: 0
> > > > 	Transceiver: internal
> > > > 	Auto-negotiation: on
> > > > 	Supports Wake-on: ug
> > > > 	Wake-on: d
> > > > 	Current message level: 0x0000003f (63)
> > > > 			       drv probe link timer ifdown ifup
> > > > 	Link detected: yes
> > > > 
> > > > I was expecting that, as MAC side is limited to 2.5G, I should set in 
> > > > phylink the correct capabilities and then outcome of autoneg would only 
> > > > have up to 2.5G modes. Am I wrong ?
> > > > 
> > > > ---
> > > > Thanks,
> > > > Jose Miguel Abreu
> > > 
> > > 
> > > ---
> > > Thanks,
> > > Jose Miguel Abreu
> > > 
> > 
> > -- 
> > RMK's Patch system: https://urldefense.proofpoint.com/v2/url?u=https-3A__www.armlinux.org.uk_developer_patches_&d=DwIBAg&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=1MdSlPrmzsMMCJbbLcDYTNuPq1njfusBRjcRz3UD4Dg&s=_30hwSYkGf9DfyCG48mnh7lXP8iiULXpfAP_6agUJno&e= 
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > According to speedtest.net: 11.9Mbps down 500kbps up
> 
> 
> ---
> Thanks,
> Jose Miguel Abreu
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
