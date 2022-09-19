Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC55BC556
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 11:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiISJ2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 05:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiISJ1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 05:27:51 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C06310FCA
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 02:27:49 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id s6so34727612lfo.7
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 02:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Ni5vNsO8umndiniabq8C5W9eiIXqQqotBmgaNWkkLK0=;
        b=kdGdpmpEChbWIseVkCKVEvUwIFi0MK0B4sNLWcpeEmqU9CRrk2WTj+kKzfKYObMR7m
         mXTvLyiMeNthhWAu8GagmQ82H8Edn+6gSumV048FtoC17iw9TJG+Nh8+R1WLThAaMurM
         I4jkZovZ1fuU/0VMZHnBMNWlfWfcv/QYfv1fFbL3meE0eOr1n0zwvocmGc66XdkeMEBe
         TKiE8eEBKPICnX7K946jxfyP1rPCdO61qSJ6GmKPYeZAgKW0E2f6lQcRIvjugfQDHnTl
         XcBY+5NOBufJa4x37aCbFok8afQLMXl8ISv2RjLCIgw54pRiwlYDAyoNcT7P6tP8NWZ8
         ximQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ni5vNsO8umndiniabq8C5W9eiIXqQqotBmgaNWkkLK0=;
        b=kdpeqrpGv7N/WzegP0GL6KQuOxp6sozy3VemZoRc9/ickbmzWj85yupmJCm18tfKzG
         1bMHUJdyabrkqYTrKzTidGZ2Q7j5OirEaI70IXL6oHuUpUHFMpq5F3Z0EUeZCzjicjak
         b9TVZbB3MM7t39fI5v54arhU4pyCjK8lWCwSRUjkyihtFqYxSSRe2Zl9SqXg5SlOGqMM
         CVd3hKyE5H505c85VIm6ksw0tESKoLknNHSZJIib6omLT6Ykw8AtbI3mvYEXCOPTZGAk
         zrogHghIDlxQHVF25ANowhcbc/2f4XuVlf1P7JvKpyTXzZyMTUJrG9TivaNnYnHDKwmB
         JdaQ==
X-Gm-Message-State: ACrzQf0lUYJ7UYpFD2rbrFCkyeAxAKUZfrZ/CC//i3Fnfdg8VIx8uPT6
        3WVDlfwT2OEln8IALDeB0HEc7g==
X-Google-Smtp-Source: AMsMyM7lxiuvbds2FRZKDW9lrUwIuvpGFw0m9oRIkcp0QON8mh5L72dtCjDGDIjOi83tFBanr+gAeA==
X-Received: by 2002:a05:6512:3d1c:b0:49d:87fc:f63 with SMTP id d28-20020a0565123d1c00b0049d87fc0f63mr5950005lfv.327.1663579667364;
        Mon, 19 Sep 2022 02:27:47 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id q16-20020a194310000000b004946aef1814sm5112366lfa.137.2022.09.19.02.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 02:27:46 -0700 (PDT)
Message-ID: <88412fcc-96be-cd9d-8805-086c7f09c03b@linaro.org>
Date:   Mon, 19 Sep 2022 11:27:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] stmmac: dwmac-mediatek: add support for mt8188
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220919080410.11270-1-jianguo.zhang@mediatek.com>
 <20220919080410.11270-2-jianguo.zhang@mediatek.com>
 <d28ce676-ed6e-98da-9761-ed46f2fa4a95@linaro.org>
 <4c537b63f609ae974dfb468ebc31225d45f785e8.camel@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <4c537b63f609ae974dfb468ebc31225d45f785e8.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/2022 10:37, Jianguo Zhang wrote:
> Dear Krzysztof,
> 
> 	Thanks for your comments.
> 
> 
> On Mon, 2022-09-19 at 10:19 +0200, Krzysztof Kozlowski wrote:
>> On 19/09/2022 10:04, Jianguo Zhang wrote:
>>> Add ethernet support for MediaTek SoCs from mt8188 family.
>>> As mt8188 and mt8195 have same ethernet design, so private data
>>> "mt8195_gmac_variant" can be reused for mt8188.
>>>
>>> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
>>> ---
>>>  drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
>>> b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
>>> index d42e1afb6521..f45be440b6d0 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
>>> @@ -720,6 +720,8 @@ static const struct of_device_id
>>> mediatek_dwmac_match[] = {
>>>  	  .data = &mt2712_gmac_variant },
>>>  	{ .compatible = "mediatek,mt8195-gmac",
>>>  	  .data = &mt8195_gmac_variant },
>>> +	{ .compatible = "mediatek,mt8188-gmac",
>>> +	  .data = &mt8195_gmac_variant },
>>
>> It's the same. No need for new entry.
>>
> mt8188 and mt8195 are different SoCs and we need to distinguish mt8188
> from mt8195, so I think a new entry is needed for mt8188 with the
> specific "compatiable".

No, this does not justify new entry. You need specific compatible, but
not new entry.

> On the other hand, mt8188 and mt8195 have same ethernet design, so the
> private data "mt8195_gmac_variant" can be resued to reduce redundant
> info in driver.

And you do not need new entry in the driver.

Best regards,
Krzysztof
