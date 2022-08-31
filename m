Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807585A88C3
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbiHaWF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiHaWF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:05:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B11205D7;
        Wed, 31 Aug 2022 15:05:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04D13B8237C;
        Wed, 31 Aug 2022 22:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C226FC433C1;
        Wed, 31 Aug 2022 22:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661983522;
        bh=TzIez7A+GlOxpxe2G1Xof/qj4dT4rxIABdfkD0ycrLo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ds1BBVUQSKZRrN6O0cGv6AyqTGOarBd82DTxtYSxWfoh9pKCxhe73bejk0CW5O4Jw
         uxU0m2GrbUjLdulihhhX9D6K7g04YMzrnq9VpfJ7gV9Q0csAUiC027fuQzLzl9yiW6
         Epr8sWYQXspoGf05CHu3GP4zRlVNGTRKKU1jMO49MXSX05FDPK80ly5vk4bn58XbgH
         RYBV9gPCniNGHcyin/w1Aid+OQnLF7rrTZSi3PyOz+/ETp2ERIwbZlcllSXzs3L2tR
         mSANHugQdi8bZKSm9GDWqHvDztvbPXyd33WP4qkcHaMhCWLdX+SffQPW7AYaCGjR8Q
         sFiLZJMU84aTg==
Received: by mail-ua1-f47.google.com with SMTP id s5so6015448uar.1;
        Wed, 31 Aug 2022 15:05:22 -0700 (PDT)
X-Gm-Message-State: ACgBeo0/r5dlo59t50vP+fJZtKa2VFCZ7W1cHvMpjgWqNsUnBREIGy+M
        nijCeCDcjhDQ78/NL1zC/YTmLEgiRf0mnwBP3Q==
X-Google-Smtp-Source: AA6agR6QISedWdqdW4pMMDODbhjnCHPnsvoYejPj3Khng8g3BoEvxFyb7qRaQklI2DQzPGGfE/hQoNQoWlOwcbCINoQ=
X-Received: by 2002:a9f:23ec:0:b0:39e:c54f:ffc7 with SMTP id
 99-20020a9f23ec000000b0039ec54fffc7mr7864716uao.17.1661983521722; Wed, 31 Aug
 2022 15:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220820082936.686924-1-dario.binacchi@amarulasolutions.com>
 <20220820082936.686924-2-dario.binacchi@amarulasolutions.com>
 <20220825211241.GA1688421-robh@kernel.org> <CABGWkvobb7yLdBZ+RsJ=oiRsgfmDo0DJ-pvnsFndUE0qRmoHOA@mail.gmail.com>
In-Reply-To: <CABGWkvobb7yLdBZ+RsJ=oiRsgfmDo0DJ-pvnsFndUE0qRmoHOA@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 31 Aug 2022 17:05:10 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKD33Bxoi88WAEECH9rn4AZjijXRoZemptirc-Ogs7-6w@mail.gmail.com>
Message-ID: <CAL_JsqKD33Bxoi88WAEECH9rn4AZjijXRoZemptirc-Ogs7-6w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] dt-bindings: net: can: add STM32 bxcan DT bindings
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-can@vger.kernel.org,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 2:27 AM Dario Binacchi
<dario.binacchi@amarulasolutions.com> wrote:
>
> Hi Rob,
>
> On Thu, Aug 25, 2022 at 11:12 PM Rob Herring <robh@kernel.org> wrote:
> >
> > On Sat, Aug 20, 2022 at 10:29:33AM +0200, Dario Binacchi wrote:
> > > Add documentation of device tree bindings for the STM32 basic extended
> > > CAN (bxcan) controller.
> > >
> > > Signed-off-by: Dario Binacchi <dariobin@libero.it>
> > > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > >
> > > ---
> > >
> > > Changes in v2:
> > > - Change the file name into 'st,stm32-bxcan-core.yaml'.
> > > - Rename compatibles:
> > >   - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
> > >   - st,stm32-bxcan -> st,stm32f4-bxcan
> > > - Rename master property to st,can-master.
> > > - Remove the status property from the example.
> > > - Put the node child properties as required.
> > >
> > >  .../bindings/net/can/st,stm32-bxcan.yaml      | 136 ++++++++++++++++++
> > >  1 file changed, 136 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> > > new file mode 100644
> > > index 000000000000..288631b5556d
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> > > @@ -0,0 +1,136 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/can/st,stm32-bxcan.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: STMicroelectronics bxCAN controller
> > > +
> > > +description: STMicroelectronics BxCAN controller for CAN bus
> > > +
> > > +maintainers:
> > > +  - Dario Binacchi <dario.binacchi@amarulasolutions.com>
> > > +
> > > +allOf:
> > > +  - $ref: can-controller.yaml#
> > > +
> > > +properties:
> > > +  compatible:
> > > +    enum:
> > > +      - st,stm32f4-bxcan-core
> > > +
> > > +  reg:
> > > +    maxItems: 1
> > > +
> > > +  resets:
> > > +    maxItems: 1
> > > +
> > > +  clocks:
> > > +    description:
> > > +      Input clock for registers access
> > > +    maxItems: 1
> > > +
> > > +  '#address-cells':
> > > +    const: 1
> > > +
> > > +  '#size-cells':
> > > +    const: 0
> > > +
> > > +additionalProperties: false
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - resets
> > > +  - clocks
> > > +  - '#address-cells'
> > > +  - '#size-cells'
> > > +
> > > +patternProperties:
> > > +  "^can@[0-9]+$":
> > > +    type: object
> > > +    description:
> > > +      A CAN block node contains two subnodes, representing each one a CAN
> > > +      instance available on the machine.
> > > +
> > > +    properties:
> > > +      compatible:
> > > +        enum:
> > > +          - st,stm32f4-bxcan
> > > +
> > > +      st,can-master:
> > > +        description:
> > > +          Master and slave mode of the bxCAN peripheral is only relevant
> > > +          if the chip has two CAN peripherals. In that case they share
> > > +          some of the required logic, and that means you cannot use the
> > > +          slave CAN without the master CAN.
> > > +        type: boolean
> > > +
> > > +      reg:
> > > +        description: |
> > > +          Offset of CAN instance in CAN block. Valid values are:
> > > +            - 0x0:   CAN1
> > > +            - 0x400: CAN2
> > > +        maxItems: 1
> > > +
> > > +      interrupts:
> > > +        items:
> > > +          - description: transmit interrupt
> > > +          - description: FIFO 0 receive interrupt
> > > +          - description: FIFO 1 receive interrupt
> > > +          - description: status change error interrupt
> > > +
> > > +      interrupt-names:
> > > +        items:
> > > +          - const: tx
> > > +          - const: rx0
> > > +          - const: rx1
> > > +          - const: sce
> > > +
> > > +      resets:
> > > +        maxItems: 1
> > > +
> > > +      clocks:
> > > +        description:
> > > +          Input clock for registers access
> > > +        maxItems: 1
> > > +
> > > +    additionalProperties: false
> > > +
> > > +    required:
> > > +      - compatible
> > > +      - reg
> > > +      - interrupts
> > > +      - resets
> > > +
> > > +examples:
> > > +  - |
> > > +    #include <dt-bindings/clock/stm32fx-clock.h>
> > > +    #include <dt-bindings/mfd/stm32f4-rcc.h>
> > > +
> > > +    can: can@40006400 {
> > > +        compatible = "st,stm32f4-bxcan-core";
> > > +        reg = <0x40006400 0x800>;
> > > +        resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
> > > +        clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN1)>;
> > > +        #address-cells = <1>;
> > > +        #size-cells = <0>;
> > > +
> >
> > Missing 'ranges'.
>
> In the file arch/arm/boot/dts/stm32f429.dtsi, I didn't find any other
> node using the 'ranges' property, so
> I didn't use it for the CAN node either.

If the child node is a memory mapped address, then you need 'ranges'.
Otherwise, things like of_iomap() don't work.

Looking at the above file, only efuse@1fff7800 and adc@40012000 seem
to be cases also missing 'ranges'.

Rob
