Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505C75377FE
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiE3JEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiE3JEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:04:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632FC793BF;
        Mon, 30 May 2022 02:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653901449; x=1685437449;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BqttjK6LoysDCfGp3a/aAnQzKKWODvXywQSQ/I73aMM=;
  b=fxqRbhYHInSEWyC71kgYZOunW4IQLbnnXv6PYeAuyQnllq2H3IDxiGV7
   POfgyy/ed7sPVv+XLfVS3Lk3vmFB2qnAEdywfO3AjBGMzh8Tmwq8GRrP4
   krxeYrQAxuNjvLh2mFKNJHm+CIvJTFbIEhmTAmkRSpNG5NpTx3RoNG9/4
   242Nczt3dInWM6Id1+/VlfwSLwawKgiK5DehZ7cEGrzOkf4nRMwRpN/Zq
   xyjr7Wh4vNaAXLgWEjg9UloE5r8dPv1nfnLAoUhh49nUHFFCQfJuGDzDl
   f7pSlvKGoeLHChDf9Po0H08i/kbEOSsx4m+jcg6enEQ1c0Z5yyyQvpDee
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="175650657"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 02:04:06 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 02:04:06 -0700
Received: from [10.159.205.135] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 30 May 2022 02:04:01 -0700
Message-ID: <3704e284-3fd0-b073-9a3b-68ae2e966181@microchip.com>
Date:   Mon, 30 May 2022 11:03:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] dt-bindings: net: Fix unevaluatedProperties warnings in
 examples
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "Shayne Chen" <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "Kalle Valo" <kvalo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        Biao Huang <biao.huang@mediatek.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
References: <20220526014149.2872762-1-robh@kernel.org>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20220526014149.2872762-1-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/05/2022 at 03:41, Rob Herring wrote:
> The 'unevaluatedProperties' schema checks is not fully working and doesn't
> catch some cases where there's a $ref to another schema. A fix is pending,
> but results in new warnings in examples. Fix the warnings by removing
> spurious properties or adding missing properties to the schema.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>   Documentation/devicetree/bindings/net/cdns,macb.yaml           | 1 -
>   Documentation/devicetree/bindings/net/mediatek,net.yaml        | 3 +++
>   Documentation/devicetree/bindings/net/mediatek-dwmac.yaml      | 3 +++
>   .../devicetree/bindings/net/wireless/mediatek,mt76.yaml        | 2 +-
>   4 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> index 337cec4d85ca..86fc31c2d91b 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -191,7 +191,6 @@ examples:
>                       clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";
>                       #address-cells = <1>;
>                       #size-cells = <0>;
> -                    #stream-id-cells = <1>;
>                       iommus = <&smmu 0x875>;
>                       power-domains = <&zynqmp_firmware PD_ETH_1>;
>                       resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;

For cdns,macb.yaml:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Rob. Best regards,
   Nicolas

> diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> index 699164dd1295..f5564ecddb62 100644
> --- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> @@ -27,6 +27,9 @@ properties:
>     reg:
>       maxItems: 1
> 
> +  clocks: true
> +  clock-names: true
> +
>     interrupts:
>       minItems: 3
>       maxItems: 4
> diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> index 901944683322..61b2fb9e141b 100644
> --- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> @@ -58,6 +58,9 @@ properties:
>         - const: rmii_internal
>         - const: mac_cg
> 
> +  power-domains:
> +    maxItems: 1
> +
>     mediatek,pericfg:
>       $ref: /schemas/types.yaml#/definitions/phandle
>       description:
> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> index 249967d8d750..5a12dc32288a 100644
> --- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> @@ -51,7 +51,7 @@ properties:
>       description:
>         Specify the consys reset for mt7986.
> 
> -  reset-name:
> +  reset-names:
>       const: consys
> 
>     mediatek,infracfg:
> --
> 2.34.1
> 


-- 
Nicolas Ferre
