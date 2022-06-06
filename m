Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B626B53E324
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiFFGVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 02:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiFFGVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 02:21:37 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AE0248DA;
        Sun,  5 Jun 2022 23:21:32 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2566L4TF023770;
        Mon, 6 Jun 2022 01:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654496464;
        bh=AnqTbDFVrqwHXrTGY/Z2NcAhGEYdlgEfr1d6CtHEp2k=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=v2fBUMtKP12il550wFLHUC/bzjyQDakjroSiiLhQ5o+cALXTxC9zq1MTrK5QLFNVu
         Fjk6N9hs4aoOra0bXkRNPBolerMJXB6iVa7CvlDdoMkCGYcNkpJTc1AoLggh40OGLO
         NMMuTn7+tx0VKorUcQfjfGrqmOpZhJbCbFzWsTSU=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2566L4Jg019207
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Jun 2022 01:21:04 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 6
 Jun 2022 01:21:03 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 6 Jun 2022 01:21:03 -0500
Received: from [172.24.222.108] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2566KvXG003420;
        Mon, 6 Jun 2022 01:20:58 -0500
Message-ID: <2c72a658-9427-b7ab-08ef-b78f51cd151b@ti.com>
Date:   Mon, 6 Jun 2022 11:50:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
References: <20220602114558.6204-1-s-vadapalli@ti.com>
 <20220602114558.6204-2-s-vadapalli@ti.com>
 <20220605224343.GA3657277-robh@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20220605224343.GA3657277-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On 06/06/22 04:13, Rob Herring wrote:
> On Thu, Jun 02, 2022 at 05:15:56PM +0530, Siddharth Vadapalli wrote:
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
>>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 140 ++++++++++++------
>>  1 file changed, 98 insertions(+), 42 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> index b8281d8be940..ec57bde7ac26 100644
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
>> @@ -108,48 +109,103 @@ properties:
>>          const: 1
>>        '#size-cells':
>>          const: 0
>> -
>> -    patternProperties:
>> -      port@[1-2]:
>> -        type: object
>> -        description: CPSWxG NUSS external ports
>> -
>> -        $ref: ethernet-controller.yaml#
>> -
>> -        properties:
>> -          reg:
>> -            minimum: 1
>> -            maximum: 2
>> -            description: CPSW port number
>> -
>> -          phys:
>> -            maxItems: 1
>> -            description: phandle on phy-gmii-sel PHY
>> -
>> -          label:
>> -            description: label associated with this port
>> -
>> -          ti,mac-only:
>> -            $ref: /schemas/types.yaml#/definitions/flag
>> -            description:
>> -              Specifies the port works in mac-only mode.
>> -
>> -          ti,syscon-efuse:
>> -            $ref: /schemas/types.yaml#/definitions/phandle-array
>> -            items:
>> -              - items:
>> -                  - description: Phandle to the system control device node which
>> -                      provides access to efuse
>> -                  - description: offset to efuse registers???
>> -            description:
>> -              Phandle to the system control device node which provides access
>> -              to efuse IO range with MAC addresses
>> -
>> -        required:
>> -          - reg
>> -          - phys
>> -
>> -    additionalProperties: false
>> +    allOf:
>> +      - if:
>> +          properties:
>> +            compatible:
>> +              contains:
>> +                enum:
>> +                  - ti,am654-cpsw-nuss
>> +                  - ti,j721e-cpsw-nuss
>> +                  - ti,am642-cpsw-nuss
>> +        then:
>> +          patternProperties:
>> +            port@[1-2]:
>> +              type: object
>> +              description: CPSWxG NUSS external ports
>> +
>> +              $ref: ethernet-controller.yaml#
>> +
>> +              properties:
>> +                reg:
>> +                  minimum: 1
>> +                  maximum: 2
>> +                  description: CPSW port number
>> +
>> +                phys:
>> +                  maxItems: 1
>> +                  description: phandle on phy-gmii-sel PHY
>> +
>> +                label:
>> +                  description: label associated with this port
>> +
>> +                ti,mac-only:
>> +                  $ref: /schemas/types.yaml#/definitions/flag
>> +                  description:
>> +                    Specifies the port works in mac-only mode.
>> +
>> +                ti,syscon-efuse:
>> +                  $ref: /schemas/types.yaml#/definitions/phandle-array
>> +                  items:
>> +                    - items:
>> +                        - description: Phandle to the system control device node which
>> +                            provides access to efuse
>> +                        - description: offset to efuse registers???
>> +                  description:
>> +                    Phandle to the system control device node which provides access
>> +                    to efuse IO range with MAC addresses
>> +
>> +              required:
>> +                - reg
>> +                - phys
>> +      - if:
>> +          properties:
>> +            compatible:
>> +              contains:
>> +                enum:
>> +                  - ti,j7200-cpswxg-nuss
>> +        then:
>> +          patternProperties:
>> +            port@[1-4]:
>> +              type: object
>> +              description: CPSWxG NUSS external ports
>> +
>> +              $ref: ethernet-controller.yaml#
>> +
>> +              properties:
>> +                reg:
>> +                  minimum: 1
>> +                  maximum: 4
>> +                  description: CPSW port number
>> +
>> +                phys:
>> +                  maxItems: 1
>> +                  description: phandle on phy-gmii-sel PHY
>> +
>> +                label:
>> +                  description: label associated with this port
>> +
>> +                ti,mac-only:
>> +                  $ref: /schemas/types.yaml#/definitions/flag
>> +                  description:
>> +                    Specifies the port works in mac-only mode.
>> +
>> +                ti,syscon-efuse:
>> +                  $ref: /schemas/types.yaml#/definitions/phandle-array
>> +                  items:
>> +                    - items:
>> +                        - description: Phandle to the system control device node which
>> +                            provides access to efuse
>> +                        - description: offset to efuse registers???
>> +                  description:
>> +                    Phandle to the system control device node which provides access
>> +                    to efuse IO range with MAC addresses
>> +
>> +              required:
>> +                - reg
>> +                - phys
> 
> You are now defining the same properties twice. Don't do that. Just add 
> an if/then schema restrict port nodes.

Thank you for reviewing the patch. I will fix this and send v3 for this series.

Thanks,
Siddharth.
