Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E4F590C30
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 08:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiHLG5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 02:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiHLG5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 02:57:23 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDCFA59B8
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 23:57:21 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f20so129919lfc.10
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 23:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=FrfRi2+lHDlBxwVVMHzDrJHx7Q3p2G+5d8uDewrRAEw=;
        b=sv21mxYeoodQClvyUh7rxGuN1p6MH+kcL/yXUdot4DG3rVyYkWJmX2BjDNru9Y7F8C
         uGX7LfFwRVLlzPO9kL6GayHvRTvYULX2sNmDJvSKpKQ6mW2Cl0xC8qvBoWP3sAIfMTEH
         RDWbpGlytbQaMqhsE/QjhqKAK/lf5SJCWcy+m+qjEa/lr1j9HnyXS7mEseGk0Nn5YMLK
         /F6kfzhoAsF6mdjN1x5Zzxs6Q8YlQs0QQyC38mwJXEAg7O2liFQJWO/tLPLMM4NSHONP
         OfsTvhfZhqAIGu0vJUm/wj3ZNinVfv3y166ukJl5qN+A0acnLYI9soA+02cR8Yu8NFBS
         WxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=FrfRi2+lHDlBxwVVMHzDrJHx7Q3p2G+5d8uDewrRAEw=;
        b=bUZssU9CjdPd3NY4prkdxIIHWE2nkJMVvmcfUUorOStDt3DG3o0mKWTxPJPTMkL3hm
         zmz9xd/Ndaf13x05urBcWpy47VRBzDZ98ZO8nrXxrpOZdL0cPYYtjJ/84Ycl5Xi4jz3/
         hPwZdbRBWxDqLwwmMPc2douRfq1JRIHVk90SIBUy6155U2y9t1fRupr1mGkQM0iTiWwE
         3eylSchAbLoWQiJuKnj+6SXAU5KOiwBUYzusMxgSHwZW/jxxOaGhpyGz976UsxJeyyVr
         GgpHHBTi6K/2JNbRlOYRIEhdtzDEVUcIr1/Hf1O6oQCABpzsEvFsZCjMCsHCwpG5D9cX
         KO1Q==
X-Gm-Message-State: ACgBeo1hDcvL8yNQx8UtifPoZOeAV6AVW/sxt47jHi8DcV/FzrtA/GBu
        Y6OTMpMksBHb1f0LfUXFRVM5Zw==
X-Google-Smtp-Source: AA6agR7M20SFyNF/dOFK27C0pl8a1ofriwmlGVRzgSCjE4kMy8Af4Pq+4LTBh+RSlfRCn9zUfdDZfg==
X-Received: by 2002:a19:740c:0:b0:48b:374:987a with SMTP id v12-20020a19740c000000b0048b0374987amr874185lfe.690.1660287440281;
        Thu, 11 Aug 2022 23:57:20 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id o17-20020ac25e31000000b0048ceb3836d4sm114182lfg.6.2022.08.11.23.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 23:57:19 -0700 (PDT)
Message-ID: <8a665b7a-bbd0-99ce-658e-bc78568bdca2@linaro.org>
Date:   Fri, 12 Aug 2022 09:57:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4/4] dt-bindings: net: dsa: mediatek,mt7530: update
 json-schema
Content-Language: en-US
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <bb60608a-7902-99fa-72aa-5765adabd300@arinc9.com>
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

On 12/08/2022 01:09, Arınç ÜNAL wrote:
>>> -patternProperties:
>>> -  "^(ethernet-)?ports$":
>>> -    type: object
>>
>> Actually four patches...
>>
>> I don't find this change explained in commit msg. What is more, it looks
>> incorrect. All properties and patternProperties should be explained in
>> top-level part.
>>
>> Defining such properties (with big piece of YAML) in each if:then: is no
>> readable.
> 
> I can't figure out another way. I need to require certain properties for 
> a compatible string AND certain enum/const for certain properties which 
> are inside patternProperties for "^(ethernet-)?port@[0-9]+$" by reading 
> the compatible string.

requiring properties is not equal to defining them and nothing stops you
from defining all properties top-level and requiring them in
allOf:if:then:patternProperties.


> If I put allOf:if:then under patternProperties, I can't do the latter.

You can.

> 
> Other than readability to human eyes, binding check works as intended, 
> in case there's no other way to do it.

I don't see the problem in doing it and readability is one of main
factors of code admission to Linux kernel.

Best regards,
Krzysztof
