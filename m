Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C195B59AC7F
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 10:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343595AbiHTIJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 04:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343781AbiHTIJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 04:09:15 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37F24D268
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 01:09:11 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id u9so8795417lfg.11
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 01:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=r4JTYj9qmkeOKWKWcNromnFZjQXRdXfr4tTRKL0mYFE=;
        b=oGNYyYCcVgvXroyrv+4hnMFb+02o65cSD2yyvYiCVdDkCye17udVFugCaCkx3Ur+xp
         TUxLu1wwOa57RiMmdLaD9xhRmKtMTJrHINTLUkDfU/xW6FR4bq8efSBZ1B8kYmizYWxz
         6I6PGR2zKJzT1ajvwOamDEs3TYYxIHfI0Lwhg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=r4JTYj9qmkeOKWKWcNromnFZjQXRdXfr4tTRKL0mYFE=;
        b=C1HtnSADhBbiPES7pupqCneYG8JeYUfC5uWFwkVdJdktD/X/wF03prpf24fsa9vrrR
         MIWlnFK2j8toLIdyjuJ/GH65txT3m8SGMKu0as6Cg6wZGJqIqZ+AkbZ9fk4lqAtNtKvj
         MITPmVcyIKa0pFc13VYwHECZGc850Zq47U291MeczTPAe9Ti3qFVwR1QkGgvWzJkTf8A
         PoNUyK6yvV3yxt/+WoknQwGvJahXWRSoeVaaEKkXYvjVpQ1uGzD08fueduN99kgfG8vr
         YT32e9WQQU2o+eNepiNauovnkuIxZYviDQTIg/IDxaDXsLuvUlQHhOR/7SwCmLqLysN4
         j0+Q==
X-Gm-Message-State: ACgBeo3Q9WR3vRrL/xso4I7Ox2f6rJkp00zG9L29yO4uGWGUWekoUYNp
        bQHoVjy5Lif33s18HdFgDr2TZ1WDjk1rp2TfwUSJpA==
X-Google-Smtp-Source: AA6agR7PSoYIN75wd+y8b/Q6GRXwfuKkotsd2MunPjbhD7CdjOdzrRz2E3RO7zy/zImiU20Jqng14NZ3NZiprHtRLxQ=
X-Received: by 2002:a05:6512:3503:b0:48a:6060:5ebb with SMTP id
 h3-20020a056512350300b0048a60605ebbmr3481578lfs.429.1660982950073; Sat, 20
 Aug 2022 01:09:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220817143529.257908-1-dario.binacchi@amarulasolutions.com>
 <20220817143529.257908-2-dario.binacchi@amarulasolutions.com> <b851147b-6453-c19e-7c31-a9cf8f87c1a4@linaro.org>
In-Reply-To: <b851147b-6453-c19e-7c31-a9cf8f87c1a4@linaro.org>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Sat, 20 Aug 2022 10:08:58 +0200
Message-ID: <CABGWkvomGpo9zWi59YNYfRfzAZZ90D9_HaiVV3Gs_x_eQ59e5A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] dt-bindings: net: can: add STM32 bxcan DT bindings
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Thu, Aug 18, 2022 at 10:22 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 17/08/2022 17:35, Dario Binacchi wrote:
> > Add documentation of device tree bindings for the STM32 basic extended
> > CAN (bxcan) controller.
> >
> > Signed-off-by: Dario Binacchi <dariobin@libero.it>
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>
> You do not need two SoBs. Keep only one, matching the From field.

I started implementing this driver in my spare time, so my intention
was to keep track of it.

>
> > ---
> >
> >  .../devicetree/bindings/net/can/st,bxcan.yaml | 139 ++++++++++++++++++
> >  1 file changed, 139 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/can/st,bxcan.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/can/st,bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,bxcan.yaml
> > new file mode 100644
> > index 000000000000..f4cfd26e4785
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/can/st,bxcan.yaml
>
> File name like compatible, so st,stm32-bxcan-core.yaml (or some other
> name, see comment later)

>
> > @@ -0,0 +1,139 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/can/st,bxcan.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: STMicroelectronics bxCAN controller Device Tree Bindings
>
> s/Device Tree Bindings//

>
> > +
> > +description: STMicroelectronics BxCAN controller for CAN bus
> > +
> > +maintainers:
> > +  - Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > +
> > +allOf:
> > +  - $ref: can-controller.yaml#
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - st,stm32-bxcan-core
>
> compatibles are supposed to be specific. If this is some type of
> micro-SoC, then it should have its name/number. If it is dedicated
> device, is the final name bxcan core? Google says  the first is true, so
> you miss specific device part.

I don't know if I understand correctly, I hope the change in version 2
is what you requested.

>
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  resets:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    description:
> > +      Input clock for registers access
> > +    maxItems: 1
> > +
> > +  '#address-cells':
> > +    const: 1
> > +
> > +  '#size-cells':
> > +    const: 0
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - resets
> > +  - clocks
> > +  - '#address-cells'
> > +  - '#size-cells'
> > +
> > +additionalProperties: false
> > +
> > +patternProperties:
>
> This goes after "properties: in top level (before "required").
>
> > +  "^can@[0-9]+$":
> > +    type: object
> > +    description:
> > +      A CAN block node contains two subnodes, representing each one a CAN
> > +      instance available on the machine.
> > +
> > +    properties:
> > +      compatible:
> > +        enum:
> > +          - st,stm32-bxcan
>
> Why exactly do you need compatible for the child? Is it an entierly
> separate device?

I took inspiration from other drivers for ST microcontroller
peripherals (e. g. drivers/iio/adc/stm32-adc-core.c,
drivers/iio/adc/stm32-adc.c) where
some resources are shared between the peripheral instances. In the
case of CAN, master (CAN1) and slave (CAN2) share the registers for
configuring the filters and the clock.
In the core module you can find the functions about the shared
resources, while the childrens implement the driver.

>
> Comments about specific part are applied here as well.
>
> > +
> > +      master:
>
> Is this a standard property?

no

> I don't see it anywhere else. Non-standard
> properties require vendor prefix.

ok, you'll find it in V2.

Thanks and regards,
Dario

>
> > +        description:
> > +          Master and slave mode of the bxCAN peripheral is only relevant
> > +          if the chip has two CAN peripherals. In that case they share
> > +          some of the required logic, and that means you cannot use the
> > +          slave CAN without the master CAN.
> > +        type: boolean
> > +
> > +      reg:
> > +        description: |
> > +          Offset of CAN instance in CAN block. Valid values are:
> > +            - 0x0:   CAN1
> > +            - 0x400: CAN2
> > +        maxItems: 1
> > +
> > +      interrupts:
> > +        items:
> > +          - description: transmit interrupt
> > +          - description: FIFO 0 receive interrupt
> > +          - description: FIFO 1 receive interrupt
> > +          - description: status change error interrupt
> > +
> > +      interrupt-names:
> > +        items:
> > +          - const: tx
> > +          - const: rx0
> > +          - const: rx1
> > +          - const: sce
> > +
> > +      resets:
> > +        maxItems: 1
> > +
> > +      clocks:
> > +        description:
> > +          Input clock for registers access
> > +        maxItems: 1
> > +
> > +    additionalProperties: false
> > +
> > +    required:
> > +      - compatible
> > +      - reg
> > +      - interrupts
> > +      - resets
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/stm32fx-clock.h>
> > +    #include <dt-bindings/mfd/stm32f4-rcc.h>
> > +
> > +    can: can@40006400 {
> > +        compatible = "st,stm32-bxcan-core";
> > +        reg = <0x40006400 0x800>;
> > +        resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
> > +        clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN1)>;
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +        status = "disabled";
>
> No status in examples.
>
> > +
> > +        can1: can@0 {
> > +            compatible = "st,stm32-bxcan";
> > +            reg = <0x0>;
> > +            interrupts = <19>, <20>, <21>, <22>;
> > +            interrupt-names = "tx", "rx0", "rx1", "sce";
> > +            resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
> > +            master;
> > +            status = "disabled";
>
> No status in examples.
>
>
> > +        };
> > +
> > +        can2: can@400 {
> > +            compatible = "st,stm32-bxcan";
> > +            reg = <0x400>;
> > +            interrupts = <63>, <64>, <65>, <66>;
> > +            interrupt-names = "tx", "rx0", "rx1", "sce";
> > +            resets = <&rcc STM32F4_APB1_RESET(CAN2)>;
> > +            clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN2)>;
> > +            status = "disabled";
>
> No status in examples.
>
> > +        };
> > +    };
>
>
> Best regards,
> Krzysztof



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
