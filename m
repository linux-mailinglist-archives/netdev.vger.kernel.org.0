Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CA6501A63
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343549AbiDNRvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbiDNRve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:51:34 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29833EA34A;
        Thu, 14 Apr 2022 10:49:09 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-d6ca46da48so5959139fac.12;
        Thu, 14 Apr 2022 10:49:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iQqCBQwwABmsQCx92CYy3lJrGFbABnzT+4M9jF9LYo0=;
        b=qOCix7v/ykPZhDA0VcTc3DtJmA9IzLkb2tG+O479rROZHailkkEMHEhHokrcuAOWc7
         /8G3YsWlmtvQES6uDiwtfVR6663nNOMEdLLvn7Dd433shn1+xy+uuToekHP2LCGBASSD
         wS3MO3c87LTNonbQELcBHUarTwKLWToarmwKoe8jBH6y85xW2wQRGI9gm1GYcA7OUcIE
         mdnAjau84uqC6pY4QX0c1CxRp1rOSsQ7AZx9E3twxdWevNVfdeFx0JXq3+egCrTOEvjq
         LWrISKoMFRaQhhQeTVKJSz1yETzz/tLHaBvCxuSRPTmG0PQ4zi0d2BwUit5ghPKJv9hI
         maHg==
X-Gm-Message-State: AOAM530g+oW1aDSwerdrXz7JEC0wrk9nx8hGRGbRRPrTH4WWQp3bP2uf
        WGAyL+XWym0zW1dsZAUlCsMoMLme2Q==
X-Google-Smtp-Source: ABdhPJxiRCvrj6iIRtwINe++WzHsBP6TYAFxmTXMFhrY+jFvjuodgA4501aSt69SSDHP84mc07z4OA==
X-Received: by 2002:a05:6870:e99e:b0:da:73d8:51b6 with SMTP id r30-20020a056870e99e00b000da73d851b6mr1848551oao.144.1649958548388;
        Thu, 14 Apr 2022 10:49:08 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o7-20020a056871078700b000e29ff467dcsm936471oap.50.2022.04.14.10.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:49:08 -0700 (PDT)
Received: (nullmailer pid 2300574 invoked by uid 1000);
        Thu, 14 Apr 2022 17:49:07 -0000
Date:   Thu, 14 Apr 2022 12:49:07 -0500
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v6 09/13] dt-bindings: mmc: imx-esdhc: Add i.MX8DXL
 compatible string
Message-ID: <Ylhek+sqhq+hdFrX@robh.at.kernel.org>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
 <20220413103356.3433637-10-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413103356.3433637-10-abel.vesa@nxp.com>
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

On Wed, 13 Apr 2022 13:33:52 +0300, Abel Vesa wrote:
> Add i.MX8DXL compatible string. It also needs "fsl,imx8qm-fec" compatible.
> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
