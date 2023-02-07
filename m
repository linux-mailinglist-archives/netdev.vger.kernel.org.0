Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D958E68CEB9
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 06:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjBGFJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 00:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjBGFJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 00:09:29 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244F137F23;
        Mon,  6 Feb 2023 21:07:44 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 31757Bxc077545;
        Mon, 6 Feb 2023 23:07:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675746431;
        bh=9z53VZ1BVzzZFAbLkQNtC3Tnesb/rnN18j8iaYp1STc=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=J0vgMlW6nFln5PJcri+u6+x/22yFumiWSLUmsM8rpwld35VSPjv4YwX+FsacHgkUT
         aURUKO8ewbV8CXySKuxZ9+GxvvAIFFXXvPO+YUT2NS8vwUlAJl+Uc5veTyMsqiINhl
         LlmL6RNm84/2dO6OlWmDLfUHQhnj6qsh7AhpeIxE=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 31757BS2005294
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Feb 2023 23:07:11 -0600
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Feb 2023 23:07:11 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Feb 2023 23:07:11 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 317575iq023952;
        Mon, 6 Feb 2023 23:07:05 -0600
Message-ID: <e31ade52-648f-d743-e3db-ba8d4d0baf94@ti.com>
Date:   Tue, 7 Feb 2023 10:37:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [EXTERNAL] Re: [PATCH v4 1/2] dt-bindings: net: Add ICSSG
 Ethernet Driver bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>
CC:     <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-2-danishanwar@ti.com>
 <e0ab9ea1-59b7-506f-1e77-231a0cdc09bf@linaro.org>
 <81dc1c83-3e66-4612-9011-cf70fb624529@ti.com>
 <bd840b3b-995e-2133-df93-a5e78128acfc@linaro.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <bd840b3b-995e-2133-df93-a5e78128acfc@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 06/02/23 16:11, Krzysztof Kozlowski wrote:
> On 06/02/2023 11:39, Md Danish Anwar wrote:
>>>> +    properties:
>>>> +      '#address-cells':
>>>> +        const: 1
>>>> +      '#size-cells':
>>>> +        const: 0
>>>> +
>>>> +    patternProperties:
>>>> +      ^port@[0-1]$:
>>>> +        type: object
>>>> +        description: ICSSG PRUETH external ports
>>>> +
>>
>> At least one ethernet port is required. Should I add the below line here for this?
>>
>>    minItems: 1
> 
> You need after the patternProperties:
>     anyOf:
>       - required:
>           - port@0
>       - required:
>           - port@1
> 


Is this correct?

  ethernet-ports:
    type: object
    additionalProperties: false

    properties:
      '#address-cells':
        const: 1
      '#size-cells':
        const: 0

    patternProperties:
      ^port@[0-1]$:
        type: object
        description: ICSSG PRUETH external ports
        $ref: ethernet-controller.yaml#
        unevaluatedProperties: false

        properties:
          reg:
            items:
              - enum: [0, 1]
            description: ICSSG PRUETH port number

          interrupts:
            maxItems: 1

          ti,syscon-rgmii-delay:
            items:
              - items:
                  - description: phandle to system controller node
                  - description: The offset to ICSSG control register
            $ref: /schemas/types.yaml#/definitions/phandle-array
            description:
              phandle to system controller node and register offset
              to ICSSG control register for RGMII transmit delay

        required:
          - reg
    anyOf:
      - required:
          - port@0
      - required:
          - port@1

Adding anyOf just below patternProperties was throwing error, so I added anyOf
after the end of patternProperties. Please let me know if this looks OK.

>>
>>
> 
> Best regards,
> Krzysztof
> 

-- 
Thanks and Regards,
Danish.
