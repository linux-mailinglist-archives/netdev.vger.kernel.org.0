Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EBF1D3DE4
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgENTsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:48:30 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:51950 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgENTs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:48:29 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04EJmMmb101895;
        Thu, 14 May 2020 14:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589485702;
        bh=L8yaIk6s3rQNnlVa1+GsvW8B3fjy5acHx+zekh7EIek=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kCm4gyCvWRHJIrlwnSoE2YKbDrJZGO49JyM2hiz3wTnJf+rs7EFeyvtfZwXSNQiQL
         A9faduoFhItlqvDDLBjzb2+TGhncLiPKEj3bck6QRF63FvjTDEKzs34SqasALG7oNH
         K4Vpn5LiwpkCQNi64WuerL3TB7C6zHBfY4v0rmac=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04EJmMXd123049
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 14:48:22 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 14:48:21 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 14:48:21 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EJmLPI008923;
        Thu, 14 May 2020 14:48:21 -0500
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dp83822: Add TI dp83822
 phy
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
References: <20200514173055.15013-1-dmurphy@ti.com>
 <20200514173055.15013-2-dmurphy@ti.com> <20200514183912.GW499265@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <2f03f066-38d0-a7c7-956d-e14356ca53b3@ti.com>
Date:   Thu, 14 May 2020 14:38:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514183912.GW499265@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/14/20 1:39 PM, Andrew Lunn wrote:
> On Thu, May 14, 2020 at 12:30:54PM -0500, Dan Murphy wrote:
>> Add a dt binding for the TI dp83822 ethernet phy device.
>>
>> CC: Rob Herring <robh+dt@kernel.org>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   .../devicetree/bindings/net/ti,dp83822.yaml   | 49 +++++++++++++++++++
>>   1 file changed, 49 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,dp83822.yaml b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
>> new file mode 100644
>> index 000000000000..60afd43ad3b6
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
>> @@ -0,0 +1,49 @@
>> +# SPDX-License-Identifier: (GPL-2.0+ OR BSD-2-Clause)
>> +# Copyright (C) 2020 Texas Instruments Incorporated
>> +%YAML 1.2
>> +---
>> +$id: "http://devicetree.org/schemas/net/ti,dp83822.yaml#"
>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>> +
>> +title: TI DP83822 ethernet PHY
>> +
>> +allOf:
>> +  - $ref: "ethernet-controller.yaml#"
>> +
>> +maintainers:
>> +  - Dan Murphy <dmurphy@ti.com>
>> +
>> +description: |
>> +  The DP83822 is a low-power, single-port, 10/100 Mbps Ethernet PHY. It
>> +  provides all of the physical layer functions needed to transmit and receive
>> +  data over standard, twisted-pair cables or to connect to an external,
>> +  fiber-optic transceiver. Additionally, the DP83822 provides flexibility to
>> +  connect to a MAC through a standard MII, RMII, or RGMII interface
> Hi Dan
>
> You say 10/100 Mbps Ethernet PHY, but then list RGMII?
Copied from the data sheet.
>
>> +
>> +  Specifications about the charger can be found at:
>> +    http://www.ti.com/lit/ds/symlink/dp83822i.pdf
>> +
>> +properties:
>> +  reg:
>> +    maxItems: 1
>> +
>> +  ti,signal-polarity-low:
>> +    type: boolean
>> +    description: |
>> +       DP83822 PHY in Fiber mode only.
>> +       Sets the DP83822 to detect a link drop condition when the signal goes
>> +       high.  If not set then link drop will occur when the signal goes low.
> Are we talking about the LOS line from the SFP cage? In the SFF/SFP
> binding we have:
>
> - los-gpios : GPIO phandle and a specifier of the Receiver Loss of Signal
>    Indication input gpio signal, active (signal lost) high
>
> It would be nice to have a consistent naming.

> Is it required the LOS signal is connected to the PHY? Russell King
> has some patches which allows the Marvell PHY to be used as a media
> converter. In that setting, i think the SFP signals are connected to
> GPIOs not the PHY. The SFP core can then control the transmit disable,
> module insertion detection etc. So i'm wondering if you need a
> property to indicate the LOS is not connected to the PHY?

The LED_1 pin can be strapped to be an input to the chip for signal loss 
detection.  This is an optional feature of the PHY.

This property defines the polarity for the 822 LED_1/GPIO input pin.

The LOS is not required to be connected to the PHY.  If the preferred 
method is to use the SFP framework and Processor GPIOs then I can remove 
this from the patch set.

And if a user would like to use the feature then they can add it.

Dan


>
> 	 Andrew
