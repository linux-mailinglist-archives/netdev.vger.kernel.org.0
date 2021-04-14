Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4323035F44F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 14:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351017AbhDNMy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 08:54:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43116 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347893AbhDNMyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 08:54:17 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13ECrPse019753;
        Wed, 14 Apr 2021 07:53:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618404805;
        bh=oirPo/EsDII0H0wpLt+7P4CG1KGd+DxoUWbHd1hnL7k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=UKxa+T3vhnZmmhiJHXkh5+qGHdkxP1xM7OOV/veTJiY3Dj/RAvKGCGonvi2BfT4n1
         nvr1jA88uKx+nNn2fFaLtiCoJaMmLo5pmHa6y0+9qOJPQy3fZT13zTv10SryvxHBug
         RUupir4TkBgpl3icdq07CBAqxqCWUjnM1GqGq37A=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13ECrPYK044091
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Apr 2021 07:53:25 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 14
 Apr 2021 07:53:24 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 14 Apr 2021 07:53:25 -0500
Received: from [172.24.145.148] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13ECrKdA092197;
        Wed, 14 Apr 2021 07:53:21 -0500
Subject: Re: [PATCH 1/4] dt-bindings: phy: Add binding for TI TCAN104x CAN
 transceivers
To:     Rob Herring <robh@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>
References: <20210409134056.18740-1-a-govindraju@ti.com>
 <20210409134056.18740-2-a-govindraju@ti.com>
 <f9b04d93-c249-970e-3721-50eb268a948f@pengutronix.de>
 <20210412174956.GA4049952@robh.at.kernel.org>
 <20210413074106.gvgtjkofyrdp5yxt@pengutronix.de>
 <CAL_Jsq+yEQGuZYWhsQ-we36_Xi5X94YJ23oFe-T6h4U4X6iUhg@mail.gmail.com>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <9350f367-2c4f-1779-ec24-94066e152992@ti.com>
Date:   Wed, 14 Apr 2021 18:23:19 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+yEQGuZYWhsQ-we36_Xi5X94YJ23oFe-T6h4U4X6iUhg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 13/04/21 6:45 pm, Rob Herring wrote:
> On Tue, Apr 13, 2021 at 2:41 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>>
>> On 12.04.2021 12:49:56, Rob Herring wrote:
>>> On Mon, Apr 12, 2021 at 12:19:30PM +0200, Marc Kleine-Budde wrote:
>>>> On 4/9/21 3:40 PM, Aswath Govindraju wrote:
>>>>> Add binding documentation for TI TCAN104x CAN transceivers.
>>>>>
>>>>> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
>>>>> ---
>>>>>  .../bindings/phy/ti,tcan104x-can.yaml         | 56 +++++++++++++++++++
>>>>>  1 file changed, 56 insertions(+)
>>>>>  create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>>>>> new file mode 100644
>>>>> index 000000000000..4abfc30a97d0
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>>>>> @@ -0,0 +1,56 @@
>>>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>>>> +%YAML 1.2
>>>>> +---
>>>>> +$id: "http://devicetree.org/schemas/phy/ti,tcan104x-can.yaml#"
>>>>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>>>>> +
>>>>> +title: TCAN104x CAN TRANSCEIVER PHY
>>>>> +
>>>>> +maintainers:
>>>>> +  - Aswath Govindraju <a-govindraju@ti.com>
>>>>> +
>>>>> +properties:
>>>>> +  $nodename:
>>>>> +    pattern: "^tcan104x-phy"
>>>>> +
>>>>> +  compatible:
>>>>> +    enum:
>>>>> +      - ti,tcan1042
>>>>> +      - ti,tcan1043
>>>>
>>>> Can you create a generic standby only and a generic standby and enable transceiver?
>>>
>>> As a fallback compatible fine, but no generic binding please. A generic
>>> binding can't describe any timing requirements between the 2 GPIO as
>>> well as supplies when someone wants to add those (and they will).
>>
>> Right - that makes sense.
>>

So, I need not add any new compatible strings right because as a
fallback the existing compatible strings can be used, as there are no
timing constraints on them.

Thanks,
Aswath

>>>>> +
>>>>> +  '#phy-cells':
>>>>> +    const: 0
>>>>> +
>>>>> +  standby-gpios:
>>>>> +    description:
>>>>> +      gpio node to toggle standby signal on transceiver
>>>>> +    maxItems: 1
>>>>> +
>>>>> +  enable-gpios:
>>>>> +    description:
>>>>> +      gpio node to toggle enable signal on transceiver
>>>>> +    maxItems: 1
>>>>> +
>>>>> +  max-bitrate:
>>>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>>>> +    description:
>>>>> +      max bit rate supported in bps
>>>
>>> We already have 'max-speed' for serial devices, use that.
>>
>> There is already the neither Ethernet PHY (PHYLINK/PHYLIB) nor generic
>> PHY (GENERIC_PHY) can-transceiver binding
>> Documentation/devicetree/bindings/net/can/can-transceiver.yaml which
>> specifies max-bitrate. I don't have strong feelings whether to use
>> max-bitrate or max-speed.
> 
> Okay, max-bitrate is fine.
> 
>>
>> Speaking about Ethernet PHYs, what are to pros and cons to use the
>> generic PHY compared to the Ethernet PHY infrastructure?
> 
> For higher speed ethernet, both are used. There's the serdes phy and
> the ethernet phy with serdes phy using the generic phy binding. For
> CAN, it probably comes down to what's a better fit.
> 
> Rob
> 

