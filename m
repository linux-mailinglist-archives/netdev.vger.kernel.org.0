Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C6E318D1
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfFAAdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:33:37 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:48559 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfFAAdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:33:37 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x510XX2J012828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 18:33:33 -0600 (CST)
Received: from eng1n65.eng.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x510XXwb047181
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 31 May 2019 18:33:33 -0600
Subject: Re: [PATCH net-next] net: phy: phylink: support using device PHY in
 fixed or 802.3z mode
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
 <20190531203131.skdlic6ub2esyw3o@shell.armlinux.org.uk>
From:   Robert Hancock <hancock@sedsystems.ca>
Openpgp: preference=signencrypt
Autocrypt: addr=hancock@sedsystems.ca; prefer-encrypt=mutual; keydata=
 mQINBFfazlkBEADG7wwkexPSLcsG1Rr+tRaqlrITNQiwdXTZG0elskoQeqS0FyOR4BrKTU8c
 FAX1R512lhHgEZHV02l0uIWRTFBshg/8EK4qwQiS2L7Bp84H1g5c/I8fsT7c5UKBBXgZ0jAL
 ls4MJiSTubo4dSG+QcjFzNDj6pTqzschZeDZvmCWyC6O1mQ+ySrGj+Fty5dE7YXpHEtrOVkq
 Y0v3jRm51+7Sufhp7x0rLF7X/OFWcGhPzru3oWxPa4B1QmAWvEMGJRTxdSw4WvUbftJDiz2E
 VV+1ACsG23c4vlER1muLhvEmx7z3s82lXRaVkEyTXKb8X45tf0NUA9sypDhJ3XU2wmri+4JS
 JiGVGHCvrPYjjEajlhTAF2yLkWhlxCInLRVgxKBQfTV6WtBuKV/Fxua5DMuS7qUTchz7grJH
 PQmyylLs44YMH21cG6aujI2FwI90lMdZ6fPYZaaL4X8ZTbY9x53zoMTxS/uI3fUoE0aDW5hU
 vfzzgSB+JloaRhVtQNTG4BjzNEz9zK6lmrV4o9NdYLSlGScs4AtiKBxQMjIHntArHlArExNr
 so3c8er4mixubxrIg252dskjtPLNO1/QmdNTvhpGugoE6J4+pVo+fdvu7vwQGMBSwQapzieT
 mVxuyGKiWOA6hllr5mheej8D1tWzEfsFMkZR2ElkhwlRcEX0ewARAQABtCZSb2JlcnQgSGFu
 Y29jayA8aGFuY29ja0BzZWRzeXN0ZW1zLmNhPokCNwQTAQIAIQIbAwIeAQIXgAUCV9rOwQUL
 CQgHAwUVCgkICwUWAgMBAAAKCRCAQSxR8cmd98VTEADFuaeLonfIJiSBY4JQmicwe+O83FSm
 s72W0tE7k3xIFd7M6NphdbqbPSjXEX6mMjRwzBplTeBvFKu2OJWFOWCETSuQbbnpZwXFAxNJ
 wTKdoUdNY2fvX33iBRGnMBwKEGl+jEgs1kxSwpaU4HwIwso/2BxgwkF2SQixeifKxyyJ0qMq
 O+YRtPLtqIjS89cJ7z+0AprpnKeJulWik5hNTHd41mcCr+HI60SFSPWFRn0YXrngx+O1VF0Z
 gUToZVFv5goRG8y2wB3mzduXOoTGM54Z8z+xdO9ir44btMsW7Wk+EyCxzrAF0kv68T7HLWWz
 4M+Q75OCzSuf5R6Ijj7loeI4Gy1jNx0AFcSd37toIzTW8bBj+3g9YMN9SIOTKcb6FGExuI1g
 PgBgHxUEsjUL1z8bnTIz+qjYwejHbcndwzZpot0XxCOo4Ljz/LS5CMPYuHB3rVZ672qUV2Kd
 MwGtGgjwpM4+K8/6LgCe/vIA3b203QGCK4kFFpCFTUPGOBLXWbJ14AfkxT24SAeo21BiR8Ad
 SmXdnwc0/C2sEiGOAmMkFilpEgm+eAoOGvyGs+NRkSs1B2KqYdGgbrq+tZbjxdj82zvozWqT
 aajT/d59yeC4Fm3YNf0qeqcA1cJSuKV34qMkLNMQn3OlMCG7Jq/feuFLrWmJIh+G7GZOmG4L
 bahC07kCDQRX2s5ZARAAvXYOsI4sCJrreit3wRhSoC/AIm/hNmQMr+zcsHpR9BEmgmA9FxjR
 357WFjYkX6mM+FS4Y2+D+t8PC1HiUXPnvS5FL/WHpXgpn8O8MQYFWd0gWV7xefPv5cC3oHS8
 Q94r7esRt7iUGzMi/NqHXStBwLDdzY2+DOX2jJpqW+xvo9Kw3WdYHTwxTWWvB5earh2I0JCY
 LU3JLoMr/h42TYRPdHzhVZwRmGeKIcbOwc6fE1UuEjq+AF1316mhRs+boSRog140RgHIXRCK
 +LLyPv+jzpm11IC5LvwjT5o71axkDpaRM/MRiXHEfG6OTooQFX4PXleSy7ZpBmZ4ekyQ17P+
 /CV64wM+IKuVgnbgrYXBB9H3+0etghth/CNf1QRTukPtY56g2BHudDSxfxeoRtuyBUgtT4gq
 haF1KObvnliy65PVG88EMKlC5TJ2bYdh8n49YxkIk1miQ4gfA8WgOoHjBLGT5lxz+7+MOiF5
 4g03e0so8tkoJgHFe1DGCayFf8xrFVSPzaxk6CY9f2CuxsZokc7CDAvZrfOqQt8Z4SofSC8z
 KnJ1I1hBnlcoHDKMi3KabDBi1dHzKm9ifNBkGNP8ux5yAjL/Z6C1yJ+Q28hNiAddX7dArOKd
 h1L4/QwjER2g3muK6IKfoP7PRjL5S9dbH0q+sbzOJvUQq0HO6apmu78AEQEAAYkCHwQYAQIA
 CQUCV9rOWQIbDAAKCRCAQSxR8cmd90K9D/4tV1ChjDXWT9XRTqvfNauz7KfsmOFpyN5LtyLH
 JqtiJeBfIDALF8Wz/xCyJRmYFegRLT6DB6j4BUwAUSTFAqYN+ohFEg8+BdUZbe2LCpV//iym
 cQW29De9wWpzPyQvM9iEvCG4tc/pnRubk7cal/f3T3oH2RTrpwDdpdi4QACWxqsVeEnd02hf
 ji6tKFBWVU4k5TQ9I0OFzrkEegQFUE91aY/5AVk5yV8xECzUdjvij2HKdcARbaFfhziwpvL6
 uy1RdP+LGeq+lUbkMdQXVf0QArnlHkLVK+j1wPYyjWfk9YGLuznvw8VqHhjA7G7rrgOtAmTS
 h5V9JDZ9nRbLcak7cndceDAFHwWiwGy9s40cW1DgTWJdxUGAMlHT0/HLGVWmmDCqJFPmJepU
 brjY1ozW5o1NzTvT7mlVtSyct+2h3hfHH6rhEMcSEm9fhe/+g4GBeHwwlpMtdXLNgKARZmZF
 W3s/L229E/ooP/4TtgAS6eeA/HU1U9DidN5SlON3E/TTJ0YKnKm3CNddQLYm6gUXMagytE+O
 oUTM4rxZQ3xuR595XxhIBUW/YzP/yQsL7+67nTDiHq+toRl20ATEtOZQzYLG0/I9TbodwVCu
 Tf86Ob96JU8nptd2WMUtzV+L+zKnd/MIeaDzISB1xr1TlKjMAc6dj2WvBfHDkqL9tpwGvQ==
Organization: SED Systems
Message-ID: <1cb5994f-cb70-e2ec-7f72-2e7828813150@sedsystems.ca>
Date:   Fri, 31 May 2019 18:33:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531203131.skdlic6ub2esyw3o@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-31 2:31 p.m., Russell King - ARM Linux admin wrote:
> On Fri, May 31, 2019 at 01:18:05PM -0600, Robert Hancock wrote:
>> The Xilinx AXI Ethernet controller supports SFP modules in 1000BaseX
>> mode in a somewhat unusual manner: it still exposes a PHY device which
>> needs some PHY-level initialization for the PCS/PMA layer to work properly,
>> and which provides some link status/control information.
>>
>> In this case, we want to use the phylink layer to support proper
>> communication with the SFP module, but in most other respects we want to
>> use the PHY attached to the controller.
>>
>> Currently the phylink driver does not initialize or use a controller PHY
>> even if it exists for fixed-link or 802.3z PHY modes, and doesn't
>> support SFP module attachment in those modes.
> 
> Sorry, I'm having a hard time following this description.  Please draw
> an ASCII diagram of the setup you have - a picture is worth 1000 words,
> and I think that is very much the case here.
>
> We do have boards where the SFP is connected to a real PHY, where the
> real PHY offers a RJ45 copper socket and a fiber interface,
> automatically switching between the two.  In this case, we do not
> use phylink to represent the link between the PHY and the SFP cage,
> but instead the PHY binds directly to the SFP cage.
>

It sounds like the setup you're describing has the PHY being smarter and
doing more of the SFP module handling internally. In our setup, the
situation is something like this:

Xilinx MAC		I2C	GPIO
|
|GMII			|	|
|			|	|
Xilinx PHY		|	|
|			|	|
|1000BaseX		|	|
|			|	|
SFP -----------------------------

So in this case the Xilinx PHY is just really doing PCS/PMA, etc.
conversions. The I2C and GPIO lines for the SFP socket are routed back
to the host separately and the Xilinx PHY has no interaction with them
(other than that I believe the LOS signal from the SFP socket is
connected into the PHY to provide some link status indication back to it).

In this setup, phylink is basically allowing us to communicate with the
SFP module over I2C and manage the LOS, TX enable, etc. control lines
properly, but the Xilinx PHY does need to be initialized as well for the
actual link traffic to pass through.

>> This change allows it to
>> utilize a controller PHY if it is defined, and allows SFP module
>> attachment/initialization but does not connect the PHY device to the
>> controller (to allow the controller PHY to be used for link state
>> tracking).
>>
>> Fully supporting this setup would probably require initializing and
>> tracking the state of both PHYs, which is a much more complex change and
>> doesn't appear to be required for this use case.
>>
>> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
>> ---
>>  drivers/net/phy/phylink.c | 29 +++++++++++++++++++----------
>>  1 file changed, 19 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> index 4fd72c2..9362aca 100644
>> --- a/drivers/net/phy/phylink.c
>> +++ b/drivers/net/phy/phylink.c
>> @@ -819,12 +819,6 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
>>  	struct phy_device *phy_dev;
>>  	int ret;
>>  
>> -	/* Fixed links and 802.3z are handled without needing a PHY */
>> -	if (pl->link_an_mode == MLO_AN_FIXED ||
>> -	    (pl->link_an_mode == MLO_AN_INBAND &&
>> -	     phy_interface_mode_is_8023z(pl->link_interface)))
>> -		return 0;
>> -
> 
> This looks to me like it will break existing users.
> 
>>  	phy_node = of_parse_phandle(dn, "phy-handle", 0);
>>  	if (!phy_node)
>>  		phy_node = of_parse_phandle(dn, "phy", 0);
>> @@ -1697,9 +1691,6 @@ static int phylink_sfp_module_insert(void *upstream,
>>  		    phy_modes(config.interface),
>>  		    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
>>  
>> -	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
>> -		return -EINVAL;
>> -
>>  	changed = !bitmap_equal(pl->supported, support,
>>  				__ETHTOOL_LINK_MODE_MASK_NBITS);
>>  	if (changed) {
>> @@ -1751,12 +1742,30 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
>>  {
>>  	struct phylink *pl = upstream;
>>  
>> +	/* In fixed mode, or in in-band mode with 802.3z PHY interface mode,
>> +	 *  ignore the SFP PHY and just use the PHY attached to the MAC.
>> +	 */
>> +	if (pl->link_an_mode == MLO_AN_FIXED ||
>> +	    (pl->link_an_mode == MLO_AN_INBAND &&
>> +	      phy_interface_mode_is_8023z(pl->link_config.interface)))
>> +		return 0;
>> +
>>  	return __phylink_connect_phy(upstream, phy, pl->link_config.interface);
>>  }
>>  
>>  static void phylink_sfp_disconnect_phy(void *upstream)
>>  {
>> -	phylink_disconnect_phy(upstream);
>> +	struct phylink *pl = upstream;
>> +
>> +	/* In fixed mode, or in in-band mode with 802.3z PHY interface mode,
>> +	 * ignore the SFP PHY and just use the PHY attached to the MAC.
>> +	 */
>> +	if (pl->link_an_mode == MLO_AN_FIXED ||
>> +	    (pl->link_an_mode == MLO_AN_INBAND &&
>> +	      phy_interface_mode_is_8023z(pl->link_config.interface)))
>> +		return;
> 
> Fixed link mode is mutually exclusive with there being a PHY present.
> Please see Documentation/devicetree/bindings/net/fixed-link.txt
> 
> Fixed links are not used to fix a declared PHY to a specific mode.

I agree it would likely make sense to not include fixed mode in this case.

> 
>> +
>> +	phylink_disconnect_phy(pl);
>>  }
>>  
>>  static const struct sfp_upstream_ops sfp_phylink_ops = {
> 
> Overall, I think you need to better describe what your setup is, and
> what you are trying to achieve:
> 
> * Are you merely trying to support copper SFP modules where the PHY
>   defaults to 1000base-X mode rather than SGMII?
> * Are you trying to support a network controller that doesn't support
>   SGMII mode?

In our case the controller is supporting 1000BaseX only and is mainly
intended for fiber modules. We do want to be able to get copper modules
to work - obviously only ones that are set up for 1000BaseX mode are
possible.

> 
> If the former, then I'm pretty certain you're going about it the wrong
> way - as I've said before, there is nothing in the EEPROM that
> indicates definitively what format the control word is (and therefore
> whether it is SGMII or 1000base-X.)
> 
> Some network controllers may be able to tell the difference, but that
> is not true of all controllers.
> 
> The only way I can see to support such modules would be to have a table
> of quirks to set the interface mode accordingly, and not try this "lets
> pick one, try to validate it with the network controller, otherwise try
> the other."
> 
> In any case, the format of the connection between the SFP module and
> the network controller isn't one that should appear in the ethtool link
> modes - I view what you've done there as a hack rather than proper
> design.
> 
> If, on the other hand it is the latter, what you do you expect to
> happen if you plug a copper SFP module that only supports SGMII into
> a network controller that only supports 1000baseX ?  The PHY on some
> of these modules won't pass data unless the SGMII handshake with the
> network controller completes, which it may or may not do depending on
> the 1000baseX implementation - but the network controller won't
> interpret the bits correctly, and certainly won't be able to deal
> with it when the link switches to 100M or 10M mode, which it will do
> depending on the results of the copper side negotiation.
> 

-- 
Robert Hancock
Senior Software Developer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
