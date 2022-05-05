Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10ECD51BAE6
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350340AbiEEIuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344398AbiEEIuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:50:37 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D0549F17
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 01:46:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w4so5117655wrg.12
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 01:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KAi9SgYYEJZdQCddUzbx52lypx3cIglFyl/qHafebhw=;
        b=tkNfdzaaxw1oNzzHEFi5PsCP9pSRB2g18WUgVkc6DnnNJz4opSwgzEVFoUUkq98Kud
         DmFNXaVYExw1NuJr8DqujznLa2az0lWDiTc0qWvNUCAP5r5OW9iSR8QEqSlWZJONTS4P
         F30VkUEk9v9uHoJqLqcvFr87lcceheNYz87udcrXOAHtFnIyEOvlcZaxaIZkOdNhT30Y
         dB4ud6EWIxegH+EYbtLr/2s0zJ21Uw2TaCRSfxNT1dPyuAPqkA2Ti2WZXu8bcR/8mxNC
         eMgh7vO/iGZwuEnOROZ+GPB0E6E/imyXgauO3i4m/vz/qEwWxwP3ttMVK1mz2Ist0shg
         sbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KAi9SgYYEJZdQCddUzbx52lypx3cIglFyl/qHafebhw=;
        b=zdMqaJ5gMG5BTqu3Tkyhz5/PB4wVkPaZuKkeauIjWZ9f3hEfamgHYT/yH7hrPPrk38
         CaUxgjQRsEHm9o6J7abr9IhnzquUil9RYJmz9bJBkR6YyQhIpD/6LdiWpvt1IY2O4JGK
         BTWniBRwGMxAWrfHD2du2Uk5A2rN8vppi01c/4QveEG8h40f0UcAumHIcURwkenAMYmP
         nIJt7p/QBCgYBu5exhXi9sDthprvqVD5yULj89sfVmMfxQWMNFhINCnVMWstuficLmn1
         IAw8LsqoJjFGbcVkoC7NvgKCuIXp2JFImOJmxyc2a+mppKg6MngZAKKBlI4c4diS39p+
         kttw==
X-Gm-Message-State: AOAM532UOl/LiIsjOdRfCvru5wNCB46fR4bT4/WiV9x6TqS3Mzyv8Tir
        42+yLWAPdXxbq1wjrC0o1XVnbA==
X-Google-Smtp-Source: ABdhPJx0cG82J35HyxF+U/lAjaHUyieUfdukDsGukXiyDflYgKWosvfKkWmN+5Kvijh4a8XoYMPHpw==
X-Received: by 2002:a5d:6551:0:b0:20a:e23c:a7fa with SMTP id z17-20020a5d6551000000b0020ae23ca7famr19657153wrv.535.1651740417622;
        Thu, 05 May 2022 01:46:57 -0700 (PDT)
Received: from [192.168.0.217] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id 67-20020a1c1946000000b003942a244f2csm6771728wmz.5.2022.05.05.01.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 01:46:57 -0700 (PDT)
Message-ID: <313a5b2e-c571-a13f-3447-b1cd7200f4c9@linaro.org>
Date:   Thu, 5 May 2022 10:46:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC v2 4/4] arm64: dts: rockchip: Add mt7531 dsa node to
 BPI-R2-Pro board
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220430130347.15190-1-linux@fw-web.de>
 <20220430130347.15190-5-linux@fw-web.de>
 <20220504152450.cs2afa4hwkqp5b5m@skbuf>
 <trinity-9f557027-8e00-4a4a-bc19-bc576e163f7b-1651678399970@3c-app-gmx-bs42>
 <20220504154720.62cwrz7frjkjbb7u@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220504154720.62cwrz7frjkjbb7u@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/05/2022 17:47, Vladimir Oltean wrote:
>>
>> current device-tree nodes using "switch" and "ports"
>>
>> see discussioon here about make it fixed to "ports" property instead of PatternProperties including optional "ethernet-"
>>
>> https://patchwork.kernel.org/project/linux-mediatek/patch/20220502153238.85090-1-linux@fw-web.de/#24843155
> 
> Hmm, I don't get why Krzysztof said to just keep what is used in
> existing device trees. The schema validator should describe what is
> valid, 

These were talks about bindings which describe hardware. The node name,
except Devicetree spec asking for generic names, does not matter here
actually.

> and since the mt7530 driver does not care one way or another
> (some drivers do explicitly parse the "ports"/"ethernet-ports" node),
> then whatever is valid for the DSA core is also valid for the mt7530
> bindings. And "ethernet-ports" is valid too, so I think it should be
> accepted by mediatek.yaml...

You can make it "(ethernet-)?ports" as well. My comment was purely to
make it simpler, for bindings (goes into properties, not
patternProperties) and for us. If you prefer to keep it like DSA core,
also fine.

Best regards,
Krzysztof
