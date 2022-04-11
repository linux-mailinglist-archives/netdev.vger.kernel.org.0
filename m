Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5256E4FB527
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 09:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245614AbiDKHog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 03:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245610AbiDKHof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 03:44:35 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B6D5599
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 00:42:22 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id q20so9329516wmq.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 00:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lwXiBSpe8uIxk+fI9dDr9NxVqCilKjnZ3dM6N+dvifc=;
        b=NO8ZZXsxGMZWS6SApm5O+5QyQusOp1n9cNqYdhifjLtO4uu60DNd0UiW72Lbc6dy1Y
         TKY7VO9XiNkPKjdq3NqmnXn2slMMbEosVbGRV5Z3qwwYCSPXRXBeC0h6OjWC6ily0snZ
         zXhQUR22kigSAS88spG8PvfW9MT1gjIEOdbxxqzoQOFyVQmZiCKFKyySAe+wcEr1Vv7k
         ToNJlkiPiBJw92YlNOdIJxn1cHIPRRcey+Hj/QlY20q9cEOEgVJnf/Kj7mm42glhYH2m
         XrwyxG5z07Q45s8xSReNkWv4uXRlexAJ2moDITeJHPU1zqHE0RVYOXgJW7eMBSX9OpFz
         fr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lwXiBSpe8uIxk+fI9dDr9NxVqCilKjnZ3dM6N+dvifc=;
        b=5bINRmy6ly4FU5Cx7A1mTt/WEgnpCP78PAWvJTHaU8LsuNTxB9qxEHqWwBk49Q/df0
         7k5kOoyIB3M87a2giY9jvHZn+fY4Y7Doj9YMnBrqz3y/01H0ook+Gsgo6AdxIlIutoY0
         DUejt8pGZBau1EH+Y4fByXCk1UnXOQpBjxYhK1FlDTjMOicK0v2oYJtJoGjLP91XCoeE
         jDH2/wA5G34knCKq/OyjCbbXtzD4S/HWuH8ez6X6d4BKWuHvBAAc74fsByKchMxfW+G0
         AQdRYYs/7XNncVxyRqLX+PopswovHA5N33rtA4udLttooO/Pw+TEFXwEucbADZ4ZuDHE
         ni5w==
X-Gm-Message-State: AOAM533wf5JH/rhfna0a8LhbYjNIOkJuMavdyXp+Gp3aX4MzN9jB3tBx
        CmeuDpTlMdC/P5597RmuHAjjlw==
X-Google-Smtp-Source: ABdhPJy0emhVTkd5BjOWeTHbwIeiUbsxkpqSesQg/UfrhLUzYYVUBz7CksqbJq0oHZop4yQg2cFGww==
X-Received: by 2002:a05:600c:4f82:b0:38c:9185:1ecd with SMTP id n2-20020a05600c4f8200b0038c91851ecdmr27418202wmq.130.1649662940760;
        Mon, 11 Apr 2022 00:42:20 -0700 (PDT)
Received: from [192.168.17.223] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id i19-20020a05600c355300b0038e1d69af52sm17239738wmq.7.2022.04.11.00.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 00:42:20 -0700 (PDT)
Message-ID: <b519690c-a487-e64c-86e1-bd37e38dc7a7@solid-run.com>
Date:   Mon, 11 Apr 2022 10:42:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/3] dt: adin: document clk-out property
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220410104626.11517-2-josua@solid-run.com>
 <d83be897-55ee-25d2-4048-586646cd7151@linaro.org>
 <bc0e507b-338b-8a86-1a7b-8055e2cf9a3a@solid-run.com>
 <e0511d39-7915-3ce1-60c7-9d7739f1b253@linaro.org>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <e0511d39-7915-3ce1-60c7-9d7739f1b253@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

\o/

Am 10.04.22 um 22:01 schrieb Krzysztof Kozlowski:
> On 10/04/2022 20:41, Josua Mayer wrote:
>>> Adjust subject prefix to the subsystem (dt-bindings, not dt, missing net).
>> Ack. So something like
>> dt-bindings: net: adin: document clk-out property
> Yes.
Great, I will have it changed in a future revision!
>>>> Signed-off-by: Josua Mayer <josua@solid-run.com>
>>>> ---
>>>>    Documentation/devicetree/bindings/net/adi,adin.yaml | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
>>>> index 1129f2b58e98..4e421bf5193d 100644
>>>> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
>>>> @@ -36,6 +36,11 @@ properties:
>>>>        enum: [ 4, 8, 12, 16, 20, 24 ]
>>>>        default: 8
>>>>    
>>>> +  adi,clk-out-frequency:
>>> Use types defined by the dtschema, so "adi,clk-out-hz". Then no need for
>>> type/ref.
>> That sounds useful, I was not aware. The only inspiration I used was the
>> at803x driver ...
>> It seemed natural to share the property name as it serves the same
>> purpose here.
> Indeed ar803x uses such property. In general reusing properties is a
> good idea, but not all properties are good enough to copy. I don't know
> why adi,clk-out-frequency got accepted because we really stick to common
> units when possible.
>
> https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/property-units.yaml
>
>>>> +    description: Clock output frequency in Hertz.
>>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>>> +    enum: [125000000]
>>> If only one value, then "const: 125000000", but why do you need such
>>> value in DT if it is always the same?
>> Yes yes yes.
>>   From my understanding of the adin1300 data-sheet, it can provide either
>> a 25MHz clock or a 125MHz clock on its GP_CLK pin. So for the context of
>> this feature we would have two options. However because we found the
>> documentation very confusing we skipped the 25MHz option.
>>
>> Actually my statement above omits some of the options.
>> - There are actually two 125MHz clocks, the first called "recovered" and
>> the second "free running".
>> - One can let the phy choose the rate based on its internal state.
>> This is indicated on page 73 of the datasheet
>> (https://www.analog.com/media/en/technical-documentation/data-sheets/adin1300.pdf)
>>
>> Because of this confusion we wanted to for now only allow selecting the
>> free-running 125MHz clock.
> Hm, so you do not insist on actual frequency but rather type of the
> clock (freerunning instead of recovered and 25 MHz). Then the frequency
> does not look enough because it does not offer you the choice of clock
> (freerunning or recovered) and instead you could have enum like:
>    adi,phy-output-clock:
>    $ref: /schemas/types.yaml#/definitions/string
>    enum: [125mhz-freerunning, 125mhz-recovered, 25mhz-freeruning....]
>
> Judging by page 24 you have 5 or more options... This could be also
> numeric ID (enum [0, 1, 2, 3 ...]) with some explanation, but strings
> seem easier to understand.

I agree that strings are more meaningful here, especially considering 
how each entry carries at least two pieces of information.
If we are not to reuse the qca,clk-out-frequency name, then an enum 
seems the easiest way to describe the available settings from the clock 
config register!

> The binding should describe the hardware, not implementation in Linux,
> therefore you should actually list all possible choices. The driver then
> can just return EINVAL on unsupported choices (or map them back to only
> one supported).

I have prepared a draft for the entries that should exist, it covers 
five of the 6 available bits. Maybe you can comment if this is 
understandable?

   adi,phy-output-clock:
     description: Select clock output on GP_CLK pin. Three clocks are 
available:
       A 25MHz reference, a free-running 125MHz and a recovered 125MHz.
       The phy can also automatically switch between the reference and the
       respective 125MHz clocks based on its internal state.
     $ref: /schemas/types.yaml#/definitions/string
     enum:
     - 25mhz-reference
     - 125mhz-free-running
     - 125mhz-recovered
     - adaptive-free-running
     - adaptive-recovered

Bit no. 3 (GE_REF_CLK_EN) is special in that it can be enabled 
independently from the 5 choices above,
and it controls a different pin. Therefore it deserves its own property, 
perhaps a flag or boolean adi,phy-output-ref-clock.
Any opinion if this should be added, or we can omit it completely?

sincerely
Josua Mayer
