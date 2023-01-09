Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781D4662E9C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbjAIST6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbjAIST3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:19:29 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6403FC94
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:15:46 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id co23so9099821wrb.4
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v9qTkdR1ZbLrR4uwBvG+cFHyG1RoSH8RVcKCF/fDWbI=;
        b=V76AE4eWGQ90qqROlfKX4/ESuAfJiI2v5hMmccYLnjlOLaeNUnE3Td+46exmFLMC3L
         OMUQtNbyNTbUULIFiHLTra24SgXPhINyJ/70m0PUHHB0/B5EB5DG6QmVvaamlkjHRcMx
         vZrVbN63DlV9JExrMxUPKTFjX+rCAULJL5/cwbzNzT5u0yHASk8djZ0ljR2wR+pYXrMZ
         k1wbc4YIUPTOzpqbJsKcvylGHYqJt9As6j2IlJ5l61xssvDVM+tjgTYl9ibK9cQ3Vjzj
         2ZCklcwLtu7fbQXnOjLc/nof4HlswN5bPWFe8G2oXIrJvWJ1lMcdNM3beYJIwHPO9GVb
         Vh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v9qTkdR1ZbLrR4uwBvG+cFHyG1RoSH8RVcKCF/fDWbI=;
        b=C+nsM3koNHGxlrh+39VWlll03pdHzMTnUOGycSI7CUejiz6XxNERSqK5zEE/6lqpTd
         RppDLFIRtEfUInjvkbGymC1rFLddgIWIUQqKEmUkJNdX9h5qcTbX1scUaW/OLQUzmt+X
         vJnkGZm+ttfvnncxlkId4GMurfIKnfTJdDTOzCEsjUXAQ9RVfg0e5DYNtKdYAvLW6GFw
         etsExpYNbVSlYhqrgB191jOOjdaeiuWNZpGzPY+LCtriSSF5dIBDfxLr2tozN6+nLuJq
         Tk1lsLHNj5IFcUy7iZvGyPxn4iITWOAnKVqzA8T4mxVQ6NApkrdoYyuSOQRnElnySfM9
         SwYA==
X-Gm-Message-State: AFqh2kqbGBAHEtk5gi42z3/xiagT4JFk2I+JFb5IaxDzdx/ktF84U9G2
        dqIEbO6492wzTE6hgCo+Uu3ifw==
X-Google-Smtp-Source: AMrXdXveSwRSuQjri9IyexgwZerG8NIbVoPfoHHq7+dNuHOkaLQbSfhwjMkmPoTXZxrUsBpdjGGVJg==
X-Received: by 2002:a5d:61cd:0:b0:276:d6ba:4b91 with SMTP id q13-20020a5d61cd000000b00276d6ba4b91mr35478492wrv.47.1673288144839;
        Mon, 09 Jan 2023 10:15:44 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id f3-20020adfdb43000000b00236883f2f5csm9337086wrj.94.2023.01.09.10.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:15:44 -0800 (PST)
Message-ID: <46e70bb1-0745-ca77-856a-0e728b7c2c84@linaro.org>
Date:   Mon, 9 Jan 2023 19:15:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 01/18] dt-bindings: clock: sa8775p: add bindings for
 Qualcomm gcc-sa8775p
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-2-brgl@bgdev.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230109174511.1740856-2-brgl@bgdev.pl>
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

On 09/01/2023 18:44, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add DT bindings for the GCC clock on SA8775P platforms. Add relevant
> DT include definitions as well.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  .../bindings/clock/qcom,gcc-sa8775p.yaml      |  77 +++++

Use name style like SM8550.

>  include/dt-bindings/clock/qcom,gcc-sa8775p.h  | 320 ++++++++++++++++++
>  2 files changed, 397 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc-sa8775p.yaml
>  create mode 100644 include/dt-bindings/clock/qcom,gcc-sa8775p.h
> 
> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sa8775p.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sa8775p.yaml
> new file mode 100644
> index 000000000000..35d92d94495a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sa8775p.yaml
> @@ -0,0 +1,77 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/clock/qcom,gcc-sa8775p.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Global Clock & Reset Controller on sa8775p
> +
> +maintainers:
> +  - Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> +
> +description: |
> +  Qualcomm global clock control module provides the clocks, resets and
> +  power domains on sa8775p.
> +
> +  See also:: include/dt-bindings/clock/qcom,gcc-sa8775p.h
> +
> +properties:
> +  compatible:
> +    const: qcom,gcc-sa8775p

Here as well.

> +
> +  clocks:
> +    items:
> +      - description: XO reference clock
> +      - description: Sleep clock
> +      - description: UFS memory first RX symbol clock
> +      - description: UFS memory second RX symbol clock
> +      - description: UFS memory first TX symbol clock
> +      - description: UFS card first RX symbol clock
> +      - description: UFS card second RX symbol clock
> +      - description: UFS card first TX symbol clock
> +      - description: Primary USB3 PHY wrapper pipe clock
> +      - description: Secondary USB3 PHY wrapper pipe clock
> +      - description: PCIe 0 pipe clock
> +      - description: PCIe 1 pipe clock
> +      - description: PCIe PHY clock
> +      - description: First EMAC controller reference clock
> +      - description: Second EMAC controller reference clock
> +
> +  protected-clocks:
> +    maxItems: 240
> +
> +required:
> +  - compatible
> +  - clocks
> +
> +allOf:
> +  - $ref: qcom,gcc.yaml#
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/qcom,rpmh.h>
> +    gcc: clock-controller@100000 {
> +        compatible = "qcom,gcc-sa8775p";
> +        reg = <0x100000 0xc7018>;
> +        #clock-cells = <1>;
> +        #reset-cells = <1>;
> +        #power-domain-cells = <1>;
> +        clocks = <&rpmhcc RPMH_CXO_CLK>,
> +                 <&sleep_clk>,
> +                 <0>,
> +                 <0>,
> +                 <0>,
> +                 <0>,
> +                 <0>,
> +                 <0>,
> +                 <0>,
> +                 <0>,
> +                 <&usb_0_ssphy>,
> +                 <0>,
> +                 <0>,
> +                 <0>,
> +                 <0>;

All these should be real in example.

> +    };
> +...
> diff --git a/include/dt-bindings/clock/qcom,gcc-sa8775p.h b/include/dt-bindings/clock/qcom,gcc-sa8775p.h
> new file mode 100644
> index 000000000000..badc253379c9
> --- /dev/null
> +++ b/include/dt-bindings/clock/qcom,gcc-sa8775p.h

Filename needs adjustments.

> @@ -0,0 +1,320 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */

Dual license.

> +/*
> + * Copyright (c) 2022, Qualcomm Innovation Center, Inc. All rights reserved.
> + * Copyright (c) 2023, Linaro Limited
> + */
Best regards,
Krzysztof

