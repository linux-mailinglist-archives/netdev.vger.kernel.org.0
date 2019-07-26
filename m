Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A82A76EF4
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfGZQXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:23:32 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53432 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfGZQXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=W2ljXYKvw+N3+JyqB9djvy0nICZnexsB0k2AWLfEhxk=; b=i8uUQer4IUEBCEI/fTZJTguWH
        rTo+NRo2hdVicx26QBI4L28j//yvWJIiqo667kCy6slRLWXFNF8wNaOEBRqMXyN1DpiwPXkBtFezZ
        0JvRsrBjv5eKmED+5jPycoPREMQeBFWBoUNme/KmeZoc2ibefV8mMwwxzYcD9tUkNnpRlDUuWCcrz
        JjeUQBWIFIvc1mYqjQkWEUCCtM6fuTlwnfcks9MBZLXTGOajVHcb3javJL2943QqGNcmI773Vod/o
        JCliJ0hoq1gbHq0TV3b22926hMUQt3XEWspgP6bVmO8Wgl+yBThTRexueVSEcbBicyp6dbQaokDpp
        +A6k6ZQRQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48972)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hr30A-0007Ec-GB; Fri, 26 Jul 2019 17:23:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hr306-0006vE-2k; Fri, 26 Jul 2019 17:23:22 +0100
Date:   Fri, 26 Jul 2019 17:23:22 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        frank-w@public-files.de, sean.wang@mediatek.com,
        f.fainelli@gmail.com, davem@davemloft.net, matthias.bgg@gmail.com,
        vivien.didelot@gmail.com, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: ethernet: Update mt7622
 docs and dts to reflect the new phylink API
Message-ID: <20190726162321.GQ1330@shell.armlinux.org.uk>
References: <20190724192411.20639-1-opensource@vdorst.com>
 <20190725193123.GA32542@lunn.ch>
 <20190726071956.Horde.s4rfuzovwXB-d3LnV0PLRc8@www.vdorst.com>
 <20190726131604.GA18223@lunn.ch>
 <20190726151622.Horde.1AA717IbQrC7_YJcSBe4M-0@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190726151622.Horde.1AA717IbQrC7_YJcSBe4M-0@www.vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 03:16:22PM +0000, René van Dorst wrote:
> Quoting Andrew Lunn <andrew@lunn.ch>:
> > On Fri, Jul 26, 2019 at 07:19:56AM +0000, René van Dorst wrote:
> > > Quoting Andrew Lunn <andrew@lunn.ch>:
> > > 
> > > >>+	gmac0: mac@0 {
> > > >>+		compatible = "mediatek,eth-mac";
> > > >>+		reg = <0>;
> > > >>+		phy-mode = "sgmii";
> > > >>+
> > > >>+		fixed-link {
> > > >>+			speed = <2500>;
> > > >>+			full-duplex;
> > > >>+			pause;
> > > >>+		};
> > > >>+	};
> > > >
> > > >Hi René
> > > >
> > > 
> > > Hi Andrew,
> > > 
> > > >SGMII and fixed-link is rather odd. Why do you need this combination?
> > > 
> > > BananaPi R64 has a RTL8367S 5+2-port switch, switch interfaces with the SOC
> > > by a
> > > (H)SGMII and/or RGMII interface. SGMII is mainly used for the LAN ports and
> > > RGMII for the WAN port.
> > > 
> > > I mimic the SDK software which puts SGMII interface in 2.5GBit fixed-link
> > > mode.
> > > The RTL8367S switch code also put switch mac in forge 2.5GBit mode.
> > > 
> > > So this is the reason why I put a fixed-link mode here.
> > 
> > Are you sure it is using SGMII and not 2500BaseX? Can you get access
> > to the signalling word? SGMII is supposed to indicate to the MAC what
> > speed it is using, via inband signalling. So there should not be any
> > need for a fixed-link. 2500BaseX however does not have such
> > signalling, so there would need to be a fixed link.
> 
> I am not sure.
> 
> I just converted the current mainline code to support phylink and mimic the
> DTS
> of the SDK. But the SDK seems to be incorrect.
> 
> Realtek[0] calls these modes:
> * SGMII (1.25GHz) Interface
> * High SGMII (3.125GHz) Interface
> Also the datasheet that I have doesn't talk about base-x modes.

So this is RTL8367S-CG, which is a switch.  It's entirely possible that
it really does support what it says it does.

> But MT7622 Reference manual[1] page 1960 says:
>  The core leverages the 1000Base-X PCS and Auto-Negotiation from IEEE 802.3
>  specification (clause 36/37). This IP can support up to 3.125G baud for
> 2.5Gbps
>  (proprietary 2500Base-X) data rate of MAC by overclocking.
> 
> So I think it phy-mode should be 2500Base-X in this case.

Right, so this suggests that it only supports 1000BASE-X and 2500BASE-X
via the normal method of "over-clocking" 1000BASE-X.

1000BASE-X and SGMII are compatible _if_ and only if you ignore the
contents of the 16-bit control word which is used for auto-negotiation
in the case of 1000BASE-X, or for communicating the negotiation results
in the case of SGMII.  Apart from that 16-bit control word, and the
semantics of it, at the data link level the two are the same.

> SGMII part is a bit hard for me to support, I don't have the hardware,
> MediaTek datasheets are mostly incomplete and also I am a not familiar with
> it.
> 
> But I think I know what I have to change.
> Based on your explanation above.
> 
> I think this more correct implementation:
> 
> * 1000base-x and 2500base-x always force the link.

I think the above is why you have to force the link: a link consisting
of one end configured for SGMII and the other end configured for
1000BASE-X is not a good idea at the best of times, but if you ignore
the 16-bit control word and force it, it will work.

What this means is that you _should_ be forcing it in DT to be a
fixed link, and not trying to do auto-neg.

> * SGMII is always inband but I need in phylink_mac_link_status() to readout
>   "PCS_SPEED_ABILITY Clause 45 3.5" register to see the inband status?
>   Or is it just the GMAC PSMR register? For me it is a bit confusing.
>   SGMII block has a register to set the link speed and etc. But tests on the
>   bananapi R64 board shows that I also need to set the GMAC register else it
>   didn't work. Also it is not easy to debug if you don't have the board.

phylink_mac_link_status() is expected to read the results of SGMII
or 1000BASE-X negotiation at the MAC side of the link.  To see why,
consider a fiber link:

MAC-PCS --- SFP ----- fiber ----- SFP --- MAC-PCS

The fiber is passive, the SFP merely converts between light and
electrical signals - there's nothing apart from the MAC's own PCS
that can report what the negotiation state of the link is.  So,
you need to read from whatever bit of hardware on the MAC side
which will report that - basically, the results of the 1000BASE-X
negotiation.

phylink currently expects results from the PCS to be automatically
propagated to the MAC through hardware, since that's what happens
on Marvell setups - however, that can be changed if there are
setups which need manual propagation.

If we do need to do that, I'd suggest we rename
phylink_mac_link_status() to be phylink_macpcs_link_status() to
clarify which bit of hardware it's supposed to be reading from.

> 
> > Maybe we should really consider what phy-mode = "sgmii"; means. Should
> > this include the overclocked 2.5G speed, or should we add a 2500sgmii
> > link mode?
> 
> No.

I'm really not in favour of "sgmii" being used to also describe the
over-clocked SGMII variants.  It's a different protocol - many data
sheets (e.g. for PHYs that support it) explicitly state that the
speed bits in the SGMII 16-bit control word are not valid, and
over-clocked vs normal SGMII can not be auto-negotiated.  Both ends
must be running at the same speed in order to successfully transfer
even the 16-bit control word that dictates the link speed.

So, SGMII at 3.125Gbps is really a different interface mode from
SGMII at 1.25Gbps.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
