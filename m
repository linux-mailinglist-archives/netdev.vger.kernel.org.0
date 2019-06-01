Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13308318C0
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfFAAR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:17:56 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:41518 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfFAAR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:17:56 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x510HqdM000782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 18:17:52 -0600 (CST)
Received: from eng1n65.eng.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x510Hp5v023076
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 31 May 2019 18:17:51 -0600
Subject: Re: [PATCH net-next] net: phy: phylink: add fallback from SGMII to
 1000BaseX
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
 <20190531201826.2qo57l2phommgpm2@shell.armlinux.org.uk>
From:   Robert Hancock <hancock@sedsystems.ca>
Openpgp: preference=signencrypt
Autocrypt: addr=hancock@sedsystems.ca; prefer-encrypt=mutual; keydata=
 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
Organization: SED Systems
Message-ID: <4b7bf6b4-dbc8-d3d0-4b31-789fcdb8e6b7@sedsystems.ca>
Date:   Fri, 31 May 2019 18:17:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190531201826.2qo57l2phommgpm2@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-31 2:18 p.m., Russell King - ARM Linux admin wrote:
> On Fri, May 31, 2019 at 01:18:04PM -0600, Robert Hancock wrote:
>> Some copper SFP modules support both SGMII and 1000BaseX,
> 
> The situation is way worse than that.  Some copper SFP modules are
> programmed to support SGMII only.  Others are programmed to support
> 1000baseX only.  There is no way to tell from the EEPROM how they
> are configured, and there is no way to auto-probe the format of the
> control word (which is the difference between the two.)
> 
>> but some
>> drivers/devices only support the 1000BaseX mode. Currently SGMII mode is
>> always being selected as the desired mode for such modules, and this
>> fails if the controller doesn't support SGMII. Add a fallback for this
>> case by trying 1000BaseX instead if the controller rejects SGMII mode.
> 
> So, what happens when a controller supports both SGMII and 1000base-X
> modes (such as the Marvell devices) but the module is setup for
> 1000base-X mode?

My description is likely a bit incorrect.. rather than supporting both
1000BaseX and SGMII, a given module can support either 1000BaseX or
SGMII, but likely only one at a time (at least without magic
vendor-specific commands to switch modes).

The logic in sfp_select_interface always selects SGMII mode for copper
modules, which is the preferred mode of operation since 100 and 10 Mbps
modes won't work with 1000BaseX. If the controller and module actually
support SGMII, everything is fine. If the controller doesn't support
SGMII, it should fail validation and the link won't come up. If the
module doesn't support SGMII, it may try to come up but the link likely
won't work properly.

Our device is mainly intended for fiber modules, which is why 1000BaseX
is being used. The variant of fiber modules we are using (for example,
Finisar FCLF8520P2BTL) are set up for 1000BaseX, and seem like they are
kind of a hack to allow using copper on devices which only support
1000BaseX mode (in fact that particular one is extra hacky since you
have to disable 1000BaseX autonegotiation on the host side). This patch
is basically intended to allow that particular case to work.

It's kind of a dumb situation, but in the absence of a way to tell from
the EEPROM content what mode the module is actually in (and you would
likely know better than I if there was), it seems like the best we can do.

> 
>>
>> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
>> ---
>>  drivers/net/phy/phylink.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> index 68d0a89..4fd72c2 100644
>> --- a/drivers/net/phy/phylink.c
>> +++ b/drivers/net/phy/phylink.c
>> @@ -1626,6 +1626,7 @@ static int phylink_sfp_module_insert(void *upstream,
>>  {
>>  	struct phylink *pl = upstream;
>>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
>> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(orig_support) = { 0, };
>>  	struct phylink_link_state config;
>>  	phy_interface_t iface;
>>  	int ret = 0;
>> @@ -1635,6 +1636,7 @@ static int phylink_sfp_module_insert(void *upstream,
>>  	ASSERT_RTNL();
>>  
>>  	sfp_parse_support(pl->sfp_bus, id, support);
>> +	linkmode_copy(orig_support, support);
>>  	port = sfp_parse_port(pl->sfp_bus, id, support);
>>  
>>  	memset(&config, 0, sizeof(config));
>> @@ -1663,6 +1665,25 @@ static int phylink_sfp_module_insert(void *upstream,
>>  
>>  	config.interface = iface;
>>  	ret = phylink_validate(pl, support, &config);
>> +
>> +	if (ret && iface == PHY_INTERFACE_MODE_SGMII &&
>> +	    phylink_test(orig_support, 1000baseX_Full)) {
>> +		/* Copper modules may select SGMII but the interface may not
>> +		 * support that mode, try 1000BaseX if supported.
>> +		 */
> 
> Here, you are talking about what the module itself supports, but this
> code is determining what it should do based on what the _network
> controller_ supports.

orig_support is from just after sfp_parse_support is called, so it's
reflecting everything we think the module supports. The "net: sfp: Set
1000BaseX support flag for 1000BaseT modules" patch adds 1000BaseX to
that list for copper modules, which allows this code to detect that
1000BaseX might be a possibility.

> 
> If the SFP module is programmed for SGMII, and the network controller
> supports 1000base-X, then it isn't going to work very well - the
> sender of the control word will be sending one format, and the
> receiver will be interpreting the bits wrongly.

Agreed, but as I mentioned above, it doesn't appear that there's any
sensible way to avoid that. Without this patch, both SGMII and 1000BaseX
copper modules would fail in a 1000BaseX-only controller. With this
patch in place, the 1000BaseX module will work.

-- 
Robert Hancock
Senior Software Developer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
