Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE49462F80D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241926AbiKROqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241909AbiKROqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:46:34 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584AF7209F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:46:30 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id b3so8565848lfv.2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hahClhRd3DWgz5IfF3Hi2OhGzrj/JdBwzY9rjBeju8s=;
        b=JZmmE5Z+1MzabRyRffMS4z0aGT9BgDXgC9DY0MCMYG1Od3pGNI30/93iq6QOZW6IdU
         fzRFWbJEIsHpicLM2uM84cqyzD3qkQI9fT5ohEFetg4fYo8GpGdRtchVdyxXexmPlddC
         eGYx58fwwwBR/DsKEi58q/WGkaBmfRML0mdohoszmg6ZPltefO3A2rcCnwjg9H2e4uHz
         Ht2YGQKv1bXzlOexPAnjWHR0AMT7xMNE/h4sT/R2kdz2G7JqebBANYjHtmXhnqbDNEln
         rVq3At5moD/Yhfg5Ccq+IamuGznKvyJiQMbNIvLxeCTTkEAeoLQaX+gl3f5Kw0H/Tmzx
         zd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hahClhRd3DWgz5IfF3Hi2OhGzrj/JdBwzY9rjBeju8s=;
        b=W4WgglKsQUpYvcsdDeL11zBcyu7XWrZO7ZW5XNQjiFko5PTORLsZscuI26+WLxlAJ9
         8Ks5g4CGjpRnH6T3rXm9ZNjaXcBMv1z6gd1//qPs3dCtoCpunuob018VgrQ9QkQJOBfB
         n7lHzmpiNFpEaZ+HwnhjUBmkBYMmxktwaHChu5QaEzDDulMmjQg/JfBr3nMXCqEZPC2h
         hPq7GBCOpHdkkMWPz/r9e69y5YpBjuuLsY+kDER4mbW/3tfwIIGJ9RPKnAjtLWsu4loT
         mxRpN8sAZKx1LUgZww9kc0eBUQPFYGjOT62hlLbzhK62QxUyr1NNpj7ENuMJ2jH7MSOY
         Hb1Q==
X-Gm-Message-State: ANoB5plgGnstc9ET26arurXLmK2c7+lwvGV61NRrUtnWrwA5Xm2OW7a2
        JHUgEEVMLLLy+8vcKjCA7uL0CQ==
X-Google-Smtp-Source: AA0mqf4xQNEVq6KlclNCEMjl56xKu/uoZoZfSEq3TwF8gKAhDBzYdep45hA5R/OZ/mt+9IdD6Luzkg==
X-Received: by 2002:a19:4f14:0:b0:4b4:b20c:4b7 with SMTP id d20-20020a194f14000000b004b4b20c04b7mr2476398lfb.201.1668782788658;
        Fri, 18 Nov 2022 06:46:28 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c3-20020ac25f63000000b004b177293a8dsm682197lfc.210.2022.11.18.06.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:46:28 -0800 (PST)
Message-ID: <57c2ca7c-05be-7fc1-69ad-e06b6e571d60@linaro.org>
Date:   Fri, 18 Nov 2022 15:46:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 01/12] dt-bindings: firmware: convert meson_sm.txt to
 dt-schema
Content-Language: en-US
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-1-3f025599b968@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-1-3f025599b968@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/11/2022 15:33, Neil Armstrong wrote:
> Convert the Amlogic Secure Monitor bindings to dt-schema.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../bindings/firmware/amlogic,meson-gxbb-sm.yaml   | 36 ++++++++++++++++++++++
>  .../bindings/firmware/meson/meson_sm.txt           | 15 ---------
>  2 files changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/firmware/amlogic,meson-gxbb-sm.yaml b/Documentation/devicetree/bindings/firmware/amlogic,meson-gxbb-sm.yaml
> new file mode 100644
> index 000000000000..33d1408610cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/firmware/amlogic,meson-gxbb-sm.yaml
> @@ -0,0 +1,36 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/firmware/amlogic,meson-gxbb-sm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Amlogic Secure Monitor (SM)
> +
> +description:
> +  In the Amlogic SoCs the Secure Monitor code is used to provide access to the
> +  NVMEM, enable JTAG, set USB boot, etc...
> +
> +maintainers:
> +  - Neil Armstrong <neil.armstrong@linaro.org>
> +
> +properties:
> +  compatible:
> +    const: amlogic,meson-gxbb-sm
> +
> +patternProperties:
> +  "power-controller":

This looks like a property, not a pattern.

> +    type: object
> +    $ref: /schemas/power/amlogic,meson-sec-pwrc.yaml#

Would be nice to add it here to example and drop from
amlogic,meson-sec-pwrc.yaml (unless it will be used by more schemas?).


Best regards,
Krzysztof

