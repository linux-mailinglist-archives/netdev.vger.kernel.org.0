Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592D84F6A9F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 21:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiDFT5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 15:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiDFT4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 15:56:55 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7253120;
        Wed,  6 Apr 2022 11:04:15 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id b17-20020a0568301df100b005ce0456a9efso2235185otj.9;
        Wed, 06 Apr 2022 11:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tFqNaCkKApeiYksTrleFPMTtEkbWW1D2qkuPxZr5fUU=;
        b=p6Kep7PdDJIXqjRSdgPPiAf6oylXPI8nJidFvIvDqmuGsJ+Ezy7i/VMCwyzUitV4zU
         WFBegedwpLH2Scye4SDLQsqcU6VAcwID/8Zssl9Ojp2nmaFkSAg1w5rMfmLF/w5hUOl0
         BFsXg5TK8IFQMA93vECO7hVHDWHTUX+iyFuJc1pZ1YkAY05l1IB2bxX7AQ5fnHtWfAtF
         y5lgkwYTkEnF4DW/legt1/uIvmwUWwE5wxxXL1NaBWelySJUayQHK1D79WxEpb8D3Tzw
         Ww+QW1ViDtA+tOJMK+hDLayQtdL0mz1mk1Id2RglJhbxg8PfUzlmXA9rxkr3S6czdZPb
         oJuA==
X-Gm-Message-State: AOAM533nsWyMHhCPiqVb/b7+/iB8AiOvh6haQmBW8WcmnK5nDHB6oYi9
        xc9r0Dp7OKm0jy+SU1mUUg==
X-Google-Smtp-Source: ABdhPJxJrK5rkRuJA8giQLl7I8TM/bAyKlXb/0qJLn0Q5cg/Dw6LDk4xNjJcq5oJVm/nbTKPAJWRrA==
X-Received: by 2002:a9d:65d4:0:b0:5b2:67f2:244 with SMTP id z20-20020a9d65d4000000b005b267f20244mr3404940oth.307.1649268255051;
        Wed, 06 Apr 2022 11:04:15 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j145-20020acaeb97000000b002d9f37166c1sm6631489oih.17.2022.04.06.11.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 11:04:14 -0700 (PDT)
Received: (nullmailer pid 2508522 invoked by uid 1000);
        Wed, 06 Apr 2022 18:04:13 -0000
Date:   Wed, 6 Apr 2022 13:04:13 -0500
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 8/8] dt-bindings: net: dwmac-imx: Document clk_csr
 property
Message-ID: <Yk3WHSr+OGRxYCg0@robh.at.kernel.org>
References: <20220404134609.2676793-1-abel.vesa@nxp.com>
 <20220404134609.2676793-9-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404134609.2676793-9-abel.vesa@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 04:46:09PM +0300, Abel Vesa wrote:
> The clk_csr property is used for CSR clock range selection.

Why?

> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> index 011363166789..1556d95943f6 100644
> --- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> +++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
> @@ -32,6 +32,10 @@ properties:
>                - nxp,imx8dxl-dwmac-eqos
>            - const: snps,dwmac-5.10a
>  
> +  clk_csr:

s/_/-/

vendor prefix needed. 

And a type is needed.

> +    description: |
> +      Fixed CSR Clock Range selection

What? Explain all this to someone that doesn't know your h/w.

> +
>    clocks:
>      minItems: 3
>      items:
> -- 
> 2.34.1
> 
> 
