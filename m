Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6427D51D20A
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 09:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389441AbiEFHTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 03:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389436AbiEFHS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 03:18:59 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071E018D
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 00:15:16 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id g6so12769784ejw.1
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 00:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BeRODHN5BKHdYqCpyT3vOELgLz8mBkeltgcKtiKMp4w=;
        b=g4TlTYxLR3HgIll7nXj0AF8/r89vyRr8TehXbuimjjfEYJccXGgABWYlPWVPZr3PYW
         g2VAiB6F3XUnbACivG4wyIHzNoFUNpjcaiA9kScMgL7fSMJzihnSNEqyOO88Apxph3/l
         G4URVFL2tqrQdjLTkPvZApvG0KAocTJPRzCwwj9ncv9ILchN5blI27jqGplvHCyVc/JH
         FbO529vOx597xt77lw6dgm5980DDVRJx2sLJcnexgLGqpMpEEZXImo9/n4+j2ZdTDIsX
         9jDzhNjlO/o/QZlfMpBHPfEUDB9P0gpwBGGu1/xrrq2mUVVgfSHqz7RXsiPCwJc3vAPI
         HAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BeRODHN5BKHdYqCpyT3vOELgLz8mBkeltgcKtiKMp4w=;
        b=E+R0UEk8X5kCbyjJo8js/w1dZ1GCUisg5OJkA6y+pABk+V+mC0DukJZh8vf2VPE8ep
         MwBuYo0VPjzoCWwmJvGCu5/IOP/MM25ljeJA6cYR5AfdodYArTOOmHV1UfCZsBbNe02i
         HmTY+8yl0KrENiqWyH+Chmv0uBJPhNVLdKN/KZwRM68GTfhwg2zjmi+ORpGbgUBV1X3h
         KpBX1laHac3sEXrBm7Zul+L2NYfSO252T9S9DcB7gwmt8nydsdiUnJgnO41I6fS2+CGr
         Peag4ZsL69jTVkJ8l1tD3mpFCoXOZ1y7phbTJpHOYm/HPaBNXkpj83/QxAaZ8wxd9VdB
         vRqA==
X-Gm-Message-State: AOAM533lljPSB5z/7DThqUn7xIYgK+FYU5JyztOZWAk0nBMGc2fBN+m9
        EA/niOVHy4jYquI4lAlSk98OWw==
X-Google-Smtp-Source: ABdhPJw+9MHfJJlxEEjx+RbBnEi8cHVQYqz5vIyQL24y5z6dfIvIfMX1LfWdV4dF8kIRqorulfWLkw==
X-Received: by 2002:a17:907:2da5:b0:6f4:7cd1:8cf5 with SMTP id gt37-20020a1709072da500b006f47cd18cf5mr1769503ejc.328.1651821314516;
        Fri, 06 May 2022 00:15:14 -0700 (PDT)
Received: from [192.168.0.223] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id w16-20020a170907271000b006f3ef214e42sm1559641ejk.168.2022.05.06.00.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 00:15:13 -0700 (PDT)
Message-ID: <ac70ae6d-7e1a-d6b9-e33e-793035d5606e@linaro.org>
Date:   Fri, 6 May 2022 09:15:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Aw: Re: [RFC v2] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
References: <20220505150008.126627-1-linux@fw-web.de>
 <6d45f060-85e6-f3ff-ef00-6c68a2ada7a1@linaro.org>
 <trinity-12061c77-38b6-4b56-bccd-3b54cf9dc0e8-1651819574078@3c-app-gmx-bs21>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <trinity-12061c77-38b6-4b56-bccd-3b54cf9dc0e8-1651819574078@3c-app-gmx-bs21>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2022 08:46, Frank Wunderlich wrote:
>>> +    const: 1
>>> +
>>> +  "#size-cells":
>>> +    const: 0
>>> +
>>> +  core-supply:
>>> +    description: |
>>
>> Drop | everywhere where it is not needed (so in all places, AFAICT)
> 
> is it necessary for multiline-descriptions or is indentation enough?

It's necessary only when YAML syntax characters appear in description or
when you want specific formatting.

https://elixir.bootlin.com/linux/v5.18-rc5/source/Documentation/devicetree/bindings/example-schema.yaml#L97

https://yaml-multiline.info/

>>> +
>>> +patternProperties:
>>
>> patternProperties go before allOf, just after regular properties.
> 
> after required, right?

properties do not go after required, so neither patternProperties
should. Something like: propertes -> patternProperties -> dependencies
-> required -> allOf -> additionalProperties -> examples

> 
>>> +  "^(ethernet-)?ports$":
>>> +    type: object
>>
>> Also on this level:
>>     unevaluatedProperties: false
> 
> this is imho a bit redundant because in dsa.yaml (which is included now after patternProperties)
> it is already set on both levels.

dsa.yaml does not set it on ethernet-ports.

> Adding it here will fail in examples because of size/address-cells which are already defined in dsa.yaml...
> so i need to define them here again.

You're right, it cannot be set here.

Best regards,
Krzysztof
