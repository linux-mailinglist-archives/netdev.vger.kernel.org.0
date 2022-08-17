Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A354859687A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 07:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbiHQFPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 01:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238307AbiHQFPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 01:15:12 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B0572B7D;
        Tue, 16 Aug 2022 22:14:50 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27H5EVei050088;
        Wed, 17 Aug 2022 00:14:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660713271;
        bh=B5oesSjrK/IZ6+FJjITC2VsvdDsfxPpTZ1cYOqxV4FM=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=hDhqteBt4RV7qFF6gEEYT/YV7nyK/4PV9zjKAqh3/jRoCk7bSVJZzNea5tHcKTsu3
         oird4rOaWi7oBK0iWqQjtuRj17LIcTMUX/RKHFc3ejjbNEs9OmzRGn5nhonSUyz2LF
         O1iAVhNbJj/smmLItyxL5PsYMQ0d7xnnVwU2sWKM=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27H5EVVi068842
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Aug 2022 00:14:31 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 17
 Aug 2022 00:14:31 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 17 Aug 2022 00:14:30 -0500
Received: from [10.24.69.241] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27H5EPxV064746;
        Wed, 17 Aug 2022 00:14:26 -0500
Message-ID: <31c3a5b0-17cc-ad7b-6561-5834cac62d3e@ti.com>
Date:   Wed, 17 Aug 2022 10:44:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <s-vadapalli@ti.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>
References: <20220816060139.111934-1-s-vadapalli@ti.com>
 <20220816060139.111934-2-s-vadapalli@ti.com>
 <79e58157-f8f2-6ca8-1aa6-b5cf6c83d9e6@linaro.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <79e58157-f8f2-6ca8-1aa6-b5cf6c83d9e6@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof,

On 16/08/22 13:14, Krzysztof Kozlowski wrote:
> On 16/08/2022 09:01, Siddharth Vadapalli wrote:
>> Update bindings for TI K3 J7200 SoC which contains 5 ports (4 external
>> ports) CPSW5G module and add compatible for it.
>>
>> Changes made:
>>     - Add new compatible ti,j7200-cpswxg-nuss for CPSW5G.
>>     - Extend pattern properties for new compatible.
>>     - Change maximum number of CPSW ports to 4 for new compatible.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml     | 17 +++++++++++++++--
>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> index b8281d8be940..5366a367c387 100644
>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> @@ -57,6 +57,7 @@ properties:
>>        - ti,am654-cpsw-nuss
>>        - ti,j721e-cpsw-nuss
>>        - ti,am642-cpsw-nuss
>> +      - ti,j7200-cpswxg-nuss
> 
> Keep some order in the list, so maybe before j721e.

Thank you for reviewing the patch. I will move ti,j7200-cpswxg-nuss
above ti,j721e-cpsw-nuss in the v5 series.

> 
>>  
>>    reg:
>>      maxItems: 1
>> @@ -110,7 +111,7 @@ properties:
>>          const: 0
>>  
>>      patternProperties:
>> -      port@[1-2]:
>> +      "^port@[1-4]$":
>>          type: object
>>          description: CPSWxG NUSS external ports
>>  
>> @@ -119,7 +120,7 @@ properties:
>>          properties:
>>            reg:
>>              minimum: 1
>> -            maximum: 2
>> +            maximum: 4
>>              description: CPSW port number
>>  
>>            phys:
>> @@ -151,6 +152,18 @@ properties:
>>  
>>      additionalProperties: false
>>  
>> +if:
> 
> This goes under allOf just before unevaluated/additionalProperties:false

allOf was added by me in v3 series patch and it is not present in the
file. I removed it in v4 after Rob Herring's suggestion. Please let me
know if simply moving the if-then statements to the line above
additionalProperties:false would be fine.

Regards,
Siddharth.
