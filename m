Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D25BE6F0
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiITNWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiITNWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:22:37 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010261759E;
        Tue, 20 Sep 2022 06:22:35 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 92FD46601F3B;
        Tue, 20 Sep 2022 14:22:32 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1663680153;
        bh=Pk+W1ozfQ0SCVra3zDNF6XprepX+dt5BIPhJgQVPHCg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ayMX/uXRw+VaEpEORAOiID4m6Ob3nBFdEr7OcT5IUKvutOwyjmbSgw5wqzarIS1Zk
         uefqwVJj5VPpRw4LoMbOyJHVaXP0Xcvj3TV4gFa4p0xT8HY3CcNfA4QqH0hyGkaqBa
         mKIM3cvd5LMdmud7IInQHvQWlMLygzt3k9neWpryFJvPVsxR7vi307VoSJqwFMR1my
         kfeGepaL13w0b4MZ3Gx2z7UWenntrhL1tQ1ZwBnqbiRxu0OnUadkXtVMtFMuncQo/k
         t75voKZHwb6/C6xlekPQcdisGpzyiCj8HsKsLWCU05eElOGKTTPoz+zI9DTSlaU6Ju
         2FTDiFwlttdiw==
Message-ID: <3ed55b0d-6c14-79a1-b4c1-5764c667d195@collabora.com>
Date:   Tue, 20 Sep 2022 15:22:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] dt-bindings: net: mediatek-dwmac: add support for
 mt8188
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
References: <20220920083617.4177-1-jianguo.zhang@mediatek.com>
 <20220920083617.4177-2-jianguo.zhang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20220920083617.4177-2-jianguo.zhang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 20/09/22 10:36, Jianguo Zhang ha scritto:
> Add binding document for the ethernet on mt8188
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> ---
>   .../devicetree/bindings/net/mediatek-dwmac.yaml        | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> index 61b2fb9e141b..eaf7e8d53432 100644
> --- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> @@ -20,6 +20,7 @@ select:
>           enum:
>             - mediatek,mt2712-gmac

Please keep the list ordered by name. MT8188 goes before 8195.

>             - mediatek,mt8195-gmac
> +          - mediatek,mt8188-gmac
>     required:
>       - compatible
>   
> @@ -37,6 +38,11 @@ properties:
>             - enum:
>                 - mediatek,mt8195-gmac
>             - const: snps,dwmac-5.10a
> +      - items:
> +          - enum:
> +              - mediatek,mt8188-gmac
> +          - const: mediatek,mt8195-gmac
> +          - const: snps,dwmac-5.10a
>   
>     clocks:
>       minItems: 5
> @@ -74,7 +80,7 @@ properties:
>         or will round down. Range 0~31*170.
>         For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
>         or will round down. Range 0~31*550.
> -      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
> +      For MT8195/MT8188 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,

For MT8188/MT8195

>         or will round down. Range 0~31*290.
>   
>     mediatek,rx-delay-ps:
> @@ -84,7 +90,7 @@ properties:
>         or will round down. Range 0~31*170.
>         For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
>         or will round down. Range 0~31*550.
> -      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
> +      For MT8195/MT8188 RGMII/RMII/MII interface, Allowed value need to be a multiple

For MT8188/MT8195

>         of 290, or will round down. Range 0~31*290.
>   
>     mediatek,rmii-rxc:


