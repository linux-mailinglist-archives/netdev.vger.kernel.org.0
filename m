Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB1A616C6B
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiKBSgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiKBSgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:36:41 -0400
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76407303F4;
        Wed,  2 Nov 2022 11:35:50 -0700 (PDT)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-13c569e5ff5so20859933fac.6;
        Wed, 02 Nov 2022 11:35:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A/CuXeX5BAmh1fy0gv5umwNjOEiAdicnjnxUO4ZSgqI=;
        b=ZWitSwO2UOAh7n6vGDEFLK0p/52dQ8/7C6YfFjZedEPdFPnvV8QRoiudEJCX/KOxKe
         eCRF1TaYu3vTIokj9FEjpWGjLFONQgnglYODrhhxKsuHIQFrg8V2VxHO2pjz88CK1m+q
         lNXcLVOimHCR2+hvD0bt90cbfjaDl61EyPIi70Hm0lt2umSmkNtp9iYHxj2w+TrCUSr3
         H6HwSUzM0qXq4GzXVuZXiwuUksjsx5P+fTI2eUxxltdRIOw9QagC3LcnxlvAz8IW4Krk
         tRpq2+cUtcaK0n7krBAWd1eAQ8MN/DPKqb+xayJPMj5kP8dzC3T2zZOTWZcZXKwXwbud
         qcWg==
X-Gm-Message-State: ACrzQf3qZKuwVu75OZ2+zaHNCM6pWQwlayUM6TrPza81PjS0HdGBBK3X
        C0pTm1BJZfML1kesPnsjhQ==
X-Google-Smtp-Source: AMsMyM7CmXp9Hfz0+ZuQVyxpx2aFwopthUXM7VzE06aXbO1uz1eEkTzlRg4N4mxvNNz525kGB6pndw==
X-Received: by 2002:a05:6870:4607:b0:127:fd93:4752 with SMTP id z7-20020a056870460700b00127fd934752mr25203464oao.64.1667414149652;
        Wed, 02 Nov 2022 11:35:49 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d22-20020a056830045600b0066210467fb1sm5384100otc.41.2022.11.02.11.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 11:35:49 -0700 (PDT)
Received: (nullmailer pid 130546 invoked by uid 1000);
        Wed, 02 Nov 2022 18:35:50 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221102161211.51139-1-krzysztof.kozlowski@linaro.org>
References: <20221102161211.51139-1-krzysztof.kozlowski@linaro.org>
Message-Id: <166741398630.127357.13160524174654511434.robh@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: nxp,sja1105: document spi-cpol
Date:   Wed, 02 Nov 2022 13:35:50 -0500
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 02 Nov 2022 12:12:11 -0400, Krzysztof Kozlowski wrote:
> Some boards use SJA1105 Ethernet Switch with SPI CPOL, so document this
> to fix dtbs_check warnings:
> 
>   arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/


ethernet-switch@1: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'fsl,spi-cs-sck-delay', 'fsl,spi-sck-cs-delay', 'spi-cpha' were unexpected)
	arch/arm/boot/dts/ls1021a-tsn.dtb

switch@0: Unevaluated properties are not allowed ('clocks', 'reset-gpios', 'spi-cpha' were unexpected)
	arch/arm/boot/dts/imx6qp-prtwd3.dtb
	arch/arm/boot/dts/stm32mp151a-prtt1c.dtb

