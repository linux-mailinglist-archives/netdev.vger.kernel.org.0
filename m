Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D9F4F85BC
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbiDGRV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiDGRV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:21:26 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFABA129;
        Thu,  7 Apr 2022 10:19:25 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id q129so6324109oif.4;
        Thu, 07 Apr 2022 10:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ktg803HSeOu69hHwdv/GSEMNaBLrm32ku7UIeeZTNoE=;
        b=jAtHQaYdNh22fDh5w8rSBMuAID1JSn3j+B2Dx2HcsJ6XG4W9QU+Ux7kxfaab6vZbJm
         l5WpNCedk8a+wotVs2qjc+Zs6z1XW/nvLYlegIMNDZ5xMphI3ERGvTdjjjAPFUXuQlwb
         wN7w9KG5ra5f8qekHhSaykEPEq/mng/CvstfovI7mRBFpF4fqeplqd9GkessClsUxVr8
         yR7/5C9eaR4On44eYe73+tutPwmSnCJT3BRgpEQ6/UBnhlLHvXBkLNskZ1F8E6z2q8hT
         WhFV2C0zTpzKh1Z9Px04+RCZyNDJUiBIothIrrU15dgWbtlOgHKsaGB7YdyToHaktcHq
         nOWw==
X-Gm-Message-State: AOAM530ugPnPvKyznpuXgB0Gpz1GTb4WXIg4Z9YGLrGRNGu9HAEVgWDX
        WCj3uK/Nyxyt72GmCiwvgb5f+iNIvg==
X-Google-Smtp-Source: ABdhPJy3RB++miojvSNpZgfUKy3/Jsrd3acxBFRmHtQUm7UVXoBZujvvsh09xoAZhSAs2J7MN6rRTQ==
X-Received: by 2002:a05:6808:191c:b0:2f9:4621:641a with SMTP id bf28-20020a056808191c00b002f94621641amr6157578oib.226.1649351965058;
        Thu, 07 Apr 2022 10:19:25 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s26-20020a4ac81a000000b00322a2b5d943sm7471279ooq.37.2022.04.07.10.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:19:24 -0700 (PDT)
Received: (nullmailer pid 1475775 invoked by uid 1000);
        Thu, 07 Apr 2022 17:19:24 -0000
Date:   Thu, 7 Apr 2022 12:19:24 -0500
From:   Rob Herring <robh@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/14] dt-bindings: arm: mediatek: document the pcie
 mirror node on MT7622
Message-ID: <Yk8dHLDG8EHKtl54@robh.at.kernel.org>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-6-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405195755.10817-6-nbd@nbd.name>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 09:57:46PM +0200, Felix Fietkau wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> This patch adds the pcie mirror document bindings for MT7622 SoC.
> The feature is used for intercepting PCIe MMIO access for the WED core
> Add related info in mediatek-net bindings.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  .../mediatek/mediatek,mt7622-pcie-mirror.yaml | 42 +++++++++++++++++++
>  .../devicetree/bindings/net/mediatek-net.txt  |  2 +
>  2 files changed, 44 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml
> new file mode 100644
> index 000000000000..9fbeb626ab23
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml
> @@ -0,0 +1,42 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-pcie-mirror.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: MediaTek PCIE Mirror Controller for MT7622
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The mediatek PCIE mirror provides a configuration interface for PCIE
> +  controller on MT7622 soc.
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - mediatek,mt7622-pcie-mirror
> +      - const: syscon

This doesn't sound like a syscon to me. Are there multiple clients or 
functions in this block? A 'syscon' property is not the only way to 
create a regmap if that's what you need.

Rob
