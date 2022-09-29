Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5605EEEDD
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiI2HXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiI2HW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:58 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F7A1181F5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:49 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id s10so575502ljp.5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=MezbcwOoul10g9j1qktZYyuEnrjgCGFz14Jt2OIrWcU=;
        b=RhniWHb7IPXZdipNBOkrg2N2RPwnujVy2ZHUcFjJqBAAyZ+M8xTFHYrzfpIMhTY3D7
         vyACY7zKLtg0e0PQ7Jd36pZWSw6Y25tUHKDTZopGN5QzHEUNqJcR8bg7iuy/dg3m1YOe
         9YZa+L+76BZZVi/r3qzlsQ2KyB3F1+aWNFbUqyvVFMmuzfq42OdMTB67FB/rTAu/61sq
         xpAZyzBdHYFr+/mNGcXwLMqst/ykhLJUa89bvphSzgn3T5NkMYs41qhD0qRDfc6Om7Fl
         7/myZVmBXsyGoTeCLw0E6gxNxUDc9qb3rHvWTQOhSD1wl9RlS/rATvrQ265OnTM/3+gv
         b4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=MezbcwOoul10g9j1qktZYyuEnrjgCGFz14Jt2OIrWcU=;
        b=A8TRdL3ADylV8X+sOTAjcLrmDojNMqqD6MDxqGFXf4i5uVbAoTeMyN/jq+4hvF/2hz
         yzRdtdGkBQsrn3XIbGuNNLWXMdP8JfZgJptinVIV+DTA9/K2SM6PuLMSYFKoU5uFcMTS
         gE2SMslKigIpYqgG6UohPkBXiRwF0bWMNXjUmXFuitWWY6Eh/HEo6Eso8gXDagca9FK3
         Jb+GuftyzUmWSZpclovceTeB0PFmCfdEP5n+//bILZKzyDem/gmHXqjoq2JKkI+ftLme
         qGd/ndOP/6nPPfOwPu7pTbjcg7jST+0NlI/AW+QyIE8WA+2eOJLQLvUk3rG3q248C8B3
         iEaQ==
X-Gm-Message-State: ACrzQf0jHZigp5V4aVFJSn8YV874+nv5hP0KUs2vizT8O+n7Ffoi5+zF
        ZyShCN3FRdnt6NSOb3YvaFYbSA==
X-Google-Smtp-Source: AMsMyM6G2n0Z1F3luJ+lGSBmmYESgaPvryPRha5PxI/XaKOCaJdB1gaXz9Rb5f0m4SUJFlXrO/h+yw==
X-Received: by 2002:a2e:98c2:0:b0:26c:5d10:63dd with SMTP id s2-20020a2e98c2000000b0026c5d1063ddmr663534ljj.326.1664436167326;
        Thu, 29 Sep 2022 00:22:47 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id z12-20020ac2418c000000b00494813c689dsm701400lfh.219.2022.09.29.00.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 00:22:46 -0700 (PDT)
Message-ID: <4e896382-c666-55c6-f50b-5c442e428a2b@linaro.org>
Date:   Thu, 29 Sep 2022 09:22:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 3/4] dt-bindings: net: qcom,ethqos: Convert bindings to
 yaml
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
 <20220929060405.2445745-4-bhupesh.sharma@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220929060405.2445745-4-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2022 08:04, Bhupesh Sharma wrote:
> Convert Qualcomm ETHQOS Ethernet devicetree binding to YAML.
> 
> While at it, also add Qualcomm Ethernet ETHQOS compatible checks
> in snps,dwmac YAML binding document.

There are no checks added to snps,dwmac.

> 
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  .../devicetree/bindings/net/qcom,ethqos.txt   |  66 --------
>  .../devicetree/bindings/net/qcom,ethqos.yaml  | 145 ++++++++++++++++++
>  2 files changed, 145 insertions(+), 66 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.txt b/Documentation/devicetree/bindings/net/qcom,ethqos.txt
> deleted file mode 100644
> index 1f5746849a71..000000000000
> --- a/Documentation/devicetree/bindings/net/qcom,ethqos.txt
> +++ /dev/null
> @@ -1,66 +0,0 @@
> -Qualcomm Ethernet ETHQOS device
> -
> -This documents dwmmac based ethernet device which supports Gigabit
> -ethernet for version v2.3.0 onwards.
> -
> -This device has following properties:
> -
> -Required properties:
> -
> -- compatible: Should be one of:
> -		"qcom,qcs404-ethqos"
> -		"qcom,sm8150-ethqos"
> -
> -- reg: Address and length of the register set for the device
> -
> -- reg-names: Should contain register names "stmmaceth", "rgmii"
> -
> -- clocks: Should contain phandle to clocks
> -
> -- clock-names: Should contain clock names "stmmaceth", "pclk",
> -		"ptp_ref", "rgmii"
> -
> -- interrupts: Should contain phandle to interrupts
> -
> -- interrupt-names: Should contain interrupt names "macirq", "eth_lpi"
> -
> -Rest of the properties are defined in stmmac.txt file in same directory
> -
> -
> -Example:
> -
> -ethernet: ethernet@7a80000 {
> -	compatible = "qcom,qcs404-ethqos";
> -	reg = <0x07a80000 0x10000>,
> -		<0x07a96000 0x100>;
> -	reg-names = "stmmaceth", "rgmii";
> -	clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
> -	clocks = <&gcc GCC_ETH_AXI_CLK>,
> -		<&gcc GCC_ETH_SLAVE_AHB_CLK>,
> -		<&gcc GCC_ETH_PTP_CLK>,
> -		<&gcc GCC_ETH_RGMII_CLK>;
> -	interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
> -			<GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
> -	interrupt-names = "macirq", "eth_lpi";
> -	snps,reset-gpio = <&tlmm 60 GPIO_ACTIVE_LOW>;
> -	snps,reset-active-low;
> -
> -	snps,txpbl = <8>;
> -	snps,rxpbl = <2>;
> -	snps,aal;
> -	snps,tso;
> -
> -	phy-handle = <&phy1>;
> -	phy-mode = "rgmii";
> -
> -	mdio {
> -		#address-cells = <0x1>;
> -		#size-cells = <0x0>;
> -		compatible = "snps,dwmac-mdio";
> -		phy1: phy@4 {
> -			device_type = "ethernet-phy";
> -			reg = <0x4>;
> -		};
> -	};
> -
> -};
> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> new file mode 100644
> index 000000000000..d3d8f6799d18
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> @@ -0,0 +1,145 @@
> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,ethqos.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Ethernet ETHQOS device
> +
> +maintainers:
> +  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
> +
> +description:
> +  This binding describes the dwmmac based Qualcomm ethernet devices which
> +  support Gigabit ethernet (version v2.3.0 onwards).
> +
> +  So, this file documents platform glue layer for dwmmac stmmac based Qualcomm
> +  ethernet devices.
> +
> +allOf:
> +  - $ref: snps,dwmac.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - qcom,qcs404-ethqos
> +      - qcom,sm8150-ethqos
> +
> +  reg:
> +    maxItems: 2
> +
> +  reg-names:
> +    items:
> +      - const: stmmaceth
> +      - const: rgmii
> +
> +  interrupts:
> +    items:
> +      - description: Combined signal for various interrupt events
> +      - description: The interrupt that occurs when Rx exits the LPI state
> +
> +  interrupt-names:
> +    items:
> +      - const: macirq
> +      - const: eth_lpi
> +
> +  clocks:
> +    maxItems: 4
> +
> +  clock-names:
> +    items:
> +      - const: stmmaceth
> +      - const: pclk
> +      - const: ptp_ref
> +      - const: rgmii
> +
> +  iommus:
> +    maxItems: 1
> +
> +  mdio:
> +    $ref: mdio.yaml#
> +    unevaluatedProperties: false
> +
> +    properties:
> +      compatible:
> +        const: snps,dwmac-mdio
> +
> +  phy-handle:
> +    maxItems: 1
> +
> +  phy-mode:
> +    maxItems: 1
> +
> +  snps,reset-gpio:
> +    maxItems: 1

Why is this one here? It's already in snps,dwmac.

Actually this applies to several other properties. You have
unevaluatedProperties:false, so you do not have to duplicate snps,dwmac.
You only need to constrain it, like we said about interrupts in your
previous patch.

> +
> +  power-domains:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  rx-fifo-depth:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  tx-fifo-depth:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +
> +  snps,tso:
> +    type: boolean
> +    description: Enables the TSO feature (otherwise managed by MAC HW capability register).

You add here several new properties. Mention in commit msg changes from
pure conversion with answer to "why".

> +
> +required:
> +  - compatible
> +  - clocks
> +  - clock-names
> +
> +unevaluatedProperties: false
> +

Best regards,
Krzysztof

