Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A664F55164A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbiFTKyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240737AbiFTKyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:54:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8852512A9D
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 03:54:05 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n20so13510649ejz.10
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 03:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hp2WGbyJPQrcYBr/XiNMK7doTTxfiplTJX+MgBeSAjk=;
        b=V8WuZTzz4RLhzrXaT34PRQdsAHlsY8b4gwm8fGjpLSJJOe6u3ktfPj/62DdTwHFl5k
         ADcxTvmNnD5PRE859vDuFkAown69AnrqSYdG3xAbvnZcdTnmxqo+BTfqM4Ofn0Bt3pEV
         ugXo2fWqMOsiBsbxbrLaa329Eh8tGnUKdjAO3gQo/QkW4djLKAsozmmt5uycJUUpeyv/
         SMjSLyz+91sntPIx0jV9KxbA9rk+z1J9790XIkDErj89KiRqcR8XqRsSLTh7vdDc1SjM
         3tugJYgoVw+PQMrWtRjy18m5Ej4ucOfMigWX7zhGB/ZWD355fhmECQKR4fyKO7uYSBnd
         yjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hp2WGbyJPQrcYBr/XiNMK7doTTxfiplTJX+MgBeSAjk=;
        b=ivQbyO/C9T24lQVT9S1f/sap8SZpxL4rnk/mxzGAeh2Clj1q5UXB06Ltsm69VPGxz+
         8IaHMqeSkAdtYq67g7MqtRj00lUgWbREgMEsM835qaGW7GkAKr2Zm4tMVNRPxeV26wYG
         RSGGr0o1t8cw6Ljecm+/+RK1E6kamcd3l/NbZrFLhUXB9PFxf+tBWBNQ/guFvsyxrPFX
         /545UQs3++b3QrSqyX0jfB+jlpTzJEvsW+o+OPsHJyNnbkxnahG5KIV8OiQwCNHoUHYA
         IFMxUJJ/EuqlP2er6KUwsPrDxziG60T3/BhzWOT6G4q2r3WXOfdAuERV5WmYSPB8q7ne
         z1Tw==
X-Gm-Message-State: AJIora9psHvZ6gohp2XL7pU+6WvpHoRH2NDgiFou0I1haCK4ygQpzTaP
        F9huZ4Yi4gMiwOIA0jQWTWi8ow==
X-Google-Smtp-Source: AGRyM1vta/B1wtP+ozKz/g12g4uYiSh9+ViwTSAraXtw87o3jK9uGbeGbfea9n+cTO//cMif3CbwAQ==
X-Received: by 2002:a17:907:6f07:b0:715:7e23:bbb7 with SMTP id sy7-20020a1709076f0700b007157e23bbb7mr19703837ejc.462.1655722444039;
        Mon, 20 Jun 2022 03:54:04 -0700 (PDT)
Received: from [192.168.0.209] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id y3-20020a056402358300b0042dc25fdf5bsm10214203edc.29.2022.06.20.03.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 03:54:03 -0700 (PDT)
Message-ID: <16684442-35d4-df51-d9f7-4de36d7cf6fd@linaro.org>
Date:   Mon, 20 Jun 2022 12:54:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 01/28] dt-bindings: phy: Add QorIQ SerDes binding
Content-Language: en-US
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-2-sean.anderson@seco.com>
 <110c4a4b-8007-1826-ee27-02eaedd22d8f@linaro.org>
 <535a0389-6c97-523d-382f-e54d69d3907e@seco.com>
 <d79239ce-3959-15f8-7121-478fc6d432e4@linaro.org>
 <e6ed314d-290f-ace5-b0ff-01a9a2edca88@seco.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <e6ed314d-290f-ace5-b0ff-01a9a2edca88@seco.com>
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

On 19/06/2022 17:53, Sean Anderson wrote:
>>>
>>>>> +          The first lane in the group. Lanes are numbered based on the register
>>>>> +          offsets, not the I/O ports. This corresponds to the letter-based
>>>>> +          ("Lane A") naming scheme, and not the number-based ("Lane 0") naming
>>>>> +          scheme. On most SoCs, "Lane A" is "Lane 0", but not always.
>>>>> +        minimum: 0
>>>>> +        maximum: 7
>>>>> +      - description: |
>>>>> +          Last lane. For single-lane protocols, this should be the same as the
>>>>> +          first lane.
>>>>> +        minimum: 0
>>>>> +        maximum: 7
>>>>> +
>>>>> +  compatible:
>>>>> +    enum:
>>>>> +      - fsl,ls1046a-serdes-1
>>>>> +      - fsl,ls1046a-serdes-2
>>>>
>>>> Does not look like proper compatible and your explanation from commit
>>>> msg did not help me. What "1" and "2" stand for? Usually compatibles
>>>> cannot have some arbitrary properties encoded.
>>>
>>> Each serdes has a different set of supported protocols for each lane. This is encoded
>>> in the driver data associated with the compatible
>>
>> Implementation does not matter.
> 
> Of *course* implementation matters. Devicetree bindings do not happen in a vacuum. They
> describe the hardware, but only in service to the implementation.

This is so not true. Bindings do not service implementation. Bindings
happen in vacuum, because they are used by different implementations:
Linux, u-Boot, BSD and several other quite different systems.

Any references to implemention from the bindings is questionable,
although of course not always wrong.

Building bindings per specific implementation is as well usually not
correct.

> 
>>> , along with the appropriate values
>>> to plug into the protocol control registers. Because each serdes has a different set
>>> of supported protocols
>>
>> Another way is to express it with a property.
>>
>>> and register configuration,
>>
>> What does it mean exactly? The same protocols have different programming
>> model on the instances?
> 
> (In the below paragraph, when I say "register" I mean "register or field within a
> register")
> 
> Yes. Every serdes instance has a different way to program protocols into lanes. While
> there is a little bit of orthogonality (the same registers are typically used for the
> same protocols), each serdes is different. The values programmed into the registers are
> unique to the serdes, and the lane which they apply to is also unique (e.g. the same
> register may be used to program a different lane with a different protocol).

That's not answering the point here, but I'll respond to the later
paragraph.

> 
>>> adding support for a new SoC will
>>> require adding the appropriate configuration to the driver, and adding a new compatible
>>> string. Although most of the driver is generic, this critical portion is shared only
>>> between closely-related SoCs (such as variants with differing numbers of cores).
>>>
>>
>> Again implementation - we do not talk here about driver, but the bindings.
>>
>>> The 1 and 2 stand for the number of the SerDes on that SoC. e.g. the documentation will
>>> refer to SerDes1 and SerDes2.
>>>    
>>> So e.g. other compatibles might be
>>>
>>> - fsl,ls1043a-serdes-1 # There's only one serdes on this SoC
>>> - fsl,t4042-serdes-1 # This SoC has four serdes
>>> - fsl,t4042-serdes-2
>>> - fsl,t4042-serdes-3
>>> - fsl,t4042-serdes-4
>>
>> If the devices are really different - there is no common parts in the
>> programming model (registers) - then please find some descriptive
>> compatible. However if the programming model of common part is
>> consistent and the differences are only for different protocols (kind of
>> expected), this should be rather a property describing which protocols
>> are supported.
>>
> 
> I do not want to complicate the driver by attempting to encode such information in the
> bindings. Storing the information in the driver is extremely common. Please refer to e.g.

Yes, quirks are even more common, more flexible and are in general
recommended for more complicated cases. Yet you talk about driver
implementation, which I barely care.

> 
> - mvebu_comphy_cp110_modes in drivers/phy/marvell/phy-mvebu-cp110-comphy.c
> - mvebu_a3700_comphy_modes in drivers/phy/marvell/phy-mvebu-a3700-comphy.c
> - icm_matrix in drivers/phy/xilinx/phy-zynqmp.c
> - samsung_usb2_phy_config in drivers/phy/samsung/

This one is a good example - where do you see there compatibles with
arbitrary numbers attached?

> - qmp_phy_init_tbl in drivers/phy/qualcomm/phy-qcom-qmp.c
> 
> All of these drivers (and there are more)
> 
> - Use a driver-internal struct to encode information specific to different device models.
> - Select that struct based on the compatible

Driver implementation. You can do it in many different ways. Does not
matter for the bindings.

> 
> The other thing is that while the LS1046A SerDes are fairly generic, other SerDes of this
> type have particular restructions on the clocks. E.g. on some SoCs, certain protocols
> cannot be used together (even if they would otherwise be legal), and some protocols must
> use particular PLLs (whereas in general there is no such restriction). There are also
> some register fields which are required to program on some SoCs, and which are reserved
> on others.

Just to be clear, because you are quite unspecific here ("some
protocols") - we talk about the same protocol programmed on two of these
serdes (serdes-1 and serdes-2 how you call it). Does it use different
registers? Are some registers - for the same protocol - reserved in one
version?

> 
> There is, frankly, a large amount of variation between devices as implemented on different
> SoCs. 

This I don't get. You mean different SoCs have entirely different
Serdes? Sure, no problem. We talk here only about this SoC, this
serdes-1 and serdes-2.

> Especially because (AIUI) drivers must remain compatible with old devicetrees, I
> think using a specific compatible string is especially appropriate here. 

This argument does not make any sense in case of new bindings and new
drivers, unless you build on top of existing implementation. Anyway no
one asks you to break existing bindings...

> It will give us
> the ability to correct any implementation quirks as they are discovered (and I anticipate
> that there will be) rather than having to determine everything up front.

All the quirks can be also chosen by respective properties.

Anyway, "serdes-1" and "serdes-2" are not correct compatibles, so my NAK
stays. These might be separate compatibles, although that would require
proper naming and proper justification (as you did not answer my actual
questions about differences when using same protocols). Judging by the
bindings and your current description (implementation does not matter),
this also looks like a property.


Best regards,
Krzysztof
