Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4885112FB80
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 18:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgACRUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 12:20:04 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43774 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgACRUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 12:20:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bbJy0lZ+YbKen4p/Kf7VRz8SR44eADZmyTrEvtxtqdE=; b=idD55OCEKGNqOizwY2SMKXfjf
        8B2fQaaXpJXss/GmXWsiMLEuScDZsOE4hLMPAkuj9Kmi+u1lqsub91kVk4uwZ+FHeE3pwj8OQRkIS
        ZmQYuradWgU2SoGp7pMMXbsOiwx6HDs3XE0ls8kg27iYJoTXgNbEEfEU0iERp9sPkxi3qMMGgy0BC
        jf9ZMxV07ji+GGAfU+mu7sUDy5rRW2ww5hMwRCqIPqalbQxWxGE7mhuEBbHsc7V5fGx7OpB/0XVBy
        owDlUTcZ0+90wAp//4cWKD8ZRPWe6jgf8foKbnhezPLScERbtnIu3ZHzCiE9Z6Hgrn7Iu4fixBSwB
        coFBE4+Zw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:50112)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1inQc9-0003IN-84; Fri, 03 Jan 2020 17:19:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1inQc4-0003J1-Tt; Fri, 03 Jan 2020 17:19:52 +0000
Date:   Fri, 3 Jan 2020 17:19:52 +0000
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
Message-ID: <20200103171952.GH25745@shell.armlinux.org.uk>
References: <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
 <20200103094204.GA18808@shell.armlinux.org.uk>
 <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103125310.GE25745@shell.armlinux.org.uk>
 <DB8PR04MB6985FB286A71FC6CFF04BE50EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6985FB286A71FC6CFF04BE50EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 03:57:45PM +0000, Madalin Bucur (OSS) wrote:
> Hi, I'm aware of the parties involved in the discussion but the messages
> are meant for the whole community so the details included are meant for
> that. We're having a conversation on the mailing list, not in private
> and the end result of this will be of use, I hope, to others that have the
> same dilemmas, be them justified or not. I had the pleasure to meet Andrew
> in person a couple of years ago and I'm looking forward to meet you as well.

The most frustrating part of this discussion for me is this:

It started by you stating that you wanted to use XFI as a
phy_interface_t, and through that initial discussion you were stating
that XFI is defined by the XFP MSA - which is quite right. XFI is the
electrical interface used for XFP modules, as defined by the XFP MSA.
SFI is the electrical interface used for SFP+ modules, as defined by
the SFP+ MSA (_not_ the SFP MSA, if you want to be pedantic.)

When I found a copy of the XFP MSA, along with its definition of what
the XFI interface is, _all_ the points that I brought up about the
XFI interface have been mostly ignored, such as my statement that XFI
includes the electrical characteristics of the platform, because the
stated specifications are valid only at the XFP mating connector.

I also found that both XFI and SFI do not define the format of the
electrical signals; indeed, there are several baud rates that are
used which result in different bit periods of the signal, and even
a case where 10GBASE-R can be carried on XFI in two different forms.

Rather than provide a counter-argument, you have instead switched to
using other arguments to justify your position, such as using a
breakdown of what 10GBASE-*R means.

Yet again, as I see from the below, you have failed to counter any
of the points that I have raised below.

> > You seem to grasp at straws to justify your position. Initially, you
> > were stating that XFI/SFI are defined by the MSAs and using that as
> > a justification. Now, when I state what the MSAs say, you then go off
> > and try to justify your position with some 3rd party description of
> > what the various bits of 10GBASE-*R mean. Now you're trying to make
> > out that your position is justified by the omission of the term "PCS"
> > in the kernel's documentation.
> > 
> > I am well aware that DT describes the hardware; I am not a newbie to
> > kernel development, but have been involved with it for near on 27
> > years as ARM maintainer, getting into the details of platform
> > support. So please stop telling me that DT describes the hardware.
> > I totally accept that.
> > 
> > What I don't accept is the idea that "XFI" needs to be a PHY interface
> > mode when there's a hell of a lot more to it than just three letters.
> > 
> > If it was that simple, then we could use "SATA" to support all SATA
> > connections, but we can't. Just like "XFI" or "SFI", sata is a
> > single channel serdes connection with electrical performance
> > requirements defined at a certain point. In the case of eSATA, they
> > are defined at the connector. In order to achieve those performance
> > requirements, we need to specify the electrical parameters in DT to
> > achieve compliance. As an example, here is what is required for the
> > cubox-i4:
> > 
> > &sata {
> >         status = "okay";
> >         fsl,transmit-level-mV = <1104>;
> >         fsl,transmit-boost-mdB = <0>;
> >         fsl,transmit-atten-16ths = <9>;
> >         fsl,no-spread-spectrum;
> > };
> > 
> > These parameters configure the interface to produce a waveform at
> > the serdes output that, when modified by the characteristics of the
> > PCB layout, result in compliance with the eSATA connection at the
> > connector - which is what is required.
> > 
> > XFI and SFI are no different; these are electrical specifications.
> > The correct set of electrical parameters to meet the specification
> > is more than just three letters, and it will be board specific.
> > Hence, on their own, they are completely meaningless.
> > 
> > We have already ascertained that "XFI" and "SFI" do nothing to
> > describe the format of the protocol - that protocol being one of
> > 10GBASE-W, 10GBASE-R, fibrechannel or G.709.
> > 
> > So, "XFI" or "SFI" as a phy_interface_t is meaningless. As a phy-mode,
> > it is meaningless. As a phy-connection-type, it is meaningless.
> > 
> > You claim that I'm looking at it from a phy_interface_t perspective.
> > Sorry, but that is where you are mistaken. I'm looking at it from a
> > high level, both from the software-protocol point of view and the
> > hardware-electrical point of view.
> > 
> > XFI and SFI are electrical specifications only. They do not come
> > close to specifying the protocol. They don't uniquely specify the
> > baud rate of the data on the link. They don't uniquely specify the
> > format of that data. You can't have two "XFI" configured devices,
> > one using XFI/10GBASE-R connected to another using XFI/10GBASE-W
> > have a working system.
> > 
> > What I might be willing to accept is if we were to introduce
> > XFI_10GBASER, XFI_10GBASEW, XFI_10GFC, XFI_G709 and their SFI
> > counterparts - but, there would remain one HUGE problem with that,
> > which is the total lack of specification of the board characteristics
> > required to achieve XFI electrical compliance.
> > 
> > As I've stated many times, "XFI" and "SFI" are electrical
> > specifications which include the platform PCB layout. The platform
> > part of it needs to be described in DT as well, and you can't do
> > that by just a simple three-letter "XFI" or "SFI" neumonic. Just like
> > my SATA example above, it takes much more.
> > 
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps
> > up
> > According to speedtest.net: 11.9Mbps down 500kbps up
> 
> This conversation started a while ago, when I tried to introduce XFI and SFI
> as valid compatibles describing the phy-connection-type device tree parameter
> for some platforms. Alternatives are "xgmii", "usxgmii" or "10gbase-kr". I can
> no longer use "xgmii" because at least one PHY is rejecting that as a PHY
> "interface":
> 
> 	WARN(phydev->interface == PHY_INTERFACE_MODE_XGMII,...

Hang on, so because a PHY driver now rejects XGMII, you're saying you
can't use it. Let's have a look at what XGMII is. It is a four data
line interface using 8b/10b encoding.

Instead of using that, you want to use XFI instead, which is a single
data line interface. The encoding is not defined, except by the
underlying protocol. In the case of clause 49 Ethernet over XFI, aka
10GBASE-R, that is using 64b/66b encoding.

You've gone on about DT describing the hardware - and yes it does
that. Describing the PHY interface correctly is part of that, and
that includes the number of data lanes and the encoding of the
signal.

So, if you were using "xgmii", and now wish to use "xfi" for the
_same_ hardware, something is very very wrong with how you are
approaching this. The two interfaces are _entirely_ different. If
it is four data lanes, then it is not XFI. If it is a single data
lane, then it _may_ be 10GBASE-R using something _like_ XFI
electrical levels.

> Thus the search for a correct value. Reading the PHY datasheet, these are
> providing support on the line side for 10GBASET/5GBASE-T/2.5GBASE-T/
> 1000BASE-T/100BASE-TX while on the system side they claim:
> 
>  * High-Performance full KR (with autonegotiation)/
>  * XFI/USXGMII/2500BASE-X/SGMII I/F w/ AC-JTAC 
>  * Capable of rate adapting all rates into KR/XFI via PAUSE and 100M/1G
> into 2500BASE-X
> 
> The SoC that connects to one such PHY can have his SERDES configured in XFI
> mode, using something called a reset configuration word (it's hardcoded).
> Other supported modes are SGMII, 10GBASE-KR, new devices will support SFI.

Right, but, as I've stated several times already, XFI in itself is
insufficient to describe the interface. What you are seeing in the
various datasheets is an appropriation of a term that is actually
meaningless.

Let's go over what XFI as defined by the XFP MSA is again:

- It is an electrical specification with parameters defined at the
  XFP socket for both the XFP host system, and the XFP module. It
  is a fact that the electrical signals reach the socket over the
  PCB, and the PCB will modify the characteristics of those signals.

- Electrical recommendations are given for the Serdes/ASIC inputs
  and outputs; these are "informative" which means they are not
  a specification.

- XFI can carry several different protocols: 10GBASE-W, 10GBASE-R,
  10G Fibrechannel, 10GBASE-R over G.709.

So, a PHY or SoC datasheet claiming that it has a XFI interface is
actually an abuse of the term:

- There is no XFP socket involved
- They certainly do not involve the electrical characteristics of
  the PCB that their device will be placed upon
- They haven't specified which of the four protocols that XFI can
  carry is to be used

The reality is, which I'm saying having spent quite a long time with
the Marvell Armada 8040 SoC, Marvell 88x3310 PHY, and SFP+ modules
including spending a lot of time analysing the eye pattern and
adjusting the electrical characteristics to bring it more into
compliance, is that this term "XFI" that is banded around so much in
datasheets bears very little relation to the XFI as specified in the
XFP MSA.

This can be seen if I compare the serdes interface electrical
specification for the Marvell 88x3310 PHY with that given in the XFP
MSA. The two are not identical; there are some subtle differences
between what is given for the 88x3310 PHY and the XFP MSA for the
"Serdes/ASIC" test points A and D, but on the whole, it meets the
"informative" "recommended" parameters given in the XFP MSA for XFI.

That doesn't mean that it _is_ XFI. As stated above, XFI could be
carrying 10GBASE-W or any of the other three.

In this instance, the PHY only accepts and generates 10GBASE-R over
its "XFI" interface.

This is my point: this PHY, which uses "XFI" through out its datasheet
is actually using XFI electrical characteristics _with_ 10GBASE-R as
the underlying protocol (because this PHY is designed to be an
Ethernet LAN PHY.)

To see how silly this is, please read some XFP module specifications,
which are, after all, what the XFI interface is there to support given
that XFI is defined by the XFP MSA:

https://eoptolink.com/pdf/XFP-ZR-1310-70km-optical-transceiver.pdf

Here, we have an optical transceiver with an XFI interface which can
carry any of 10GBASE-ZW, 10GBASE-ZR, 10G Ethernet over G.709. Each
of these is a different baud rate, and requires the XFI to run at a
slightly different speed.

So, "XFI" is nothing but a mis-nomer when it comes to PHY and SoC
datasheets; it is an incomplete specification of what they actually
support, which is 10GBASE-R with a compliance with the XFI Serdes/
ASIC test point *recommendations*.

> You say this is not sufficient, and it may not be, but for this PHY and for
> this SoC pair in particular, it's all it's needed. There are not that many
> things to set up in SW but some things need to be put in place and a
> indication that this mode is used is required.

So, let's do a thought experiment. Let's say that we adopt your
proposal to use "XFI" for this instance.  Great.

How do we handle 10GBASE-W over XFI when that comes along? That's
still XFI, but it's incompatible with _your_ version of XFI. "But
my datasheet says it is so it must be correct".  Yes, it's as
correct as your current usage of XFI.

And that's my point: XFI is not 10GBASE-R. It is not 10GBASE-W. XFI
is an electrical specification which may be one of several different
protocols.

To properly describe it, you need _both_ the electrical specification
and the protocol specification - but manufacturers omit that, because
it's implied in the datasheeet.  If you're looking at a LAN 10G PHY
that says XFI, it is actually meaning 10GBASE-R over a link that
complies with the XFI recommendations.

If you're looking at a SONET OC-192 device which has an XFI interface,
it is actually meaning 10GBASE-W over a link that complies with the
XFI recommendations.

I hope this finally clears up exactly the point I'm making.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
