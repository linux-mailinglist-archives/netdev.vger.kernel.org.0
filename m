Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A44B470964
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245627AbhLJS4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:56:00 -0500
Received: from mail-ot1-f50.google.com ([209.85.210.50]:42861 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245622AbhLJSz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 13:55:56 -0500
Received: by mail-ot1-f50.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so10502565otv.9;
        Fri, 10 Dec 2021 10:52:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y7NmFP1p6Qd1b0fL9f5rRq9R2qqG2ejfV+/bfCnpsio=;
        b=3ZxZ1geVH/NV5eWu3VGPh/O8Zz/FbHO5qKodzll+szjx1dhXF0VoKSqasKSiWw0tEi
         dgid+OZVFpMIlGFn84iBVBY5DI4JumJPfM+g7K9PV0hI69J07+J3bPEYXuMb3/ygiV7L
         0oRstbyC6OSG77vAVKok2+t1GAlZKm4KDuzPfTkzlniD3yI5KPYAsRkCTSltjHFEBd5D
         hZ8G7+XbB8ZoXzwx2y1b1bgVyRh1pTa+W3/CHqasF5OKnY29B/gxGFEXWTADqLz3qQbS
         GdFhtbw7YZSumByAsSbg6vy5jMfv12Q4whNf7aGhecOR9MWroXSufxIxtoQFaDpPywqc
         VojA==
X-Gm-Message-State: AOAM532MAQ37HGWRGfTWy2EkGSSOS/6lMivggsMEh6ap9X3rjgF0VBmE
        EsxgTuM4uz0gcCPBvqR3Ng==
X-Google-Smtp-Source: ABdhPJxJINpWT9IGxH/gECmIc454mQcQqjJ6lflDgb0psgutHeLk4C87tidil+dvRTPlkQbusGCZJQ==
X-Received: by 2002:a9d:6190:: with SMTP id g16mr12460797otk.54.1639162340148;
        Fri, 10 Dec 2021 10:52:20 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id z12sm686907oor.45.2021.12.10.10.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:52:19 -0800 (PST)
Received: (nullmailer pid 1694615 invoked by uid 1000);
        Fri, 10 Dec 2021 18:52:18 -0000
Date:   Fri, 10 Dec 2021 12:52:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        angelogioacchino.delregno@collabora.com, dkirjanov@suse.de
Subject: Re: [PATCH net-next v8 6/6] net: dt-bindings: dwmac: add support for
 mt8195
Message-ID: <YbOh4hZfc+QKA/hO@robh.at.kernel.org>
References: <20211210013129.811-1-biao.huang@mediatek.com>
 <20211210013129.811-7-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210013129.811-7-biao.huang@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 09:31:29AM +0800, Biao Huang wrote:
> Add binding document for the ethernet on mt8195.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.yaml          | 86 +++++++++++++++----
>  1 file changed, 70 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> index 9207266a6e69..fb04166404d8 100644
> --- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> @@ -19,11 +19,67 @@ select:
>        contains:
>          enum:
>            - mediatek,mt2712-gmac
> +          - mediatek,mt8195-gmac
>    required:
>      - compatible
>  
>  allOf:
>    - $ref: "snps,dwmac.yaml#"
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - mediatek,mt2712-gmac
> +
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 5
> +          items:
> +            - description: AXI clock
> +            - description: APB clock
> +            - description: MAC Main clock
> +            - description: PTP clock
> +            - description: RMII reference clock provided by MAC
> +
> +        clock-names:
> +          minItems: 5
> +          items:
> +            - const: axi
> +            - const: apb
> +            - const: mac_main
> +            - const: ptp_ref
> +            - const: rmii_internal
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - mediatek,mt8195-gmac
> +
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 6
> +          items:
> +            - description: AXI clock
> +            - description: APB clock
> +            - description: MAC clock gate

Add new clocks on to the end of existing clocks. That will simplify the 
binding as here you will just need 'minItems: 6'.

> +            - description: MAC Main clock
> +            - description: PTP clock
> +            - description: RMII reference clock provided by MAC
> +
> +        clock-names:
> +          minItems: 6
> +          items:
> +            - const: axi
> +            - const: apb
> +            - const: mac_cg
> +            - const: mac_main
> +            - const: ptp_ref
> +            - const: rmii_internal
>  
>  properties:
>    compatible:
> @@ -32,22 +88,10 @@ properties:
>            - enum:
>                - mediatek,mt2712-gmac
>            - const: snps,dwmac-4.20a
> -
> -  clocks:
> -    items:
> -      - description: AXI clock
> -      - description: APB clock
> -      - description: MAC Main clock
> -      - description: PTP clock
> -      - description: RMII reference clock provided by MAC
> -
> -  clock-names:
> -    items:
> -      - const: axi
> -      - const: apb
> -      - const: mac_main
> -      - const: ptp_ref
> -      - const: rmii_internal
> +      - items:
> +          - enum:
> +              - mediatek,mt8195-gmac
> +          - const: snps,dwmac-5.10a
>  
>    mediatek,pericfg:
>      $ref: /schemas/types.yaml#/definitions/phandle
> @@ -62,6 +106,8 @@ properties:
>        or will round down. Range 0~31*170.
>        For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
>        or will round down. Range 0~31*550.
> +      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
> +      or will round down. Range 0~31*290.
>  
>    mediatek,rx-delay-ps:
>      description:
> @@ -70,6 +116,8 @@ properties:
>        or will round down. Range 0~31*170.
>        For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
>        or will round down. Range 0~31*550.
> +      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
> +      of 290, or will round down. Range 0~31*290.
>  
>    mediatek,rmii-rxc:
>      type: boolean
> @@ -103,6 +151,12 @@ properties:
>        3. the inside clock, which be sent to MAC, will be inversed in RMII case when
>           the reference clock is from MAC.
>  
> +  mediatek,mac-wol:
> +    type: boolean
> +    description:
> +      If present, indicates that MAC supports WOL(Wake-On-LAN), and MAC WOL will be enabled.
> +      Otherwise, PHY WOL is perferred.
> +
>  required:
>    - compatible
>    - reg
> -- 
> 2.25.1
> 
> 
