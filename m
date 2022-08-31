Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3515A783A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 09:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiHaH4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 03:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiHaH4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 03:56:14 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B30F12AD1
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:55:04 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id z20so13782541ljq.3
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=EjNp+7haJJSgy95sPk2VW8hRKYlROSxGZaohd5CN+EI=;
        b=CwqpdxtS9UCgIfqRkt6+aIZ0njmYiIrSHVdD82RbExYkj+ULE08yVapfltsyJ9hvSW
         Rb6AyDPrPUcT6w7doSdjava+dERXsqEeqkJ/OdD9iIWnhGyYr2pbtl8OVMc5f2KR9nKS
         Qejeur1bzAP74t/mQ82tyWDbqmUDC9AhxRI4X9KatAxvosA3H+xbR59V13PI2JEk8yY4
         qWl8JtRsZaoZqu2Oosv2IdDv4tHuE5U72Xa7zFNCUlFfBxSJzmT7ZvD/IY2EURuy74eP
         vqquwYSd+wYFYdE4xfwCK7GOhmxagKAy3tb2bHzXyZ0n2wc2lCB65CjuZc7jHCba/tZX
         bOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=EjNp+7haJJSgy95sPk2VW8hRKYlROSxGZaohd5CN+EI=;
        b=ZVzqwD1DhRF/uQ2MtcwxS3Vl8UoNzf9r5/bjWQnQcSO2xNbyL6AUncVg0Aelfpro0W
         rO3c8/gvcUb1+CRq9K4EyJPYZL0QQPOiRsZ7aW2ozgPHImXAbxkzVlHsXfGH8B3fYAuc
         RIzi9w71fAhtmS2c1WDDh2ymaX6t/fSwh0Y4W8Io2EThfkiFmxiTYUPG/mw46h1WcTMH
         x4jBgPqVIj27PiBYG07KFK+bgUluz9S4jloGjwZE463dh6p+cnYGxkFTSbnkNSVidJMl
         M2cpqFOA7mqaU11Ua0lDfeouYq+kwpZMuvIeo7Iuj8m+eWS2Rn/shtgGLGc9kurPu0f3
         19Ug==
X-Gm-Message-State: ACgBeo3DUU2EOON8z4JZla3u1jtcXeYn+1ZgRh36cAe44+EMnpi40TfQ
        UTSJbG8w4ioVUaXZAjTm1/MhYA==
X-Google-Smtp-Source: AA6agR5TonQq2egwGvsmAbtSJj7KC2P5OqTK7X6niXiRLekmSFrg4NY6LC2zIVdsJmcKXe2E6Q9IwA==
X-Received: by 2002:a2e:9d8b:0:b0:265:b87d:b43b with SMTP id c11-20020a2e9d8b000000b00265b87db43bmr3660954ljj.531.1661932501985;
        Wed, 31 Aug 2022 00:55:01 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id bn38-20020a05651c17a600b0025e778f6f13sm2030296ljb.4.2022.08.31.00.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 00:55:01 -0700 (PDT)
Message-ID: <ffe0e6a8-96ba-e5ed-70c9-f7c6cd9c9ade@linaro.org>
Date:   Wed, 31 Aug 2022 10:55:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1 08/14] dt-bindings: mtd: relax the nvmem compatible
 string
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-9-michael@walle.cc>
 <e0afa0fc-4718-2aa1-2555-4ebb2274850b@linaro.org>
 <c8aea3ecb0fcf08c42852f99a4f265b6@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <c8aea3ecb0fcf08c42852f99a4f265b6@walle.cc>
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

On 31/08/2022 10:48, Michael Walle wrote:
> Am 2022-08-31 09:37, schrieb Krzysztof Kozlowski:
>> On 26/08/2022 00:44, Michael Walle wrote:
>>> The "user-otp" and "factory-otp" compatible string just depicts a
>>> generic NVMEM device. But an actual device tree node might as well
>>> contain a more specific compatible string. Make it possible to add
>>> more specific binding elsewere and just match part of the compatibles
>>
>> typo: elsewhere
>>
>>> here.
>>>
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>> ---
>>>  Documentation/devicetree/bindings/mtd/mtd.yaml | 7 ++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/mtd/mtd.yaml 
>>> b/Documentation/devicetree/bindings/mtd/mtd.yaml
>>> index 376b679cfc70..0291e439b6a6 100644
>>> --- a/Documentation/devicetree/bindings/mtd/mtd.yaml
>>> +++ b/Documentation/devicetree/bindings/mtd/mtd.yaml
>>> @@ -33,9 +33,10 @@ patternProperties:
>>>
>>>      properties:
>>>        compatible:
>>> -        enum:
>>> -          - user-otp
>>> -          - factory-otp
>>> +        contains:
>>> +          enum:
>>> +            - user-otp
>>> +            - factory-otp
>>
>> This does not work in the "elsewhere" place. You need to use similar
>> approach as we do for syscon or primecell.
> 
> I'm a bit confused. Looking at
>    Documentation/devicetree/bindings/arm/primecell.yaml
> it is done in the same way as this binding.

Yes. primecell is like your mtd here. And how are other places with
primcell (like other places with user-otp) done?

> 
> Whereas, the syscon use a "select:" on top of it. I'm
> pretty sure, I've tested it without the select and the
> validator picked up the constraints.
> 
> Could you elaborate on what is wrong here? Select missing?

You got warning from Rob, so run tests. I think you will see the errors,
just like bot reported them.

Best regards,
Krzysztof
