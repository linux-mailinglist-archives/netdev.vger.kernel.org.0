Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4247C565072
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiGDJIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiGDJIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:08:41 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FB6265A
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 02:08:38 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t25so14675700lfg.7
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 02:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oGNDCl3xbz89yHsXLL6sBYHqZXI1K+BhWsAL0ZkEsFc=;
        b=TupbwQza+6J6iVerLVWmqv8E3wm0w8p/FrXy3tIb8knjaqECQNOPplV4tLxQSlo9hR
         AHFDcBiLOQs7Od1rSazaVaF0y2I0HZpY+qZfttcF4+tXTaINAvCUVNfv9AOitgsD/0U6
         5+Iqt5eX1bpygi5Wl7RcRgTiQcsX4mOyNar0lOwEfX6vW89WZZfiBCQDWrPKxuVNvsvK
         z1Ha2V0xuJRuQdkmVLNDZOKyAO8YxXFQ0sGAUa8CWqps0xTh+XQ/og8JElMK42VG/4eD
         ro9CHuFL0dutYc2o2VJPiQTGqDQRBU8Bf19vd8BVebJe5egyXwCSSdWri8zsI+DFSeSd
         PCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oGNDCl3xbz89yHsXLL6sBYHqZXI1K+BhWsAL0ZkEsFc=;
        b=V/fpcj+tQfLwhoDVVCq9VOkzfxSTV25OAs1fD6V7DTNdsThz+D9H5ULLUUC3vypQ1e
         oRHa5XQSUDRz+iDB0+pMHJL8/NMfNHMxwMbSMiE9MUVXVzeoV4kScGzM5ZZ2TqIXU3Ss
         cSl7yDsrpn3P/wTPor7hsRsOfC5LNqlvNk4820H+36ptT0on+T1PRMh+uDiLQXA8GBsg
         8hBmAtlVgE+/xQtCM7tkrMmB+LviMZ9i5Ki2ykHcS1P4qVUfIPAz7VZlexPwwMl76F6d
         ZQ2/1kZyxKXGSEa1k1zB6DFSTzTKYaqwI9YfGAJsl/nevh+aQFndNKpZ+hp+rGhArLtg
         Gajg==
X-Gm-Message-State: AJIora/1wnFzSktkRlUM11AdRmDhFbik+JNWTIa3uRAg9gwV6MIeQ8B0
        0XEMJddGA+xmGL8zwJhZ/bNj/Q==
X-Google-Smtp-Source: AGRyM1tdqvHET1AdQnkMAFZqNA8EbWbSwsyPfxDvNoMg5dC9JD2C0sq7gBZUQPSOybW9JConCzkEBw==
X-Received: by 2002:a05:6512:3d86:b0:47f:9adc:cc27 with SMTP id k6-20020a0565123d8600b0047f9adccc27mr17770690lfv.608.1656925716970;
        Mon, 04 Jul 2022 02:08:36 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id v8-20020ac258e8000000b0047f6d20e424sm5032577lfo.55.2022.07.04.02.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 02:08:36 -0700 (PDT)
Message-ID: <404a0146-5e74-b0df-6e1a-c6a689e2c858@linaro.org>
Date:   Mon, 4 Jul 2022 11:08:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to json-schema
Content-Language: en-US
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
 <20220704075032.383700-2-biju.das.jz@bp.renesas.com>
 <ed032ae8-6a2b-b79f-d42a-6e96fe53a0d7@linaro.org>
 <OS0PR01MB5922ECBBEFF973867CC23B2786BE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <OS0PR01MB5922ECBBEFF973867CC23B2786BE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/07/2022 11:03, Biju Das wrote:
> Hi Krystof,
> 
> Thanks for the feedback.
> 
>> Subject: Re: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to json-
>> schema
>>
>> On 04/07/2022 09:50, Biju Das wrote:
>>> Convert the NXP SJA1000 CAN Controller Device Tree binding
>>> documentation to json-schema.
>>>
>>> Update the example to match reality.
>>>
>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>> ---
>>> v2->v3:
>>>  * Added reg-io-width is a required property for technologic,sja1000
>>>  * Removed enum type from nxp,tx-output-config and updated the
>> description
>>>    for combination of TX0 and TX1.
>>>  * Updated the example
>>> v1->v2:
>>>  * Moved $ref: can-controller.yaml# to top along with if conditional
>>> to
>>>    avoid multiple mapping issues with the if conditional in the
>> subsequent
>>>    patch.
>>> ---
>>>  .../bindings/net/can/nxp,sja1000.yaml         | 103 ++++++++++++++++++
>>>  .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
>>>  2 files changed, 103 insertions(+), 58 deletions(-)  create mode
>>> 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
>>>  delete mode 100644
>>> Documentation/devicetree/bindings/net/can/sja1000.txt
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
>>> b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
>>> new file mode 100644
>>> index 000000000000..d34060226e4e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
>>> @@ -0,0 +1,103 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) %YAML 1.2
>>> +---
>>> +$id:
>>> +
>>> +title: Memory mapped SJA1000 CAN controller from NXP (formerly
>>> +Philips)
>>> +
>>> +maintainers:
>>> +  - Wolfgang Grandegger <wg@grandegger.com>
>>> +
>>> +allOf:
>>> +  - $ref: can-controller.yaml#
>>> +  - if:
>>
>> The advice of moving it up was not correct. The allOf containing ref and
>> if:then goes to place like in example-schema, so before
>> additional/unevaluatedProperties at the bottom.
>>
>> Please do not introduce some inconsistent style.
> 
> There are some examples like[1], where allOf is at the top.
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.yaml?h=next-20220704

And they are wrong. There is always some incorrect code in the kernel,
but that's not argument to do it in incorrect way. The coding style is
here expressed in example-schema, so use this as an argument.

> 
> Marc, please let us know, if you still prefer allOf at the top.
> 
>>


Best regards,
Krzysztof
