Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6E6287B89
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgJHSSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 14:18:18 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:50578 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJHSSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 14:18:17 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 098IIAaY059566;
        Thu, 8 Oct 2020 13:18:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602181090;
        bh=OZ4CI6uU94nRKdZAQZi5RdPMEtud/Gsh2orNwUmssVI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=gAp6umqLQU5C4uX3HgJyCWpgp44fO1M1k018erkc+OZM7Yc28HxljX7uaH3gtaVsQ
         +gZEg/4CV9X5T60nc+QxSa7hQzdv1zMljVTNCOYufUOUtAZ9xVxmkqmulme9xmJ5tE
         MpLzzG5suqewHZ/Z0xqyyrdL43hRRxZo2PS2e48k=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 098IIAuW101541
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 8 Oct 2020 13:18:10 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 8 Oct
 2020 13:18:10 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 8 Oct 2020 13:18:09 -0500
Received: from [10.250.39.105] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 098II9xV015780;
        Thu, 8 Oct 2020 13:18:09 -0500
Subject: Re: [PATCH net-next 1/2] dt-bindings: dp83td510: Add binding for
 DP83TD510 Ethernet PHY
To:     Florian Fainelli <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201008162347.5290-1-dmurphy@ti.com>
 <20201008162347.5290-2-dmurphy@ti.com>
 <b704d919-b665-04e7-39bf-fadd5bc35ecf@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <cb44ea1f-4c7a-98c6-6206-526169d8f24b@ti.com>
Date:   Thu, 8 Oct 2020 13:18:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b704d919-b665-04e7-39bf-fadd5bc35ecf@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

Thanks for the review

On 10/8/20 12:11 PM, Florian Fainelli wrote:
>
>
> On 10/8/2020 9:23 AM, Dan Murphy wrote:
>> The DP83TD510 is a 10M single twisted pair Ethernet PHY
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   .../devicetree/bindings/net/ti,dp83td510.yaml | 70 +++++++++++++++++++
>>   1 file changed, 70 insertions(+)
>>   create mode 100644 
>> Documentation/devicetree/bindings/net/ti,dp83td510.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,dp83td510.yaml 
>> b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
>> new file mode 100644
>> index 000000000000..0f0eac77a11a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
>> @@ -0,0 +1,70 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +# Copyright (C) 2020 Texas Instruments Incorporated
>> +%YAML 1.2
>> +---
>> +$id: "http://devicetree.org/schemas/net/ti,dp83td510.yaml#"
>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>> +
>> +title: TI DP83TD510 ethernet PHY
>> +
>> +allOf:
>> +  - $ref: "ethernet-controller.yaml#"
>> +
>> +maintainers:
>> +  - Dan Murphy <dmurphy@ti.com>
>> +
>> +description: |
>> +  The PHY is an twisted pair 10Mbps Ethernet PHY that support MII, 
>> RMII and
>> +  RGMII interfaces.
>> +
>> +  Specifications about the Ethernet PHY can be found at:
>> +    http://www.ti.com/lit/ds/symlink/dp83td510e.pdf
>> +
>> +properties:
>> +  reg:
>> +    maxItems: 1
>> +
>> +  tx-fifo-depth:
>> +    description: |
>> +       Transmitt FIFO depth for RMII mode.  The PHY only exposes 4 
>> nibble
>> +       depths. The valid nibble depths are 4, 5, 6 and 8.
>> +    default: 5
>> +
>> +  rx-internal-delay-ps:
>> +    description: |
>> +       Setting this property to a non-zero number sets the RX 
>> internal delay
>> +       for the PHY.  The internal delay for the PHY is fixed to 30ns 
>> relative
>> +       to receive data.
>> +
>> +  tx-internal-delay-ps:
>> +    description: |
>> +       Setting this property to a non-zero number sets the TX 
>> internal delay
>> +       for the PHY.  The internal delay for the PHY has a range of 
>> -4 to 4ns
>> +       relative to transmit data.
>
> Those two properties are already defined as part of 
> Documentation/devicetree/bindings/net/ethernet-phy.yaml, so you can 
> reference that binding, too.

OK I referenced the ethernet-controller.yaml for the delay. I am 
wondering if we should add rx/tx-fifo-depth to the ethernet-phy.yaml as 
well. That way PHYs only have to reference ethernet-phy.yaml.

Or maybe remove the internal-delay from the ethernet-phy.yaml and 
reference the ethernet-controller.yaml in the ethernet-phy.yaml so we 
don't have to maintain duplicate properties

>
>> +
>> +  ti,master-slave-mode:
>> +    $ref: /schemas/types.yaml#definitions/uint32
>> +    default: 0
>> +    description: |
>> +      Force the PHY to be configured to a specific mode.
>> +      Force Auto Negotiation - 0
>> +      Force Master mode at 1v p2p - 1
>> +      Force Master mode at 2.4v p2p - 2
>> +      Force Slave mode at 1v p2p - 3
>> +      Force Slave mode at 2.4v p2p - 4
>
> If you accept different values you should be indicating which values 
> are supported with an enumeration.

Ah yes forgot the min/max

