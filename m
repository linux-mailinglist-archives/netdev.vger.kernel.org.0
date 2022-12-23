Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD97654FBD
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 12:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbiLWLbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 06:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiLWLbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 06:31:13 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE6E20BF0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 03:31:10 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f34so6744643lfv.10
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 03:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=llhQA0rnSGJ+JftB+Nxs0vp6UMArAFpZKIdg/XX73SQ=;
        b=oBKd1m5C0N8g0ejFAFl6/envtfQYJi6IlCn+b48P56zjffeuRtRhpzIAdUyLio6Mcz
         SdWE1m4myrNi451f6y8eHDS3jidT4X2L5uCKWHigtE82R1Phn/KQk81Dl5WKcGObMouI
         u3O0hiIcrriJfFBR1eYJ52FTRarD/1/UxZ13auAqSt8LenX2RuZECHoddzGDzcLRzGOS
         4a1jv0ce6tcrzC4rkSXSdPwRPSwacoQTExxonFonbnKBIn5A2kEOLYu/cHFF7BJ7/JWJ
         o3pKKP6ErXBviFK8LJNJ4jQ/pkFTZoJ49cqA4yoWoJ6DhkHxOARXccdP2sExVN99nlnN
         M0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=llhQA0rnSGJ+JftB+Nxs0vp6UMArAFpZKIdg/XX73SQ=;
        b=M/p2UK0iQw+91vYDNhPGpBLWe+lgP3Sqed6wfF0Okyu+onrHjSiUhcC89qrSvJJoBr
         ntisyLi0RtvbTyG7Yyt2ZjKbqTC1VNTvLzsQ8V5I2uHppMmABvhZUpdSzU9sH4T71gbc
         HA3qD3m+MuknFsvn398DkRVmQXU21PCM4SL/0GM+N0n+wUABHT4IaLyMVXUCUtOs5Qbj
         6999BwfG+ECtqBl90xkOKUab7AAuGlLLmCskORWRZQ6qPHJTpIwd9pyg7bGVWbAPUGlX
         aK2rOAmANR8SgqfSN8BqCmi75VZ2xmNupQTZgO2l23YKdgl6xmEZRxWGbndS0SqMlArX
         Q5JQ==
X-Gm-Message-State: AFqh2korxSH4FteCJmiMAZQ0ZCjew/jEkmPEC1ZoBS4+H45bKg55gJ+F
        pnsXhjmxDx0RMeHKewvrBuF+Yg==
X-Google-Smtp-Source: AMrXdXv0EuPxUkMt9ZpWbWa2hcc1h4UGVElRW724FlbLHIm3Ot/+qsOBQQbsXS8TCoqONJRQhV6B6g==
X-Received: by 2002:a05:6512:444:b0:4a4:68b7:d657 with SMTP id y4-20020a056512044400b004a468b7d657mr2444925lfk.62.1671795069197;
        Fri, 23 Dec 2022 03:31:09 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id t12-20020a056512208c00b004b551505c29sm493378lfr.218.2022.12.23.03.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 03:31:08 -0800 (PST)
Message-ID: <b17e9a32-cfdb-223c-f500-c897061753f6@linaro.org>
Date:   Fri, 23 Dec 2022 12:31:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch
Cc:     nm@ti.com, ssantosh@kernel.org, srk@ti.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20221223110930.1337536-1-danishanwar@ti.com>
 <20221223110930.1337536-2-danishanwar@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221223110930.1337536-2-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/12/2022 12:09, MD Danish Anwar wrote:
> From: Puranjay Mohan <p-mohan@ti.com>
> 
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
> to interface the PRUs and load/run the firmware for supporting ethernet
> functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 174 ++++++++++++++++++
>  1 file changed, 174 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> new file mode 100644
> index 000000000000..7659f5fd3132
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> @@ -0,0 +1,174 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title:
> +  Texas Instruments ICSSG PRUSS Ethernet

Keep it in one line.

> +
> +maintainers:
> +  - Puranjay Mohan <p-mohan@ti.com>
> +  - Md Danish Anwar <danishanwar@ti.com>
> +
> +description:
> +  Ethernet based on the Programmable Real-Time
> +  Unit and Industrial Communication Subsystem.
> +
> +allOf:
> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,am654-icssg-prueth  # for AM65x SoC family
> +
> +  sram:
> +    description:
> +      phandle to MSMC SRAM node

Where does the definition of this come from? If from nowhere, usually
you need vendor prefix and type/ref.

> +
> +  dmas:
> +    maxItems: 10
> +
> +  dma-names:
> +    items:
> +      - const: tx0-0
> +      - const: tx0-1
> +      - const: tx0-2
> +      - const: tx0-3
> +      - const: tx1-0
> +      - const: tx1-1
> +      - const: tx1-2
> +      - const: tx1-3
> +      - const: rx0
> +      - const: rx1
> +
> +  ethernet-ports:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      ^port@[0-1]$:
> +        type: object
> +        description: ICSSG PRUETH external ports
> +
> +        $ref: ethernet-controller.yaml#
> +
> +        unevaluatedProperties: false
> +        additionalProperties: false

You cannot have both. Did you test the binding? I doubt it...

> +        properties:
> +          reg:
> +            items:
> +              - enum: [0, 1]
> +            description: ICSSG PRUETH port number
> +
> +          ti,syscon-rgmii-delay:
> +            $ref: /schemas/types.yaml#/definitions/phandle-array
> +            description:
> +              phandle to system controller node and register offset
> +              to ICSSG control register for RGMII transmit delay

You need to describe the items. And in your own bindings from TI you
will even find example...

> +
> +        required:
> +          - reg
> +
> +  ti,mii-g-rt:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: |
> +      phandle to MII_G_RT module's syscon regmap.
> +
> +  ti,mii-rt:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: |
> +      phandle to MII_RT module's syscon regmap

Why do you have so many phandles? Aren't you missing some phys?

> +
> +  interrupts:
> +    minItems: 2

Drop minItems

> +    maxItems: 2
> +    description: |
> +      Interrupt specifiers to TX timestamp IRQ.
> +
> +  interrupt-names:
> +    items:
> +      - const: tx_ts0
> +      - const: tx_ts1
> +
> +required:
> +  - compatible
> +  - sram
> +  - ti,mii-g-rt

Keep same order as in properties:.

> +  - dmas
> +  - dma-names
> +  - ethernet-ports
> +  - interrupts
> +  - interrupt-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +

No need for blank line.

> +    /* Example k3-am654 base board SR2.0, dual-emac */
> +    pruss2_eth: pruss2_eth {

No underscores in node names.

Node names should be generic.
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation

> +        compatible = "ti,am654-icssg-prueth";
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&icssg2_rgmii_pins_default>;
> +        sram = <&msmc_ram>;
> +
> +        ti,prus = <&pru2_0>, <&rtu2_0>, <&tx_pru2_0>,
> +                  <&pru2_1>, <&rtu2_1>, <&tx_pru2_1>;
> +        firmware-name = "ti-pruss/am65x-pru0-prueth-fw.elf",
> +                        "ti-pruss/am65x-rtu0-prueth-fw.elf",
> +                        "ti-pruss/am65x-txpru0-prueth-fw.elf",
> +                        "ti-pruss/am65x-pru1-prueth-fw.elf",
> +                        "ti-pruss/am65x-rtu1-prueth-fw.elf",
> +                        "ti-pruss/am65x-txpru1-prueth-fw.elf";

I really doubt it was tested... and maybe there will be no testing from
Rob's bot due to dependency.

Please post dt_binding_check testing results.

Best regards,
Krzysztof

