Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B975751E9D0
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 22:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387177AbiEGUDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 16:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387134AbiEGUDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 16:03:37 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8503720186
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 12:59:49 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id z2so18480242ejj.3
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 12:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CdoG5uiVasejnemLfedUgLlvjuPyIUBH7WuMB7uxqPM=;
        b=G8Vjn90QHh4oxbaJwezEh8X4SVtSXeFZn8VXZRUxQIu0HU1b7VGHwI7AG+kOTaDjFS
         yi8t3CePCvXmRG135Rn5jZUd0Pf6LyYi0WuHbYD2PpZga7fl7oyGrmn6MFrDhvuqEYOu
         5xZxpHJKHa77j+O5RX4Xv8H9jZgjvgFLM2zWTncqdFngFlMcF66c5aWQqI/PS9zVm1A2
         RpiMCR/KX6xO+X5w7WkaKovW1gAWSrV3pNNV2iGvAGptglr99z9bDWlhnK62MH+cD2Pc
         bYHBlSkRMm6iTkShZl3yjUGaslFLd8tceWpLTUZA6BM8nVBcF6H1ZrZlwqoWHi5ECnDt
         BJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CdoG5uiVasejnemLfedUgLlvjuPyIUBH7WuMB7uxqPM=;
        b=vgDtGNH1UElpQd5mnnvbIq6s21e/wZoKZI2GyII4NmaENO5w7RN+AU25hTR/1f5Kha
         T4D29kopEsMc/IZhOt6fXVLAEHyfCTOuvipzCC2RNWYMzp7zEqnhCDcvLLAjFAHuCl3C
         F85rSdNBA0rEZrhh9QWJhonzI8MGzcf3BYrsuGLzkthtGLpCcBE7nsvOibRyoVSoLS7V
         1ngFyvZolsPY0U8r94/2MGIZefDTBpWA8UA/6/OwL/7LiamL21jXp2DGeTvRD/kRDr7F
         w5sjK+uTZMTxHiEuVi1neeT+zn6zrLKpOzy2kLDGqOy3KWrdB2iNoOtmUm0bFhKNLPy7
         eFew==
X-Gm-Message-State: AOAM530+MaZHqckIwPwp6n+4VgZmfXhWcKN1+vGTd2QiumfOqwTkBtKa
        00o7NnBAiXXMEL1TQJUjWfrYIw==
X-Google-Smtp-Source: ABdhPJxDyRdhI3lmezTH/4XlyD6pWqtW8AtiH011+LGHZ7x81uRCA7+9hB4bLPR29SliclbWIzW34w==
X-Received: by 2002:a17:906:32d5:b0:6f3:be75:8485 with SMTP id k21-20020a17090632d500b006f3be758485mr8393835ejk.685.1651953588123;
        Sat, 07 May 2022 12:59:48 -0700 (PDT)
Received: from [192.168.0.235] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id wi7-20020a170906fd4700b006f3ef214dd4sm3265880ejb.58.2022.05.07.12.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 12:59:47 -0700 (PDT)
Message-ID: <e7fe1268-8604-4d50-08be-d83bcf2e9537@linaro.org>
Date:   Sat, 7 May 2022 21:59:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/6] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Language: en-US
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
References: <20220507170440.64005-1-linux@fw-web.de>
 <20220507170440.64005-2-linux@fw-web.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220507170440.64005-2-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2022 19:04, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Convert txt binding to yaml binding for Mediatek switches.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
> v3:
> - include standalone patch in mt7530 series
> - drop some descriptions (gpio-cells,reset-gpios,reset-names)
> - drop | from descriptions
> - move patternProperties above allOf
> 
> v2:
> - rename mediatek.yaml => mediatek,mt7530.yaml
> - drop "boolean" in description
> - drop description for interrupt-properties
> - drop #interrupt-cells as requirement
> - example: eth=>ethernet,mdio0=>mdio,comment indention
> - replace 0 by GPIO_ACTIVE_HIGH in first example
> - use port(s)-pattern from dsa.yaml
> - adress/size-cells not added to required because this
>   is defined at mdio-level inc current dts , not switch level
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 423 ++++++++++++++++++
>  .../devicetree/bindings/net/dsa/mt7530.txt    | 327 --------------
>  2 files changed, 423 insertions(+), 327 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> new file mode 100644
> index 000000000000..a7696d1b4a8c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -0,0 +1,423 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)

I don't see any acks here so that part is unresolved.

Rest looks good:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
