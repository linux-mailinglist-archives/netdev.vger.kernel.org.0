Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC55A88CA
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiHaWGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbiHaWGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:06:20 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A83816A0;
        Wed, 31 Aug 2022 15:06:17 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id d18-20020a9d72d2000000b0063934f06268so11220767otk.0;
        Wed, 31 Aug 2022 15:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=bUxxZUu9ewnTBb+tAEbdLRE9nNXH978M8nxstojv75g=;
        b=o4vkMQ/issUa2ilkCwezCqsyztUaVUBRsVfHlJPNzQhh4cZIJ1OPKgSFZiojQ/j7hM
         N4SDOGNM3tBn6720uLjOZQx47H8MTatzV8D0lzkSJzZKr0+hphTHqQ+x/To5rPJhjJiR
         jV5Jjk+Q+xfFhbrnxquZp7Y2oV+CVJmqbiGQjZd0bJY+Z3BkvgvAfdrqfaP6WIcMsYtC
         hslpct6wiwMNBTQWWJ2xBa5sBoK4JJI0jPQr7AOkkufwc96fsZxWuTRWNBZejOZyn29O
         qm1TvcpgVodSMKGssBk7rMUQggYQG+BI5h+QN6Fg3ghIkFoOQowhEX1ZY19AhpPvGl4/
         o1qQ==
X-Gm-Message-State: ACgBeo2q/PUad3YkUVbn8eoAL3R/YNSXXwwCuYLv5+/NezLNsUzXT8Q+
        lkCs5GcDodWMh1zZTXoU2w==
X-Google-Smtp-Source: AA6agR4nunA3HWR7HrY12H0e3vD8ahCK+m8+lro/Es0d3OxAJO6N6GcSrqm2psCPJon0tF2tZhZ2Vg==
X-Received: by 2002:a05:6830:2498:b0:638:9325:3370 with SMTP id u24-20020a056830249800b0063893253370mr11369906ots.228.1661983576608;
        Wed, 31 Aug 2022 15:06:16 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x18-20020a4ab912000000b0044b24273f55sm7490440ooo.6.2022.08.31.15.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 15:06:16 -0700 (PDT)
Received: (nullmailer pid 334935 invoked by uid 1000);
        Wed, 31 Aug 2022 22:06:14 -0000
Date:   Wed, 31 Aug 2022 17:06:14 -0500
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
Subject: Re: [RFC PATCH v3 1/4] dt-bindings: net: can: add STM32 bxcan DT
 bindings
Message-ID: <20220831220614.GA319827-robh@kernel.org>
References: <20220828133329.793324-1-dario.binacchi@amarulasolutions.com>
 <20220828133329.793324-2-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828133329.793324-2-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 03:33:26PM +0200, Dario Binacchi wrote:
> Add documentation of device tree bindings for the STM32 basic extended
> CAN (bxcan) controller.
> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> 
> ---
> 
> Changes in v3:
> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
> - Add description to the parent of the two child nodes.
> - Move "patterProperties:" after "properties: in top level before "required".
> - Add "clocks" to the "required:" list of the child nodes.
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
>  .../bindings/net/can/st,stm32-bxcan.yaml      | 142 ++++++++++++++++++
>  1 file changed, 142 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> new file mode 100644
> index 000000000000..3278c724e6f5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> @@ -0,0 +1,142 @@
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
> +    description:
> +      It manages the access to the 512-bytes SRAM memory shared by the
> +      two bxCAN cells (CAN1 master and CAN2 slave) in dual CAN peripheral
> +      configuration.
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
> +      - clocks
> +
> +required:
> +  - compatible
> +  - reg
> +  - resets
> +  - clocks
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +additionalProperties: false
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

Again, the addressing is not correct here if 0 and 0x400 are memory 
mapped register offsets.

Rob

> +
> +        can1: can@0 {
> +            compatible = "st,stm32f4-bxcan";
> +            reg = <0x0>;
> +            interrupts = <19>, <20>, <21>, <22>;
> +            interrupt-names = "tx", "rx0", "rx1", "sce";
> +            resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
> +            clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN1)>;
> +            st,can-master;
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
