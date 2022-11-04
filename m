Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD5F6191F9
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 08:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiKDH3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 03:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiKDH33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 03:29:29 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D1C2983C;
        Fri,  4 Nov 2022 00:29:21 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2A47T16s003028;
        Fri, 4 Nov 2022 02:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1667546941;
        bh=4UX+JOIA0cUjXrdtnYQ9OAFqNa+7xSinwp6Dd4emurE=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=EzEax9WtCXruJGS7Xpt1ijxbdoaSgYKvAjhOvWVOcQR+CNu1BmLtHkWTaWFe+C29f
         BnZ7mNDXoqFLTDIyMKf1bR3kgO8XwiV4fIcQJXAA1m1mMZS/VtpIy+oPRBrPmVzYqn
         aGonBQYcBuexSyaci9bRD8JsMhyxKNmr/SjVTc3E=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2A47T1wT061855
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 4 Nov 2022 02:29:01 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Fri, 4 Nov
 2022 02:29:00 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Fri, 4 Nov 2022 02:29:00 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2A47StkS014834;
        Fri, 4 Nov 2022 02:28:56 -0500
Message-ID: <41d5952b-51f8-bbc6-2e81-22d6f66320ee@ti.com>
Date:   Fri, 4 Nov 2022 12:58:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <nm@ti.com>, <ssantosh@kernel.org>,
        <s-anna@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@kernel.org>, <vigneshr@ti.com>, <kishon@ti.com>,
        <robh+dt@kernel.org>, <afd@ti.com>, <andrew@lunn.ch>
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-2-p-mohan@ti.com>
 <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
From:   Md Danish Anwar <a0501179@ti.com>
In-Reply-To: <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

I am Danish, new addition to TI team. Puranjay left TI, I'll be posting
upstream patches for Programmable Real-time Unit and Industrial Communication
Subsystem
Gigabit (PRU_ICSSG).

On 31/05/22 15:38, Krzysztof Kozlowski wrote:
> On 31/05/2022 11:51, Puranjay Mohan wrote:
>> Add a YAML binding document for the ICSSG Programmable real time unit
>> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
>> to interface the PRUs and load/run the firmware for supporting ethernet
>> functionality.
>>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> ---
>> v1: https://lore.kernel.org/all/20220506052433.28087-2-p-mohan@ti.com/ 
>> v1 -> v2:
>> * Addressed Rob's Comments
> 
> Nope, they were not addressed.
> 
>> * It includes indentation, formatting, and other minor changes.
>> ---
>>  .../bindings/net/ti,icssg-prueth.yaml         | 181 ++++++++++++++++++
>>  1 file changed, 181 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> new file mode 100644
>> index 000000000000..40af968e9178
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> @@ -0,0 +1,181 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: |+
> 
> Missed Rob's comment.
> 

I'll remove this in the next version of this series.

>> +  Texas Instruments ICSSG PRUSS Ethernet
>> +
>> +maintainers:
>> +  - Puranjay Mohan <p-mohan@ti.com>
>> +
>> +description:
>> +  Ethernet based on the Programmable Real-Time
>> +  Unit and Industrial Communication Subsystem.
>> +
>> +allOf:
>> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
>> +
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - ti,am654-icssg-prueth  # for AM65x SoC family
>> +
>> +  pinctrl-0:
>> +    maxItems: 1
>> +
>> +  pinctrl-names:
>> +    items:
>> +      - const: default
> 
> You do not need these usually, they are coming from schema.
>
Here from what I understand, I need to delete the below block, right?

  pinctrl-names:
    items:
     - const: default

>> +
>> +  sram:
>> +    description:
>> +      phandle to MSMC SRAM node
>> +
>> +  dmas:
>> +    maxItems: 10
>> +    description:
>> +      list of phandles and specifiers to UDMA.
> 
> Please follow Rob's comment - drop description.
> 

I'll drop desceeiption.

>> +
>> +  dma-names:
>> +    items:
>> +      - const: tx0-0
>> +      - const: tx0-1
>> +      - const: tx0-2
>> +      - const: tx0-3
>> +      - const: tx1-0
>> +      - const: tx1-1
>> +      - const: tx1-2
>> +      - const: tx1-3
>> +      - const: rx0
>> +      - const: rx1
>> +
>> +  ethernet-ports:
>> +    type: object
>> +    properties:
>> +      '#address-cells':
>> +        const: 1
>> +      '#size-cells':
>> +        const: 0
>> +
>> +    patternProperties:
>> +      ^port@[0-1]$:
> 
> How did you implement Rob's comments here?
> 
>> +        type: object
>> +        description: ICSSG PRUETH external ports
>> +
>> +        $ref: ethernet-controller.yaml#
>> +
>> +        unevaluatedProperties: false
>> +        additionalProperties: true
> 
> No one proposed to add additionalProperties:true... Does it even work?
> 

I'll remove additionalProperties:true and keep it as false, as it was in the
previous version.

>> +        properties:
>> +          reg:
>> +            items:
>> +              - enum: [0, 1]
>> +            description: ICSSG PRUETH port number
>> +
>> +          ti,syscon-rgmii-delay:
>> +            $ref: /schemas/types.yaml#/definitions/phandle-array
>> +            description:
>> +              phandle to system controller node and register offset
>> +              to ICSSG control register for RGMII transmit delay
>> +
>> +        required:
>> +          - reg
>> +
>> +  ti,mii-g-rt:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: |
>> +      phandle to MII_G_RT module's syscon regmap.
>> +
>> +  ti,mii-rt:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: |
>> +      phandle to MII_RT module's syscon regmap
>> +
>> +  interrupts:
>> +    minItems: 2
>> +    maxItems: 2
>> +    description: |
>> +      Interrupt specifiers to TX timestamp IRQ.
>> +
>> +  interrupt-names:
>> +    items:
>> +      - const: tx_ts0
>> +      - const: tx_ts1
>> +
>> +required:
>> +  - compatible
>> +  - sram
>> +  - ti,mii-g-rt
>> +  - dmas
>> +  - dma-names
>> +  - ethernet-ports
>> +  - interrupts
>> +  - interrupt-names
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +
>> +    /* Example k3-am654 base board SR2.0, dual-emac */
>> +    pruss2_eth: pruss2_eth {
>> +            compatible = "ti,am654-icssg-prueth";
> 
> Again missed Rob's comment.
> 

I'll keep the indentation in example as 4 for first block, 4+4 for second block
and so on.

> Really, you ignored four of his comments. Please respect reviewers time
> but not forcing them to repeat same review comments.
> 
> Best regards,
> Krzysztof
> 

Thanks and Regards,
Md Danish Anwar.

> From mboxrd@z Thu Jan  1 00:00:00 1970
> Return-Path: <linux-arm-kernel-bounces+linux-arm-kernel=archiver.kernel.org@lists.infradead.org>
> X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
> 	aws-us-west-2-korg-lkml-1.web.codeaurora.org
> Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
> 	(No client certificate requested)
> 	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E5FC433FE
> 	for <linux-arm-kernel@archiver.kernel.org>; Tue, 31 May 2022 10:10:18 +0000 (UTC)
> DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
> 	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
> 	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
> 	List-Archive:List-Unsubscribe:List-Id:In-Reply-To:From:References:Cc:To:
> 	Subject:MIME-Version:Date:Message-ID:Reply-To:Content-ID:Content-Description:
> 	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
> 	List-Owner; bh=1a8R2aPtpN8VJ8nnKPmRS52Aa9f7VxdsHDMYjLy3Nec=; b=wIC+W0D4fCGLL2
> 	d62YYbdS41pfLBGPmRsc7zOtnryxJBMZ+3ranQeCbNLF852PAuSOHzYQlKfDiPG8G4rTileKr2zI4
> 	tgmrfHwiYz4zFLOrZSK/F0gUKRcXs+ivHNa5dEWipt2UaOnrPjVxJNPa2ExKalwxedTTlzXuOKvRp
> 	lBsupH/BY2Yhwdiy0YGYEQ06wug/wAJrHw6gVZ2A54brkI/Gh0MgQA3DX2vFqtAf+FRLB5o38KzD6
> 	uRsYf/QKOD1ixkP2Uh+isRMsVK1GJAY1BaxNnfisYDCJ31Y4auPV1TTJ5JsqOPIl+oAc+qQOoWhUt
> 	ZHtAzDsfrPhRteMR8nGA==;
> Received: from localhost ([::1] helo=bombadil.infradead.org)
> 	by bombadil.infradead.org with esmtp (Exim 4.94.2 #2 (Red Hat Linux))
> 	id 1nvyns-00A97O-Kp; Tue, 31 May 2022 10:08:44 +0000
> Received: from mail-ej1-x629.google.com ([2a00:1450:4864:20::629])
> 	by bombadil.infradead.org with esmtps (Exim 4.94.2 #2 (Red Hat Linux))
> 	id 1nvynp-00A96p-Bi
> 	for linux-arm-kernel@lists.infradead.org; Tue, 31 May 2022 10:08:43 +0000
> Received: by mail-ej1-x629.google.com with SMTP id f9so25684073ejc.0
>         for <linux-arm-kernel@lists.infradead.org>; Tue, 31 May 2022 03:08:40 -0700 (PDT)
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>         d=linaro.org; s=google;
>         h=message-id:date:mime-version:user-agent:subject:content-language:to
>          :cc:references:from:in-reply-to:content-transfer-encoding;
>         bh=0xEDKtRJ1gFx9yMLHsbYq7kEF2/saJCmbQuGtwp5BAo=;
>         b=FJlTsAsgLQm8T7cg7ztoR+hVidoRf0V5AWOmRsLnTi0T7R1GvuT2r/FFDmqkIl53A6
>          DbHgnZvG+DyTKUwG/vdUmgZmVNF+w7UeZKwmdDVjGozRWvHTYOIaY1SWDxFECXfVzcy0
>          LAg5f9EqBC3WEIjvhOnIkvR7P+OsgIhI/OiivIkJBdzRo9jS9E+2yx+Sm8NDltnFTUwA
>          IYLDY1JDsLGwfIc2HtBk3jWG83NDp0Ea+TiENVqdmzdP+uv3rQqxCeGPQQRIR8kZ+lhz
>          EsPkUVZzzGoPnArdmSNQGceUzqD1QuOmhiLIlqBDnkgIxv0uDEGSG52wLOF3N4QCWRdj
>          7/7A==
> X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>         d=1e100.net; s=20210112;
>         h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
>          :content-language:to:cc:references:from:in-reply-to
>          :content-transfer-encoding;
>         bh=0xEDKtRJ1gFx9yMLHsbYq7kEF2/saJCmbQuGtwp5BAo=;
>         b=B8P1vdEHTMWSN4xCuq1bRYTxlQJ2WbgTX33+iZ64xwRYFE43op8cqxMLe8ItNeXhOa
>          ygVqXL+3FCMKHUz2qvOplSkkHDMwKumX+X/ErqhpU2u+Npqyo8EvNGH0toag3qflFryq
>          GsjzmWphffPt7/1Z/+K5+0dqvy92g9tDtBmNyRTn52i0RoOQ05LlbKBxkJOXEXxNaD/y
>          l9T9G26QAQaF7kT/gKe2Lrj+kCrTpJ/1yI05qKdrhZdka3xZa6GBIi6VRwJcynxUcxs8
>          aJQL70rRY4tfncRNUghETqpjQu8clZdj57R9HaO3LEBfq8uZlFvQVTr9u13RL2twT3aa
>          3UAA==
> X-Gm-Message-State: AOAM531dEZwptqWX2TF8w5F1B3CdGvkaOesF74IGrBLIeJeoH/LfzFiG
> 	4a4rxd2QE25vDQvfgJchJ+HUkw==
> X-Google-Smtp-Source: ABdhPJxvLTVkRm6gy9yj0yU6UO395ZmuZmGbmyxXWGwAn4IUJBt1uCvPDQ8Lpwmm1nn62gUGkldWYA==
> X-Received: by 2002:a17:906:5d0d:b0:6fe:b420:5eab with SMTP id g13-20020a1709065d0d00b006feb4205eabmr45855204ejt.23.1653991719238;
>         Tue, 31 May 2022 03:08:39 -0700 (PDT)
> Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
>         by smtp.gmail.com with ESMTPSA id i16-20020a1709063c5000b006fed85c1a72sm4802036ejg.223.2022.05.31.03.08.38
>         (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
>         Tue, 31 May 2022 03:08:38 -0700 (PDT)
> Message-ID: <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
> Date: Tue, 31 May 2022 12:08:37 +0200
> MIME-Version: 1.0
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
>  Thunderbird/91.9.1
> Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
>  bindings
> Content-Language: en-US
> To: Puranjay Mohan <p-mohan@ti.com>, linux-kernel@vger.kernel.org
> Cc: davem@davemloft.net, edumazet@google.com,
>  krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
>  devicetree@vger.kernel.org, nm@ti.com, ssantosh@kernel.org, s-anna@ti.com,
>  linux-arm-kernel@lists.infradead.org, rogerq@kernel.org,
>  grygorii.strashko@ti.com, vigneshr@ti.com, kishon@ti.com,
>  robh+dt@kernel.org, afd@ti.com, andrew@lunn.ch
> References: <20220531095108.21757-1-p-mohan@ti.com>
>  <20220531095108.21757-2-p-mohan@ti.com>
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> In-Reply-To: <20220531095108.21757-2-p-mohan@ti.com>
> X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
> X-CRM114-CacheID: sfid-20220531_030841_459584_A3DCA991 
> X-CRM114-Status: GOOD (  21.47  )
> X-BeenThere: linux-arm-kernel@lists.infradead.org
> X-Mailman-Version: 2.1.34
> Precedence: list
> List-Id: <linux-arm-kernel.lists.infradead.org>
> List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
>  <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
> List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
> List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
> List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
> List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
>  <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
> Content-Type: text/plain; charset="us-ascii"
> Content-Transfer-Encoding: 7bit
> Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
> Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=archiver.kernel.org@lists.infradead.org
> 
> On 31/05/2022 11:51, Puranjay Mohan wrote:
>> Add a YAML binding document for the ICSSG Programmable real time unit
>> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
>> to interface the PRUs and load/run the firmware for supporting ethernet
>> functionality.
>>
>> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
>> ---
>> v1: https://lore.kernel.org/all/20220506052433.28087-2-p-mohan@ti.com/ 
>> v1 -> v2:
>> * Addressed Rob's Comments
> 
> Nope, they were not addressed.
> 
>> * It includes indentation, formatting, and other minor changes.
>> ---
>>  .../bindings/net/ti,icssg-prueth.yaml         | 181 ++++++++++++++++++
>>  1 file changed, 181 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> new file mode 100644
>> index 000000000000..40af968e9178
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>> @@ -0,0 +1,181 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: |+
> 
> Missed Rob's comment.
> 
>> +  Texas Instruments ICSSG PRUSS Ethernet
>> +
>> +maintainers:
>> +  - Puranjay Mohan <p-mohan@ti.com>
>> +
>> +description:
>> +  Ethernet based on the Programmable Real-Time
>> +  Unit and Industrial Communication Subsystem.
>> +
>> +allOf:
>> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
>> +
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - ti,am654-icssg-prueth  # for AM65x SoC family
>> +
>> +  pinctrl-0:
>> +    maxItems: 1
>> +
>> +  pinctrl-names:
>> +    items:
>> +      - const: default
> 
> You do not need these usually, they are coming from schema.
> 
>> +
>> +  sram:
>> +    description:
>> +      phandle to MSMC SRAM node
>> +
>> +  dmas:
>> +    maxItems: 10
>> +    description:
>> +      list of phandles and specifiers to UDMA.
> 
> Please follow Rob's comment - drop description.
> 
>> +
>> +  dma-names:
>> +    items:
>> +      - const: tx0-0
>> +      - const: tx0-1
>> +      - const: tx0-2
>> +      - const: tx0-3
>> +      - const: tx1-0
>> +      - const: tx1-1
>> +      - const: tx1-2
>> +      - const: tx1-3
>> +      - const: rx0
>> +      - const: rx1
>> +
>> +  ethernet-ports:
>> +    type: object
>> +    properties:
>> +      '#address-cells':
>> +        const: 1
>> +      '#size-cells':
>> +        const: 0
>> +
>> +    patternProperties:
>> +      ^port@[0-1]$:
> 
> How did you implement Rob's comments here?
> 
>> +        type: object
>> +        description: ICSSG PRUETH external ports
>> +
>> +        $ref: ethernet-controller.yaml#
>> +
>> +        unevaluatedProperties: false
>> +        additionalProperties: true
> 
> No one proposed to add additionalProperties:true... Does it even work?
> 
>> +        properties:
>> +          reg:
>> +            items:
>> +              - enum: [0, 1]
>> +            description: ICSSG PRUETH port number
>> +
>> +          ti,syscon-rgmii-delay:
>> +            $ref: /schemas/types.yaml#/definitions/phandle-array
>> +            description:
>> +              phandle to system controller node and register offset
>> +              to ICSSG control register for RGMII transmit delay
>> +
>> +        required:
>> +          - reg
>> +
>> +  ti,mii-g-rt:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: |
>> +      phandle to MII_G_RT module's syscon regmap.
>> +
>> +  ti,mii-rt:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: |
>> +      phandle to MII_RT module's syscon regmap
>> +
>> +  interrupts:
>> +    minItems: 2
>> +    maxItems: 2
>> +    description: |
>> +      Interrupt specifiers to TX timestamp IRQ.
>> +
>> +  interrupt-names:
>> +    items:
>> +      - const: tx_ts0
>> +      - const: tx_ts1
>> +
>> +required:
>> +  - compatible
>> +  - sram
>> +  - ti,mii-g-rt
>> +  - dmas
>> +  - dma-names
>> +  - ethernet-ports
>> +  - interrupts
>> +  - interrupt-names
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +
>> +    /* Example k3-am654 base board SR2.0, dual-emac */
>> +    pruss2_eth: pruss2_eth {
>> +            compatible = "ti,am654-icssg-prueth";
> 
> Again missed Rob's comment.
> 
> Really, you ignored four of his comments. Please respect reviewers time
> but not forcing them to repeat same review comments.
> 
> Best regards,
> Krzysztof
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 
