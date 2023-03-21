Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2480D6C3AB4
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCUTel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCUTek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:34:40 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F6C5373B;
        Tue, 21 Mar 2023 12:34:00 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-17683b570b8so17269607fac.13;
        Tue, 21 Mar 2023 12:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fw4oA6sQFO3oz372kux+un0E6HQ5jc+wHkvkZJ9IwFU=;
        b=u0aSHV003jgkFORDouKK9AdXV9jYmrPX+WuNYpZ+KSiQV4O/Bpy0fbsA8FpnlCTXnI
         XCAzKTouDynGFfRaMrHRjnf4fWXXAwT5q1kcGdL5k9BClJQuMkX3gpp0oBWt5kcF9R5O
         TjEmNGqvigzfz2NA4r9muZEX3A0LLnw74ulX8XQhDmNRv90pmMpLMKl/0U0UQM7aGH0P
         HxFaZU1rIvwEAvMdOl2IfhxjI0ot7omux+uI60qqc//C007N/dHDXzb5pM+7b5LDgTEW
         pxGz3d6VxgOQSZDrClxkttnlEtRE9+2O4tAgoh38bOgbNPYjnOjJh8/KqmdMiQiocs0m
         T6GA==
X-Gm-Message-State: AO0yUKUEVrvgCNrq8+AAh8Y2LKavGPz6uLUDuoaEQRQzcrwSEENU1+nw
        cLA8ru75frZ+bZTE6I8ldA==
X-Google-Smtp-Source: AK7set9APR5/PD9MttMR2PXhbEanCH39cNdf56FBKKwW28VU+BO3r98osWsOZpOBDMqCJvMFzQGayg==
X-Received: by 2002:a05:6870:b292:b0:17a:cc20:6d31 with SMTP id c18-20020a056870b29200b0017acc206d31mr64287oao.30.1679427176404;
        Tue, 21 Mar 2023 12:32:56 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w14-20020a056870b38e00b001723f29f6e2sm4575531oap.37.2023.03.21.12.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:32:55 -0700 (PDT)
Received: (nullmailer pid 1311802 invoked by uid 1000);
        Tue, 21 Mar 2023 19:32:54 -0000
Date:   Tue, 21 Mar 2023 14:32:54 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 06/10] dt-bindings: soc: mediatek: move ilm in a
 dedicated dts node
Message-ID: <20230321193254.GA1306908-robh@kernel.org>
References: <cover.1679330630.git.lorenzo@kernel.org>
 <c9b65ef3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9b65ef3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 05:58:00PM +0100, Lorenzo Bianconi wrote:
> Since the cpuboot memory region is not part of the RAM SoC, move ilm in
> a deidicated syscon node.
> This patch helps to keep backward-compatibility with older version of
> uboot codebase where we have a limit of 8 reserved-memory dts child
> nodes.

Maybe, but breaks the ABI. It also looks like a step backwards. Fix your 
u-boot.

> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 14 +++---
>  .../soc/mediatek/mediatek,mt7986-wo-ilm.yaml  | 45 +++++++++++++++++++
>  2 files changed, 53 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> index 7f6638d43854..5d2397ec5891 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> @@ -32,14 +32,12 @@ properties:
>    memory-region:
>      items:
>        - description: firmware EMI region
> -      - description: firmware ILM region
>        - description: firmware DLM region
>        - description: firmware CPU DATA region
>  
>    memory-region-names:
>      items:
>        - const: wo-emi
> -      - const: wo-ilm
>        - const: wo-dlm
>        - const: wo-data
>  
> @@ -51,6 +49,10 @@ properties:
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description: mediatek wed-wo cpuboot controller interface.
>  
> +  mediatek,wo-ilm:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: mediatek wed-wo ilm interface.
> +
>  allOf:
>    - if:
>        properties:
> @@ -63,6 +65,7 @@ allOf:
>          memory-region: false
>          mediatek,wo-ccif: false
>          mediatek,wo-cpuboot: false
> +        mediatek,wo-ilm: false
>  
>  required:
>    - compatible
> @@ -97,11 +100,10 @@ examples:
>          reg = <0 0x15010000 0 0x1000>;
>          interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
>  
> -        memory-region = <&wo_emi>, <&wo_ilm>, <&wo_dlm>,
> -                        <&wo_data>;
> -        memory-region-names = "wo-emi", "wo-ilm", "wo-dlm",
> -                              "wo-data";
> +        memory-region = <&wo_emi>, <&wo_dlm>, &wo_data>;
> +        memory-region-names = "wo-emi", "wo-dlm", "wo-data";
>          mediatek,wo-ccif = <&wo_ccif0>;
>          mediatek,wo-cpuboot = <&wo_cpuboot>;
> +        mediatek,wo-ilm = <&wo_ilm>;
>        };
>      };
> diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml
> new file mode 100644
> index 000000000000..2a3775cd941e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ilm.yaml
> @@ -0,0 +1,45 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/soc/mediatek/mediatek,mt7986-wo-ilm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek Wireless Ethernet Dispatch (WED) WO ILM firmware interface for MT7986

Either this region is some memory or it's a device. Sounds like the 
former and this is not a 'syscon'.

> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The MediaTek wo-ilm (Information Lifecycle Management) provides a configuration
> +  interface for WiFi critical data used by WED WO firmware. WED WO controller is
> +  used to perform offload rx packet processing (e.g. 802.11 aggregation packet
> +  reordering or rx header translation) on MT7986 soc.
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - mediatek,mt7986-wo-ilm
> +      - const: syscon
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +
> +      syscon@151e0000 {
> +        compatible = "mediatek,mt7986-wo-ilm", "syscon";
> +        reg = <0 0x151e0000 0 0x8000>;
> +      };
> +    };
> -- 
> 2.39.2
> 
