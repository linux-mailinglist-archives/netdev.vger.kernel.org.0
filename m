Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1C15B3C22
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbiIIPiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiIIPhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:37:43 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19A972862
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 08:36:33 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w8so3304811lft.12
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 08:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=72IKp5JhqIMtfECNJjjPmdnnrzUSSSK/UrmLy7eeLeQ=;
        b=NXdEY12XTeuuYu/Csekbn0zatod6oeuRuFZvKmX4iAA5javleoseYqK1qRO4vkPYo7
         CDRBGpMwmQCPv1UzH0BkpkfkR30Cn4qvchRwM6quuYautlo1W7Lg+yvZk6HJOVrPzTAU
         sPEYOH9LXxu1FT/Nml9aRhijaVUIEGH7COlz5KuHXKGoMcL/vy0dPcOAyvbr5x4DeS+B
         E4GYyjRqwXj4ibKVszV4Qbp64trC3tegr59Yzswwani/Tu9QlgX0gI1YWAvDiGqT49Rj
         WRaMGVBwMQ5sq6fn64MjQjZN/9nETr+AyrJaGk91XhZ36HLBnGe/+m24EQg8PCtDFp4M
         +JBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=72IKp5JhqIMtfECNJjjPmdnnrzUSSSK/UrmLy7eeLeQ=;
        b=EK2JsqgpkRmWJXF+S5bFiQ5Q4ZEK2hZAUz7bATXvLuKVB/jhrdwyqZhHRkZ2wxmhF6
         i4EH+YHjx4lNya33CJPgmXEhrJD5SVAhSarQdhjxPChtyDV/ZxgaoDRt+0D2W03UrNtZ
         PHT7RA9xz0wNmMyIUo70wm7pv37GorJCvCOyUV07T/2lg2NlR00xh0CDmcHTK1RJdztW
         kkyCRR7gL1C1d9Nuw+vswXAVrKcTn2I3/898vLMvgNkes55vB3Rfh7/i7Wfa+b/0murH
         LWE/k8YFyLmMJ7k1jC9UnkrqbMRtBPzz/RCMtSV3uUs545jHYghJzHq9yi6QaymdNzc/
         jQFg==
X-Gm-Message-State: ACgBeo1neCuyMpkpX1yuoXfydJnNbuijw41O7yAkkD/I1WmXtU0j1GCx
        joyfC4+V+EZe7+FUPFsXldGhTA==
X-Google-Smtp-Source: AA6agR5ShChGjwnDe/Nujbbb6w5SJ8/ttzb3Xq7V2kmdtDFt30nqRthe1GZPt8gf0RZUuSdxenWjlA==
X-Received: by 2002:a05:6512:3d02:b0:498:f4d4:e246 with SMTP id d2-20020a0565123d0200b00498f4d4e246mr2147165lfv.115.1662737746822;
        Fri, 09 Sep 2022 08:35:46 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id a2-20020a056512374200b00496693860dcsm117246lfs.232.2022.09.09.08.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 08:35:46 -0700 (PDT)
Message-ID: <54cc906d-0b79-e9fb-c025-2e361d1fa03c@linaro.org>
Date:   Fri, 9 Sep 2022 17:35:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v4 4/5] net: dt-bindings: Introduce the Qualcomm
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
References: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
 <20220909152454.7462-5-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220909152454.7462-5-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2022 17:24, Maxime Chevallier wrote:
> Add the DT binding for the IPQESS Ethernet Controller. This is a simple
> controller, only requiring the phy-mode, interrupts, clocks, and
> possibly a MAC address setting.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V3->V4:
>  - Fix a binding typo in the compatible string
> V2->V3:
>  - Cleanup on reset and clock names
> V1->V2:
>  - Fixed the example
>  - Added reset and clocks
>  - Removed generic ethernet attributes
> 
>  .../devicetree/bindings/net/qcom,ipqess.yaml  | 95 +++++++++++++++++++
>  1 file changed, 95 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipqess.yaml b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> new file mode 100644
> index 000000000000..3d2f790647cd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> @@ -0,0 +1,95 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,ipqess.yaml#

Filename based on the compatible, so qcom,ipq4019-ess-edma.yaml

Apologies for not bringing it up earlier...

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm IPQ ESS EDMA Ethernet Controller
> +
> +maintainers:
> +  - Maxime Chevallier <maxime.chevallier@bootlin.com>
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"

Drop quotes.


Best regards,
Krzysztof
