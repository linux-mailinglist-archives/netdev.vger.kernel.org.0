Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B6139405
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbfFGSLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:11:04 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:29063 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730336AbfFGSLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:11:04 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x57IAxjK010633
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Jun 2019 12:10:59 -0600 (CST)
Received: from eng1n65.eng.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x57IAvst038860
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 7 Jun 2019 12:10:57 -0600
Subject: Re: [PATCH net-next] net: phy: phylink: add fallback from SGMII to
 1000BaseX
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
 <20190531201826.2qo57l2phommgpm2@shell.armlinux.org.uk>
 <4b7bf6b4-dbc8-d3d0-4b31-789fcdb8e6b7@sedsystems.ca>
 <20190602151534.nv4b67n5n2iermnr@shell.armlinux.org.uk>
From:   Robert Hancock <hancock@sedsystems.ca>
Openpgp: preference=signencrypt
Autocrypt: addr=hancock@sedsystems.ca; prefer-encrypt=mutual; keydata=
 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
Organization: SED Systems
Message-ID: <37914305-fd19-949a-e20e-b709495c517d@sedsystems.ca>
Date:   Fri, 7 Jun 2019 12:10:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190602151534.nv4b67n5n2iermnr@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-02 9:15 a.m., Russell King - ARM Linux admin wrote:
> On Fri, May 31, 2019 at 06:17:51PM -0600, Robert Hancock wrote:
>> Our device is mainly intended for fiber modules, which is why 1000BaseX
>> is being used. The variant of fiber modules we are using (for example,
>> Finisar FCLF8520P2BTL) are set up for 1000BaseX, and seem like they are
>> kind of a hack to allow using copper on devices which only support
>> 1000BaseX mode (in fact that particular one is extra hacky since you
>> have to disable 1000BaseX autonegotiation on the host side). This patch
>> is basically intended to allow that particular case to work.
> 
> Looking at the data sheet for FCLF8520P2BTL, it explicit states:
> 
> PRODUCT SELECTION
> Part Number	Link Indicator	1000BASE-X auto-negotiation
> 		on RX_LOS Pin	enabled by default
> FCLF8520P2BTL	Yes		No
> FCLF8521P2BTL	No		Yes
> FCLF8522P2BTL	Yes		Yes
> 
> The idea being, you buy the correct one according to what the host
> equipment requires, rather than just picking one and hoping it works.
> 
> The data sheet goes on to mention that the module uses a Marvell
> 88e1111 PHY, which seems to be quite common for copper SFPs from
> multiple manufacturers (but not all) and is very flexible in how it
> can be configured.
> 
> If we detect a PHY on the SFP module, we check detect whether it is
> an 88e1111 PHY, and then read out its configured link type.  We don't
> have a way to deal with the difference between FCLF8520P2BTL and
> FCLF8521P2BTL, but at least we'll be able to tell whether we should
> be in 1000Base-X mode for these modules, rather than SGMII.

It looks like that might provide a solution for modules using the
Marvell PHY, however some of the modules we are supporting seem to use a
Broadcom PHY, and I have no idea if there is any documentation for those.

It would really be rather silly if there were absolutely no way to tell
what mode the module wants from the EEPROM.. I don't have any copper
modules set up for SGMII, but below is the ethtool -m output for two of
the 1000BaseX modules I have. If you have access to an SGMII module, can
you compare this to what it indicates?

# ethtool -m eth1
	Identifier                                : 0x03 (SFP)
	Extended identifier                       : 0x04 (GBIC/SFP defined by
2-wire interface ID)
	Connector                                 : 0x00 (unknown or unspecified)
	Transceiver codes                         : 0x00 0x00 0x00 0x08 0x00
0x00 0x00 0x00 0x00
	Transceiver type                          : Ethernet: 1000BASE-T
	Encoding                                  : 0x01 (8B/10B)
	BR, Nominal                               : 1200MBd
	Rate identifier                           : 0x00 (unspecified)
	Length (SMF,km)                           : 0km
	Length (SMF)                              : 0m
	Length (50um)                             : 0m
	Length (62.5um)                           : 0m
	Length (Copper)                           : 100m
	Length (OM3)                              : 0m
	Laser wavelength                          : 0nm
	Vendor name                               : FINISAR CORP.
	Vendor OUI                                : 00:90:65
	Vendor PN                                 : FCLF8520P2BTL
	Vendor rev                                : A
	Option values                             : 0x00 0x12
	Option                                    : RX_LOS implemented
	Option                                    : TX_DISABLE implemented
	BR margin, max                            : 0%
	BR margin, min                            : 0%
	Vendor SN                                 : PX90NHX
	Date code                                 : 170303


# ethtool -m eth1
	Identifier                                : 0x03 (SFP)
	Extended identifier                       : 0x04 (GBIC/SFP defined by
2-wire interface ID)
	Connector                                 : 0x00 (unknown or unspecified)
	Transceiver codes                         : 0x00 0x00 0x00 0x08 0x00
0x00 0x00 0x00 0x00
	Transceiver type                          : Ethernet: 1000BASE-T
	Encoding                                  : 0x01 (8B/10B)
	BR, Nominal                               : 1300MBd
	Rate identifier                           : 0x00 (unspecified)
	Length (SMF,km)                           : 0km
	Length (SMF)                              : 0m
	Length (50um)                             : 0m
	Length (62.5um)                           : 0m
	Length (Copper)                           : 100m
	Length (OM3)                              : 0m
	Laser wavelength                          : 0nm
	Vendor name                               : BEL-FUSE
	Vendor OUI                                : 00:00:00
	Vendor PN                                 : 1GBT-SFP06
	Vendor rev                                : PB
	Option values                             : 0x00 0x12
	Option                                    : RX_LOS implemented
	Option                                    : TX_DISABLE implemented
	BR margin, max                            : 0%
	BR margin, min                            : 0%
	Vendor SN                                 :      0000000610
	Date code                                 : 1336


> 
> For a SFP cage meant to support fiber, I would recommend using the
> FCLF8521P2BTL or FCLF8522P2BTL since those will behave more like a
> 802.3z standards-compliant gigabit fiber connection.
> 

-- 
Robert Hancock
Senior Software Developer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
