Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F152B672223
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjARPwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjARPvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:51:32 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63473F299
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:49:36 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id o17-20020a05600c511100b003db021ef437so1839642wms.4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zZKLrjDE6gNxqEyqtKQtAvgreZnol5CzLZ53Y6iptjQ=;
        b=DlobVO+fkH8lmWsg1Xbf+Les5HoBiix+EaSOkIu5MwtszuT9dbvx5yOdyy679QZS7H
         CgPzbDI2fqg6KzaW9TiPApqEfeZG3Stt6b1sMjK6A8u1y6ydyF+/E0c8h8xH6g/UN/WG
         sTmOzb/K64HbvxlGd1RvxKQmH+BSoaJlt1k6dOirDf01+HFJdZPCdvv9YjuYqusHZUPv
         gYo7DFQ19DZmUNThj8aJBEc2NsecSdoOrJdc5fjupVNSRfI+3b+8kB7LxraGqDeVZMR9
         UHp7s/tTfKavPWZOipGA+yzU4HQGkBAuQi9JxOd9PxN3pU6hmk+64iKMMQcs4OVIzuAx
         ZGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZKLrjDE6gNxqEyqtKQtAvgreZnol5CzLZ53Y6iptjQ=;
        b=OZmyeN3bTozQE+gLpY/cC9g/oyd2XlXZJ4++1uMxRaDjDzEkMGOQVSL2idHN9TkGTQ
         aNhimpuyVmpYzhPSs9ZST7EGEZgsTyxl/g9CjLmmaIB/gDrAEjbW22RPi35MLYIFoZJa
         e8Pifv96fiJEy7nEba+8cPAL/mqFRLeDP0llAuKi5u3yiMBK/DViTIbQQYWw649qpSoA
         VVcLGrrqI95GWP1kTf2ZY5GkE8b/doFohTuYnqlWX7S9Dv2H1voy45Xq+eEez+lXshwo
         lzz+LLmoxN1p/UraT7plRqI0gsCJp0nJCms4WpUyydTo441z0IT/mZay6yBxIJiPdnRn
         +/WQ==
X-Gm-Message-State: AFqh2kqdRjaDX1tQBN80GdoMQ0WixFKoNVLqgNAEmm8uXqZe/DnXpdh5
        9mSm77yUFitesD5X/l67pJmCNg==
X-Google-Smtp-Source: AMrXdXvUXPw/cK446ap5ID8iRUgB13K9qZXkhy+nek/O84uQWg7WqzMIXywLZvU1ZWBitD0vM9ljLA==
X-Received: by 2002:a05:600c:511f:b0:3d0:bd9:edd4 with SMTP id o31-20020a05600c511f00b003d00bd9edd4mr7080861wms.0.1674056975399;
        Wed, 18 Jan 2023 07:49:35 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id b11-20020a05600018ab00b002be2279f100sm5447471wri.96.2023.01.18.07.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 07:49:35 -0800 (PST)
Message-ID: <102db6ae-742b-ea20-076e-386a0284a185@linaro.org>
Date:   Wed, 18 Jan 2023 16:49:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v4 4/7] dt-bindings: net: Add support StarFive dwmac
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
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-5-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230118061701.30047-5-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2023 07:16, Yanhong Wang wrote:
> Add documentation to describe StarFive dwmac driver(GMAC).
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>


Subject is poor. You miss device prefix and it's not correct sentence.

"Add support for XYZ"
or better:
"Add XYZ"


> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>  .../bindings/net/starfive,jh7110-dwmac.yaml   | 113 ++++++++++++++++++
>  MAINTAINERS                                   |   5 +
>  3 files changed, 119 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index baf2c5b9e92d..8b07bc9c8b00 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -91,6 +91,7 @@ properties:
>          - snps,dwmac-5.20
>          - snps,dwxgmac
>          - snps,dwxgmac-2.10
> +        - starfive,jh7110-dwmac
>  
>    reg:
>      minItems: 1
> diff --git a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> new file mode 100644
> index 000000000000..eb0767da834a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> @@ -0,0 +1,113 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) 2022 StarFive Technology Co., Ltd.
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/starfive,jh7110-dwmac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: StarFive JH7110 DWMAC glue layer
> +
> +maintainers:
> +  - Yanhong Wang <yanhong.wang@starfivetech.com>
> +
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - starfive,jh7110-dwmac
> +  required:
> +    - compatible
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - starfive,jh7110-dwmac
> +      - const: snps,dwmac-5.20
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
> +    items:
> +      - const: stmmaceth
> +      - const: pclk
> +      - const: ptp_ref
> +      - const: tx
> +      - const: gtxc
> +      - const: gtx
> +
> +  resets:
> +    items:
> +      - description: MAC Reset signal.

Drop trailing dot

> +      - description: AHB Reset signal.

Ditto

> +
> +  reset-names:
> +    items:
> +      - const: stmmaceth
> +      - const: ahb

You have two resets. Why do you change them to three for all variants?
It's not explained in commit 2/7, so this is confusing.

> +
> +allOf:
> +  - $ref: snps,dwmac.yaml#
> +
> +unevaluatedProperties: true
> +
> +required:
> +  - compatible
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +


Best regards,
Krzysztof

