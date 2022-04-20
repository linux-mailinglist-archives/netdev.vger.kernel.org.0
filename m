Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A74508D2B
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 18:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380537AbiDTQ0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 12:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376497AbiDTQ0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 12:26:51 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE6D3DDFB;
        Wed, 20 Apr 2022 09:24:04 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id w194so2580727oiw.11;
        Wed, 20 Apr 2022 09:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eqRuR80cwcGhb1bZpUFPS9H8sCLdtwMaN4leB1jQaUo=;
        b=ugxoj5NFkVAZbXODfuSHPRZ91dkseGSrlIiD/x81FDFlvXBFgVNwBOK26go969rzj2
         JJmlvGvuHjPuq9g6M/PAXrycI2O65BAQ+Kccx+HAZGczUfh/mKtwiJe1zoM00guVhqUM
         mL6uriX3/bIXyxsr5XQXrmBiu4v7BbiV0/Q47gjBAwsC9TCrcqcDd47JpL5VN1nvgabO
         OiBUBNeL4JvippwoidxPMnUS9XL8kzjTflp1vhHJYRezouYZNPdskilidoxMCLNzxezo
         qiFODhVQ3XoPx26FU2Cbkrg6rZ2her7MdfvIkyk0wkNHduAwly+pd/rKnKuz9zHFvNsN
         IRhw==
X-Gm-Message-State: AOAM530ulcNGFsw7Ls/zmLPU0KEa6LnvxEvYvIdxXSIoPeWWfAhTqS13
        a4NU4B09L8c3uvTbVuWf6w==
X-Google-Smtp-Source: ABdhPJy5sRyqbV6H1nky7jUgsc4SvVnBgGMkW66trSKOz92/NZSbbjjYt53XFfCWY+uBTYHwI2PVeQ==
X-Received: by 2002:a05:6808:e8c:b0:322:4b82:d33d with SMTP id k12-20020a0568080e8c00b003224b82d33dmr2128366oil.21.1650471843684;
        Wed, 20 Apr 2022 09:24:03 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j9-20020a056808056900b0032252797ea4sm5551746oig.6.2022.04.20.09.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:24:03 -0700 (PDT)
Received: (nullmailer pid 1423242 invoked by uid 1000);
        Wed, 20 Apr 2022 16:24:02 -0000
Date:   Wed, 20 Apr 2022 11:24:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, netdev@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v8 08/13] dt-bindings: arm: Document i.MX8DXL EVK board
 binding
Message-ID: <YmAzos7VBz2vgJd6@robh.at.kernel.org>
References: <20220419113516.1827863-1-abel.vesa@nxp.com>
 <20220419113516.1827863-9-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419113516.1827863-9-abel.vesa@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Apr 2022 14:35:11 +0300, Abel Vesa wrote:
> Document devicetree binding of i.XM8DXL EVK board.

i.XM?

> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  Documentation/devicetree/bindings/arm/fsl.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
