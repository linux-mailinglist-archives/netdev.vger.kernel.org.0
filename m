Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6139E596A86
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiHQHlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiHQHln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:41:43 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B2C77E9C;
        Wed, 17 Aug 2022 00:41:41 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27H7f9q8104499;
        Wed, 17 Aug 2022 02:41:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660722070;
        bh=/zDSKKT1Pikh4+rD3KuCHFMZ7jEY6eOdH61BQhafa6k=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=yuJ+dXzatpY058ruSpt+KhHs4dLeEqBnhwZzeh68Zb9zZDULLof4oIoEOem7vlZ4Z
         NlM5+pTe7p56Il1rK46hy8qEriO77mtM7y1m7lpfE67BK7lctVhqcHvqCy+xyUjOFy
         a/VQluOUn4bXlW0I6Hvj/VqB7MxgmayiW19IitP8=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27H7f9KA011237
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Aug 2022 02:41:09 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 17
 Aug 2022 02:41:09 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 17 Aug 2022 02:41:09 -0500
Received: from [10.24.69.241] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27H7f4Q9012503;
        Wed, 17 Aug 2022 02:41:05 -0500
Message-ID: <176ab999-e274-e22a-97d8-31f655b16800@ti.com>
Date:   Wed, 17 Aug 2022 13:11:04 +0530
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
 <31c3a5b0-17cc-ad7b-6561-5834cac62d3e@ti.com>
 <9c331cdc-e34a-1146-fb83-84c2107b2e2a@linaro.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <9c331cdc-e34a-1146-fb83-84c2107b2e2a@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof,

On 17/08/22 11:20, Krzysztof Kozlowski wrote:
> On 17/08/2022 08:14, Siddharth Vadapalli wrote:
> 
>>>> -      port@[1-2]:
>>>> +      "^port@[1-4]$":
>>>>          type: object
>>>>          description: CPSWxG NUSS external ports
>>>>  
>>>> @@ -119,7 +120,7 @@ properties:
>>>>          properties:
>>>>            reg:
>>>>              minimum: 1
>>>> -            maximum: 2
>>>> +            maximum: 4
>>>>              description: CPSW port number
>>>>  
>>>>            phys:
>>>> @@ -151,6 +152,18 @@ properties:
>>>>  
>>>>      additionalProperties: false
>>>>  
>>>> +if:
>>>
>>> This goes under allOf just before unevaluated/additionalProperties:false
>>
>> allOf was added by me in v3 series patch and it is not present in the
>> file. I removed it in v4 after Rob Herring's suggestion. Please let me
>> know if simply moving the if-then statements to the line above
>> additionalProperties:false would be fine.
> 
> I think Rob's comment was focusing not on using or not-using allOf, but
> on format of your entire if-then-else. Your v3 was huge and included
> allOf in wrong place).
> 
> Now you add if-then in proper place, but it is still advisable to put it
> with allOf, so if ever you grow the if-then by new entry, you do not
> have to change the indentation.
> 
> Anyway the location is not correct. Regardless if this is if-then or
> allOf-if-then, put it just like example schema is suggesting.

I will move the if-then statements to the lines above the
"additionalProperties: false" line. Also, I will add an allOf for this
single if-then statement in the v5 series.

Regards,
Siddharth.
