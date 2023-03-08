Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139B56B01AE
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjCHIiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjCHIiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:38:25 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF1A302B8;
        Wed,  8 Mar 2023 00:38:23 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3288c7v9112012;
        Wed, 8 Mar 2023 02:38:07 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678264687;
        bh=l+8lRDZMHWoBBZW7onnv/nboUX3OxsUJ2sMGHq3jYhE=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=t3M1JhRNo+8ls7f7pmqPVpQuVKHt3sYMf6e9/a0QiBcxBRjxG4WFiiPFyIqghPwcR
         yT8SJXT5+65VebM/tFHWyV4QhAQD7FZwYDIpHX62X43KMbhbW5ibpNLLgqKHttsAYy
         Ddbq1Uf2GHCOc9XX7+ozbZwdzA84nerpSCNIA1CM=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3288c7P3089868
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 8 Mar 2023 02:38:07 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 8
 Mar 2023 02:38:06 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 8 Mar 2023 02:38:07 -0600
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3288c2Ep003307;
        Wed, 8 Mar 2023 02:38:02 -0600
Message-ID: <7b6e8131-8e5b-88bc-69f7-b737c0c35bb6@ti.com>
Date:   Wed, 8 Mar 2023 14:08:01 +0530
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
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <1ffed720-322c-fa73-1160-5fd73ce3c7c2@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof,

On 08/03/23 14:04, Krzysztof Kozlowski wrote:
> On 08/03/2023 06:18, Siddharth Vadapalli wrote:
>> Update bindings to include Serdes PHY as an optional PHY, in addition to
>> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
>> Serdes PHY is optional. The Serdes PHY handle has to be provided only
>> when the Serdes is being configured in a Single-Link protocol. Using the
>> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
>> driver can obtain the Serdes PHY and request the Serdes to be
>> configured.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>
>> Hello,
>>
>> This patch corresponds to the Serdes PHY bindings that were missed out in
>> the series at:
>> https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
>> This was pointed out at:
>> https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/
>>
>> Changes from v1:
>> 1. Describe phys property with minItems, items and description.
>> 2. Use minItems and items in phy-names.
>> 3. Remove the description in phy-names.
>>
>> v1:
>> https://lore.kernel.org/r/20230306094750.159657-1-s-vadapalli@ti.com/
>>
>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> index 900063411a20..0fb48bb6a041 100644
>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> @@ -126,8 +126,18 @@ properties:
>>              description: CPSW port number
>>  
>>            phys:
>> -            maxItems: 1
>> -            description: phandle on phy-gmii-sel PHY
>> +            minItems: 1
>> +            items:
>> +              - description: CPSW MAC's PHY.
>> +              - description: Serdes PHY. Serdes PHY is required only if
>> +                             the Serdes has to be configured in the
>> +                             Single-Link configuration.
>> +
>> +          phy-names:
>> +            minItems: 1
>> +            items:
>> +              - const: mac-phy
>> +              - const: serdes-phy
> 
> Drop "phy" suffixes.

The am65-cpsw driver fetches the Serdes PHY by looking for the string
"serdes-phy". Therefore, modifying the string will require changing the driver's
code as well. Please let me know if it is absolutely necessary to drop the phy
suffix. If so, I will post a new series with the changes involving dt-bindings
changes and the driver changes.

Regards,
Siddharth.
