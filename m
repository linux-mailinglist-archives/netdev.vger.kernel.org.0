Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBDD360559
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhDOJMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:12:51 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47648 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhDOJMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:12:47 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13F9C3QS127848;
        Thu, 15 Apr 2021 04:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618477923;
        bh=jGR561TrDqzLWL9VO6pvcCN3CbJFcTaYeFYvpbcz6N0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Z1jk2Vh/7eTOg55ohx9aljFaNhj3h4q4T2EY2S/V2NDbm16BoErnBInCT0JO0wL6/
         5S0Uh/YA/4aUqMUJzHQBad2dqXgIh8DwMDmc97bzcDdiIdq+HlmvRNSENd4P6cShZl
         07h4mzsn/LWP8wCgyBvOyTxnyAb7EVFFkFT79f5E=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13F9C31w073960
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Apr 2021 04:12:03 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 15
 Apr 2021 04:12:03 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 15 Apr 2021 04:12:03 -0500
Received: from [172.24.145.148] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13F9BwUV106092;
        Thu, 15 Apr 2021 04:11:59 -0500
Subject: Re: [PATCH v2 3/6] dt-bindings: phy: Add binding for TI TCAN104x CAN
 transceivers
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-phy@lists.infradead.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20210414140521.11463-1-a-govindraju@ti.com>
 <20210414140521.11463-4-a-govindraju@ti.com>
 <20210414153303.yig6bguue3g25yhg@pengutronix.de>
 <9a9a3b8b-f345-faae-b9bc-3961518e3d29@ti.com>
 <20210415073810.nwoi2hx57hdg4ima@pengutronix.de>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <072648d4-a747-bc5f-a525-25dd055905ee@ti.com>
Date:   Thu, 15 Apr 2021 14:41:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210415073810.nwoi2hx57hdg4ima@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 15/04/21 1:08 pm, Marc Kleine-Budde wrote:
> On 15.04.2021 11:57:20, Aswath Govindraju wrote:
>> Hi Marc,
>>
>> On 14/04/21 9:03 pm, Marc Kleine-Budde wrote:
>>> On 14.04.2021 19:35:18, Aswath Govindraju wrote:
>>>> Add binding documentation for TI TCAN104x CAN transceivers.
>>>>
>>>> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
>>>> ---
>>>>  .../bindings/phy/ti,tcan104x-can.yaml         | 56 +++++++++++++++++++
>>>>  MAINTAINERS                                   |  1 +
>>>>  2 files changed, 57 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>>>> new file mode 100644
>>>> index 000000000000..4abfc30a97d0
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>>>> @@ -0,0 +1,56 @@
>>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>>> +%YAML 1.2
>>>> +---
>>>> +$id: "http://devicetree.org/schemas/phy/ti,tcan104x-can.yaml#"
>>>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>>>> +
>>>> +title: TCAN104x CAN TRANSCEIVER PHY
>>>> +
>>>> +maintainers:
>>>> +  - Aswath Govindraju <a-govindraju@ti.com>
> 
> Can you create a maintainers entry for this file with your address?

I don't see this being done for other phy yamls in the
Documentation/devicetree/bindings/phy folder. Also,
scripts/get_maintainer.pl is giving the names of maintainers after
reading the yaml files too.

Thanks,
Aswath

> 
>>>> +
>>>> +properties:
>>>> +  $nodename:
>>>> +    pattern: "^tcan104x-phy"
>>>> +
>>>> +  compatible:
>>>> +    enum:
>>>> +      - ti,tcan1042
>>>> +      - ti,tcan1043
>>>
>>> Can you ensure that the 1042 has only the standby gpio and the 1043 has both?
>>>
>>
>> In the driver, it is the way the flags have been set for ti,tcan1042 and
>> ti,tcan1043.
> 
> I was wondering if we would enforce in the DT the 1042 has exactly one
> the standby GPIO and the 1043 has exactly the standby and the enable
> GPIO.
> 
> On the other hand the HW might have pulled one or the other pin high or
> low and only one of the pins is connected to a GPIO.
> 
>>>> +
>>>> +  '#phy-cells':
>>>> +    const: 0
>>>> +
>>>> +  standby-gpios:
>>>> +    description:
>>>> +      gpio node to toggle standby signal on transceiver
>>>> +    maxItems: 1
>>>> +
>>>> +  enable-gpios:
>>>> +    description:
>>>> +      gpio node to toggle enable signal on transceiver
>>>> +    maxItems: 1
>>>> +
>>>> +  max-bitrate:
>>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>>> +    description:
>>>> +      max bit rate supported in bps
>>>> +    minimum: 1
>>>> +
>>>> +required:
>>>> +  - compatible
>>>> +  - '#phy-cells'
>>>> +
>>>> +additionalProperties: false
>>>> +
>>>> +examples:
>>>> +  - |
>>>> +    #include <dt-bindings/gpio/gpio.h>
>>>> +
>>>> +    transceiver1: tcan104x-phy {
>>>> +      compatible = "ti,tcan1043";
>>>> +      #phy-cells = <0>;
>>>> +      max-bitrate = <5000000>;
>>>> +      standby-gpios = <&wakeup_gpio1 16 GPIO_ACTIVE_LOW>;
>>>> +      enable-gpios = <&main_gpio1 67 GPIO_ACTIVE_LOW>;
>>>
>>> AFAICS the enable gpio is active high.
>>>
>>
>> I will correct this in the respin.
> 
> Marc
> 

