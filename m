Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05B85B956E
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiIOHaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiIOH35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:29:57 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367CD13E12;
        Thu, 15 Sep 2022 00:29:42 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28F7T0Dv004698;
        Thu, 15 Sep 2022 02:29:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663226940;
        bh=kK3MFPKNCAR0l9Tkn5PBHDwUH9L6G+mhGZnNZrSdX1A=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=x8uvcSgB81Unk5UGB9mpQOB66hsSep6s8mt1L6w8k+X8tHXkOgwvwDvHiKdRFuZCD
         a5KYW/7lhG2fEqkvkDT5gBixwb/0eo7exnmH4sMwIlAZWCQgC12auNUca1qVAZ13j2
         He1KUrB8hobi49LvXtFQ2pYSuU8Q3UeGMTs+iT2I=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28F7T0af017667
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Sep 2022 02:29:00 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 15
 Sep 2022 02:28:59 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 15 Sep 2022 02:28:59 -0500
Received: from [10.24.69.241] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28F7SrQY016573;
        Thu, 15 Sep 2022 02:28:54 -0500
Message-ID: <2b21b163-0a70-4786-4314-20743178a2e2@ti.com>
Date:   Thu, 15 Sep 2022 12:58:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH 1/8] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J721e CPSW9G
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-2-s-vadapalli@ti.com>
 <20220914162004.GA2433106-robh@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20220914162004.GA2433106-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On 14/09/22 21:50, Rob Herring wrote:
> On Wed, Sep 14, 2022 at 03:20:46PM +0530, Siddharth Vadapalli wrote:
>> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
>> ports) CPSW9G module and add compatible for it.
>>
>> Changes made:
>>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>>     - Extend pattern properties for new compatible.
>>     - Change maximum number of CPSW ports to 8 for new compatible.
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 23 +++++++++++++++++--
>>  1 file changed, 21 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> index 821974815dec..868b7fb58b06 100644
>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> @@ -57,6 +57,7 @@ properties:
>>        - ti,am654-cpsw-nuss
>>        - ti,j7200-cpswxg-nuss
>>        - ti,j721e-cpsw-nuss
>> +      - ti,j721e-cpswxg-nuss
>>        - ti,am642-cpsw-nuss
>>  
>>    reg:
>> @@ -111,7 +112,7 @@ properties:
>>          const: 0
>>  
>>      patternProperties:
>> -      "^port@[1-4]$":
>> +      "^port@[1-8]$":
>>          type: object
>>          description: CPSWxG NUSS external ports
>>  
>> @@ -121,7 +122,7 @@ properties:
>>          properties:
>>            reg:
>>              minimum: 1
>> -            maximum: 4
>> +            maximum: 8
>>              description: CPSW port number
>>  
>>            phys:
>> @@ -181,6 +182,21 @@ required:
>>    - '#size-cells'
>>  
>>  allOf:
>> +  - if:
>> +      not:
>> +        properties:
>> +          compatible:
>> +            contains:
>> +              const: ti,j721e-cpswxg-nuss
>> +    then:
>> +      properties:
>> +        ethernet-ports:
>> +          patternProperties:
>> +            "^port@[5-8]$": false
>> +            properties:
>> +              reg:
>> +                maximum: 4
> 
> Your indentation is off. 'properties' here is under patternProperties 
> making it a DT property.
> 
>> +
>>    - if:
>>        not:
>>          properties:
>> @@ -192,6 +208,9 @@ allOf:
>>          ethernet-ports:
>>            patternProperties:
>>              "^port@[3-4]$": false
>> +            properties:
>> +              reg:
>> +                maximum: 2
> 
> Same here.

Thank you for reviewing the patch. Sorry for the indentation errors. I
will fix them in the v2 series.

Regards,
Siddharth.
