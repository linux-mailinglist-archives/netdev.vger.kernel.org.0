Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3AE501A5F
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbiDNRvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbiDNRvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:51:04 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E18DEA34B;
        Thu, 14 Apr 2022 10:48:39 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id b188so6149224oia.13;
        Thu, 14 Apr 2022 10:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cEDWctBLQqoKqBMPRZdmlVJD6EYEjiWIYczo6xf9EkY=;
        b=5BAvboq6OoMNHyEdcI0/V0NNmZHRefFfK2gs6qeBaSbkXbyQl2X6OfuZjMcZmbONLP
         kO8/vdWqPWy62Y8SgVbQ+0ihHlyHRJtNtzRhNOMSfWfaPfVA4GaA7HrEroB30Ex1E+vp
         b+oEJux3pTi5Trk+oMNNCfmkh7uzSUlWH4rsHvNuUhdGp1zMyQHyR/Rakg3AH+LBaCwd
         1jXizEfyGDcN4r0BVUgA0t4YAWE9gJVDsrfny+5dvUUmys8Dz3aVbo4hgwQTnkO4Q/e+
         qP4AdLhwCbSKxpvgGt/Wde5UZ7tZXqxrtSdDadnRTZQwLT1pNfyAjCDlzd8QLIDlwE7n
         r98A==
X-Gm-Message-State: AOAM532qRam6Dq++PxArKWh5twlZyfswi7B1KsL4JDgb+WAbo8S7YNLg
        vFiYO9OpqW9ivj4KwgLgHw==
X-Google-Smtp-Source: ABdhPJyKNZhVdNy7lwQTsCgIJxZIs45Db9ytkpfZ/FYPydP3nbHvLW0QgtJN04Fo18PTgykBzJ4tyw==
X-Received: by 2002:a05:6808:1202:b0:2f9:c7b4:fd56 with SMTP id a2-20020a056808120200b002f9c7b4fd56mr1851457oil.55.1649958518691;
        Thu, 14 Apr 2022 10:48:38 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b18-20020a056830105200b005e9899ae22dsm252856otp.52.2022.04.14.10.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:48:38 -0700 (PDT)
Received: (nullmailer pid 2299756 invoked by uid 1000);
        Thu, 14 Apr 2022 17:48:37 -0000
Date:   Thu, 14 Apr 2022 12:48:37 -0500
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 08/13] dt-bindings: arm: Document i.MX8DXL EVK board
 binding
Message-ID: <YlhedQppRXyGESmg@robh.at.kernel.org>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
 <20220413103356.3433637-9-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413103356.3433637-9-abel.vesa@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 01:33:51PM +0300, Abel Vesa wrote:
> Document devicetree binding of i.XM8DXL EVK board.
> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  Documentation/devicetree/bindings/arm/fsl.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
> index b6cc34115362..c44ce1f6fb98 100644
> --- a/Documentation/devicetree/bindings/arm/fsl.yaml
> +++ b/Documentation/devicetree/bindings/arm/fsl.yaml
> @@ -803,6 +803,13 @@ properties:
>                - fsl,imx7ulp-evk           # i.MX7ULP Evaluation Kit
>            - const: fsl,imx7ulp
>  
> +      - description: i.MX8DXL based Boards
> +        items:
> +          - enum:
> +              - fsl,imx8dxl-evk           # i.MX8DXL Evaluation Kit
> +          - const: fsl,imx8dxl
> +
> +

Extra blank line

>        - description: i.MX8MM based Boards
>          items:
>            - enum:
> -- 
> 2.34.1
> 
> 
