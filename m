Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6DB1D3F76
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgENVAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:00:40 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54236 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgENVAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:00:40 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04EL0XZZ084868;
        Thu, 14 May 2020 16:00:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589490033;
        bh=c3ng3n5AaYJdWpIwj65f56Oxw0Dl7RViG5iPPiEH66Q=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=BUmWCscolmuRhy/3BjEc92xI23rDjEZKho6zBds1DsTqeHXIMtIhrcwUMmo/X3BMz
         bRkpWM+1SrnrxDCC6jlJA9vlOjxwBDRpmebIAIypW3v4GXaxK4ofRF3A5+6eAqoneY
         3h8K2T1w8ZX2IdiYdwfktwjWgvjuUUt6E6NjdnyU=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04EL0XHL093253
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 16:00:33 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 16:00:33 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 16:00:33 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EL0WZw082129;
        Thu, 14 May 2020 16:00:32 -0500
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dp83822: Add TI dp83822
 phy
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
References: <20200514173055.15013-1-dmurphy@ti.com>
 <20200514173055.15013-2-dmurphy@ti.com> <20200514183912.GW499265@lunn.ch>
 <2f03f066-38d0-a7c7-956d-e14356ca53b3@ti.com>
 <20200514205028.GA499265@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <b79f8df0-add8-4ebb-1784-36cc6c50b285@ti.com>
Date:   Thu, 14 May 2020 15:51:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514205028.GA499265@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/14/20 3:50 PM, Andrew Lunn wrote:
>>> Hi Dan
>>>
>>> You say 10/100 Mbps Ethernet PHY, but then list RGMII?
>> Copied from the data sheet.
> O.K. So maybe it can connect over RGMII, but then only run 100Mbps
> over it, rather than 1G.
Yes.  This is not a 1Gbps PHY.  Max is 100Mbps.
>
>> The LED_1 pin can be strapped to be an input to the chip for signal loss
>> detection.  This is an optional feature of the PHY.
>>
>> This property defines the polarity for the 822 LED_1/GPIO input pin.
>>
>> The LOS is not required to be connected to the PHY.  If the preferred method
>> is to use the SFP framework and Processor GPIOs then I can remove this from
>> the patch set.
>>
>> And if a user would like to use the feature then they can add it.
> Well, both options are supported by the hardware. So i'm wondering if
> we need to support both. So one property indicating the LOS is
> actually connected to the PHY and a second indicating the polarity?

Why would we need 2?  The SFP core would need to know that the LOS is 
connected to the PHY.

The PHY is strapped to configure the LED_1 as a GPIO input.  I am not 
seeing a register that we can force this configuration.

Data sheet says

Note: To enable 100Base-FX Signal Detection on LED_1 (pin #24), strap 
SD_EN = '1'

So we can read the straps to see if the PHY is connected as the LOS 
input and set the polarity.  But if we are in fiber mode and that pin is 
not strapped for LOS then this setting takes no affect on the PHY.  So 
even reading the straps just allows us to bypass the polarity write.

Dan

>
> 	 Andrew
