Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A984EE249
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 22:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241198AbiCaUFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 16:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241171AbiCaUFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 16:05:49 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0861905AF
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 13:04:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id o10so1616734ejd.1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 13:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z2EGtbaUSdZqJdfHjTh9+r3ua+pSh9uHmfL1sOZD5QM=;
        b=HKF4UdRl+O0WSsymoX6w2BXJfg7HGXHE6hHgkyPszGlcZXlymHI3mC7nt7d91lCR13
         qqm1RjMspBXVqwPlQ+ZdMSuXRrI7vrNeLp8lWx7kwbBmceRfk8Is0n7eAEgvzJ2o0p45
         9Og1U9P0y+aYJV6v2RIg1ZSFmGI/1qXdEK9mTKvdVVtINthUR+8UW4NmNJHPScCltRug
         isQjTz9oZvGEmZdlE//NMg1bDmmkZ03Htu8wqpxoA6rFPzOIo/8A6m50jAAHsaSxAH4Y
         o4NnTzNNu4sx/lpn7FhhoDaufYAoDYsOM0XoCVG9rst2AWLsXqD0z0kYQaUcIw3o2ZbW
         n25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z2EGtbaUSdZqJdfHjTh9+r3ua+pSh9uHmfL1sOZD5QM=;
        b=iPvqxjsjoe3DFmWl6LruC2JRN5+gx98NrnkcGdRrv/0HJIY91fIeNo8LwmFfplgNT4
         mHZsGcx3Kymhsm2qwHdFZ3Xh88cw7dZATN549W21fxAFIh7gSxbv2uHyOoiVWCznfQKe
         jzzIi4skIuEc+74+18FtqUxlmveCoGMTNs+2LWnsGRrC/pGhoKQvMn8Y6KORez3iIu/c
         HkDvZ7q0rmRdcjX/6y73dwTe8kr5IV6LEp6Bs140wDGfBoZ+pIb5zkTi3K7Teb/TL2J7
         h0LwW3cCLKsJhvOLFKKDTF+uM1bprUxYfQVLTjN//aZfOLGVRxDxGap0DlfdjCdyOINr
         iZKA==
X-Gm-Message-State: AOAM533BL1hzlS7jB+mYiRCTaqDnkWmaZoTFSqj2CU12sbR+fq9sEHNr
        xRYqKaKMSCDBiFjFafFs9sppzg==
X-Google-Smtp-Source: ABdhPJzZ1JZCjRL24uzjb3wZLU0ZX28TmA+40iLJYWlpIPLhIfzvlPJ4Rv8WnVcGGMisztOOrsRCxw==
X-Received: by 2002:a17:907:d89:b0:6df:e54d:2462 with SMTP id go9-20020a1709070d8900b006dfe54d2462mr6492434ejc.97.1648757039749;
        Thu, 31 Mar 2022 13:03:59 -0700 (PDT)
Received: from [192.168.0.167] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id jv19-20020a170907769300b006e095c047d6sm150889ejc.109.2022.03.31.13.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 13:03:59 -0700 (PDT)
Message-ID: <6de0f1f6-2096-28fa-e213-907aeea4f703@linaro.org>
Date:   Thu, 31 Mar 2022 22:03:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 1/3] dt-bindings: net: convert mscc-miim to
 YAML format
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220331151440.3643482-1-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220331151440.3643482-1-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2022 17:14, Michael Walle wrote:
> Convert the mscc-miim device tree binding to the new YAML format.
> 
> The original binding don't mention if the interrupt property is optional
> or not. But on the SparX-5 SoC, for example, the interrupt property isn't
> used, thus in the new binding that property is optional. FWIW the driver
> doesn't use interrupts at all.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../devicetree/bindings/net/mscc,miim.yaml    | 55 +++++++++++++++++++
>  .../devicetree/bindings/net/mscc-miim.txt     | 26 ---------
>  2 files changed, 55 insertions(+), 26 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/mscc,miim.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mscc-miim.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc,miim.yaml b/Documentation/devicetree/bindings/net/mscc,miim.yaml
> new file mode 100644
> index 000000000000..b52bf1732755
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mscc,miim.yaml
> @@ -0,0 +1,55 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mscc,miim.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microsemi MII Management Controller (MIIM)
> +
> +maintainers:
> +  - Alexandre Belloni <alexandre.belloni@bootlin.com>
> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mscc,ocelot-miim
> +      - microchip,lan966x-miim
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +  reg:
> +    items:
> +      - description: base address
> +      - description: associated reset register for internal PHYs
> +    minItems: 1
> +
> +  interrupts: true

how many? maxItems

> +
> +required:
> +  - compatible
> +  - reg
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    mdio@107009c {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      compatible = "mscc,ocelot-miim";
> +      reg = <0x107009c 0x36>, <0x10700f0 0x8>;

Please put the compatible followed by reg at the beginning (first
properties).

Best regards,
Krzysztof
