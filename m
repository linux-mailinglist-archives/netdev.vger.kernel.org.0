Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226056B1C37
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCIHY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCIHYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:24:50 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD4C5C13A;
        Wed,  8 Mar 2023 23:24:47 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3297OO41012761;
        Thu, 9 Mar 2023 01:24:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678346664;
        bh=44SxyQhWo0hD7O0RGABT3Ev3kJMjf+dOrR+1vK4J2e8=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=mQRNQOZcgn6iUuQbDkpzWnX5ldwxQBouax1ywdyGNPiYrVhLwPyUKnv6JyAVMXX6p
         IQaU9cABkkKC+cDg/Tr89PJTAEC0X3H+JRvu2Da3wsjqDGsE7DEO95dnVesGDPy0qO
         CyA6niNTanZ6RQ2jyuTMDLSGpaRTUcRtvZrVBhFA=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3297OORJ008705
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Mar 2023 01:24:24 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 9
 Mar 2023 01:24:23 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 9 Mar 2023 01:24:23 -0600
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3297OJGD125559;
        Thu, 9 Mar 2023 01:24:19 -0600
Message-ID: <e4d04ae7-c83f-79d4-7551-516e7f35c615@ti.com>
Date:   Thu, 9 Mar 2023 12:54:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <nsekhar@ti.com>, <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next v2] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Document Serdes PHY
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>
References: <20230308051835.276552-1-s-vadapalli@ti.com>
 <1ffed720-322c-fa73-1160-5fd73ce3c7c2@linaro.org>
 <7b6e8131-8e5b-88bc-69f7-b737c0c35bb6@ti.com>
 <dbbe3cd2-3329-d267-338b-8e513209ddcd@linaro.org>
 <882cdb42-3f80-048a-88a5-836c479a421f@ti.com>
 <624f5dc8-0807-e799-d66e-213aadabfc84@linaro.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <624f5dc8-0807-e799-d66e-213aadabfc84@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof,

On 09/03/23 11:51, Krzysztof Kozlowski wrote:
> On 09/03/2023 05:18, Siddharth Vadapalli wrote:
>> Hello Krzysztof,
>>
>> On 08/03/23 18:04, Krzysztof Kozlowski wrote:
>>> On 08/03/2023 09:38, Siddharth Vadapalli wrote:
>>>> Hello Krzysztof,
>>>>
>>>> On 08/03/23 14:04, Krzysztof Kozlowski wrote:
>>>>> On 08/03/2023 06:18, Siddharth Vadapalli wrote:
>>>>>> Update bindings to include Serdes PHY as an optional PHY, in addition to
>>>>>> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
>>>>>> Serdes PHY is optional. The Serdes PHY handle has to be provided only
>>>>>> when the Serdes is being configured in a Single-Link protocol. Using the
>>>>>> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
>>>>>> driver can obtain the Serdes PHY and request the Serdes to be
>>>>>> configured.
>>>>>>
>>>>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>>>>> ---
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> This patch corresponds to the Serdes PHY bindings that were missed out in
>>>>>> the series at:
>>>>>> https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
>>>>>> This was pointed out at:
>>>>>> https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/
>>>>>>
>>>>>> Changes from v1:
>>>>>> 1. Describe phys property with minItems, items and description.
>>>>>> 2. Use minItems and items in phy-names.
>>>>>> 3. Remove the description in phy-names.
>>>>>>
>>>>>> v1:
>>>>>> https://lore.kernel.org/r/20230306094750.159657-1-s-vadapalli@ti.com/
>>>>>>
>>>>>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
>>>>>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>>>> index 900063411a20..0fb48bb6a041 100644
>>>>>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>>>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>>>> @@ -126,8 +126,18 @@ properties:
>>>>>>              description: CPSW port number
>>>>>>  
>>>>>>            phys:
>>>>>> -            maxItems: 1
>>>>>> -            description: phandle on phy-gmii-sel PHY
>>>>>> +            minItems: 1
>>>>>> +            items:
>>>>>> +              - description: CPSW MAC's PHY.
>>>>>> +              - description: Serdes PHY. Serdes PHY is required only if
>>>>>> +                             the Serdes has to be configured in the
>>>>>> +                             Single-Link configuration.
>>>>>> +
>>>>>> +          phy-names:
>>>>>> +            minItems: 1
>>>>>> +            items:
>>>>>> +              - const: mac-phy
>>>>>> +              - const: serdes-phy
>>>>>
>>>>> Drop "phy" suffixes.
>>>>
>>>> The am65-cpsw driver fetches the Serdes PHY by looking for the string
>>>> "serdes-phy". Therefore, modifying the string will require changing the driver's
>>>> code as well. Please let me know if it is absolutely necessary to drop the phy
>>>> suffix. If so, I will post a new series with the changes involving dt-bindings
>>>> changes and the driver changes.
>>>
>>> Why the driver uses some properties before adding them to the binding?
>>
>> I missed adding the bindings for the Serdes PHY as a part of the series
>> mentioned in the section below the tearline of the patch. With this patch, I am
>> attempting to fix it.
>>
>>>
>>> And is it correct method of adding ABI? You add incorrect properties
>>> without documentation and then use this as an argument "driver already
>>> does it"?
>>
>> I apologize if my earlier comment appeared to justify the usage of "serdes-phy"
>> based on the driver already using it. I did not mean it in that sense. I simply
>> meant to ask if dropping "phy" suffixes was a suggestion or a rule. In that
>> context, I felt that if it was a suggestion, I would prefer retaining the names
>> with the "phy" suffixes, since the driver is already using it. Additionally, I
>> also mentioned in my earlier comment that if it is necessary to drop the "phy"
>> suffix, then I will do so and add another patch to change the string the driver
>> looks for as well.
>>
>> I shall take it that dropping "phy" suffixes is a rule/necessity. With this, I
>> will post the v3 series making this change, along with the patch to update the
>> string the driver looks for.
> 
> Drop the "phy" suffix.
> 
> It's a new binding. "phy" as suffix for "phy" is useless and for new
> bindings it should be dropped. If you submitted driver changes without
> bindings, which document the ABI, it's not good, but also not a reason
> for me for exceptions.

Thank you for clarifying. I will post the v3 series dropping the "phy" suffix
and also include the patch to change the name used in the driver to refer to the
Serdes PHY.

Regards,
Siddharth.
