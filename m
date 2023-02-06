Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF60E68B6D6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjBFHvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBFHvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:51:02 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686371E1FF
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 23:50:41 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n13so7983399wmr.4
        for <netdev@vger.kernel.org>; Sun, 05 Feb 2023 23:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RAh9ybEce2K1WPlqn2ygHTTlak6RqgDwVfYWXIxrXHw=;
        b=Iw/JK0h+4e1If8/zBSu8M4U3MKoqk5bgY+fg+PFlHI9g6QS2JxYQsZinVvu7NZ1m2j
         ZNVSOBF2+r/io7nS2nAsrk6N3AXNTBnjF70AnwZHnzi7ARkL0L+A3YC15FPMcidYgX9K
         Ty7JJXlAL4g4e3rn1hxDtFnx8YOJCo/wHLQBWdqKMzmDTShrxX/5S6MOFVvvMllETfit
         K3lVKRrAshxbLYckJbaqCBnNmYg6D29avGCvv3LmmrNiTgYDx1/RcXhdTupTXBv1E3sd
         td7Zdln9LLzV+Kugyf5HBRbg8NUA9Sc1zIbRAZ6LhbX4cJ4tBIalcp+8bZXbKE+osI7j
         zBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RAh9ybEce2K1WPlqn2ygHTTlak6RqgDwVfYWXIxrXHw=;
        b=mMFvOhUkH6uyo6PjoecH9UaWVJXtZgAo7CQkuftLO/4+hf9gscEHLayVzdVmVnxXk/
         ZmQUAP64F8/L3lK7vAOFQf3RcktXCdumb64QWZ5lrjokfbloupH2qNL67et7hdZRDEZT
         RUxWqgS4UkEcuK9YOPqqdJGHMKXY5D4SAvgug/QQwwaaxqcHQHxhSAWRh/1BRomWx3Ug
         OQQ5N5b/9X6YumxXH3lXqLDnQOaq51ZXbFHTJqesf0uBFWolNs3YrsiNZBWh9vDwiu42
         9DyS07ZrRItwgsbXu+BTwRGyIZx/dr+ev3hm47J9MlADsb/F6DRqHrvGLvIAcIZsJVYm
         4DMw==
X-Gm-Message-State: AO0yUKXAGn4VgEdxHpay8mXcwJ78UNF7sZYOzDwdHhq4a7f5+431YpHJ
        WCdqhYOzoOyuDkpmbAvC4JG6iA==
X-Google-Smtp-Source: AK7set/mw3Jb6zm/r2pLBEguqorSqBd4fhhXyBw+svPoDqNIONS/L/RXBnj0oio0UIxpbq894xbY+A==
X-Received: by 2002:a05:600c:35d3:b0:3de:e8c5:d82c with SMTP id r19-20020a05600c35d300b003dee8c5d82cmr19113405wmq.29.1675669835383;
        Sun, 05 Feb 2023 23:50:35 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id j14-20020a05600c190e00b003daf681d05dsm10964068wmq.26.2023.02.05.23.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Feb 2023 23:50:35 -0800 (PST)
Message-ID: <e0ab9ea1-59b7-506f-1e77-231a0cdc09bf@linaro.org>
Date:   Mon, 6 Feb 2023 08:50:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
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
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-2-danishanwar@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230206060708.3574472-2-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/02/2023 07:07, MD Danish Anwar wrote:
> From: Puranjay Mohan <p-mohan@ti.com>
> 
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs

You add a binding for the hardware, not for driver.

> to interface the PRUs and load/run the firmware for supporting ethernet
> functionality.

Subject: drop second/last, redundant "driver bindings". The
"dt-bindings" prefix is already stating that these are bindings.

> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 179 ++++++++++++++++++
>  1 file changed, 179 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> new file mode 100644
> index 000000000000..e4dee01a272a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> @@ -0,0 +1,179 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Texas Instruments ICSSG PRUSS Ethernet
> +
> +maintainers:
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
> +  ti,sram:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      phandle to MSMC SRAM node
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

Bring some order or logic in the order of the properties. Keep the
ethernet-ports as last property.

> +    type: object
> +    additionalProperties: false

Blank line

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

Drop blank line

> +        $ref: ethernet-controller.yaml#
> +

Drop blank line

> +        unevaluatedProperties: false
> +
> +        properties:
> +          reg:
> +            items:
> +              - enum: [0, 1]
> +            description: ICSSG PRUETH port number
> +
> +          interrupts-extended:

Just "interrupts"
> +            maxItems: 1
> +
> +          ti,syscon-rgmii-delay:
> +            items:
> +              - items:
> +                  - description: phandle to system controller node
> +                  - description: The offset to ICSSG control register
> +            $ref: /schemas/types.yaml#/definitions/phandle-array
> +            description:
> +              phandle to system controller node and register offset
> +              to ICSSG control register for RGMII transmit delay
> +
> +        required:
> +          - reg

required for ethernet-ports - at least one port is required, isn't it?
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
> +
> +  interrupts:
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
> +  - ti,sram
> +  - dmas
> +  - dma-names
> +  - ethernet-ports
> +  - ti,mii-g-rt
> +  - interrupts
> +  - interrupt-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    /* Example k3-am654 base board SR2.0, dual-emac */
> +    pruss2_eth: ethernet {
> +        compatible = "ti,am654-icssg-prueth";
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&icssg2_rgmii_pins_default>;
> +        ti,sram = <&msmc_ram>;
> +
> +        ti,prus = <&pru2_0>, <&rtu2_0>, <&tx_pru2_0>,
> +                  <&pru2_1>, <&rtu2_1>, <&tx_pru2_1>;
> +        firmware-name = "ti-pruss/am65x-pru0-prueth-fw.elf",
> +                        "ti-pruss/am65x-rtu0-prueth-fw.elf",
> +                        "ti-pruss/am65x-txpru0-prueth-fw.elf",
> +                        "ti-pruss/am65x-pru1-prueth-fw.elf",
> +                        "ti-pruss/am65x-rtu1-prueth-fw.elf",
> +                        "ti-pruss/am65x-txpru1-prueth-fw.elf";
> +        ti,pruss-gp-mux-sel = <2>,      /* MII mode */
> +                              <2>,
> +                              <2>,
> +                              <2>,      /* MII mode */
> +                              <2>,
> +                              <2>;
> +        dmas = <&main_udmap 0xc300>, /* egress slice 0 */
> +               <&main_udmap 0xc301>, /* egress slice 0 */
> +               <&main_udmap 0xc302>, /* egress slice 0 */
> +               <&main_udmap 0xc303>, /* egress slice 0 */
> +               <&main_udmap 0xc304>, /* egress slice 1 */
> +               <&main_udmap 0xc305>, /* egress slice 1 */
> +               <&main_udmap 0xc306>, /* egress slice 1 */
> +               <&main_udmap 0xc307>, /* egress slice 1 */
> +               <&main_udmap 0x4300>, /* ingress slice 0 */
> +               <&main_udmap 0x4301>; /* ingress slice 1 */
> +        dma-names = "tx0-0", "tx0-1", "tx0-2", "tx0-3",
> +                    "tx1-0", "tx1-1", "tx1-2", "tx1-3",
> +                    "rx0", "rx1";
> +        ti,mii-g-rt = <&icssg2_mii_g_rt>;
> +        interrupts = <24 0 2>, <25 1 3>;

Aren't you open-coding some IRQ flags?

> +        interrupt-names = "tx_ts0", "tx_ts1";
> +        ethernet-ports {


Best regards,
Krzysztof

