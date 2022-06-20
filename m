Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6D85523C6
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245304AbiFTSV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243351AbiFTSVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:21:25 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9571DA67
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 11:21:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id kq6so22673295ejb.11
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 11:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JKrFM89GcLLmQzO5VtM/39MP/BwY1t9bzpGPMCQw5cw=;
        b=kplp5cKbDB4UPvO89H/A/gMYJqBuSsiENMl2dskLkx4cnEtB1U4mlYuoocCqWv+LMQ
         P7We1BghIcsWReR1qfdnKoBkV9bQYm5iOQjK4OYwkZiGDBLxqkgnuJ8pxP/mfXGc0uE8
         04TZae6y4SRfjIdZrRDIEz84dXla2/8MvhE/ll9g+JNUHmfGecQFsSnkniVHe75jJyU3
         8IJM3M4JSdAzn2GhwbDJGiLKkF2PU/EvtDaEwNIGqSo1wgn1NVZ814cBQJsyde1oaVNi
         qrjy43nkNKsqadU5X6wup/pBp/yoQVBWX6RBvGbqp6z+TfU6LxOHMBD0r25y0asFHzpn
         sDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JKrFM89GcLLmQzO5VtM/39MP/BwY1t9bzpGPMCQw5cw=;
        b=cSTUrNxh/3XpIRwMDtbeRCyRRflTjrmZjEAOkG53OFnz5Es3bI1+d330ufW7dpD58d
         YHQKMcSFa0UjXj2gq9EjNZjcSSUdZBMnUDouOdP7HesDjK3LGWvqJGyzmpAMtrQ1yxki
         /4hUGiXNuUG/coHDV+5KNup6nJnEFV11GUcaMffTZy5PplfAQmRVuNDEoAHijafuL+pM
         556MY6QFBPhB13op894peS5qwaE3ZwwMiEMKbU0p8zPfNhU1De+aXxenyBKVixr2ZwyF
         rstCtn10NKERD5K9DjzzZD8tegcro/bCBSilJS2qwRlZ+etgwqKnxMWwwO+FwBR3vKdn
         IglA==
X-Gm-Message-State: AJIora/GcmzP8e/RcYBCFPqMMQnisKk/YzysdCjhGc+49BKT7D5FS8Dd
        aif/1gu8VvFE6RNrUqvH+VGfOg==
X-Google-Smtp-Source: AGRyM1uU+h0eNcLepUwfCZPxnKsoOuZISOXhWBa6OpWpG2eHFKz1yGXrq/lIFbv+++FWA/ArNtVRhw==
X-Received: by 2002:a17:907:2d13:b0:711:b149:5272 with SMTP id gs19-20020a1709072d1300b00711b1495272mr22450007ejc.326.1655749282114;
        Mon, 20 Jun 2022 11:21:22 -0700 (PDT)
Received: from [192.168.0.211] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id c18-20020a05640227d200b0042617ba6396sm11332328ede.32.2022.06.20.11.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 11:21:21 -0700 (PDT)
Message-ID: <e922714b-29c7-0f41-9e5c-9a0aef9fb5de@linaro.org>
Date:   Mon, 20 Jun 2022 20:21:19 +0200
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
 <16684442-35d4-df51-d9f7-4de36d7cf6fd@linaro.org>
 <50fa16ce-ac24-8e4c-5d81-0218535cd05c@seco.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <50fa16ce-ac24-8e4c-5d81-0218535cd05c@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/06/2022 19:19, Sean Anderson wrote:
> 
> 
> On 6/20/22 6:54 AM, Krzysztof Kozlowski wrote:
>> On 19/06/2022 17:53, Sean Anderson wrote:
>>>>>
>>>>>>> +          The first lane in the group. Lanes are numbered based on the register
>>>>>>> +          offsets, not the I/O ports. This corresponds to the letter-based
>>>>>>> +          ("Lane A") naming scheme, and not the number-based ("Lane 0") naming
>>>>>>> +          scheme. On most SoCs, "Lane A" is "Lane 0", but not always.
>>>>>>> +        minimum: 0
>>>>>>> +        maximum: 7
>>>>>>> +      - description: |
>>>>>>> +          Last lane. For single-lane protocols, this should be the same as the
>>>>>>> +          first lane.
>>>>>>> +        minimum: 0
>>>>>>> +        maximum: 7
>>>>>>> +
>>>>>>> +  compatible:
>>>>>>> +    enum:
>>>>>>> +      - fsl,ls1046a-serdes-1
>>>>>>> +      - fsl,ls1046a-serdes-2
>>>>>>
>>>>>> Does not look like proper compatible and your explanation from commit
>>>>>> msg did not help me. What "1" and "2" stand for? Usually compatibles
>>>>>> cannot have some arbitrary properties encoded.
>>>>>
>>>>> Each serdes has a different set of supported protocols for each lane. This is encoded
>>>>> in the driver data associated with the compatible
>>>>
>>>> Implementation does not matter.
>>>
>>> Of *course* implementation matters. Devicetree bindings do not happen in a vacuum. They
>>> describe the hardware, but only in service to the implementation.
>>
>> This is so not true. > Bindings do not service implementation. Bindings
>> happen in vacuum
> 
> Where are all the bindings for hardware without drivers?
> 
> Why don't device trees describe the entire hardware before any drivers are written?
> 
> Actually, I have seen some device trees written like that (baked into the chip's ROM),
> and they cannot be used because the bindings
> 
> - Do not fully describe the hardware (e.g. clocks, resets, interrupts, and other things)
> - Do not describe the hardware in a compatible way (e.g. using different names for
>   registers and clocks, or ordering fields differently).
> - Contain typos and errors (since they were never used)
> 
> These same issues apply to any new binding documentation. Claiming that bindings happen
> in a vacuum is de facto untrue, and would be unsound practice if it wasn't.
> 
>> because they are used by different implementations:
>> Linux, u-Boot, BSD and several other quite different systems.
> 
> U-Boot doesn't use devicetree for this device (and if it did the port would likely be
> based on the Linux driver). BSD doesn't support this hardware at all. We are the first
> to create a driver for this device, so we get to choose the binding.

You choose the binding in respect to the guidelines. You cannot choose
some random weirdness just because you are first. It does not matter
that there are no other implementations in that way - you must choose
reasonable bindings.

> 
>> Any references to implemention from the bindings is questionable,
>> although of course not always wrong.
>>
>> Building bindings per specific implementation is as well usually not
>> correct.
> 
> Sure, but there are of course many ways to create bindings, even for the same hardware.
> As an example, pinctrl bindings can be written like
> 
> pinctrl@cafebabe {
> 	uart-tx {
> 		function = "uart-tx";
> 		pins = "5";
> 	};
> };
> 
> or
> 
> pinctrl@deadbeef {
> 	uart-tx {
> 		pinmux = <SOME_MACRO(5, UART_TX)>;
> 	};
> };
> 
> or
> 
> pinctrl@d00dfeed {
> 	uart-tx {
> 		pinmux = <SOME_MACRO(5, FUNC3)>;
> 	};
> };
> 
> and which one to use depends both on the structure of the hardware, as well as the
> driver. These bindings require a different driver style under the hood, and using
> the wrong binding can unnecessarily complicate the driver for no reason.
> 
> To further beat home the point, someone might use a "fixed-clock" to describe a clock
> and then later change to a more detailed implementation. They could use "simple-pinctrl"
> and then later move to a device-specific driver. 
> 
> If the devicetree author is smart, then they will create a binding like
> 
> clock {
> 	compatible = "vendor,my-clock", "fixed-clock";
> 	...
> };
> 
> so that better support might be added in the future. In fact, that is *exactly* what I
> am suggesting here.
> 
>>>
>>>>> , along with the appropriate values
>>>>> to plug into the protocol control registers. Because each serdes has a different set
>>>>> of supported protocols
>>>>
>>>> Another way is to express it with a property.
>>>>
>>>>> and register configuration,
>>>>
>>>> What does it mean exactly? The same protocols have different programming
>>>> model on the instances?
>>>
>>> (In the below paragraph, when I say "register" I mean "register or field within a
>>> register")
>>>
>>> Yes. Every serdes instance has a different way to program protocols into lanes. While
>>> there is a little bit of orthogonality (the same registers are typically used for the
>>> same protocols), each serdes is different. The values programmed into the registers are
>>> unique to the serdes, and the lane which they apply to is also unique (e.g. the same
>>> register may be used to program a different lane with a different protocol).
>>
>> That's not answering the point here, but I'll respond to the later
>> paragraph.
>>
>>>
>>>>> adding support for a new SoC will
>>>>> require adding the appropriate configuration to the driver, and adding a new compatible
>>>>> string. Although most of the driver is generic, this critical portion is shared only
>>>>> between closely-related SoCs (such as variants with differing numbers of cores).
>>>>>
>>>>
>>>> Again implementation - we do not talk here about driver, but the bindings.
>>>>
>>>>> The 1 and 2 stand for the number of the SerDes on that SoC. e.g. the documentation will
>>>>> refer to SerDes1 and SerDes2.
>>>>>    
>>>>> So e.g. other compatibles might be
>>>>>
>>>>> - fsl,ls1043a-serdes-1 # There's only one serdes on this SoC
>>>>> - fsl,t4042-serdes-1 # This SoC has four serdes
>>>>> - fsl,t4042-serdes-2
>>>>> - fsl,t4042-serdes-3
>>>>> - fsl,t4042-serdes-4
>>>>
>>>> If the devices are really different - there is no common parts in the
>>>> programming model (registers) - then please find some descriptive
>>>> compatible. However if the programming model of common part is
>>>> consistent and the differences are only for different protocols (kind of
>>>> expected), this should be rather a property describing which protocols
>>>> are supported.
>>>>
>>>
>>> I do not want to complicate the driver by attempting to encode such information in the
>>> bindings. Storing the information in the driver is extremely common. Please refer to e.g.
>>
>> Yes, quirks are even more common, more flexible and are in general
>> recommended for more complicated cases. Yet you talk about driver
>> implementation, which I barely care.
>>
>>>
>>> - mvebu_comphy_cp110_modes in drivers/phy/marvell/phy-mvebu-cp110-comphy.c
>>> - mvebu_a3700_comphy_modes in drivers/phy/marvell/phy-mvebu-a3700-comphy.c
>>> - icm_matrix in drivers/phy/xilinx/phy-zynqmp.c
>>> - samsung_usb2_phy_config in drivers/phy/samsung/
>>
>> This one is a good example - where do you see there compatibles with
>> arbitrary numbers attached?
> 
> samsung_usb2_phy_of_match in drivers/phy/samsung/phy-samsung-usb2.c
> 
> There is a different compatible for each SoC variant. Each compatible selects a struct
> containing
> 
> - A list of phys, each with custom power on and off functions
> - A function which converts a rate to an arbitrary value to program into a register
> 
> This is further documented in Documentation/driver-api/phy/samsung-usb2.rst

Exactly, please follow this approach. Compatible is per different
device, e.g. different SoC variant. Of course you could have different
devices on same SoC, but "1" and "2" are not different devices.

> 
>>> - qmp_phy_init_tbl in drivers/phy/qualcomm/phy-qcom-qmp.c
>>>
>>> All of these drivers (and there are more)
>>>
>>> - Use a driver-internal struct to encode information specific to different device models.
>>> - Select that struct based on the compatible
>>
>> Driver implementation. You can do it in many different ways. Does not
>> matter for the bindings.
> 
> And because this both describes the hardware and is convenient to the implementation,
> I have chosen this way.
> 
>>>
>>> The other thing is that while the LS1046A SerDes are fairly generic, other SerDes of this
>>> type have particular restructions on the clocks. E.g. on some SoCs, certain protocols
>>> cannot be used together (even if they would otherwise be legal), and some protocols must
>>> use particular PLLs (whereas in general there is no such restriction). There are also
>>> some register fields which are required to program on some SoCs, and which are reserved
>>> on others.
>>
>> Just to be clear, because you are quite unspecific here ("some
>> protocols") - we talk about the same protocol programmed on two of these
>> serdes (serdes-1 and serdes-2 how you call it). Does it use different
>> registers?
> 
> Yes.
> 
>> Are some registers - for the same protocol - reserved in one version?
> 
> Yes.
> 
> For example, I excerpt part of the documentation for PCCR2 on the T4240:
> 
>> XFIa Configuration:
>> XFIA_CFG Default value set by RCW configuration.
>> This field must be 0 for SerDes 3 & 4
>> All settings not shown are reserved
>>
>> 00 Disabled
>> 01 x1 on Lane 3 to FM2 MAC 9
> 
> And here is part of the documentation for PCCR2 on the LS1046A:
> 
>> SATAa Configuration
>> All others reserved
>> NOTE: This field is not supported in every instance. The following table includes only
>>       supported registers.
>> Field supported in	Field not supported in
>> SerDes1_PCCR2		—
>> —			SerDes2_PCCR2
>>
>> 000b - Disabled
>> 001b - x1 on Lane 3 (SerDes #2 only)
> 
> And here is part of the documentation for PCCRB on the LS1046A:
> 
>> XFIa Configuration
>> All others reserved Default value set by RCW configuration.
>>
>> 000b - Disabled
>> 010b - x1 on Lane 1 to XGMIIa (Serdes #1 only)
> You may notice that
> 
> - For some SerDes on the same SoC, these fields are reserved

That all sounds like quite different devices, which indeed usually is
described with different compatibles. Still "xxx-1" and "xxx-2" are not
valid compatibles. You need to come with some more reasonable name
describing them. Maybe the block has revision or different model/vendor.

> - Between different SoCs, different protocols may be configured in different registers
> - The same registers may be used for different protocols in different SoCs (though
>   generally there are several general layouts)

Different SoCs give you different compatibles, so problem is solved and
that's not exactly argument for this case.

> - Fields have particular values which must be programmed
> 
> In addition, the documentation also says
> 
>> Reserved registers and fields must be preserved on writes.
> 
> All of these combined issues make it so that we need detailed, serdes-specific
> configuration. The easiest way to store this configuration is in the driver. This
> is consistent with *many* existing phy implementations. I would like to write a
> standard phy driver, not one twisted by unusual device tree requirements.

Sure.

> 
>>>
>>> There is, frankly, a large amount of variation between devices as implemented on different
>>> SoCs. 
>>
>> This I don't get. You mean different SoCs have entirely different
>> Serdes? Sure, no problem. We talk here only about this SoC, this
>> serdes-1 and serdes-2.
>>
>>> Especially because (AIUI) drivers must remain compatible with old devicetrees, I
>>> think using a specific compatible string is especially appropriate here. 
>>
>> This argument does not make any sense in case of new bindings and new
>> drivers, unless you build on top of existing implementation. Anyway no
>> one asks you to break existing bindings...
> 
> When there is a bug in the bindings how do you fix it? If I were to follow your suggested method, it would be difficult to determine the particular devices
> 
>>> It will give us
>>> the ability to correct any implementation quirks as they are discovered (and I anticipate
>>> that there will be) rather than having to determine everything up front.
>>
>> All the quirks can be also chosen by respective properties.
> 
> Quirks are *exactly* the sort of implementation-specific details that you were opposed to above.
> 
>> Anyway, "serdes-1" and "serdes-2" are not correct compatibles,
> 
> The compatibles suggested were "fsl,ls1046-serdes-1" and -2. As noted above, these are separate
> devices which, while having many similarities, have different register layouts and protocol
> support. They are *not* 100% compatible with each other. Would you require that clock drivers
> for different SoCs use the same compatibles just because they had the same registers, even though
> the clocks themselves had different functions and hierarchy?

You miss the point. Clock controllers on same SoC have different names
used in compatibles. We do not describe them as "vendor,aa-clk-1" and
"vendor,aa-clk-2".

Come with proper naming and entire discussion might be not valid
(although with not perfect naming Rob might come with questions). I
cannot propose the name because I don't know these hardware blocks and I
do not have access to datasheet.

Other way, if any reasonable naming is not possible, could be also to
describe the meaning of "-1" suffix, e.g. that it does not mean some
index but a variant from specification.

> 
> --Sean
> 
>> so my NAK
>> stays. These might be separate compatibles, although that would require
>> proper naming and proper justification (as you did not answer my actual
>> questions about differences when using same protocols). Judging by the
>> bindings and your current description (implementation does not matter),
>> this also looks like a property.


Best regards,
Krzysztof
