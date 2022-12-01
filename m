Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F1663F522
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiLAQVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiLAQVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:21:10 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31738A80AE
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:21:09 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id c1so3248381lfi.7
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iegIkb4fipqnzTjEHK3Rzo5fetpTzelf4+OZ20EGaxQ=;
        b=VbvXhlxH6TipiO2qGi6mtKXCZ0FlWYWE3s3cOvx/seesTXZpq1sMLXDxBph+NPebj3
         kAOJB4fyBKMl/6/rkR4wjztOUc9WMVU7DkTPlbI/5XE+y8XpZzqP0rR03EgQpTMtEZfm
         UUv9z6659u9OUywCheoHC6K9pQwLRo8Nl4sGnGmW88JrNTvIKC//5ieGG6NQGyplmQSD
         fy5kGfrSnT+Nm1JuQPgTsLUF7NLUPVRzU7RxF45iuz8drQZazBFvXle5mGMUSqUNZhye
         V59Br0xY2ZJ2Ws2c3lvArQPzH3aRtBb1ZMKDBWk7WOogGVz1S4FCGaYPpdDXTZw1lemm
         Nr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iegIkb4fipqnzTjEHK3Rzo5fetpTzelf4+OZ20EGaxQ=;
        b=6aFtB8pg+WuVIMW+KcnMWC91Ri+pwIoywyst+lpvZfJvQwVlCf/PMub4eOt4C5Q07S
         aBclKneOgo6p9A9d6/LbLOy7O0obCQe4kO4PDcOzx7Up3N4kjrCbQTQ/HDSoIOLEPj4N
         aw+yL+Io3xPFU+tR6nqCHuGhU6EFmXJ24lsHca83BDr3CHWnJ5+DDUW/RoYWRonOogmH
         LsWsygwUORrulOx4AJAbWu+bprCx2ePfXflN0Q4Y0karpMQshBRJUQk07dFlph9llweX
         PWORDNBV1KcVHrVbP+0lBW7GQsBS+ZfYaGijjkg5np1USyjYK8RzX0x5yv1sJPaPjv/n
         1j0w==
X-Gm-Message-State: ANoB5plrSD0bcKDUVsYjzcKthg7AB3/iL+wXGtdtFsG4tfsNtLgpAyRp
        qOXgMltuZo90Vx7CW58q68KwFQ==
X-Google-Smtp-Source: AA0mqf6hzJAldb7QB0+TmhU70sfyI9ugpbVn1aL8hGBP0zumhEwBHDgD4o5f2wa/of7dOVE7+YARug==
X-Received: by 2002:a05:6512:34d0:b0:4a8:ebec:7140 with SMTP id w16-20020a05651234d000b004a8ebec7140mr22563341lfr.150.1669911667556;
        Thu, 01 Dec 2022 08:21:07 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c24-20020a056512075800b004a01105eea2sm690936lfs.150.2022.12.01.08.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 08:21:05 -0800 (PST)
Message-ID: <36565cc1-3c48-0fa8-f98b-414a7ac8f5bf@linaro.org>
Date:   Thu, 1 Dec 2022 17:21:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Content-Language: en-US
To:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221201090242.2381-4-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2022 10:02, Yanhong Wang wrote:
> Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.

Subject: drop second, redundant "bindings".

> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>  .../bindings/net/starfive,dwmac-plat.yaml     | 106 ++++++++++++++++++
>  MAINTAINERS                                   |   5 +
>  3 files changed, 112 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index d8779d3de3d6..13c5928d7170 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -33,6 +33,7 @@ select:
>            - snps,dwmac-5.20
>            - snps,dwxgmac
>            - snps,dwxgmac-2.10
> +          - starfive,dwmac
>  
>            # Deprecated
>            - st,spear600-gmac
> diff --git a/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml b/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
> new file mode 100644
> index 000000000000..561cf2a713ab
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml

Filename should base on compatible.

> @@ -0,0 +1,106 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) 2022 StarFive Technology Co., Ltd.
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/dwmac-starfive.yaml#"

Does not look like you tested the bindings. Please run `make
dt_binding_check` (see
Documentation/devicetree/bindings/writing-schema.rst for instructions).

> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"

Drop quotes from both lines.

> +
> +title: StarFive DWMAC glue layer
> +
> +maintainers:
> +  - Yanhong Wang <yanhong.wang@starfivetech.com>
> +
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - starfive,dwmac
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"

Drop quotes.

> +
> +properties:
> +  compatible:
> +    oneOf:

Drop oneOf. You do not have more cases here.

> +      - items:
> +          - enum:
> +               - starfive,dwmac

Wrong indentation.... kind of expected since you did not test the bindings.

> +          - const: snps,dwmac-5.20
> +
> +  clocks:
> +    items:
> +      - description: GMAC main clock
> +      - description: GMAC AHB clock
> +      - description: PTP clock
> +      - description: TX clock
> +      - description: GTXC clock
> +      - description: GTX clock
> +
> +  clock-names:
> +    contains:
> +      enum:
> +        - stmmaceth
> +        - pclk
> +        - ptp_ref
> +        - tx
> +        - gtxc
> +        - gtx

Names should be specific and with fixed order, just like clocks are.

> +
> +required:
> +  - compatible
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +
> +unevaluatedProperties: false
> +

Best regards,
Krzysztof

