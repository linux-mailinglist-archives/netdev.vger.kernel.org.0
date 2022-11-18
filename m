Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4241F62F870
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242114AbiKRO4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241986AbiKROzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:55:54 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF9370A30
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:55:29 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bp15so8544714lfb.13
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=goUFPMKX4auhNOytpCS76F6+oFJbm5nDF3rRTkPSoxs=;
        b=ev8zzitMeZQuPjRj0P/TC0v7bJQVBjsNTIlj/vYfhMxFuR+OvntUDzBIMZEH11nujL
         HnCteaXp5n3QMFnDnDel1pkcwRnmcKF/HHapoacLlJxE+OJVvIFOmygYxO+zHqfZA/5Y
         Wtq0j+q+fqeudod2CPBAmCSaV2IWitzEjn2oAnGw4iK/nVg1L1ZkFB3vCZne8IJqHO1B
         xYgV+wALymQwd8zrJiMeLmbYxbaFgOZboRUK6CdTv2a0n2WI1fI2v8wz+a0V7uDToqEH
         EjY4B3YVUTJklIUQFYAZFlDp39fr/BGv/HZRpH481+iTcad97kjoL+sSZHZ2e2YUb8gK
         c+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=goUFPMKX4auhNOytpCS76F6+oFJbm5nDF3rRTkPSoxs=;
        b=jueCVJSc1QVdziJpkLwukxU/eraNzdbqpfaJ/TlNgtmjAZvpp1woOxWbr6kBepvq36
         Y4tJTQ/JwubgD5O8EMdBMwn4WXIIKaklzIgD3H6ESUEvEpz8Tg/wI9w6uiz6M0fA4aeE
         tZqRjOK9BV2mC+r5Ad3SghVN2a7YBdUsblMpn2RZoTenANV3KksO6JAv2M07pW7Acgrm
         bEetM2GqnJ2fw+988BgdZktE5kI225NKGeIphtWuohgKT3nKBZBzlMf8vQ3wYgOxAn16
         P2LG+AT4ATWYDXgqvAzDq8BXAECg2OylhWsbEMV0WJJQ6V9EWNaOShje20EjEfJGS4qK
         UDKw==
X-Gm-Message-State: ANoB5pnJ0UMt9SL8BG+pSshZfuRrtRNBSKBJJahCHNcCwihY+ElzxFS3
        rVaga0oHS/VLvz3Sjv+CCMcOZw==
X-Google-Smtp-Source: AA0mqf4rUU5GFN13rGIm8oVXpzqHjxQvPRkD/HFkVTV6c9Dwb96c2a3B93ODDu0Sm7WxWsDPEwgNmQ==
X-Received: by 2002:a05:6512:3282:b0:4a2:4b1b:6ad9 with SMTP id p2-20020a056512328200b004a24b1b6ad9mr2863014lfe.296.1668783327899;
        Fri, 18 Nov 2022 06:55:27 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b004afc1607130sm693758lfs.8.2022.11.18.06.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:55:27 -0800 (PST)
Message-ID: <86d3cb18-4e31-7389-f982-7985cf976791@linaro.org>
Date:   Fri, 18 Nov 2022 15:55:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 09/12] dt-bindings: phy: convert meson-gxl-usb2-phy.txt to
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
 <20221117-b4-amlogic-bindings-convert-v1-9-3f025599b968@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-9-3f025599b968@linaro.org>
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
> Convert the Amlogic Meson GXL USB2 PHY bindings to dt-schema.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../bindings/phy/amlogic,meson-gxl-usb2-phy.yaml   | 56 ++++++++++++++++++++++
>  .../devicetree/bindings/phy/meson-gxl-usb2-phy.txt | 21 --------
>  2 files changed, 56 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-gxl-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-gxl-usb2-phy.yaml
> new file mode 100644
> index 000000000000..4dd287f1f400
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/amlogic,meson-gxl-usb2-phy.yaml
> @@ -0,0 +1,56 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/amlogic,meson-gxl-usb2-phy.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Amlogic Meson GXL USB2 PHY
> +
> +maintainers:
> +  - Neil Armstrong <neil.armstrong@linaro.org>
> +
> +properties:
> +  compatible:
> +    const: amlogic,meson-gxl-usb2-phy
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: phy
> +
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    items:
> +      - const: phy
> +
> +  "#phy-cells":
> +    const: 0
> +
> +  phy-supply: true
> +
> +required:
> +  - compatible
> +  - reg
> +  - "#phy-cells"
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    phy@78000 {
> +          compatible = "amlogic,meson-gxl-usb2-phy";
> +          reg = <0x78000 0x20>;
> +          clocks = <&xtal>;
> +          clock-names = "phy";
> +          resets = <&phy_reset>;
> +          reset-names = "phy";
> +          #phy-cells = <0>;
> +          phy-supply = <&usb2_supply>;

Use 4 spaces for example indentation.

With indentation fixed:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

