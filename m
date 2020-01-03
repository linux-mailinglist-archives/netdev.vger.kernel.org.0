Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1700512F886
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 13:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgACMxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 07:53:20 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40714 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgACMxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 07:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XHNeXrzfdTabvPC6P9Ns9gJ0I7CWIRDHSAxEUCf0ziI=; b=yzySYAYMg7BLL2qA4r5dfDIsD
        Bm8t4sooBRs+lwHa8+qisSFKWq4ZUN2hGtYZBlT9pp/LXwJS+MS5jhSaphnHRDJDI2vuVo9TEebV9
        SMkqU+YToBObG4HrxDXdy1kt1qIOZQWpdBCROiVGSkEC8RwJODheqxbMtAGx+JemkP3ex9HJkKzg9
        QKJFxHrcM24jv/qHj0ebfdYoobEEJao1h54VnvGrBVa52z0K3y2wklHhpbBxuliy46yTT7dbw8cyl
        iejN/n3fseJphaUbzvmw4GsolEQBQlk4fbQO+I87qv9XxVlJVYi+RbE4IakG7O/Bp5q1lZvYPmnke
        VqZ0hnMkA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33452)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1inMS1-00028k-GW; Fri, 03 Jan 2020 12:53:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1inMRy-00038z-FA; Fri, 03 Jan 2020 12:53:10 +0000
Date:   Fri, 3 Jan 2020 12:53:10 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20200103125310.GE25745@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
 <20200103094204.GA18808@shell.armlinux.org.uk>
 <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 12:03:44PM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Sent: Friday, January 3, 2020 11:42 AM
> > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > Cc: devicetree@vger.kernel.org; davem@davemloft.net;
> > netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
> > hkallweit1@gmail.com; shawnguo@kernel.org
> > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > 
> > On Fri, Jan 03, 2020 at 09:27:18AM +0000, Russell King - ARM Linux admin
> > wrote:
> > > Merely specifying "xfi" does not tell you what you need to do to achieve
> > > XFI compliance at the point defined in INF8077i.  Plus, XFI can also be
> > > protocols _other_ than 10GBASE-R.
> > >
> > > Claiming that "XFI" properly defines the interface is utter rubbish. It
> > > does not. XFI defines the electrical characteristics *only* and not
> > > the underlying protocol. It is not limited to 10GBASE-R, but includes
> > > other protocols as well.
> > 
> > Let me quote from INF-8077i, which is the XFP MSA, the document
> > responsible for defining XFI:
> > 
> > 3.1 INTRODUCTION
> >    XFI signaling is based on high speed low voltage logic, with nominal
> > 100
> >    Ohms differential impedance and AC coupled in the module. XFI was de-
> >    veloped with the primary goal of low power and low Electro-Magnetic-In-
> > 
> >    terference (EMI). To satisfy this requirement the nominal differential
> > signal   levels are 500 mV p-p with edge speed control to reduce EMI.
> > 
> > 3.2 XFI APPLICATIONS DEFINITION
> >    The application reference model for XFI, which connects a high speed
> >    ASIC/SERDES to the XFP module is shown in Figure 4. The XFI interface
> >    is designed to support SONET OC-192, IEEE.Std-802.3ae, 10GFC and
> >    G.709(OTU-2) applications. The SERDES is required to meet the applica-
> >    tion requirements for jitter generation and transfer when interfaced
> > with a
> >    compliant XFP module through an XFP compliant channel. Modules or
> > 
> >    hosts designed only for 10 Gigabit Ethernet or 10GFC are not required
> > to
> >    meet more stringent Telecom jitter requirements. XFI supported data
> >    rates are listed in Table 5. XFP compliant module are not required to
> > sup-
> >    port all the rates listed in Table 5 in simultaneously.
> > 
> >    Standard                            Description           Nominal Bit
> > Rate     Units
> >    OC-192/SDH-64                         SONET                     9.95
> > Gigabaud
> >    IEEE std-802.3ae             10 Gb/s Ethernet LAN PHY           10.31
> > Gigabaud
> >    INCITS/T11 Project 1413-D             10GFC                     10.52
> > Gigabaud
> >    ITU G.709(OTU-2)                 OC-192 Over FEC                10.70
> > Gigabaud
> >    Emerging                     10Gb/s Ethernet Over G.709         11.09
> > Gigabaud
> > 
> > So here, we can clearly see that it's possible to run SONET, 10GBASE-R,
> > 10G Fiberchannel, OC-192, and G.709 over XFI, so XFI does not describe
> > _just_ ethernet. If we're going to be configuring a serdes to output
> > XFI, we need to know a lot more than just "XFI".
> > 
> >    XFI Compliance points are defined as the following:
> > 
> >    •   A: SerDes transmitter output at ASIC/SerDes package pin on a DUT
> >        board 3.6 and A.1
> >    •   B: Host system SerDes output across the host board and connector
> >        at the Host Compliance Test Card 3.7.1 and A.2
> >    •   B': XFP transmitter input across the Module Compliance Test Board
> >        3.8.1 and A.3.
> >    •   C: Host system input at the Host Compliance Test Card input 3.7.2
> >        and A.2
> >    •   C': XFP module output across the Module Compliance Test Board
> >        3.8.2 and A.3.
> > 
> >    •   D: ASIC/SerDes input package pin on the DUT board 3.6.2 and A.1.
> > 
> >    ASIC/SerDes compliance points are informative.
> > 
> > So the electrical points that count are B, B', C and C'. A and D
> > are merely "informative".  Hence, compliance with XFI is required
> > to take the entire platform into account, not just the output of
> > the serdes/asic.  That means the performance of the PCB needs to
> > be described in DT if you want to achieve compliance with XFI.
> > phy_interface_t can't do that.
> > 
> > So, let me re-iterate: neither XFI nor SFI are suitable for
> > phy_interface_t. XFI defines merely a group of possible protocols
> > and an electrical specification. It doesn't tell you which of those
> > protocols you should be using.
> 
> The disconnect is you are focused on phy_interface_t and I'm looking at
> the device tree as there's where one starts (actually at the device tree
> binding document). Your concern is with configuring the HW to use a certain
> PCS setting, thus 10GBASE-R, while I'm concerned with the fact the device
> tree must not configure software but describe HW. So let's do some archeology
> on the matter, to try to understand where this is coming from.
> 
> A device tree entry that described the electrical interface between the chip
> harboring an Ethernet MAC bloc and another chip that served the purpose of an
> Ethernet PHY was needed. In the past this parameter was "phy-connection-type".
> We find it detailed in kernel v3.0 in 
> Documentation/devicetree/bindings/net/fsl-tsec-phy.txt:52
> 
>   - phy-connection-type : a string naming the controller/PHY interface type,
>     i.e., "mii" (default), "rmii", "gmii", "rgmii", "rgmii-id", "sgmii",
>     "tbi", or "rtbi".  This property is only really needed if the connection
>     is of type "rgmii-id", as all other connection types are detected by
>     hardware.
> 
> Later, in kernel version v4.0 we find it described in 
> Documentation/devicetree/bindings/net/ethernet.txt:16
> 
> - phy-mode: string, operation mode of the PHY interface; supported values are
>   "mii", "gmii", "sgmii", "qsgmii", "tbi", "rev-mii", "rmii", "rgmii", "rgmii-id",
>   "rgmii-rxid", "rgmii-txid", "rtbi", "smii", "xgmii"; this is now a de-facto
>   standard property;
> - phy-connection-type: the same as "phy-mode" property but described in ePAPR;
> 
> Now (v5.5-rc3) we find it moved to
> Documentation/devicetree/bindings/net/ethernet-controller.yaml:57:
> 
>   phy-connection-type:
>     description:
>       Operation mode of the PHY interface
>     enum:
>       # There is not a standard bus between the MAC and the PHY,
>       # something proprietary is being used to embed the PHY in the
>       # MAC.
>       - internal
>       - mii
>       - gmii
>       - sgmii
>       - qsgmii
>       - tbi
>       - rev-mii
>       - rmii
> 
>       # RX and TX delays are added by the MAC when required
>       - rgmii
> 
>       # RGMII with internal RX and TX delays provided by the PHY,
>       # the MAC should not add the RX or TX delays in this case
>       - rgmii-id
> 
>       # RGMII with internal RX delay provided by the PHY, the MAC
>       # should not add an RX delay in this case
>       - rgmii-rxid
> 
>       # RGMII with internal TX delay provided by the PHY, the MAC
>       # should not add an TX delay in this case
>       - rgmii-txid
>       - rtbi
>       - smii
>       - xgmii 
>       - trgmii
>       - 1000base-x
>       - 2500base-x
>       - rxaui
>       - xaui
> 
>       # 10GBASE-KR, XFI, SFI
>       - 10gbase-kr
>       - usxgmii
> 
>   phy-mode:
>     $ref: "#/properties/phy-connection-type"
> 
> At each step, it was changed a bit. It started by describing the actual MII
> connection (RGMII, SGMII, XGMII). Later is was changed to denote "operation
> mode" of the interface. There is no reference here to PCS configuration (it
> could not be as the device tree does not configure but describes the HW). I
> see no reference about this device tree entry describing the protocol only
> (I'm referring to your second reply on this here). If the device tree binding
> does not describe the protocol only, but when it's parsed in software, into
> the phy_interface_t it describes only the protocol and not the actual interface
> type("mode"), then we have a disconnect here. This type is described as:
> 
> /* Interface Mode definitions */
> typedef enum {
>         PHY_INTERFACE_MODE_NA,
>         PHY_INTERFACE_MODE_INTERNAL,
>         PHY_INTERFACE_MODE_MII,
>         PHY_INTERFACE_MODE_GMII,
>         PHY_INTERFACE_MODE_SGMII,
>         PHY_INTERFACE_MODE_TBI,
>         PHY_INTERFACE_MODE_REVMII,
>         PHY_INTERFACE_MODE_RMII,
>         PHY_INTERFACE_MODE_RGMII,
>         PHY_INTERFACE_MODE_RGMII_ID,
>         PHY_INTERFACE_MODE_RGMII_RXID,
>         PHY_INTERFACE_MODE_RGMII_TXID,
>         PHY_INTERFACE_MODE_RTBI,
>         PHY_INTERFACE_MODE_SMII,
>         PHY_INTERFACE_MODE_XGMII,
> ...
> } phy_interface_t;
> 
> 
> So we can notice that is in sync with the device tree binding document.
> Please note the RGMII, RGMII_ID, RGMII_RXID, RGMII_TXID. The only
> difference there is in the delays on the electrical connections between
> the chips. Take a step back, look at the list of existing entries, at
> the history of this and see if it maps to one story or another.

You have the author of the SFP/phylink layers disagreeing with you,
and you have one of the maintainers of phylib also disagreeing with
you.

You seem to grasp at straws to justify your position. Initially, you
were stating that XFI/SFI are defined by the MSAs and using that as
a justification. Now, when I state what the MSAs say, you then go off
and try to justify your position with some 3rd party description of
what the various bits of 10GBASE-*R mean. Now you're trying to make
out that your position is justified by the omission of the term "PCS"
in the kernel's documentation.

I am well aware that DT describes the hardware; I am not a newbie to
kernel development, but have been involved with it for near on 27
years as ARM maintainer, getting into the details of platform
support. So please stop telling me that DT describes the hardware.
I totally accept that.

What I don't accept is the idea that "XFI" needs to be a PHY interface
mode when there's a hell of a lot more to it than just three letters.

If it was that simple, then we could use "SATA" to support all SATA
connections, but we can't. Just like "XFI" or "SFI", sata is a
single channel serdes connection with electrical performance
requirements defined at a certain point. In the case of eSATA, they
are defined at the connector. In order to achieve those performance
requirements, we need to specify the electrical parameters in DT to
achieve compliance. As an example, here is what is required for the
cubox-i4:

&sata {
        status = "okay";
        fsl,transmit-level-mV = <1104>;
        fsl,transmit-boost-mdB = <0>;
        fsl,transmit-atten-16ths = <9>;
        fsl,no-spread-spectrum;
};

These parameters configure the interface to produce a waveform at
the serdes output that, when modified by the characteristics of the
PCB layout, result in compliance with the eSATA connection at the
connector - which is what is required.

XFI and SFI are no different; these are electrical specifications.
The correct set of electrical parameters to meet the specification
is more than just three letters, and it will be board specific.
Hence, on their own, they are completely meaningless.

We have already ascertained that "XFI" and "SFI" do nothing to
describe the format of the protocol - that protocol being one of
10GBASE-W, 10GBASE-R, fibrechannel or G.709.

So, "XFI" or "SFI" as a phy_interface_t is meaningless. As a phy-mode,
it is meaningless. As a phy-connection-type, it is meaningless.

You claim that I'm looking at it from a phy_interface_t perspective.
Sorry, but that is where you are mistaken. I'm looking at it from a
high level, both from the software-protocol point of view and the
hardware-electrical point of view.

XFI and SFI are electrical specifications only. They do not come
close to specifying the protocol. They don't uniquely specify the
baud rate of the data on the link. They don't uniquely specify the
format of that data. You can't have two "XFI" configured devices,
one using XFI/10GBASE-R connected to another using XFI/10GBASE-W
have a working system.

What I might be willing to accept is if we were to introduce
XFI_10GBASER, XFI_10GBASEW, XFI_10GFC, XFI_G709 and their SFI
counterparts - but, there would remain one HUGE problem with that,
which is the total lack of specification of the board characteristics
required to achieve XFI electrical compliance.

As I've stated many times, "XFI" and "SFI" are electrical
specifications which include the platform PCB layout. The platform
part of it needs to be described in DT as well, and you can't do
that by just a simple three-letter "XFI" or "SFI" neumonic. Just like
my SATA example above, it takes much more.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
