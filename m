Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0742C50CCC2
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 19:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiDWRwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 13:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbiDWRwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 13:52:32 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7459B1C82E5
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 10:49:33 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g23so6972925edy.13
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 10:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zzTlr5i1vBH3eZkwgYdNgfi9JX5fLc8qr1ql93tJV/Y=;
        b=K+1SaZwztaHUvVqD4eNlYpZBN76mjtx6X5TywZ3y38vEWUlCs3d3C8MG++H7IoHYDC
         obAlZ/MFE+RmLzK9BST6KuGjJgj2nvuxyf+EArxIFmALpq7dutV6VEVcrWnef1iZqfqu
         gsvljKL8WC0w2kuY/LP5FZJr0Cljwtb0q6RJYd5mHPwTHiHZQMBsMsbMIkawn+YRaPV5
         xR6zfWn6NS16/H+5Phh3JIRq6JLCN3166AGSz5ZSR/j3UDt27gwBrNEW3Jjy3UFAYwl/
         O5ehOaVT1XdJYZaveHMdsVPQP/+X762VrAFvmtHYQHPLhYENkSK48IKmGKBAYGwuZ0vC
         ol5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zzTlr5i1vBH3eZkwgYdNgfi9JX5fLc8qr1ql93tJV/Y=;
        b=dtEucROXkotBkBnVufsvUJoG6GUNi/dcgCoSHcAR8UmgGqLSAqiax2Zo4OV1Pv/stl
         f/lqD+ugrtbHJK7X7SgBrg8iONzz+IljTmNPzHTjLFqpXw2SFOHCSCua3f8pXTD81ylL
         9/ZWbYcHlPuWAf9QsUT0JowOmPhMxuQVVMYB4FcXIacgZWWgJwLV9Ga376GZVzqAWuiK
         1v1JLnbL2nsQ3frkkTfzaKe//Er0d1m35M/c5LgLJt7L9BA57xp2i0BxakYPirV0nPdx
         KPPdvbQ8gPj5NRXMVwWSTiMapFwcTyPHQLN7cvYOsDnKDbAA340fTvVF8g/+3z9mtRVV
         5Ikw==
X-Gm-Message-State: AOAM5333l1MdBSegRSJ9e8+/IR8Mxkc6w3tRlGSpbz3dcs1hmnYUsl9d
        mwg2JEyIIFUaG//Gt50vsrnuRQ==
X-Google-Smtp-Source: ABdhPJw/vOnH+HBxj1ggcvptoHPHf/x94iLfOJcPMwCd4J+FV95mNVywr9SyxLVrLvWEXCzt9EK7aA==
X-Received: by 2002:a05:6402:4493:b0:41d:83ca:35d6 with SMTP id er19-20020a056402449300b0041d83ca35d6mr10731655edb.89.1650736172007;
        Sat, 23 Apr 2022 10:49:32 -0700 (PDT)
Received: from [192.168.0.234] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id r22-20020a17090638d600b006d584aaa9c9sm1871730ejd.133.2022.04.23.10.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 10:49:31 -0700 (PDT)
Message-ID: <34d3bfdc-cf8c-bf63-4f67-57c8d6c9b780@linaro.org>
Date:   Sat, 23 Apr 2022 19:49:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 4/5] net: dt-bindings: Introduce the Qualcomm
 IPQESS Ethernet controller
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
 <20220422180305.301882-5-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220422180305.301882-5-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/04/2022 20:03, Maxime Chevallier wrote:
> Add the DT binding for the IPQESS Ethernet Controller. This is a simple
> controller, only requiring the phy-mode, interrupts, clocks, and
> possibly a MAC address setting.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  .../devicetree/bindings/net/qcom,ipqess.yaml  | 94 +++++++++++++++++++
>  1 file changed, 94 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipqess.yaml b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> new file mode 100644
> index 000000000000..8fec5633692f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> @@ -0,0 +1,94 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,ipqess.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm IPQ ESS EDMA Ethernet Controller Device Tree Bindings

s/Device Tree Bindings//

> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"

allOf goes after maintainers.

> +
> +maintainers:
> +  - Maxime Chevallier <maxime.chevallier@bootlin.com>
> +
> +properties:
> +  compatible:
> +    const: qcom,ipq4019e-ess-edma
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 2
> +    maxItems: 32
> +    description: One interrupt per tx and rx queue, with up to 16 queues.
> +
> +  clocks:
> +    maxItems: 1
> +
> +  phy-mode: true
> +
> +  fixed-link: true
> +
> +  mac-address: true

You don't need all these three. They come from ethernet-controller and
you use unevaluatedProperties.

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - phy-mode
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    gmac: ethernet@c080000 {
> +        compatible = "qcom,ipq4019-ess-edma";
> +        reg = <0xc080000 0x8000>;
> +        interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
> +
> +        status = "okay";

No status in the example.

> +
> +        phy-mode = "internal";
> +        fixed-link {
> +            speed = <1000>;
> +            full-duplex;
> +            pause;
> +            asym-pause;
> +        };
> +    };
> +
> +...


Best regards,
Krzysztof
