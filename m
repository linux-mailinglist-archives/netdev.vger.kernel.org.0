Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E51F4FAF9F
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 21:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbiDJTD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 15:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiDJTD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 15:03:26 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB3D4AE08
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 12:01:14 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bg10so26866374ejb.4
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 12:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ISi/SnvjpSpuz7Zhm3FlgCkEEz8Sf/dTAMDf5mrLVvg=;
        b=LIhlHJVJC9H1/Ks+cwykGtq69LgKMknCOnmbCQihSc3Y1xPvL+oVeO/Iu7U1ms+KRb
         uA8IRW38ag05wntauHnGDITn65iZPzZ/m98lzJVCUr1U6hMXL4uK6hkvjAgMYPaPxOKC
         6JIR1/dqcpcQa1OjMpyeXOpAmHF/t+THG/9JGkNIWZmCoMN+NwXCoxUZllywn+Pf6le9
         dIU3QDUwDNXqojmA3/48yGMiZ8M6SUzMWjHZBhYAjrZ0wnMcc85ixuWlt+hqHm3UhpMg
         E4hxGe9bTdGwrk/FA8sQ13/MMztoVJyZcf0i6SsWaOT7cWhE1l/nQw94VhTbZfOcGVce
         WEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ISi/SnvjpSpuz7Zhm3FlgCkEEz8Sf/dTAMDf5mrLVvg=;
        b=ShaWa7vZWwvEpa+ZXKcwT2iVBss/6ushm/3cB9K+5/CqELELFvP/Hz+MxtmWgrM9eE
         +VsGTUaypLQ4ulrIMIm8sL0mrvsh0jPL2bKN5q8q5iqEE6CXInr0xWkRhJdsYE1eCAsv
         eoLf4+lLpqA6ABrQVNEQfjNkaoOzEVrx2NCKb2bM/1J2MIEJonvp/uEQhg7K8TlV03Al
         BpWnDmgqWbwPC6CbWEsbfwCwbesqVr1gilpi6ZOMnIFxRCI7hiGG6JySFmDgews4z71N
         MYkQfjW64E3jDExM3J7u4kJs7tRX1zTAbZyrbXub1XFM0uEWbi8b7NJq+Cr2iRWeR8ux
         18Ag==
X-Gm-Message-State: AOAM530JqT/8KtugiGqew4Ppb9zkY0inXsd6+NyLSW7aWHFDZv7qdsT3
        KekF06crDeb/VryHsfE/ac876Q==
X-Google-Smtp-Source: ABdhPJyh7p2d+2K1jNHzN5ybDdJDJtFGMuhOEhMvn2gHOWV6C4XCVVU7b3YJERUgcz8Hjid3qSSx9g==
X-Received: by 2002:a17:907:1c8c:b0:6e0:eb0c:8ee8 with SMTP id nb12-20020a1709071c8c00b006e0eb0c8ee8mr27683258ejc.265.1649617273536;
        Sun, 10 Apr 2022 12:01:13 -0700 (PDT)
Received: from [192.168.0.191] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id wn10-20020a170907068a00b006e87d354452sm1427284ejb.29.2022.04.10.12.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 12:01:13 -0700 (PDT)
Message-ID: <e0511d39-7915-3ce1-60c7-9d7739f1b253@linaro.org>
Date:   Sun, 10 Apr 2022 21:01:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/3] dt: adin: document clk-out property
Content-Language: en-US
To:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <bc0e507b-338b-8a86-1a7b-8055e2cf9a3a@solid-run.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/04/2022 20:41, Josua Mayer wrote:
>>
>> Adjust subject prefix to the subsystem (dt-bindings, not dt, missing net).
> Ack. So something like
> dt-bindings: net: adin: document clk-out property

Yes.


>>> Signed-off-by: Josua Mayer <josua@solid-run.com>
>>> ---
>>>   Documentation/devicetree/bindings/net/adi,adin.yaml | 5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
>>> index 1129f2b58e98..4e421bf5193d 100644
>>> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
>>> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
>>> @@ -36,6 +36,11 @@ properties:
>>>       enum: [ 4, 8, 12, 16, 20, 24 ]
>>>       default: 8
>>>   
>>> +  adi,clk-out-frequency:
>> Use types defined by the dtschema, so "adi,clk-out-hz". Then no need for
>> type/ref.
> That sounds useful, I was not aware. The only inspiration I used was the 
> at803x driver ...
> It seemed natural to share the property name as it serves the same 
> purpose here.

Indeed ar803x uses such property. In general reusing properties is a
good idea, but not all properties are good enough to copy. I don't know
why adi,clk-out-frequency got accepted because we really stick to common
units when possible.

https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/property-units.yaml

>>> +    description: Clock output frequency in Hertz.
>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>> +    enum: [125000000]
>> If only one value, then "const: 125000000", but why do you need such
>> value in DT if it is always the same?
> Yes yes yes.
>  From my understanding of the adin1300 data-sheet, it can provide either 
> a 25MHz clock or a 125MHz clock on its GP_CLK pin. So for the context of 
> this feature we would have two options. However because we found the 
> documentation very confusing we skipped the 25MHz option.
> 
> Actually my statement above omits some of the options.
> - There are actually two 125MHz clocks, the first called "recovered" and 
> the second "free running".
> - One can let the phy choose the rate based on its internal state.
> This is indicated on page 73 of the datasheet
> (https://www.analog.com/media/en/technical-documentation/data-sheets/adin1300.pdf)
> 
> Because of this confusion we wanted to for now only allow selecting the 
> free-running 125MHz clock.

Hm, so you do not insist on actual frequency but rather type of the
clock (freerunning instead of recovered and 25 MHz). Then the frequency
does not look enough because it does not offer you the choice of clock
(freerunning or recovered) and instead you could have enum like:
  adi,phy-output-clock:
  $ref: /schemas/types.yaml#/definitions/string
  enum: [125mhz-freerunning, 125mhz-recovered, 25mhz-freeruning....]

Judging by page 24 you have 5 or more options... This could be also
numeric ID (enum [0, 1, 2, 3 ...]) with some explanation, but strings
seem easier to understand.

The binding should describe the hardware, not implementation in Linux,
therefore you should actually list all possible choices. The driver then
can just return EINVAL on unsupported choices (or map them back to only
one supported).


Best regards,
Krzysztof
