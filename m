Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AC45999C5
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 12:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348353AbiHSK3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 06:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347966AbiHSK3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 06:29:49 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A561AF4A7;
        Fri, 19 Aug 2022 03:29:45 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27JATJGS108014;
        Fri, 19 Aug 2022 05:29:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660904959;
        bh=AVrDVBFLBkE3Zwz6MfjLTiwDw+hQlbCuU5vzEr5zREs=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=ArYbwJ/CIrN6RTw1AlFv2iBfRllbaAPjqusYtnDuWC7diQbxn8mzUM6/9BxnN6fpt
         7cmNNDIlakmfON8R2ZTKUUID7v2vrjlv+BiPqnSMvruo+nSNCTx4FKWGCjJTDcoHb8
         fsjT40ucR38Afb1eTAPq1ZiipgUNi3YI4JrdpoLc=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27JATJ57126247
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Aug 2022 05:29:19 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Fri, 19
 Aug 2022 05:29:19 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Fri, 19 Aug 2022 05:29:19 -0500
Received: from [10.24.69.241] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27JATDs3029523;
        Fri, 19 Aug 2022 05:29:14 -0500
Message-ID: <da82e71f-e32c-7adb-250e-0c80cc6e30bd@ti.com>
Date:   Fri, 19 Aug 2022 15:59:13 +0530
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
 <176ab999-e274-e22a-97d8-31f655b16800@ti.com>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <176ab999-e274-e22a-97d8-31f655b16800@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof,

On 17/08/22 13:11, Siddharth Vadapalli wrote:
> Hello Krzysztof,
> 
> On 17/08/22 11:20, Krzysztof Kozlowski wrote:
>> On 17/08/2022 08:14, Siddharth Vadapalli wrote:
>>
>>>>> -      port@[1-2]:
>>>>> +      "^port@[1-4]$":
>>>>>          type: object
>>>>>          description: CPSWxG NUSS external ports
>>>>>  
>>>>> @@ -119,7 +120,7 @@ properties:
>>>>>          properties:
>>>>>            reg:
>>>>>              minimum: 1
>>>>> -            maximum: 2
>>>>> +            maximum: 4
>>>>>              description: CPSW port number
>>>>>  
>>>>>            phys:
>>>>> @@ -151,6 +152,18 @@ properties:
>>>>>  
>>>>>      additionalProperties: false
>>>>>  
>>>>> +if:
>>>>
>>>> This goes under allOf just before unevaluated/additionalProperties:false
>>>
>>> allOf was added by me in v3 series patch and it is not present in the
>>> file. I removed it in v4 after Rob Herring's suggestion. Please let me
>>> know if simply moving the if-then statements to the line above
>>> additionalProperties:false would be fine.
>>
>> I think Rob's comment was focusing not on using or not-using allOf, but
>> on format of your entire if-then-else. Your v3 was huge and included
>> allOf in wrong place).
>>
>> Now you add if-then in proper place, but it is still advisable to put it
>> with allOf, so if ever you grow the if-then by new entry, you do not
>> have to change the indentation.
>>
>> Anyway the location is not correct. Regardless if this is if-then or
>> allOf-if-then, put it just like example schema is suggesting.
> 
> I will move the if-then statements to the lines above the
> "additionalProperties: false" line. Also, I will add an allOf for this

I had a look at the example at [1] and it uses allOf after the
"additionalProperties: false" line. Would it be fine then for me to add
allOf and the single if-then statement below the "additionalProperties:
false" line? Please let me know.

[1] -> https://github.com/devicetree-org/dt-schema/blob/mai/test/schemas/conditionals-allof-example.yaml

Regards,
Siddharth.
