Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C612619D89
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiKDQnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiKDQmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:42:43 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720352BB0A
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 09:42:42 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g24so5406604plq.3
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 09:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HwyjxWhZP/MgIgc5HM4/DGfwKdzwFd87DAz0NuXY8dw=;
        b=xGqZScJ8boQw8m8d7rB+ASPYAOPe2WE8nrsOx2qcbG5iG7rIVKFDzyr7pVcEpUmjNV
         p/nLqSgB1hU200+S88ug1jVS9tYZwBpZFtJJx1VxIUEVV/rslXj2arxQ9xc90mY+cokw
         g99Z7Wdyy8PnCtB061AJG3IvPYYu3764iGjOqwYz5uxIJF4uXPKYGAtpSDFbuzSD3vgl
         5tvVQ1pfME1LMkjFdRht2HUiHww9G5+5tqem7IKN4ifZSjM9BDqo78sEbuVljRGqR9u+
         IOQUkROjy4U5+edGGbe2BG6un6yAoj9hUka1LcsL2qkgWh7v6c6G0X13T17cLMv6a+ab
         2rug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HwyjxWhZP/MgIgc5HM4/DGfwKdzwFd87DAz0NuXY8dw=;
        b=K37T1aAtIOBaZGllHRKF4lkYoAHFgDOH/28sHZdSA23dZsIzhHkU6/Rme2D3CB1nFX
         tcgEAHDpnKcxVXohhhCKLOE52/BNSKEJt4nbsdKfM5IyZPSuysAOptLz5KfQBZ8HHe4m
         SIbdVhC4c4NNNXpITvt/4+/Po9CT+qbWZ/MxicjKKIrkneB90vZECT98t7gp2sWDqmzY
         l5K9qLDzpg+8GQJ3G85guXd5Km5Sd8Kky5pALVeCftEktSGXj4YSGdceU1i5jc5li4mt
         ZiDPlnR2JZHW6eSrd5WXdIO//BXhwkKfXivHbABxg/a11MHUUQQGqqAv4ZwXG4zH3h+I
         l8zA==
X-Gm-Message-State: ACrzQf20vTB0xPSROhHUenL1Ok9mEdpZ5WTAzOfFBx9+hXRGnj3IInQ4
        K+48fWE0bc+K9zhM5zCNjHYlfbvnjR8lvEupqP05rA==
X-Google-Smtp-Source: AMsMyM5W4PMELNbAUb/lCFcSeStB7XeYIssPubhTCYDlCbdwq23rNZtSX9WBSCEmwJOAlx6ldI/sXbNs7re6ZZQuvhI=
X-Received: by 2002:a17:902:edc3:b0:172:8ae3:9778 with SMTP id
 q3-20020a170902edc300b001728ae39778mr35968030plk.72.1667580161879; Fri, 04
 Nov 2022 09:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com> <20221104142746.350468-6-maxime.chevallier@bootlin.com>
In-Reply-To: <20221104142746.350468-6-maxime.chevallier@bootlin.com>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Fri, 4 Nov 2022 17:42:30 +0100
Message-ID: <CA+HBbNHTmpPJqzja11OqS9J-37vdDiDLubrimke73x+oQKuoJA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 4, 2022 at 3:28 PM Maxime Chevallier
<maxime.chevallier@bootlin.com> wrote:
>
> The Qualcomm IPQ4019 includes an internal 5 ports switch, which is
> connected to the CPU through the internal IPQESS Ethernet controller.
>
> Add support for this internal interface, which is internally connected to a
> modified version of the QCA8K Ethernet switch.
>
> This Ethernet controller only support a specific internal interface mode
> for connection to the switch.
>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> V6->V7:
>  - No Changes
> V5->V6:
>  - Removed extra blank lines
>  - Put the status property last
> V4->V5:
>  - Reword the commit log
> V3->V4:
>  - No Changes
> V2->V3:
>  - No Changes
> V1->V2:
>  - Added clock and resets
>
>  arch/arm/boot/dts/qcom-ipq4019.dtsi | 44 +++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
> index b23591110bd2..5fa1af147df9 100644
> --- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
> +++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
> @@ -38,6 +38,7 @@ aliases {
>                 spi1 = &blsp1_spi2;
>                 i2c0 = &blsp1_i2c3;
>                 i2c1 = &blsp1_i2c4;
> +               ethernet0 = &gmac;
>         };
>
>         cpus {
> @@ -591,6 +592,49 @@ wifi1: wifi@a800000 {
>                         status = "disabled";
>                 };
>
> +               gmac: ethernet@c080000 {
> +                       compatible = "qcom,ipq4019-ess-edma";
> +                       reg = <0xc080000 0x8000>;
> +                       resets = <&gcc ESS_RESET>;
> +                       reset-names = "ess";
> +                       clocks = <&gcc GCC_ESS_CLK>;
> +                       clock-names = "ess";
> +                       interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
> +                       phy-mode = "internal";
> +                       status = "disabled";

The fixed-link should be defined here AFAIK, otherwise it will fail probing with
just internal PHY mode.

Regards,
Robert
> +               };
> +
>                 mdio: mdio@90000 {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
> --
> 2.37.3
>


-- 
Robert Marko
Staff Embedded Linux Engineer
Sartura Ltd.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
