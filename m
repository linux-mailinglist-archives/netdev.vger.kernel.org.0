Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE35B6B1A5D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 05:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjCIETO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 23:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCIETL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 23:19:11 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C6872B3E;
        Wed,  8 Mar 2023 20:19:10 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3294IkXM035148;
        Wed, 8 Mar 2023 22:18:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678335526;
        bh=0IbbDvAZb1mX7MDZ2lTVXUBvwZAqpL5G1lf4vpzvPlE=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=fo69kfaTxMdYkJIVJ3V4ea3AoDAvB07xxEELqE9iNxZ0KyimcbntD2jwUhzM6p/7G
         ZOnhgq4PDE7mPd0nX0orY8N6U+LtIBCr2dejgplB0A5azEc4wjazkcCuaMATKdTrzB
         0vAl8LU2JvjwYRYu04sdyVkNn+SXLTxeEZoOzHHc=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3294IjqN011723
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 8 Mar 2023 22:18:46 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 8
 Mar 2023 22:18:46 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 8 Mar 2023 22:18:45 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3294IeNo089859;
        Wed, 8 Mar 2023 22:18:41 -0600
Message-ID: <882cdb42-3f80-048a-88a5-836c479a421f@ti.com>
Date:   Thu, 9 Mar 2023 09:48:40 +0530
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
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>
References: <20230308051835.276552-1-s-vadapalli@ti.com>
 <1ffed720-322c-fa73-1160-5fd73ce3c7c2@linaro.org>
 <7b6e8131-8e5b-88bc-69f7-b737c0c35bb6@ti.com>
 <dbbe3cd2-3329-d267-338b-8e513209ddcd@linaro.org>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <dbbe3cd2-3329-d267-338b-8e513209ddcd@linaro.org>
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

On 08/03/23 18:04, Krzysztof Kozlowski wrote:
> On 08/03/2023 09:38, Siddharth Vadapalli wrote:
>> Hello Krzysztof,
>>
>> On 08/03/23 14:04, Krzysztof Kozlowski wrote:
>>> On 08/03/2023 06:18, Siddharth Vadapalli wrote:
>>>> Update bindings to include Serdes PHY as an optional PHY, in addition to
>>>> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
>>>> Serdes PHY is optional. The Serdes PHY handle has to be provided only
>>>> when the Serdes is being configured in a Single-Link protocol. Using the
>>>> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
>>>> driver can obtain the Serdes PHY and request the Serdes to be
>>>> configured.
>>>>
>>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>>>> ---
>>>>
>>>> Hello,
>>>>
>>>> This patch corresponds to the Serdes PHY bindings that were missed out in
>>>> the series at:
>>>> https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
>>>> This was pointed out at:
>>>> https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/
>>>>
>>>> Changes from v1:
>>>> 1. Describe phys property with minItems, items and description.
>>>> 2. Use minItems and items in phy-names.
>>>> 3. Remove the description in phy-names.
>>>>
>>>> v1:
>>>> https://lore.kernel.org/r/20230306094750.159657-1-s-vadapalli@ti.com/
>>>>
>>>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
>>>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>> index 900063411a20..0fb48bb6a041 100644
>>>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>>>> @@ -126,8 +126,18 @@ properties:
>>>>              description: CPSW port number
>>>>  
>>>>            phys:
>>>> -            maxItems: 1
>>>> -            description: phandle on phy-gmii-sel PHY
>>>> +            minItems: 1
>>>> +            items:
>>>> +              - description: CPSW MAC's PHY.
>>>> +              - description: Serdes PHY. Serdes PHY is required only if
>>>> +                             the Serdes has to be configured in the
>>>> +                             Single-Link configuration.
>>>> +
>>>> +          phy-names:
>>>> +            minItems: 1
>>>> +            items:
>>>> +              - const: mac-phy
>>>> +              - const: serdes-phy
>>>
>>> Drop "phy" suffixes.
>>
>> The am65-cpsw driver fetches the Serdes PHY by looking for the string
>> "serdes-phy". Therefore, modifying the string will require changing the driver's
>> code as well. Please let me know if it is absolutely necessary to drop the phy
>> suffix. If so, I will post a new series with the changes involving dt-bindings
>> changes and the driver changes.
> 
> Why the driver uses some properties before adding them to the binding?

I missed adding the bindings for the Serdes PHY as a part of the series
mentioned in the section below the tearline of the patch. With this patch, I am
attempting to fix it.

> 
> And is it correct method of adding ABI? You add incorrect properties
> without documentation and then use this as an argument "driver already
> does it"?

I apologize if my earlier comment appeared to justify the usage of "serdes-phy"
based on the driver already using it. I did not mean it in that sense. I simply
meant to ask if dropping "phy" suffixes was a suggestion or a rule. In that
context, I felt that if it was a suggestion, I would prefer retaining the names
with the "phy" suffixes, since the driver is already using it. Additionally, I
also mentioned in my earlier comment that if it is necessary to drop the "phy"
suffix, then I will do so and add another patch to change the string the driver
looks for as well.

I shall take it that dropping "phy" suffixes is a rule/necessity. With this, I
will post the v3 series making this change, along with the patch to update the
string the driver looks for.

Regards,
Siddharth.
