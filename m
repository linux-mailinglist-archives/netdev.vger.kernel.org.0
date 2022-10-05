Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F67C5F580A
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 18:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiJEQKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 12:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiJEQKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 12:10:08 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D7A20F4D
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 09:10:02 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 25so15960968lft.9
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 09:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=2w6hGoXebPoIegDYARuqnK05b0IdR9ODgaAioly0Ktc=;
        b=C9uRIYGiPgNOdG/lUp4vq9QDJVOR4kpvX5aDKIQVnibFvliDEOJ4KnLvGOG1m9bJYd
         0szSjcSBVI4G+rgLO1FFdzSLowVVZtXR960+drzUJqa9+vAwqZlbnxC+oFmReNECrr87
         LoOeSge12tNaO03Wjm1SSAd3Oz7S0bKmIEPZC1UsP029lbz9Mgjl6nkwk34tyepS5+Ig
         h46D9gElGJJXVxVROr2DPet/isIlK9P4qbulcMZzW3U7TdrOWC96wjvhCPa3uBf6cgUp
         EP3NirBLBATvOdFwT92cyKhafVRoVvatZebvZAeOW8UzUGMWJUnn+mg1E9SKUE9cJHw2
         CTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=2w6hGoXebPoIegDYARuqnK05b0IdR9ODgaAioly0Ktc=;
        b=bdPnXHg0tUNu5ksgMJv1xzzF3dlVds42I50Ja4V70ql3SWVu/wHrV+g7NswNcnv9Z6
         fwYZv2PIUjFZRynoP4Yol++CtxY+mkyyvDDXTKmmEQoW8vyfzCfgwceIqfOKIBN6nik1
         nSq+CFZdTw7A6Pc0sh8/8RzkbywEgS9huG5wuGdIVRhouABNTWihw/nst12eY+I5FGW7
         EYmUpq/INofRTNVJJ9T9mHQERPmTGG1VJ1L9g2J+XQPuP7sS/opo9zOZGPWhf7LumamB
         VHlkHRUPUgWXWNRPNHPEDW9sQqb39myzVcehWj1rJ7eELXJCYQZzS6u0s3CPsJt1qOQE
         jm/Q==
X-Gm-Message-State: ACrzQf0P40rIO4AGx2c1pj65R6EMC2uoP1yuI0Fu3wVvyVXsmq4ovxdh
        teOQotXBH1exH7znobRUlJavlQ==
X-Google-Smtp-Source: AMsMyM6u9Jcg5Bpj/vRbbdNruCLC22wal80+Yi7bGV9KAIQkiRtpJtngykChcOEuUs9jCtHFLrP4tA==
X-Received: by 2002:a19:3849:0:b0:49e:e07:5e7c with SMTP id d9-20020a193849000000b0049e0e075e7cmr198445lfj.357.1664986200532;
        Wed, 05 Oct 2022 09:10:00 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id y1-20020a2e4b01000000b0026bfadf87e3sm601871lja.20.2022.10.05.09.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 09:10:00 -0700 (PDT)
Message-ID: <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
Date:   Wed, 5 Oct 2022 18:09:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Yz2mSOXf68S16Xg/@colin-ia-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2022 17:44, Colin Foster wrote:
> On Wed, Oct 05, 2022 at 10:03:04AM +0200, Krzysztof Kozlowski wrote:
>> On 05/10/2022 02:08, Colin Foster wrote:
>>> Hi Krzysztof,
>>>
>>> On Tue, Oct 04, 2022 at 01:19:33PM +0200, Krzysztof Kozlowski wrote:
>>>> On 26/09/2022 02:29, Colin Foster wrote:
>>>>> The ocelot-ext driver is another sub-device of the Ocelot / Felix driver
>>>>> system, which currently supports the four internal copper phys.
>>>>>
>>>>> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
>>> ...
>>>>> +  # Ocelot-ext VSC7512
>>>>> +  - |
>>>>> +    spi {
>>>>> +        soc@0 {
>>>>
>>>> soc in spi is a bit confusing.
>>>>
>>>> Does it even pass the tests? You have unit address but no reg.
>>>
>>> I omitted those from the documentation. Rob's bot is usually quick to
>>> alert me when I forgot to run dt_binding_check and something fails
>>> though. I'll double check, but I thought everything passed.
>>>
>>>>
>>>>> +            compatible = "mscc,vsc7512";
>>>>
>>>>
>>>>> +            #address-cells = <1>;
>>>>> +            #size-cells = <1>;
>>>>> +
>>>>> +            ethernet-switch@0 {
>>>>> +                compatible = "mscc,vsc7512-switch";
>>>>> +                reg = <0 0>;
>>>>
>>>> 0 is the address on which soc bus?
>>>
>>> This one Vladimir brought up as well. The MIPS cousin of this chip
>>> is the VSC7514. They have exactly (or almost exactly) the same hardware,
>>> except the 7514 has an internal MIPS while the 7512 has an 8051.
>>>
>>> Both chips can be controlled externally via SPI or PCIe. This is adding
>>> control for the chip via SPI.
>>>
>>> For the 7514, you can see there's an array of 20 register ranges that
>>> all get mmap'd to 20 different regmaps.
>>>
>>> (Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml)
>>>
>>>     switch@1010000 {
>>>       compatible = "mscc,vsc7514-switch";
>>>       reg = <0x1010000 0x10000>,
>>>             <0x1030000 0x10000>,
>>>             <0x1080000 0x100>,
>>>             <0x10e0000 0x10000>,
>>>             <0x11e0000 0x100>,
>>>             <0x11f0000 0x100>,
>>>             <0x1200000 0x100>,
>>>             <0x1210000 0x100>,
>>>             <0x1220000 0x100>,
>>>             <0x1230000 0x100>,
>>>             <0x1240000 0x100>,
>>>             <0x1250000 0x100>,
>>>             <0x1260000 0x100>,
>>>             <0x1270000 0x100>,
>>>             <0x1280000 0x100>,
>>>             <0x1800000 0x80000>,
>>>             <0x1880000 0x10000>,
>>>             <0x1040000 0x10000>,
>>>             <0x1050000 0x10000>,
>>>             <0x1060000 0x10000>,
>>>             <0x1a0 0x1c4>;
>>>       reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
>>>             "port2", "port3", "port4", "port5", "port6",
>>>             "port7", "port8", "port9", "port10", "qsys",
>>>             "ana", "s0", "s1", "s2", "fdma";
>>>
>>>
>>> The suggestion was to keep the device trees of the 7512 and 7514 as
>>> similar as possible, so this will essentially become:
>>>     switch@71010000 {
>>>       compatible = "mscc,vsc7512-switch";
>>>       reg = <0x71010000 0x10000>,
>>>             <0x71030000 0x10000>,
>>>       ...
>>
>> I don't understand how your answer relates to "reg=<0 0>;". How is it
>> going to become 0x71010000 if there is no other reg/ranges set in parent
>> nodes. The node has only one IO address, but you say the switch has 20
>> addresses...
>>
>> Are we talking about same hardware?
> 
> Yes. The switch driver for both the VSC7512 and VSC7514 use up to ~20 regmaps
> depending on what capabilities it is to have. In the 7514 they are all
> memory-mapped from the device tree. While the 7512 does need these
> regmaps, they are managed by the MFD, not the device tree. So there
> isn't a _need_ for them to be here, since at the end of the day they're
> ignored.
> 
> The "reg=<0 0>;" was my attempt to indicate that they are ignored, but I
> understand that isn't desired. So moving forward I'll add all the
> regmaps back into the device tree.

You need to describe the hardware. If hardware has IO address space, how
does it matter that some driver needs or needs not something?

You mentioned that address space is mapped to regmaps. Regmap is Linux
specific implementation detail, so this does not answer at all about
hardware.

On the other hand, if your DTS design requires this is a child of
something else and by itself it does not have address space, it would be
understandable to skip unit address entirely... but so far it is still
confusing, especially that you use arguments related to implementation
to justify the DTS.

Best regards,
Krzysztof

