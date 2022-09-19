Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5BB5BC42A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiISITj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiISITh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:19:37 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339E526EF
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 01:19:35 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id j16so18662657lfg.1
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 01:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=cGOksTlx7HPSEJ3tGiKUBW8haHMuXJVe8E31nOF/Xns=;
        b=u9l2LNU0CtHKm3nLxR0sboWaatfqLlHDDYdD0KtG6vgT7rByAJBdDqLIW8xoizWSpI
         JGuIrGSoS+YC8NMafiKedkZhmmi6H/JQYvKgLkyUK/5eayLL6wwCI6JxE9atMQsxVTgs
         bJeBcOaTgwbYtcLzCjy/WdyZxxlMpidrQ35dwPmsE86vsSzlOw5dM7Fc5Q/ZOPz5Fppr
         eGU+rUIJV0ltdyeqopkPtnju4ZyfTrJyvglKK8OnEs9lZOiVZhn9lYqC7UpKFozAe3xL
         IETBbJCmkOd3KzcDUzrmzPfsKEoDZl4iu8gJKe/VB+Bsn87Knwfwnhm5R6FBhOWalmfl
         EILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cGOksTlx7HPSEJ3tGiKUBW8haHMuXJVe8E31nOF/Xns=;
        b=QqylIIcz/cHb1EN6zq51dzvVU0qbCssOdwKGg8lFd0nVhGKNa5KH5JrtnDgSU2f6p2
         NZ7m6gUyyLHCEm6RpRVzqh+PQmzq80ORPjp9HOXcrm5/NfRoiNX1b6pjxF5bXqeH5feA
         0SPyEElKCZrbs6C4ccev/jVyHEvelpBsCFREQZYRDqRkiijTFywk10A1aqqmNG+2cMqa
         ZAvA1V3wHB4a8QjoWg+3mgo3G4n3QjFmKAwyLZ2nHZBs4Sy3sCbD51Hj72I7xt2DgJsk
         wcP9hUqGjcnu6FWIQOucu0Gm7+QGWlXbvWM6158g75UseJEWeht3Vw8AeLvqXLu/Ujf7
         /e5A==
X-Gm-Message-State: ACrzQf16/nSAOMuMU8D/PfN06zKJKw5gZconkr3JKgiwyF9sq+o2qMUl
        b9WxC7LIg0Mp7sVkXlNueuq6ig==
X-Google-Smtp-Source: AMsMyM4bsPPOk94vI7dWhP43voq8RX38StuUfrTlgpjKh06SgkNvXLTG2zWq+zZzzqFCbHg8+VZQtQ==
X-Received: by 2002:a05:6512:3d9f:b0:497:a108:544f with SMTP id k31-20020a0565123d9f00b00497a108544fmr5478197lfv.688.1663575573570;
        Mon, 19 Sep 2022 01:19:33 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id j20-20020a056512345400b00493014c3d7csm5059793lfr.309.2022.09.19.01.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 01:19:33 -0700 (PDT)
Message-ID: <d28ce676-ed6e-98da-9761-ed46f2fa4a95@linaro.org>
Date:   Mon, 19 Sep 2022 10:19:32 +0200
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220919080410.11270-2-jianguo.zhang@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/2022 10:04, Jianguo Zhang wrote:
> Add ethernet support for MediaTek SoCs from mt8188 family.
> As mt8188 and mt8195 have same ethernet design, so private data
> "mt8195_gmac_variant" can be reused for mt8188.
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> index d42e1afb6521..f45be440b6d0 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> @@ -720,6 +720,8 @@ static const struct of_device_id mediatek_dwmac_match[] = {
>  	  .data = &mt2712_gmac_variant },
>  	{ .compatible = "mediatek,mt8195-gmac",
>  	  .data = &mt8195_gmac_variant },
> +	{ .compatible = "mediatek,mt8188-gmac",
> +	  .data = &mt8195_gmac_variant },

It's the same. No need for new entry.


Best regards,
Krzysztof
