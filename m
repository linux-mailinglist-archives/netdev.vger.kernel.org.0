Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EA8590C39
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 09:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbiHLHBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 03:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbiHLHB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 03:01:27 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756CE98A6A
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 00:01:24 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c17so169523lfb.3
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 00:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=SIkBdKPO0ia6WryWVkSmCCsuoT+XbQoa2jB/wItvraw=;
        b=QcVSBUIiPoJBTP/i7J05TmQcLDmF+7re5RaUW7Yue5QCHt7PFToz9xeuYL+4EJnuDs
         PFMzc0bg7G7TBDlF3Cngr/XnD+myenUSl3WYUmUL+hKlvo5AWe2kdbHCGU5MgkXMujCr
         9W7P70YJqRFOr8+//4z1CYL7szZB6+BkBjvGQOnv71VP+Ku3Jo0ZUpGp6593ciRFCBag
         vm6RZNbiSm3spWzlFQsdbYZokeZEGRvHID10EruE8e4ru/khzXsnWFMT72bojLKxZnZ0
         80VDCyatjKWKuRqlrkGfH1+rQxzg/CR67vgqR/UmTVlXB7hhLDkIusXtyEWo0J2dQeQf
         wMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=SIkBdKPO0ia6WryWVkSmCCsuoT+XbQoa2jB/wItvraw=;
        b=juTSMiuPZL0vrCBn6tOfJKnFAvi750RhESvOmnuqWDn2emDl8hdY9BikoXGYuX1/OU
         zX7+v7EeFhxtkA1vxeFyKt8iwIyzBmJAZXIdzLBsohPJ4u4ChOh7+2Z5EqH81DX6omGQ
         G6fPg7zfhYmP7E9WhHoJ4c/b110xOASxfDoqc2IJ4sB9BvNQoh2HzUU2I/3o7I+k7/p/
         nGySdQIkoPNi+JI62aLI0/BBsQMTU2fzkrC3ZMJWJyxLmonz1sltcWr5FkerHPqFFtL7
         p+hwEbiHB5ao6fX94op5YrvV38k603c8uXZej1z6OPFmjPL1NKVSXPj1IamZpB3GtRWq
         aBPA==
X-Gm-Message-State: ACgBeo0SDQcLrPQClseZQP7/otrG4CeoZeMD/HCvnexDGJ6RP0h0ttKi
        DqVn8lUY77FA1Z5NMpFuva5SGhrX0nEW2A3o
X-Google-Smtp-Source: AA6agR4dr9OpzaVrayVua9XEETsz6x4gzfPaVp1rLoMSliu+ypKx2TsqnT6xOOIjwQQiKfzvXErzDQ==
X-Received: by 2002:a05:6512:3501:b0:48b:205f:91a2 with SMTP id h1-20020a056512350100b0048b205f91a2mr834830lfs.83.1660287682735;
        Fri, 12 Aug 2022 00:01:22 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id x2-20020ac24882000000b0047f6b4f82d1sm105601lfc.250.2022.08.12.00.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:01:22 -0700 (PDT)
Message-ID: <40130c63-1e36-bb43-43b4-444a8f287226@linaro.org>
Date:   Fri, 12 Aug 2022 10:01:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4/4] dt-bindings: net: dsa: mediatek,mt7530: update
 json-schema
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220730142627.29028-1-arinc.unal@arinc9.com>
 <20220730142627.29028-5-arinc.unal@arinc9.com>
 <e5cf8a19-637c-95cf-1527-11980c73f6c0@linaro.org>
 <bb60608a-7902-99fa-72aa-5765adabd300@arinc9.com>
 <8a665b7a-bbd0-99ce-658e-bc78568bdca2@linaro.org>
In-Reply-To: <8a665b7a-bbd0-99ce-658e-bc78568bdca2@linaro.org>
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

On 12/08/2022 09:57, Krzysztof Kozlowski wrote:
> On 12/08/2022 01:09, Arınç ÜNAL wrote:
>>>> -patternProperties:
>>>> -  "^(ethernet-)?ports$":
>>>> -    type: object
>>>
>>> Actually four patches...
>>>
>>> I don't find this change explained in commit msg. What is more, it looks
>>> incorrect. All properties and patternProperties should be explained in
>>> top-level part.
>>>
>>> Defining such properties (with big piece of YAML) in each if:then: is no
>>> readable.
>>
>> I can't figure out another way. I need to require certain properties for 
>> a compatible string AND certain enum/const for certain properties which 
>> are inside patternProperties for "^(ethernet-)?port@[0-9]+$" by reading 
>> the compatible string.
> 
> requiring properties is not equal to defining them and nothing stops you
> from defining all properties top-level and requiring them in
> allOf:if:then:patternProperties.
> 
> 
>> If I put allOf:if:then under patternProperties, I can't do the latter.
> 
> You can.
> 
>>
>> Other than readability to human eyes, binding check works as intended, 
>> in case there's no other way to do it.
> 
> I don't see the problem in doing it and readability is one of main
> factors of code admission to Linux kernel.

One more thought - if your schema around allOf:if:then grows too much,
it is actually a sign that it might benefit from splitting. Either into
two separate schemas or into common+two separate.

Best regards,
Krzysztof
