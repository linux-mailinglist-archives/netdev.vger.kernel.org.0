Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F153F64B09B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 08:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiLMHuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 02:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiLMHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 02:50:21 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59DA13D04
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:50:19 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id b9so2469202ljr.5
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 23:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7iZB0Z1Q5CE+H3OL4aZrZbM8R0KsjYsEMH0TW8UzXLo=;
        b=VPae7pDsz+OQHASONsyLL23oKLeCq2/hkZrhrJKVwBS2UrCgfjoPYWO7OR77Ps4zSI
         RJMwGYp//01hUOVf74fsPbAabFJd4jy2gnmTjf0IYMRl88HUUjxHwDeif5XZijisqL09
         TLPcDXJkJOdLSr3Eg0z2sjQgbRJxzwdyDhDKbhdE/2H33XA0+hYIOozldeP5SAFDgTSR
         sPUYXDzigHShg8WF7ieOiUc3ZXcQaxlvI5NroJrQ8HVg9vHS0ZApd7W5gqRUR7V3rn/f
         z2oAzHkU7KQwUg+ofy1tlhOwX8u3X2HZ3GC/A5S+HSpMQLUG2VmsEz8PQmiFFWn6J927
         LZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7iZB0Z1Q5CE+H3OL4aZrZbM8R0KsjYsEMH0TW8UzXLo=;
        b=ffSBtwSYgMCoCimliOMJNxiWAgFvPaf44nz1ytLuKesLzfduiWGDFQozo7eEYc1JMK
         XTexpog/s7fz2zW89PwSucY68f4MzJDACL5aDpcqBeF4BEFXtinouHbGjsI0GTk4NTlR
         SDQuEon72lIU8ghUtsvAqbs6AM8om8OQmnHzFHO88RL1N70dcWNXoJNVTHCtBxBwxrUa
         j6kp0gMiKVPePiGGggXvsQeBS00cbKdTfuFOWm7O+ucoZUtwgM65MGfFc5XBhbElN7VY
         oMqitp4KJnlk5nxUuJgB2UuBKarYgH5Eju6ZHw4T5XAL1aCdoUInbkOJW3CfikFGFPgM
         6a8w==
X-Gm-Message-State: ANoB5plcuXxMSz83ymgvA2bf9TiHPF0XszrwKv0sKx0KeBLQhE5u9NIw
        1hxV9zTI2CGpRF2ZB6Bx8+AW8Q==
X-Google-Smtp-Source: AA0mqf5nxUYPiaQbarDHk5mufFAu/s0JMQQ1bzvU3duUeUWzup6xGLcqzdZt01PaJVdzC5yyUd/YPA==
X-Received: by 2002:a2e:b634:0:b0:27a:131:2649 with SMTP id s20-20020a2eb634000000b0027a01312649mr4812473ljn.35.1670917818055;
        Mon, 12 Dec 2022 23:50:18 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id s1-20020a05651c048100b0027710117ebdsm167406ljc.121.2022.12.12.23.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 23:50:17 -0800 (PST)
Message-ID: <49834ea3-7fc2-d2cf-36a7-b509d36f260f@linaro.org>
Date:   Tue, 13 Dec 2022 08:50:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
To:     Chester Lin <clin@suse.com>
Cc:     =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>,
        ghennadi.procopciuc@oss.nxp.com
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-3-clin@suse.com>
 <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
 <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
 <9778695f-f8a9-e361-e28f-f99525c96689@linaro.org>
 <Y42jqDiiq+rOurV+@linux-8mug>
 <3908e923-a063-0377-1854-ccbb3ecc704d@linaro.org>
 <Y5fnjhugp8cQSzwM@linux-8mug>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y5fnjhugp8cQSzwM@linux-8mug>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/12/2022 03:46, Chester Lin wrote:
> Hi Krzysztof,
> 
> Sorry for the late reply.
> 
> On Mon, Dec 05, 2022 at 09:55:40AM +0100, Krzysztof Kozlowski wrote:
>> On 05/12/2022 08:54, Chester Lin wrote:
>>>>>>> +examples:
>>>>>>> +  - |
>>>>>>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>>>>>>> +    #include <dt-bindings/interrupt-controller/irq.h>
>>>>>>> +
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_AXI
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_PCS
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_PCS
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
>>>>>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TS
>>>>>>
>>>>>> Why defines? Your clock controller is not ready? If so, just use raw
>>>>>> numbers.
>>>>>
>>>>> Please compare v1: There is no Linux-driven clock controller here but 
>>>>> rather a fluid SCMI firmware interface. Work towards getting clocks into 
>>>>> a kernel-hosted .dtsi was halted in favor of (downstream) TF-A, which 
>>>>> also explains the ugly examples here and for pinctrl.
>>>>
>>>> This does not explain to me why you added defines in the example. Are
>>>> you saying these can change any moment?
>>>>
>>>
>>> Actually these GMAC-related SCMI clock IDs changed once in NXP's downstream TF-A,
>>> some redundant TS clock IDs were removed and the rest of clock IDs were all moved
>>> forward. 
>>
>> This is not accepted. Your downstream TF-A cannot change bindings. As an
>> upstream contributor you should push this back and definitely not try to
>> upstream such approach.
>>
>>> Apart from GMAC-related IDs, some other clock IDs were also appended
>>> in both base-clock IDs and platform-specific clock IDs [The first plat ID =
>>> The last base ID + 1]. Due to the current design of the clk-scmi driver and the
>>> SCMI clock protocol, IIUC, it's better to keep all clock IDs in sequence without
>>> a blank in order to avoid query miss, which could affect the probe speed.
>>
>> You miss here broken ABI! Any change in IDs causes all DTBs to be
>> broken. Downstream, upstream, other projects, everywhere.
>>
>> Therefore thank you for clarifying that we need to be more careful about
>> stuff coming from (or for) NXP. Here you need to drop all defines and
>> all your patches must assume the ID is fixed. Once there, it's
>> unchangeable without breaking the ABI.
>>
> 
> Please accept my apologies for submitting these bad patches. We were just
> confused since we thought that this approach might be acceptable because
> there were some similar examples got merged in the kernel tree:

How are these related to the talk of ABI break?

> 
> https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/net/intel,dwmac-plat.yaml#L57
> https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/usb/intel,keembay-dwc3.yaml#L55
> https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/sound/intel,keembay-i2s.yaml#L73
> https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/pwm/intel,keembay-pwm.yaml#L39
> https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/watchdog/intel,keembay-wdt.yaml#L46
> https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/pci/intel,keembay-pcie.yaml#L75
> https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/mmc/arasan,sdhci.yaml#L282

How are these even relevant here? The support for this platform is
incomplete, right? These are just few scattered pieces - only bindings -
without drivers and DTS. It proves nothing. You cannot take some
incomplete platform and build on top of it theory that you can keep
changing ABI!

And anyway it is entirely independent problem. You just said you want to
change defines which is not allowed. ABI break. No one changes the
Keembay defines, whatever they are (you even do not know what they are...).

> 
> The defines in these yaml files are not actually referred by kernel DTs or
> drivers so I assume that they should be provided by firmware as pure integer
> numbers and the clk-scmi driver should just take them to ask firmware for doing
> clk stuff.


Best regards,
Krzysztof

