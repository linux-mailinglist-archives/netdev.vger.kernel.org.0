Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822095A217E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244755AbiHZHMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245156AbiHZHMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:12:36 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4870BD2B2E
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:12:34 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m3so858222lfg.10
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=TsGga+p3/E9an7wI98rRb/MFwrywOK8BvinFvruEnr4=;
        b=P42W/vx34Oi+AYvrGS4jqaKlFDewTQhYL4ODI5SFqrhkKEDPUmG5xuyuoz6/7/3WvV
         bpYw1dlQLRoPG+DiwwlfJxCdGmlPdnf/UCBNIowzO+wyD8JVTESRd84prKTjzIryZqJi
         0maAw46JHNlMVTaDLJ5espB4KYWCgnXqPBKJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=TsGga+p3/E9an7wI98rRb/MFwrywOK8BvinFvruEnr4=;
        b=nNvGJr0/U84haEs2uqYLyea5np7cMxNI6pxDUfz3HC1k/9tkGcpvYrnjFPL8DZTv+C
         zjBWOmUU7S1AKcmBAr6PwXa3q/rf+RP1+RlZS/Bzo1OKTzd9fKQ+juEbDTC63MEnPlXq
         MgZbP3Lg+A2OmpAOwXWzvWYKBM4vLokOAcvz+W0uCUrg2kf1/X1Oz/qjZnEfBFVLVcLl
         sunBZfFCI4pJXcKkY7xU2UTP0jmxWMqmVWpXal3/e+jI38jCERjZiUMiyGZ44CAvrs1d
         e3nGkWVw9PUdW+96O/MpOiVodeax4TXSiV0I9Q52JphxtjzDQEqiNU5NRBxgmELO6EEb
         0YFg==
X-Gm-Message-State: ACgBeo3VlgIK1I1pFlrjw6mylSQeW84327dxbtVkwP1JqU55NOZ6Vf2w
        OZlANmDV9B6U1tX6sIDXC6uC/XZtT/Eok2AiFjUA2Q==
X-Google-Smtp-Source: AA6agR7CkxZMhLsDqNufa2XQws9YeFkWd1TvveuOauUFwiJpdK+2brKqI5N9qCf01ayFkWEcv+/FL2+Q6RobfuyrFxU=
X-Received: by 2002:a05:6512:1585:b0:48d:158:7013 with SMTP id
 bp5-20020a056512158500b0048d01587013mr2305322lfb.536.1661497952481; Fri, 26
 Aug 2022 00:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220820082936.686924-1-dario.binacchi@amarulasolutions.com>
 <20220820082936.686924-2-dario.binacchi@amarulasolutions.com> <fe2041cc-dd8b-6695-1fc8-6c1c49dd7220@linaro.org>
In-Reply-To: <fe2041cc-dd8b-6695-1fc8-6c1c49dd7220@linaro.org>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Fri, 26 Aug 2022 09:12:21 +0200
Message-ID: <CABGWkvrdqE=1JpOvzs9u9j_gYFsDuKQ92ruzwc=CJQBB5jaj4g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] dt-bindings: net: can: add STM32 bxcan DT bindings
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Aug 23, 2022 at 3:41 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 20/08/2022 11:29, Dario Binacchi wrote:
> > Add documentation of device tree bindings for the STM32 basic extended
> > CAN (bxcan) controller.
> >
> > Signed-off-by: Dario Binacchi <dariobin@libero.it>
> > Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> >
> > ---
> >
> > Changes in v2:
> > - Change the file name into 'st,stm32-bxcan-core.yaml'.
> > - Rename compatibles:
> >   - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
> >   - st,stm32-bxcan -> st,stm32f4-bxcan
> > - Rename master property to st,can-master.
> > - Remove the status property from the example.
> > - Put the node child properties as required.
> >
> >  .../bindings/net/can/st,stm32-bxcan.yaml      | 136 ++++++++++++++++++
> >  1 file changed, 136 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-=
bxcan.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.y=
aml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> > new file mode 100644
> > index 000000000000..288631b5556d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> > @@ -0,0 +1,136 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/can/st,stm32-bxcan.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: STMicroelectronics bxCAN controller
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
> > +      - st,stm32f4-bxcan-core
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
> > +additionalProperties: false
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - resets
> > +  - clocks
> > +  - '#address-cells'
> > +  - '#size-cells'
> > +
> > +patternProperties:
>
> No improvements here, so my comment stay. Please fix it.

Sorry, I'ff fix it in version 3.

>
>
> > +  "^can@[0-9]+$":
> > +    type: object
> > +    description:
> > +      A CAN block node contains two subnodes, representing each one a =
CAN
> > +      instance available on the machine.
>
> I still do not understand why you need children. You did not CC me on
> driver change, so difficult to say. You did not describe the parent

On the next submissions I'll send you all the series patches.

> device - there is no description.

Ok, I'll do it.

> Why do you need parent device at all?
> This looks like some driver-driven-bindings instead of just real
> hardware description.

The two devices are not independent.
As described in the reference manual RM0386 (STM32F469xx and STM32F479xx
advanced Arm=C2=AE-based 32-bit MCUs) in paragraph 34.2, the bxCAN controll=
er is a
dual CAN peripheral configuration:

=E2=80=A2 CAN1: Master bxCAN for managing the communication between a Slave=
 bxCAN and
the 512-byte SRAM memory
=E2=80=A2 CAN2: Slave bxCAN, with no direct access to the SRAM memory.

So, if I want to use CAN2 only (and not CAN1), I need to be able to use sha=
red
resources with CAN1 without having to probe the CAN1 driver. IMHO here is t=
he
justification of the parent node.

Thanks and regards,
Dario

>
> Best regards,
> Krzysztof



--=20

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
