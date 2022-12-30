Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFAC65976B
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 11:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbiL3KlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 05:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiL3KlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 05:41:15 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350A9BC87
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 02:41:14 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id bp15so31205384lfb.13
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 02:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LAt50/c1XxD+d5an6LMQKbLUUo7P/Ao2RnbkovM7714=;
        b=nocHCo/Y60JUaApj7QepMG0/BYQpgVEBD6JFQe6EwJv1va+ujnkO/ott5KiRJK8wTx
         cEX+4mxaieGqL/opS5CimllxoYV67A0PseukhIpmcozAa/CluPUE/r8wH7ZEln0JnKS/
         8cBBgeYSiza1ZiGU+Qdjaef7neIOkScslIwcWLz7pWe2FYI7B7dlMjeMbGeAfJUAVFMn
         o4mODUay6zb/zWlwgmi6acNiPB+Zz+3wO/hxaIyPFdXhlOV7JA8zvaWnOTENJK9RIDhE
         IXfb9ESaNYl+NlZaZ22hKIdagv3GnxY+mDhkYz9SKMf3h8xcs+ya+jbtqxjBIiXPB2E2
         s43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAt50/c1XxD+d5an6LMQKbLUUo7P/Ao2RnbkovM7714=;
        b=nWSBDYnHDvwy5CoXoKBzEyRCk2sQFx35iNaA6Ocr3HkQw3a3Rns1Ux4WSxysu19cn1
         w7kcKLLyaKboThZP17IKfUXMu2PIqrjdnn2f0Kjt/UynXHkVXyamJf/XKy+sfOMeU+cL
         OuVKHIFSOZHg7C0BxZtWNgQ0rhX58RQgfEsX0m9VpMu1LP/I68aTLzkl1V1+XTt/zXFB
         GsWvdDTQebT71N0rmJudrbYdXFZwyKWAf8MJRSzTopbqvgEB7UpudxMOu1FV5q/CdsoS
         8/a+hh2iLCCk2CMDR3M2OiFZHen9I745/i5mf+yLYbkF/YPvzqRBFcAnYQ3CdtZATGH2
         bA5w==
X-Gm-Message-State: AFqh2krFfaB9jxypVTHYfUMbbC3aZ1R8pjbyCN+cFE4p9hDoW199OWKY
        tNLzc9VbwVlB3ftMllQaHCeIzQ==
X-Google-Smtp-Source: AMrXdXsSkyaGu9E9QH7yKdMdxqcdZNJgrJO39Y3lFx2Nl+hw+pOn8KhPjTbifaGpSB/RJyJAiyU9Vg==
X-Received: by 2002:ac2:5604:0:b0:4ba:83f3:fb36 with SMTP id v4-20020ac25604000000b004ba83f3fb36mr8239472lfd.9.1672396872059;
        Fri, 30 Dec 2022 02:41:12 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id n20-20020a05651203f400b004a44ffb1023sm3436267lfq.57.2022.12.30.02.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 02:41:11 -0800 (PST)
Message-ID: <33196eef-b1d5-8dd2-7c59-16a73327e8c0@linaro.org>
Date:   Fri, 30 Dec 2022 11:41:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 01/19] dt-bindings: ARM: MediaTek: Add new document
 bindings of MT8188 clock
Content-Language: en-US
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20221230073357.18503-1-Garmin.Chang@mediatek.com>
 <20221230073357.18503-2-Garmin.Chang@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221230073357.18503-2-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/12/2022 08:33, Garmin.Chang wrote:
> Add the new binding documentation for system clock
> and functional clock on MediaTek MT8188.
> 

Subject: drop second, redundant "document bindings of".

> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>  .../arm/mediatek/mediatek,mt8188-clock.yaml   |  71 ++
>  .../mediatek/mediatek,mt8188-sys-clock.yaml   |  55 ++
>  .../dt-bindings/clock/mediatek,mt8188-clk.h   | 733 ++++++++++++++++++
>  3 files changed, 859 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt8188-clock.yaml
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt8188-sys-clock.yaml
>  create mode 100644 include/dt-bindings/clock/mediatek,mt8188-clk.h
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt8188-clock.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt8188-clock.yaml
> new file mode 100644
> index 000000000000..6654cead71f6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt8188-clock.yaml

Clock controllers do not go to arm but to clock. It's so suprising
directory that I missed to notice it in v1... Why putting it in some
totally irrelevant directory?


> @@ -0,0 +1,71 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt8188-clock.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek Functional Clock Controller for MT8188
> +
> +maintainers:
> +  - Garmin Chang <garmin.chang@mediatek.com>
> +
> +description: |
> +  The clock architecture in MediaTek like below
> +  PLLs -->
> +          dividers -->
> +                      muxes
> +                           -->
> +                              clock gate
> +
> +  The devices provide clock gate control in different IP blocks.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mediatek,mt8188-adsp-audio26m
> +      - mediatek,mt8188-imp-iic-wrap-c
> +      - mediatek,mt8188-imp-iic-wrap-en
> +      - mediatek,mt8188-imp-iic-wrap-w
> +      - mediatek,mt8188-mfgcfg
> +      - mediatek,mt8188-vppsys0
> +      - mediatek,mt8188-wpesys
> +      - mediatek,mt8188-wpesys-vpp0
> +      - mediatek,mt8188-vppsys1
> +      - mediatek,mt8188-imgsys
> +      - mediatek,mt8188-imgsys-wpe1
> +      - mediatek,mt8188-imgsys-wpe2
> +      - mediatek,mt8188-imgsys-wpe3
> +      - mediatek,mt8188-imgsys1-dip-top
> +      - mediatek,mt8188-imgsys1-dip-nr
> +      - mediatek,mt8188-ipesys
> +      - mediatek,mt8188-camsys
> +      - mediatek,mt8188-camsys-rawa
> +      - mediatek,mt8188-camsys-yuva
> +      - mediatek,mt8188-camsys-rawb
> +      - mediatek,mt8188-camsys-yuvb
> +      - mediatek,mt8188-ccusys
> +      - mediatek,mt8188-vdecsys-soc
> +      - mediatek,mt8188-vdecsys
> +      - mediatek,mt8188-vencsys
> +
> +  reg:
> +    maxItems: 1
> +
> +  '#clock-cells':
> +    const: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - '#clock-cells'
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    clock-controller@11283000 {
> +        compatible = "mediatek,mt8188-imp-iic-wrap-c";
> +        reg = <0x11283000 0x1000>;
> +        #clock-cells = <1>;
> +    };
> +
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt8188-sys-clock.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt8188-sys-clock.yaml
> new file mode 100644
> index 000000000000..2b28df1ff895
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt8188-sys-clock.yaml

Wrong directory.

> @@ -0,0 +1,55 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt8188-sys-clock.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek System Clock Controller for MT8188
> +
> +maintainers:
> +  - Garmin Chang <garmin.chang@mediatek.com>
> +
> +description: |
> +  The clock architecture in MediaTek like below
> +  PLLs -->
> +          dividers -->
> +                      muxes
> +                           -->
> +                              clock gate
> +
> +  The apmixedsys provides most of PLLs which generated from SoC 26m.
> +  The topckgen provides dividers and muxes which provide the clock source to other IP blocks.
> +  The infracfg_ao provides clock gate in peripheral and infrastructure IP blocks.
> +  The mcusys provides mux control to select the clock source in AP MCU.
> +  The device nodes also provide the system control capacity for configuration.
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - mediatek,mt8188-topckgen
> +          - mediatek,mt8188-infracfg-ao
> +          - mediatek,mt8188-apmixedsys
> +          - mediatek,mt8188-pericfg-ao
> +      - const: syscon
> +
> +  reg:
> +    maxItems: 1
> +
> +  '#clock-cells':
> +    const: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - '#clock-cells'
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    syscon@10000000 {

clock-controller

> +        compatible = "mediatek,mt8188-topckgen", "syscon";
> +        reg = <0x10000000 0x1000>;
> +        #clock-cells = <1>;



Best regards,
Krzysztof

