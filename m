Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3388E476576
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 23:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhLOWND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 17:13:03 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:33708 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhLOWND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 17:13:03 -0500
Received: by mail-ot1-f52.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso26733801otf.0;
        Wed, 15 Dec 2021 14:13:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ITxrC42cpEdFPF3axFsIeZiANWHi83eE7MbTcA8W+gg=;
        b=woP6wUFLq3RI2nWA5aH4VFVgxJv49yzJ3px/8nSzthwX/EATef4YsVKSkRmFmXtV87
         WXQcG11Qz0QViQ1jf8VTG4oAt6azgOTQbDc/CVgIBrKcKH8k3x11Ls/2fHj9wVa6cnco
         5ueFGHQLMEXRpItxp+lnhujjvM623Q85Eqimn5IwaWheZGJnDageBabvPbxPqO8M/MDa
         vvMNzXPFeITNEKu2typt6ISyzjNbYODe0YeLlfZCVOwJLfvaGplUFljS1ktAktrBPNFM
         S+xLrg46RpEWzo1ymoMeg6PVWvkblhGfGiYollDdC6xdrkUaqCFzNjvRKWN9o8eDrsh9
         8SKA==
X-Gm-Message-State: AOAM531LXTSlNIfHwMbFNE6r1iRR9mbzg9emk89Ym/+H9G+J/lt7DE4w
        h07IBUzjBMigx7182uJkWg==
X-Google-Smtp-Source: ABdhPJwaDEcWGo2pJ8CHSx9viVOHay+ZBu3YGBOyUvT6TDJu7jRsraMtVM63nT7+QEIcvGrQCS8ePw==
X-Received: by 2002:a05:6830:1092:: with SMTP id y18mr10206759oto.119.1639606382307;
        Wed, 15 Dec 2021 14:13:02 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t18sm698156ott.2.2021.12.15.14.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:13:01 -0800 (PST)
Received: (nullmailer pid 1932976 invoked by uid 1000);
        Wed, 15 Dec 2021 22:13:00 -0000
Date:   Wed, 15 Dec 2021 16:13:00 -0600
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
Subject: Re: [PATCH net-next v9 6/6] net: dt-bindings: dwmac: add support for
 mt8195
Message-ID: <YbpobIscSDPKuxxY@robh.at.kernel.org>
References: <20211215021652.7270-1-biao.huang@mediatek.com>
 <20211215021652.7270-7-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215021652.7270-7-biao.huang@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 10:16:52AM +0800, Biao Huang wrote:
> Add binding document for the ethernet on mt8195.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.yaml          | 42 ++++++++++++++-----
>  1 file changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> index 8ad6e19661b8..44d55146def4 100644
> --- a/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> @@ -19,6 +19,7 @@ select:
>        contains:
>          enum:
>            - mediatek,mt2712-gmac
> +          - mediatek,mt8195-gmac
>    required:
>      - compatible
>  
> @@ -27,26 +28,37 @@ allOf:
>  
>  properties:
>    compatible:
> -    items:
> -      - enum:
> -          - mediatek,mt2712-gmac
> -      - const: snps,dwmac-4.20a
> +    oneOf:
> +      - items:
> +          - enum:
> +              - mediatek,mt2712-gmac
> +          - const: snps,dwmac-4.20a
> +      - items:
> +          - enum:
> +              - mediatek,mt8195-gmac
> +          - const: snps,dwmac-5.10a
>  
>    clocks:
> +    minItems: 5

As before, you need 'minItems: 4' in the previous patch.

If you aren't clear what's needed, run 'make dtbs_checks' yourself 
before submitting again.

>      items:
>        - description: AXI clock
>        - description: APB clock
>        - description: MAC Main clock
>        - description: PTP clock
>        - description: RMII reference clock provided by MAC
> +      - description: MAC clock gate
>  
>    clock-names:
> -    items:
> -      - const: axi
> -      - const: apb
> -      - const: mac_main
> -      - const: ptp_ref
> -      - const: rmii_internal
> +    minItems: 5
> +    maxItems: 6
> +    contains:

No, you just threw out the order requirements. And this schema will be 
true with just 1 of the strings below plus any other strings. For 
example, this will pass:

clock-names = "foo", "bar", "axi", "baz", "rob";

> +      enum:
> +        - axi
> +        - apb
> +        - mac_main
> +        - ptp_ref
> +        - rmii_internal
> +        - mac_cg
>  
>    mediatek,pericfg:
>      $ref: /schemas/types.yaml#/definitions/phandle
> @@ -61,6 +73,8 @@ properties:
>        or will round down. Range 0~31*170.
>        For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
>        or will round down. Range 0~31*550.
> +      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple of 290,
> +      or will round down. Range 0~31*290.
>  
>    mediatek,rx-delay-ps:
>      description:
> @@ -69,6 +83,8 @@ properties:
>        or will round down. Range 0~31*170.
>        For MT2712 RMII/MII interface, Allowed value need to be a multiple of 550,
>        or will round down. Range 0~31*550.
> +      For MT8195 RGMII/RMII/MII interface, Allowed value need to be a multiple
> +      of 290, or will round down. Range 0~31*290.
>  
>    mediatek,rmii-rxc:
>      type: boolean
> @@ -102,6 +118,12 @@ properties:
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
