Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0672539412
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbfFGSPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:15:13 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:17657 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730092AbfFGSPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:15:12 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x57IF9ix004010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Jun 2019 12:15:09 -0600 (CST)
Received: from eng1n65.eng.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x57IF96f045114
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 7 Jun 2019 12:15:09 -0600
Subject: Re: [PATCH net-next] net: phy: phylink: support using device PHY in
 fixed or 802.3z mode
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
 <20190531203131.skdlic6ub2esyw3o@shell.armlinux.org.uk>
 <1cb5994f-cb70-e2ec-7f72-2e7828813150@sedsystems.ca>
 <20190601201055.isqcqj4psps3fafr@shell.armlinux.org.uk>
From:   Robert Hancock <hancock@sedsystems.ca>
Openpgp: preference=signencrypt
Autocrypt: addr=hancock@sedsystems.ca; prefer-encrypt=mutual; keydata=
 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
Organization: SED Systems
Message-ID: <499db618-9ab7-c89f-ffa7-79cd6b316132@sedsystems.ca>
Date:   Fri, 7 Jun 2019 12:15:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190601201055.isqcqj4psps3fafr@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-01 2:10 p.m., Russell King - ARM Linux admin wrote:
>>> Sorry, I'm having a hard time following this description.  Please draw
>>> an ASCII diagram of the setup you have - a picture is worth 1000 words,
>>> and I think that is very much the case here.
>>>
>>> We do have boards where the SFP is connected to a real PHY, where the
>>> real PHY offers a RJ45 copper socket and a fiber interface,
>>> automatically switching between the two.  In this case, we do not
>>> use phylink to represent the link between the PHY and the SFP cage,
>>> but instead the PHY binds directly to the SFP cage.
>>>
>>
>> It sounds like the setup you're describing has the PHY being smarter and
>> doing more of the SFP module handling internally. In our setup, the
>> situation is something like this:
>>
>> Xilinx MAC		I2C	GPIO
>> |
>> |GMII			|	|
>> |			|	|
>> Xilinx PHY		|	|
>> |			|	|
>> |1000BaseX		|	|
>> |			|	|
>> SFP -----------------------------
> 
> That is very similar, except the Marvell 88x3310 uses a 10GBASE-R
> protocol to a SFP+ module, but can be switched to either SGMII or
> 1000BASE-X mode (neither of which we currently support, but work is
> in progress, if it turns out that these boards with strong pullups
> can work with SFP modules.)
> 
> With the 88x3310, I have a couple of patches that "bolt on" to the
> PHY driver, so we end up with this setup from the DT, kernel and
> hardware point of view:
> 
>                  ,-----> Copper RJ45
>    MAC -----> PHY
>                  `-----> SFP
> 
> Hence, the PHY driver is responsible for registering itself as an
> "upstream" of the SFP cage without involving phylink - phylink gets
> used for the MAC <-> PHY part of the connection.

Looking at the patches you have on your branch, it looks like a similar
sort of approach could work in our case. One difference however, is that
the Marvell driver has its own internal PHY driver that knows about the
SFP cage attachment, whereas axienet doesnt (right now we are using the
generic PHY driver). Would it make sense for that SFP support to be
added into the generic PHY layer?

> 
> There's an awkward problem though: the PHY driver doesn't really have
> much clue whether the network interface is up or down, which SFP
> really needs to know so it can control whether the SFP module's laser
> is emitting or not.  One of the patches tweaks the phylink code to
> pass this information over to the SFP cage, around phylib, but the
> proper solution would be for phylib to propagate that information to
> the phylib driver, so that it can in turn pass that on to the SFP cage.
> 
> However, there's a slightly bigger problem looming here, which is that
> phylib and the network layers in general do _not_ support having two
> PHYs actively bound to one network interface, and without radically
> reworking phylib and how phylib is bolted into the network layer, that
> is not easy to get around.>
>> So in this case the Xilinx PHY is just really doing PCS/PMA, etc.
>> conversions. The I2C and GPIO lines for the SFP socket are routed back
>> to the host separately and the Xilinx PHY has no interaction with them
>> (other than that I believe the LOS signal from the SFP socket is
>> connected into the PHY to provide some link status indication back to it).
> 
> So, very similar situation as on the Macchiatobin with the 88x3310
> PHYs.
> 
>> In this setup, phylink is basically allowing us to communicate with the
>> SFP module over I2C and manage the LOS, TX enable, etc. control lines
>> properly, but the Xilinx PHY does need to be initialized as well for the
>> actual link traffic to pass through.
> 
> I think what you're missing is that the design is a layered one.
> All the SFP cage stuff is interfaced through the sfp layer, and is
> made accessible independently via the sfp-bus layer (which is needed
> to avoid sfp being a hard dependency for the MAC driver - especially
> important when we have SoCs such as Armada 8040 where one hardware
> module provides multiple network ports.)
> 
> phylink provides a mechanism to separate PHYs from the MAC driver
> such that we can hot-plug PHYs (necessary for the PHYs on SFP modules),
> and deal with dynamically reconfiguring the MAC's hardware interface
> mode according to what the module supports.  It isn't intended to
> always be closely bound to the SFP cage side.
> 
> One of the reasons we have this design is because the early boards I
> had access to when designing this setup were direct MAC to SFP cage
> setups - there was no intermediate PHY.  Then came the Macchiatobin
> board which does have a PHY, which brings with it additional
> complexities, but various hardware problems have stood in the way of
> having SFP modules in the 10G slots.
> 
>> In our case the controller is supporting 1000BaseX only and is mainly
>> intended for fiber modules. We do want to be able to get copper modules
>> to work - obviously only ones that are set up for 1000BaseX mode are
>> possible.
> 
> So, what I say below applies:
> 
>>> If the former, then I'm pretty certain you're going about it the wrong
>>> way - as I've said before, there is nothing in the EEPROM that
>>> indicates definitively what format the control word is (and therefore
>>> whether it is SGMII or 1000base-X.)
>>>
>>> Some network controllers may be able to tell the difference, but that
>>> is not true of all controllers.
>>>
>>> The only way I can see to support such modules would be to have a table
>>> of quirks to set the interface mode accordingly, and not try this "lets
>>> pick one, try to validate it with the network controller, otherwise try
>>> the other."
>>>
>>> In any case, the format of the connection between the SFP module and
>>> the network controller isn't one that should appear in the ethtool link
>>> modes - I view what you've done there as a hack rather than proper
>>> design.
> 
> I do have the beginnings of a quirk system for the sfp-bus layer,
> since I've been conversing with someone with a GPON module that
> does appear to follow the SFP MSA, in particular with regard to the
> time it takes the module to start responding on I2C, and in regard
> of the speeds it actually supports (basically, the EEPROM is
> misleading.)  So, that should be useful for you as well.
> 
> http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=phy
> 
> is my playground of patches for SFP, which are in various stages of
> maturity, some which have been posted for inclusion (and merged)
> others that have been waiting some time.
> 

-- 
Robert Hancock
Senior Software Developer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
