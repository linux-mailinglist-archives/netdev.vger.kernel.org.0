Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8E85A1ADA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242414AbiHYVMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiHYVMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:12:44 -0400
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1F6B1BBD;
        Thu, 25 Aug 2022 14:12:43 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-11c5505dba2so26530515fac.13;
        Thu, 25 Aug 2022 14:12:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7cYyxg+Rjs2OKuzQlOjAlSHEpxBggE7h7LYSTjnsFQY=;
        b=O0aNaAc2BQP/ZfLv6yEbmA7bMaS/MztotiuxUg7TSVRYePqhPtj7sLJooCKs3GbMEn
         +EJG02mkjQAjlnPoYp1BbKgDpJjqcwlcjaX+PeYpJxWq8pioUOuPndHkKjemKfknxj71
         SD2qcI5FHgXw3bHxiFf25nWo9ZNF/+Y9IXJXaQEkjHJnluxXJNjUsbNkuRqamgN3eEFK
         OX6bAW7tQfR6rJg1s16eu7xPTjL15gQrbx43X0+yTcamssJG5pPkRGgAi9Tq9zYabhSD
         5rQ0Qv8OS0b+V73BIvWNSji+P19wAGui9MAnpFlzcPCYRS4tzONLepYemKtKWevyJ0Ip
         3cEw==
X-Gm-Message-State: ACgBeo3ZrUeuSdkeGRRseI2Aw2cOTERypth7jFey+Yezus7dtjJqlvJE
        LLSwBf/D3rXS8Ykh0kBkaw==
X-Google-Smtp-Source: AA6agR7L4kQd6z1UzBVG2YOwp2flBq48abWOo4dTD4AKZRma54US5SS++O70oOI3XePD8j7/qDEheA==
X-Received: by 2002:a05:6870:438b:b0:11c:ecf2:e4ca with SMTP id r11-20020a056870438b00b0011cecf2e4camr449518oah.122.1661461963080;
        Thu, 25 Aug 2022 14:12:43 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o12-20020a9d5c0c000000b0061d31170573sm92760otk.20.2022.08.25.14.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:12:42 -0700 (PDT)
Received: (nullmailer pid 1696440 invoked by uid 1000);
        Thu, 25 Aug 2022 21:12:41 -0000
Date:   Thu, 25 Aug 2022 16:12:41 -0500
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        michael@amarulasolutions.com, Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] dt-bindings: net: can: add STM32 bxcan DT
 bindings
Message-ID: <20220825211241.GA1688421-robh@kernel.org>
References: <20220820082936.686924-1-dario.binacchi@amarulasolutions.com>
 <20220820082936.686924-2-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820082936.686924-2-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 20, 2022 at 10:29:33AM +0200, Dario Binacchi wrote:
> Add documentation of device tree bindings for the STM32 basic extended
> CAN (bxcan) controller.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> 
> ---
> 
> Changes in v2:
> - Change the file name into 'st,stm32-bxcan-core.yaml'.
> - Rename compatibles:
>   - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
>   - st,stm32-bxcan -> st,stm32f4-bxcan
> - Rename master property to st,can-master.
> - Remove the status property from the example.
> - Put the node child properties as required.
> 
>  .../bindings/net/can/st,stm32-bxcan.yaml      | 136 ++++++++++++++++++
>  1 file changed, 136 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> new file mode 100644
> index 000000000000..288631b5556d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> @@ -0,0 +1,136 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/st,stm32-bxcan.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: STMicroelectronics bxCAN controller
> +
> +description: STMicroelectronics BxCAN controller for CAN bus
> +
> +maintainers:
> +  - Dario Binacchi <dario.binacchi@amarulasolutions.com>
> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - st,stm32f4-bxcan-core
> +
> +  reg:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  clocks:
> +    description:
> +      Input clock for registers access
> +    maxItems: 1
> +
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0
> +
> +additionalProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +  - resets
> +  - clocks
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +patternProperties:
> +  "^can@[0-9]+$":
> +    type: object
> +    description:
> +      A CAN block node contains two subnodes, representing each one a CAN
> +      instance available on the machine.
> +
> +    properties:
> +      compatible:
> +        enum:
> +          - st,stm32f4-bxcan
> +
> +      st,can-master:
> +        description:
> +          Master and slave mode of the bxCAN peripheral is only relevant
> +          if the chip has two CAN peripherals. In that case they share
> +          some of the required logic, and that means you cannot use the
> +          slave CAN without the master CAN.
> +        type: boolean
> +
> +      reg:
> +        description: |
> +          Offset of CAN instance in CAN block. Valid values are:
> +            - 0x0:   CAN1
> +            - 0x400: CAN2
> +        maxItems: 1
> +
> +      interrupts:
> +        items:
> +          - description: transmit interrupt
> +          - description: FIFO 0 receive interrupt
> +          - description: FIFO 1 receive interrupt
> +          - description: status change error interrupt
> +
> +      interrupt-names:
> +        items:
> +          - const: tx
> +          - const: rx0
> +          - const: rx1
> +          - const: sce
> +
> +      resets:
> +        maxItems: 1
> +
> +      clocks:
> +        description:
> +          Input clock for registers access
> +        maxItems: 1
> +
> +    additionalProperties: false
> +
> +    required:
> +      - compatible
> +      - reg
> +      - interrupts
> +      - resets
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/stm32fx-clock.h>
> +    #include <dt-bindings/mfd/stm32f4-rcc.h>
> +
> +    can: can@40006400 {
> +        compatible = "st,stm32f4-bxcan-core";
> +        reg = <0x40006400 0x800>;
> +        resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
> +        clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN1)>;
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +

Missing 'ranges'.

> +        can1: can@0 {
> +            compatible = "st,stm32f4-bxcan";
> +            reg = <0x0>;
> +            interrupts = <19>, <20>, <21>, <22>;
> +            interrupt-names = "tx", "rx0", "rx1", "sce";
> +            resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
> +            st,can-master;

No clocks?

> +        };
> +
> +        can2: can@400 {
> +            compatible = "st,stm32f4-bxcan";
> +            reg = <0x400>;
> +            interrupts = <63>, <64>, <65>, <66>;
> +            interrupt-names = "tx", "rx0", "rx1", "sce";
> +            resets = <&rcc STM32F4_APB1_RESET(CAN2)>;
> +            clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN2)>;
> +        };
> +    };
> -- 
> 2.32.0
> 
> 
