Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04ABC59C528
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiHVRjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbiHVRjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:39:52 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2063F332
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:39:50 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id l1so15767185lfk.8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=oZtQ/WFsgMHD1ADUx1lXU0GWvfCZk4DciPrC4xHBmeo=;
        b=ESNJlDwwLUrymdH68KLBiBoUbRDrU0LvEqC6sPEtHnwPtcOtngzkU78N0rz0NnYLij
         lsPZW+Z4Nq4PIUjlI6KYg6hG1Jg642JCGKGd4w8KCTiPq0cZl7NcIdxleU9M/fl7R5Aa
         0l53PozQ0tmUIUrN/lVXWv9O6JpyWDm1U5C12Pwe2ZtbUbvZVODgdxmfV3hxS0qNlDtQ
         2PiGETBptGNU2UUYw44vyFYRcwSmdRtMgRhK4gV8fWMicIqX9o5swC6ZG7dY50a6qzpb
         LhAyGA21Bze3OjYjn9NTddMLRPxDTM3Zv7YTrqhh3TqvEIAx25Sf8hJm4fN2BZCvGH0o
         poLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=oZtQ/WFsgMHD1ADUx1lXU0GWvfCZk4DciPrC4xHBmeo=;
        b=HzpWhMP5O5SRs5xauDSlOoOigvovakY4PejrThg6bjx2R+rVSsiIsjRzkiD2pm0qn/
         p6sLYV/tkBNpZZ56qrzmEe+l/iW58NdrznXeHLo7fnfy5WdgzJEcU6ZdD5aq0vYodhNS
         LqCkf+QqzmqIs6hkt5jvLTvk0c46XCzz+FUC9Yo44I9/GGdeBxS/XnYHDppv4MIikAz9
         H2TuFEbzB+ho6zbS8ELfUCX8JojODSs6kJxHqNOcWKCuQf+2zgldLU1XkdedIRUILv9Q
         5TsbAvoQPn5njtT35t9gur2FPlGa/R8p3c+SAgJ3bkqSJ3wHBzM70NrS8Xu4YaOeqMl3
         3UEw==
X-Gm-Message-State: ACgBeo11+m0Y9ixS9jXlM8WH7JmdXs6qORAY5g74b1PVHbaSVZuYNa6w
        QR/vn6UHLs/tqUhE2UEb21HBFQ==
X-Google-Smtp-Source: AA6agR4htFOFSAWl6c7BpunUIKLnmTFNLNG3Fia/CHZbF7Xxnrp6rEzVwwgfC7JJMb7eNB1tHyPLMQ==
X-Received: by 2002:ac2:4e6a:0:b0:492:f027:218e with SMTP id y10-20020ac24e6a000000b00492f027218emr763637lfs.676.1661189989298;
        Mon, 22 Aug 2022 10:39:49 -0700 (PDT)
Received: from [192.168.0.11] (89-27-92-210.bb.dnainternet.fi. [89.27.92.210])
        by smtp.gmail.com with ESMTPSA id p5-20020a05651238c500b0048a83336343sm2020168lft.252.2022.08.22.10.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 10:39:48 -0700 (PDT)
Message-ID: <d8db1648-edcd-3580-60d3-96ef91d6bbed@linaro.org>
Date:   Mon, 22 Aug 2022 20:39:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 1/4] dt-bindings: net: can: add STM32 bxcan DT
 bindings
Content-Language: en-US
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
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
References: <20220817143529.257908-1-dario.binacchi@amarulasolutions.com>
 <20220817143529.257908-2-dario.binacchi@amarulasolutions.com>
 <b851147b-6453-c19e-7c31-a9cf8f87c1a4@linaro.org>
 <CABGWkvomGpo9zWi59YNYfRfzAZZ90D9_HaiVV3Gs_x_eQ59e5A@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CABGWkvomGpo9zWi59YNYfRfzAZZ90D9_HaiVV3Gs_x_eQ59e5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2022 11:08, Dario Binacchi wrote:
> Hi Krzysztof,
> 
> On Thu, Aug 18, 2022 at 10:22 AM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> On 17/08/2022 17:35, Dario Binacchi wrote:
>>> Add documentation of device tree bindings for the STM32 basic extended
>>> CAN (bxcan) controller.
>>>
>>> Signed-off-by: Dario Binacchi <dariobin@libero.it>
>>> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>>
>> You do not need two SoBs. Keep only one, matching the From field.
> 
> I started implementing this driver in my spare time, so my intention
> was to keep track of it.

SoB is not related to copyrights. Keep personal copyrights (with/next to
work ones), but SoB is coming from a person and that's only one. Choose
one "person".

> 
>>
>>> ---
>>>
>>>  .../devicetree/bindings/net/can/st,bxcan.yaml | 139 ++++++++++++++++++
>>>  1 file changed, 139 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/net/can/st,bxcan.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/can/st,bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,bxcan.yaml
>>> new file mode 100644
>>> index 000000000000..f4cfd26e4785
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/can/st,bxcan.yaml
>>
>> File name like compatible, so st,stm32-bxcan-core.yaml (or some other
>> name, see comment later)
> 
>>
>>> @@ -0,0 +1,139 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/can/st,bxcan.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: STMicroelectronics bxCAN controller Device Tree Bindings
>>
>> s/Device Tree Bindings//
> 
>>
>>> +
>>> +description: STMicroelectronics BxCAN controller for CAN bus
>>> +
>>> +maintainers:
>>> +  - Dario Binacchi <dario.binacchi@amarulasolutions.com>
>>> +
>>> +allOf:
>>> +  - $ref: can-controller.yaml#
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - st,stm32-bxcan-core
>>
>> compatibles are supposed to be specific. If this is some type of
>> micro-SoC, then it should have its name/number. If it is dedicated
>> device, is the final name bxcan core? Google says  the first is true, so
>> you miss specific device part.
> 
> I don't know if I understand correctly, I hope the change in version 2
> is what you requested.

What is the name of the SoC, where this is in?

> 
>>
>>> +
>>> +  reg:
>>> +    maxItems: 1
>>> +
>>> +  resets:
>>> +    maxItems: 1
>>> +
>>> +  clocks:
>>> +    description:
>>> +      Input clock for registers access
>>> +    maxItems: 1
>>> +
>>> +  '#address-cells':
>>> +    const: 1
>>> +
>>> +  '#size-cells':
>>> +    const: 0
>>> +
>>> +required:
>>> +  - compatible
>>> +  - reg
>>> +  - resets
>>> +  - clocks
>>> +  - '#address-cells'
>>> +  - '#size-cells'
>>> +
>>> +additionalProperties: false
>>> +
>>> +patternProperties:
>>
>> This goes after "properties: in top level (before "required").
>>
>>> +  "^can@[0-9]+$":
>>> +    type: object
>>> +    description:
>>> +      A CAN block node contains two subnodes, representing each one a CAN
>>> +      instance available on the machine.
>>> +
>>> +    properties:
>>> +      compatible:
>>> +        enum:
>>> +          - st,stm32-bxcan
>>
>> Why exactly do you need compatible for the child? Is it an entierly
>> separate device?
> 
> I took inspiration from other drivers for ST microcontroller
> peripherals (e. g. drivers/iio/adc/stm32-adc-core.c,
> drivers/iio/adc/stm32-adc.c) where
> some resources are shared between the peripheral instances. In the
> case of CAN, master (CAN1) and slave (CAN2) share the registers for
> configuring the filters and the clock.
> In the core module you can find the functions about the shared
> resources, while the childrens implement the driver.

In both cases you refer to the driver, but we talk here about bindings
which are rather not related. So I repeat the question - is the child
entirely separate device which can be used in other devices?


Best regards,
Krzysztof
