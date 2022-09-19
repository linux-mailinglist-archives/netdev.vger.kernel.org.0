Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C885BC42E
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiISIUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiISIU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:20:28 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811A7205E0
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 01:20:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id u18so45688670lfo.8
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 01:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=SGgxv53dHIjXJ3+5OtXDvsxDbiwWOA/yeZMOpVwR9sE=;
        b=jqS5qrHT/lRc6Hd8Kbl/qm5idbOkccwmou4G3VZ3mR4iMvxTumgDH8KiaZsKZJlE88
         q51YgHccPdTyAs/+I/bA9U5CVUtRRohAdW/yXUyhAM9z4iwUWqtT7JYJTMzOLLdNokti
         KasoRZzYn00duGVXg+mjiMrf4GbL44XCpolWNVRtKzcSmgGt9P4XOnkWwcsRIXxATC9/
         PU53AZt1Nx4wTaXiVsWA1PGqGPcstEQQIKmgC3Ew1I/Q/3XVuZN+QNt1Wi56auoWpRkb
         S/5Ddn5C1q/1zp8r4mEgZaAmNUtt2co86VF+mk1aayC9X5SUcyQaHU60Uqkjl4HYcITQ
         vbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SGgxv53dHIjXJ3+5OtXDvsxDbiwWOA/yeZMOpVwR9sE=;
        b=EhVMi4t0fOOxIIcECbsAZGQw6rWUgjINcJZq8UgkYk3bfvlKiEtNzuSwxOvErJ+b6H
         3f/aJYJBf184HF+hs8LfYNTBJRLsMIjSEZZAU10pNIuILktQUK86gx3qPgidGtC2tiRO
         GpgxGkzAYRHzLYef2ttIYJErIY5Dq0ZFQS2Z7Pop67Q135L83YEbwXcVJpCmzfF8K22V
         H2bqe/UA5LKoswLJwVVgOrvRLvrfa1F8jkOnbfJ+je3U4lmiD2cFk9kOBvrmc7C83Atx
         9wm62PP5MCrvYBWGhVlntadisbwl0p+X29M+Pmg8l3kHtuUU7fXUyM6o3et3DleuxMiP
         O3MA==
X-Gm-Message-State: ACrzQf1ZuCuG1vyADTnHYJ72mKbWub+rDxkly4ecuGH6a2vTGmQ2r93l
        tEW5jpO6B5C1yGdKDLK9mnNJcw==
X-Google-Smtp-Source: AMsMyM6bRBZ8G+CT95Fr4CW65i9CBuQ4s3d0bl7vfeGsSGeNKYX/SQ6P9xpSr5c0nP9T6YIDzbL4bg==
X-Received: by 2002:a05:6512:c1:b0:497:a63d:563a with SMTP id c1-20020a05651200c100b00497a63d563amr5680113lfp.366.1663575625819;
        Mon, 19 Sep 2022 01:20:25 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id t2-20020ac243a2000000b00497a8f04905sm5088615lfl.251.2022.09.19.01.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 01:20:25 -0700 (PDT)
Message-ID: <49d6adae-7c44-b349-419c-dcd099374354@linaro.org>
Date:   Mon, 19 Sep 2022 10:20:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 2/2] net: dt-bindings: dwmac: add support for mt8188
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
 <20220919080410.11270-3-jianguo.zhang@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220919080410.11270-3-jianguo.zhang@mediatek.com>
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

On 19/09/2022 10:04, Jianguo Zhang wrote:
> Add binding document for the ethernet on mt8188
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> ---
>  Documentation/devicetree/bindings/net/mediatek-dwmac.yaml | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> index 61b2fb9e141b..b7d4f956f92e 100644
> --- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> @@ -20,6 +20,7 @@ select:
>          enum:
>            - mediatek,mt2712-gmac
>            - mediatek,mt8195-gmac
> +          - mediatek,mt8188-gmac

Won't be needed after comment below.

>    required:
>      - compatible
>  
> @@ -36,6 +37,7 @@ properties:
>        - items:
>            - enum:
>                - mediatek,mt8195-gmac
> +              - mediatek,mt8188-gmac

That's not what your driver change is saying. They are the same or
compatible according to your patch #1.


>            - const: snps,dwmac-5.10a

Best regards,
Krzysztof
