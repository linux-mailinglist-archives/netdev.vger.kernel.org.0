Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20718833B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfHITZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:25:21 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34052 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfHITZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H3olMX5Tvug62NJZyzESkqNh2GP+L95NddsXelQ3SO0=; b=l6zCPDHvyPJfIzVLy9PD8Ufn4
        CkdrY8vesEgkXyH4kSd4A2Zf6yJmLcDncsIBVCM0vF+xq1KIlt3+nps/ckPuJ5oBiAJaxNb6Kvjie
        RYUjjrNFeIvWZwe09ZOEdOn+Lpauda+D+VFU+MC3PvUlLQ2WA8kk2/zInGSPtnczFEYSXs5Idpo2n
        maAiwPe3BEHJQ9XRWvJ3q3QdHxOW7naDTxKKcsQbadDA3qvFrqBQaumTWYDnlK0zGJsWgE6TAQz9R
        1xTMy6wUc4WZzndOxJHYzpkKrnGvY7qc9T8uijammIuZPfykgi5jPHen0XXXpWxn9l5A3e/K11m/8
        1B/mIuIMA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50492)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hwAVp-0003Xf-WF; Fri, 09 Aug 2019 20:25:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hwAVo-0003vH-2D; Fri, 09 Aug 2019 20:25:16 +0100
Date:   Fri, 9 Aug 2019 20:25:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Clause 73 and USXGMII
Message-ID: <20190809192515.GB13294@shell.armlinux.org.uk>
References: <BN8PR12MB32662070AAC1C34BA47C0763D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB3266A710111427071814D371D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808082626.GB5193@shell.armlinux.org.uk>
 <BN8PR12MB32665E5465A83D5E11C7B5D6D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808092313.GC5193@shell.armlinux.org.uk>
 <BN8PR12MB3266DF4F017FCB03E6ED8097D3D70@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190808120903.GF5193@shell.armlinux.org.uk>
 <BN8PR12MB32664B2DE18A30311A19E5B8D3D60@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32664B2DE18A30311A19E5B8D3D60@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 06:42:39PM +0000, Jose Abreu wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Aug/08/2019, 13:09:03 (UTC+00:00)
> 
> > On Thu, Aug 08, 2019 at 11:45:29AM +0000, Jose Abreu wrote:
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Date: Aug/08/2019, 10:23:13 (UTC+00:00)
> > > 
> > > > On Thu, Aug 08, 2019 at 09:02:57AM +0000, Jose Abreu wrote:
> > > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > > Date: Aug/08/2019, 09:26:26 (UTC+00:00)
> > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > Have you tried enabling debug mode in phylink (add #define DEBUG at the
> > > > > > top of the file) ?
> > > > > 
> > > > > Yes:
> > > > > 
> > > > > [ With > 2.5G modes removed ]
> > > > > # dmesg | grep -i phy
> > > > > libphy: stmmac: probed
> > > > > stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 10G]
> > > > > stmmaceth 0000:04:00.0 enp4s0: phy: setting supported 
> > > > > 00,00000000,0002e040 advertising 00,00000000,0002e040
> > > > > stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mode
> > > > > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config: 
> > > > > mode=phy/usxgmii/Unknown/Unknown adv=00,00000000,0002e040 pause=10 
> > > > > link=0 an=1
> > > > > stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknown
> > > > 
> > > > This shows that the PHY isn't reporting that the link came up.  Did
> > > > the PHY negotiate link?  If so, why isn't it reporting that the link
> > > > came up?  Maybe something is mis-programming the capability bits in
> > > > the PHY?  Maybe disabling the 10G speeds disables everything faster
> > > > than 1G?
> > > 
> > > Autoneg was started but never finishes and disabling 10G modes is 
> > > causing autoneg to fail.
> > > 
> > > > 
> > > > > [ Without any limit ]
> > > > > # dmesg | grep -i phy
> > > > > libphy: stmmac: probed
> > > > > stmmaceth 0000:04:00.0 enp4s0: PHY [stmmac-1:00] driver [Synopsys 10G]
> > > > > stmmaceth 0000:04:00.0 enp4s0: phy: setting supported 
> > > > > 00,00000000,000ee040 advertising 00,00000000,000ee040
> > > > > stmmaceth 0000:04:00.0 enp4s0: configuring for phy/usxgmii link mode
> > > > > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config: 
> > > > > mode=phy/usxgmii/Unknown/Unknown adv=00,00000000,000ee040 pause=10 
> > > > > link=0 an=1
> > > > > stmmaceth 0000:04:00.0 enp4s0: phy link down usxgmii/Unknown/Unknown
> > > > > stmmaceth 0000:04:00.0 enp4s0: phy link up usxgmii/2.5Gbps/Full
> > > > > stmmaceth 0000:04:00.0 enp4s0: phylink_mac_config: 
> > > > > mode=phy/usxgmii/2.5Gbps/Full adv=00,00000000,00000000 pause=0f link=1 
> > > > > an=0
> > > > > 
> > > > > I'm thinking on whether this can be related with USXGMII. As link is 
> > > > > operating in 10G but I configure USXGMII for 2.5G maybe autoneg outcome 
> > > > > should always be 10G ?
> > > > 
> > > > As I understand USXGMII (which isn't very well, because the spec isn't
> > > > available) I believe that it operates in a similar way to SGMII where
> > > > data is replicated the appropriate number of times to achieve the link
> > > > speed.  So, the USXGMII link always operates at a bit rate equivalent
> > > > to 10G, but data is replicated twice for 5G, four times for 2.5G, ten
> > > > times for 1G, etc.
> > > > 
> > > > I notice that you don't say that you support any copper speeds, which
> > > > brings up the question about what the PHY's media is...
> > > 
> > > I just added the speeds that XPCS supports within Clause 73 
> > > specification:
> > > Technology Ability field. Indicates the supported technologies:
> > > 	A0: When this bit is set to 1, the 1000BASE-KX technology is supported
> > > 	A1: When this bit is set to 1, the 10GBASE-KX4 technology is supported
> > > 	A2: When this bit is set to 1, the 10GBASE-KR technology is supported
> > > 	A11: When this bit is set to 1, the 2.5GBASE-KX technology is supported
> > > 	A12: When this bit is set to 1, the 5GBASE-KR technology is supported
> > > 
> > > And, within USXGMII, XPCS supports the following:
> > > 	Single Port: 10G-SXGMII, 5G-SXGMII, 2.5G-SXGMII
> > > 	Dual Port: 10G-DXGMII, 5G-DXGMII
> > > 	Quad Port: 10G-XGMII
> > > 
> > > My HW is currently fixed for USXGMII at 2.5G.
> > 
> > So what do you actually have?
> > 
> > +-----+              +----------+
> > | STM |    USXGMII   | Synopsis |   ????????
> > | MAC | <----------> |   PHY    | <----------> ????
> > |     |     link     |          |
> > +-----+              +----------+ (media side)
> > 
> > Does the above refer to what the STM MAC and Synopsis PHY support for
> > the USXGMII link?  What about the media side?
> 
> This is my setup:
> 
> XGMAC <-> XPCS <-> Xilinx SERDES <-> SFP
> 
> I'm not sure about the media side. I use a passive SFP cable if that 
> helps ...

And at the other end of the passive SFP cable?  I guess some kind of
standard networking device.

If the SFP is running at 10G, the protocol to the SFP is expected to be
10GBASE-R - which is fixed at 10G speed.  Unless the Xilinx serdes
(which you previously stated was a PHY) is capable of speed conversion
between 2.5G to the XPCS over USXGMII and 10G to the SFP, then I don't
see how you can expect this setup to work - at least not in a standard
environment.

In any case, I don't think it is phylink causing your problems. Without
knowing more about the "phy", what the Xilinx serdes is capable of, and
how that is being programmed, I don't see how I can provide further
help.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
