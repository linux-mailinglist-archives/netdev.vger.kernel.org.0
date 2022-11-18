Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CC362F816
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbiKROsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbiKROsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:48:22 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4957B6DCCD
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:48:20 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id b9so7054332ljr.5
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JzDAVj14Kg7cyIXYwLhr95fRyEdtiFybQ+a9MmGfD7k=;
        b=P4iKBxDecGp7qNoMMYwLnoMJ7yQ2X4wm+chKoQAVcYgIbVgW/4Ic8Xtb7DnzlMuYXa
         a+KagPKM9e/V54JuDN4+ZpL+QSS0cClqMG3jaI8OG6ey10xV8p5VOGhv4B335yHdxxZ6
         udWuBi6XP4QdHTPL0/u9jWPb4AmhpkScZ6bVOxyFMBMkN5Up2LKYq3H5zmJuIcdkX0Fx
         8fRUzWUlUGxjaJQgcLB1Zf1N9rH+cvB0CSSHsOL6EuqAPju3FneXzOwnJAxFBrQpQVyr
         +UCtax2+FAg215FZ7h57gHkOjOg6N1bkk3yl6x31o6eYoiHPgEiKNXvzlBRf3tcxr8+J
         ZKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JzDAVj14Kg7cyIXYwLhr95fRyEdtiFybQ+a9MmGfD7k=;
        b=nwVF5HPkVUvbndqiaK5QzxBR9AM+HPUjuMWGPEGWcTo+l8LsrCRi7G9e+F1zX2bls/
         h9KIsehQ4zwPZ9b8ziT+xoz4/RO6MgJnbc5liUIJNruMVy5/ccAS5UK3SLafJwR94jX2
         8/0ZHy/VcQI+sgT9gjv/qO70K74EG34u06fTz9J+kUFaerOuyIrxMnyXrwg3jC9p/ihR
         rfrf+LkQ6Oho5C4l5SBWSRBIYFrD7jMCvAkZ5oSpL94GhwGCCEKGcA/7ClihO55UzMFX
         tt3rJnZ7W+wbwNdjeMIyRGsUnzqOsunIdKJiFIxu6ocyxBd42gZp1lsdMzrVDV9q9nko
         luXw==
X-Gm-Message-State: ANoB5pmnnmaiTZIuyb3BL7etkl60FXBlO6DQzGLFfwMGyWs7EezOfOf4
        PwwCNfMmX9xIzuy5fd6yD8AKww==
X-Google-Smtp-Source: AA0mqf5cBtRAtVWCHt/JKQ9brxqzzQxd4TedCgkS2P/jQOnKdMCSZLGEZqSJlBl/s61brK5m99FHbQ==
X-Received: by 2002:a2e:a274:0:b0:278:eef5:8d07 with SMTP id k20-20020a2ea274000000b00278eef58d07mr2463980ljm.61.1668782898632;
        Fri, 18 Nov 2022 06:48:18 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id be40-20020a056512252800b00497a61453a9sm683196lfb.243.2022.11.18.06.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:48:18 -0800 (PST)
Message-ID: <40a4d3fd-bde8-c8ce-a93e-e0f8b633f10b@linaro.org>
Date:   Fri, 18 Nov 2022 15:48:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 02/12] dt-bindings: nvmem: convert amlogic-efuse.txt to
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
 <20221117-b4-amlogic-bindings-convert-v1-2-3f025599b968@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-2-3f025599b968@linaro.org>
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
> Convert the  Amlogic Meson GX eFuse bindings to dt-schema.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../bindings/nvmem/amlogic,meson-gxbb-efuse.yaml   | 52 ++++++++++++++++++++++
>  .../devicetree/bindings/nvmem/amlogic-efuse.txt    | 48 --------------------
>  2 files changed, 52 insertions(+), 48 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/nvmem/amlogic,meson-gxbb-efuse.yaml b/Documentation/devicetree/bindings/nvmem/amlogic,meson-gxbb-efuse.yaml
> new file mode 100644
> index 000000000000..1d88f7eee840
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvmem/amlogic,meson-gxbb-efuse.yaml
> @@ -0,0 +1,52 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/nvmem/amlogic,meson-gxbb-efuse.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Amlogic Meson GX eFuse
> +
> +maintainers:
> +  - Neil Armstrong <neil.armstrong@linaro.org>
> +
> +allOf:
> +  - $ref: nvmem.yaml#
> +
> +properties:
> +  compatible:
> +    const: amlogic,meson-gxbb-efuse
> +
> +  clocks:
> +    maxItems: 1
> +
> +  secure-monitor:
> +    description: phandle to the secure-monitor node

This does not look like standard property, so you need the type ($ref).

> +
> +required:
> +  - compatible
> +  - clocks
> +  - secure-monitor
> +


Best regards,
Krzysztof

