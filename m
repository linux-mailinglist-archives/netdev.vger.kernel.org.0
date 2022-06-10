Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B605B545C0C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 08:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbiFJGDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 02:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243100AbiFJGDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 02:03:09 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DB74A3C8;
        Thu,  9 Jun 2022 23:03:07 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 25A62jo9078851;
        Fri, 10 Jun 2022 01:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654840965;
        bh=3EAB8uaXkhxhjhCgmUaUFeiRR+9QscDQzQvvfzegg1g=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=mofHFl7mKnrDygg7SGOJ7e77vX9NICFG3kOK22OKiTSbcDaoTNG3o8O45pFoESnzY
         c9DzYtwNAcxV+kCnXG7PxBP8byLKAciaZPKLl5HKhsIntLNWn4pDWh8t8/t4DKRnmo
         8hq5+Xad3lz2UL0qthKeIm2P6vSc3yJW1WsZ6aPQ=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 25A62jdD029637
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jun 2022 01:02:45 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 10
 Jun 2022 01:02:44 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Fri, 10 Jun 2022 01:02:44 -0500
Received: from [172.24.222.108] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 25A62cLP062475;
        Fri, 10 Jun 2022 01:02:39 -0500
Message-ID: <cca6368b-2d2f-2996-edd3-0daf32d120e1@ti.com>
Date:   Fri, 10 Jun 2022 11:32:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH v3 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
References: <20220606110443.30362-1-s-vadapalli@ti.com>
 <20220606110443.30362-2-s-vadapalli@ti.com>
 <20220609182606.GA4024580-robh@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20220609182606.GA4024580-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On 09/06/22 23:56, Rob Herring wrote:
> On Mon, Jun 06, 2022 at 04:34:41PM +0530, Siddharth Vadapalli wrote:
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
>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 135 ++++++++++++------
>>  1 file changed, 93 insertions(+), 42 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> index b8281d8be940..49f63aaf5a08 100644
>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> @@ -57,6 +57,7 @@ properties:
>>        - ti,am654-cpsw-nuss
>>        - ti,j721e-cpsw-nuss
>>        - ti,am642-cpsw-nuss
>> +      - ti,j7200-cpswxg-nuss
>>  
>>    reg:
>>      maxItems: 1
>> @@ -108,48 +109,98 @@ properties:
>>          const: 1
>>        '#size-cells':
>>          const: 0
>> -
>> -    patternProperties:
>> -      port@[1-2]:
> 
> Just change this to 'port@[1-4]'.
> 
>> -        type: object
>> -        description: CPSWxG NUSS external ports
>> -
>> -        $ref: ethernet-controller.yaml#
>> -
>> -        properties:
>> -          reg:
>> -            minimum: 1
>> -            maximum: 2
> 
> And this to 4.
> 
> Then, you just need this to disallow the additional ports:
> 
> if:
>   not:
>     properties:
>       compatible:
>         contains:
>           const: ti,j7200-cpswxg-nuss
> then:
>   patternProperties:
>     '^port@[3-4]$': false

Thank you for the suggestion. I will implement this and send the v4 series.

Regards,
Siddharth.
