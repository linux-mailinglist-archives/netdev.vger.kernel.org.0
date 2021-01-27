Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E49C305B9F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343628AbhA0Mio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:38:44 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:48176 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343561AbhA0MgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 07:36:03 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10RCZ3JC128270;
        Wed, 27 Jan 2021 06:35:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1611750903;
        bh=qabvSZkOO7Bgd0+5fJBGInSldiOFFnkGAcK+2VB0AXg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=KBDNLjPwRKrLZU1e9U7O8mRhfRZ7omTjyeb5ZbYE/2aHhetjihZBnFLc4MFMGqFlt
         yneDLKSJeuFuk6/oeVOarGJOTHWFtg9HQhxpv6HtughMAERiEDgPP3aXS0udrc00tq
         e96cy5dqPr6QjB4KMZoa1czK8tUYoO72dOZAcb4U=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10RCZ2t1079260
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 Jan 2021 06:35:03 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 27
 Jan 2021 06:35:02 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 27 Jan 2021 06:35:02 -0600
Received: from [10.250.235.36] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10RCYwqO016143;
        Wed, 27 Jan 2021 06:34:59 -0600
Subject: Re: [PATCH v12 2/4] phy: Add ethernet serdes configuration option
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
 <20210107091924.1569575-3-steen.hegelund@microchip.com>
 <92a943cc-b332-4ac6-42a8-bb3cdae13bc0@ti.com>
 <f35e3c33f011b6aabd96d3b6de3750bf3d04b699.camel@microchip.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <70aa5716-bd14-0a0a-26bc-d3dfa23de47e@ti.com>
Date:   Wed, 27 Jan 2021 18:04:53 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f35e3c33f011b6aabd96d3b6de3750bf3d04b699.camel@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

On 15/01/21 9:44 pm, Steen Hegelund wrote:
> Hi Kishon,
> 
> On Fri, 2021-01-15 at 21:22 +0530, Kishon Vijay Abraham I wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>>
>> Hi,
>>
>> On 07/01/21 2:49 pm, Steen Hegelund wrote:
>>> Provide a new ethernet phy configuration structure, that
>>> allow PHYs used for ethernet to be configured with
>>> speed, media type and clock information.
>>>
>>> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
>>> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>> ---
>>>  include/linux/phy/phy-ethernet-serdes.h | 30
>>> +++++++++++++++++++++++++
>>>  include/linux/phy/phy.h                 |  4 ++++
>>>  2 files changed, 34 insertions(+)
>>>  create mode 100644 include/linux/phy/phy-ethernet-serdes.h
>>>
>>> diff --git a/include/linux/phy/phy-ethernet-serdes.h
>>> b/include/linux/phy/phy-ethernet-serdes.h
>>> new file mode 100644
>>> index 000000000000..d2462fadf179
>>> --- /dev/null
>>> +++ b/include/linux/phy/phy-ethernet-serdes.h
>>> @@ -0,0 +1,30 @@
>>> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
>>> +/*
>>> + * Microchip Sparx5 Ethernet SerDes driver
>>> + *
>>> + * Copyright (c) 2020 Microschip Inc
>>> + */
>>> +#ifndef __PHY_ETHERNET_SERDES_H_
>>> +#define __PHY_ETHERNET_SERDES_H_
>>> +
>>> +#include <linux/types.h>
>>> +
>>> +enum ethernet_media_type {
>>> +     ETH_MEDIA_DEFAULT,
>>> +     ETH_MEDIA_SR,
>>> +     ETH_MEDIA_DAC,
>>> +};
>>
>> I'm not familiar with Ethernet. Are these generic media types? what
>> does
>> SR or DAC refer to? 
> 
> The SR stands for Short Reach and is a fiber type connection used by
> SFPs.  There also other "reach" variants.
> 
> DAC stands for Direct Attach Copper and is a type of cable that plugs
> into an SFP cage and provides information back to the user via its
> EEPROM regarding supported speed and capabilities in general.  These
> typically supports speed of 5G or more.
> 
> The SFP/Phylink is the "out-of-band" method that provides the type of
> connection: speed and media type that allows the client to adapt the
> SerDes configuration to the type of media selected by the user.
> 
>> Are there other media types? What is the out-of-band
>> mechanism by which the controller gets the media type? Why was this
>> not
>> required for other existing Ethernet SERDES? 
> 
> This is probably a matter of the interface speed are now getting higher
> and the amount of configuration needed for the SerDes have increased,
> at the same time as this is not being a static setup, because the user
> an plug and unplug media to the SFP cage.
> 
>> Are you aware of any other
>> vendors who might require this?
> 
> I suspect that going forward it will become more widespread, at least
> we have more chips in the pipeline that need this SerDes for high speed
> connectivity.

For this case I would recommend to add new API, something like
phy_set_media(). Configure() and Validate() is more for probing
something that is supported by SERDES and changing the parameters. But
in this case, I'd think the media type is determined by the cable that
is connected and cannot be changed.

Thanks
Kishon
