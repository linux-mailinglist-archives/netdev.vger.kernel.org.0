Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193FF55E7D0
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346234AbiF1Oew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343551AbiF1Oev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:34:51 -0400
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95CF2A26B;
        Tue, 28 Jun 2022 07:34:50 -0700 (PDT)
Received: by mail-il1-f172.google.com with SMTP id p14so8293876ile.1;
        Tue, 28 Jun 2022 07:34:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPoxK7UkWIzbnloX5xnrgOb8urdj87dNhnlew5jmd0o=;
        b=u4S7ZTRLC3i+Ti7Z95GCXWdGBDFs8qZ6cYGRh1e+YobUCxGseOMevBxGrgbiRgwJqH
         I8544QPPqrcKnhaiATXI76CnE2nOolpwAn1m21An1y7HHkxUWvmBvyjyX1au1KGMJpLd
         QBR9gj6LMpLy5Qc5tYgKF1XAV/0yuRzdeqsyNpMPNVSPluPTPLzVyAth6Z6HTYDwF7p/
         FYPkGdGXOOPadKHeI0mf8hbcUIwhkifEJQW8MAIryhpV/j9qA1r97DvozxvbZlvh5S2Q
         /+IzmST+4asD3j7saRdEud2wTZXJfuitUGLcnKeFvz+TQ0wufjCPLDg5pZe4ckb3VPzO
         zMCg==
X-Gm-Message-State: AJIora+GGZUugRwSKaHP3U2H1MM3N5h3pS+VFRem1y5ByCb6FphpDXnz
        hB/ljZka0k6d8GG5++/1/w==
X-Google-Smtp-Source: AGRyM1sqlSTD29iR+cokrJ7VsHr7ygnsPazCCSJ7aALbsqgWguXFu7/DtM1Nu49DwQM/Xg4WbV1UTQ==
X-Received: by 2002:a05:6e02:1525:b0:2da:b0b2:61c6 with SMTP id i5-20020a056e02152500b002dab0b261c6mr1831621ilu.198.1656426889998;
        Tue, 28 Jun 2022 07:34:49 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id g9-20020a028509000000b00339de094a02sm6135879jai.172.2022.06.28.07.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 07:34:49 -0700 (PDT)
Received: (nullmailer pid 421663 invoked by uid 1000);
        Tue, 28 Jun 2022 14:34:47 -0000
Date:   Tue, 28 Jun 2022 08:34:47 -0600
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: Re: [PATCH v9 11/12] dt-bindings: arm: freescale: scu-ocotp: Add
 i.MX8DXL compatible string
Message-ID: <20220628143447.GA417671-robh@kernel.org>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
 <20220607111625.1845393-12-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607111625.1845393-12-abel.vesa@nxp.com>
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

On Tue, Jun 07, 2022 at 02:16:24PM +0300, Abel Vesa wrote:
> Add i.MX8DXL compatible string to the scu-ocotp bindings.
> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  .../devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml        | 2 ++
>  1 file changed, 2 insertions(+)

Why are you adding this patch which adds a dependency on v9 of your 
series?

> 
> diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml b/Documentation/devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml
> index 1c2d2486f366..73c9bd16ec35 100644
> --- a/Documentation/devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml
> +++ b/Documentation/devicetree/bindings/arm/freescale/fsl,scu-ocotp.yaml
> @@ -20,7 +20,9 @@ properties:
>            - enum:
>                - fsl,imx8qm-scu-ocotp
>                - fsl,imx8qxp-scu-ocotp
> +              - fsl,imx8dxl-scu-ocotp
>        - items:
> +          - const: fsl,imx8dxl-scu-ocotp
>            - const: fsl,imx8qxp-scu-ocotp

This doesn't make sense. Either you have a fallback or you don't.

>  
>    '#address-cells':
> -- 
> 2.34.3
> 
> 
