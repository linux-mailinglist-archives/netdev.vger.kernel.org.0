Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC525699A0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 06:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiGGE7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 00:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiGGE7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 00:59:53 -0400
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E661F2AE13;
        Wed,  6 Jul 2022 21:59:51 -0700 (PDT)
Received: by mail-il1-f179.google.com with SMTP id v2so1368129ilo.7;
        Wed, 06 Jul 2022 21:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=BluPNYlPwRAADufAvcH+mPYEv1SwH8lYhCuBMwsLBUY=;
        b=YiTar1kXUwQSlUGyw1HdgHxc0zcMCbvdWaQ6oRXiHVvn5mxcI1N5vfiz2lLb5KqSHU
         2Sm3MYl3S/jl00OfTtlJN/IC0IRfJrrzXS+EmcahXI//YqWV1SgMRhGOCWsL5bDSHvLC
         y889awRYqRSD8zBgQ8SyWdJtMI7WqA0hEkRl5vN4UYboLjrhWgTq5VvIPhJMY1WLMaES
         Kk+UcWgwUiKITVP/gXbSL4GFuN+mXFyKRPQoSbyUvgcQ0p/mnT7aY7oAmWYomSIiawU9
         hRQ82lEQ4FeQlCZnBYXJuO89wk0bFz5VpD+xthzZBLkH0orSKCAJlZPDMR/jrgUaqdS8
         v63A==
X-Gm-Message-State: AJIora+Hf8t1Fe0oXvH5XD2C9a+wBbqybUmWhpYHZ26k/jS4AU2amWvn
        YBmcRo9ZNvZLPi4i2tNu8A==
X-Google-Smtp-Source: AGRyM1vWFwpjzmbwWrBvD20F+4HMtbJVjBSTJCkJlCQWUNnu4KSLu4TtzQ4aZSgNB8DZaHYYStAObA==
X-Received: by 2002:a05:6e02:11af:b0:2dc:2cee:5083 with SMTP id 15-20020a056e0211af00b002dc2cee5083mr6394743ilj.69.1657169991136;
        Wed, 06 Jul 2022 21:59:51 -0700 (PDT)
Received: from robh.at.kernel.org ([98.38.210.73])
        by smtp.gmail.com with ESMTPSA id o7-20020a056e02114700b002dc258e3093sm2610210ill.64.2022.07.06.21.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 21:59:50 -0700 (PDT)
Received: (nullmailer pid 709504 invoked by uid 1000);
        Thu, 07 Jul 2022 04:59:49 -0000
From:   Rob Herring <robh@kernel.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        linux-tegra@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20220706213255.1473069-6-thierry.reding@gmail.com>
References: <20220706213255.1473069-1-thierry.reding@gmail.com> <20220706213255.1473069-6-thierry.reding@gmail.com>
Subject: Re: [PATCH v3 5/9] dt-bindings: net: Add Tegra234 MGBE
Date:   Wed, 06 Jul 2022 22:59:49 -0600
Message-Id: <1657169989.827036.709503.nullmailer@robh.at.kernel.org>
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

On Wed, 06 Jul 2022 23:32:51 +0200, Thierry Reding wrote:
> From: Bhadram Varka <vbhadram@nvidia.com>
> 
> Add device-tree binding documentation for the Multi-Gigabit Ethernet
> (MGBE) controller found on NVIDIA Tegra234 SoCs.
> 
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v3:
> - add macsec and macsec-ns interrupt names
> - improve mdio bus node description
> - drop power-domains description
> - improve bindings title
> 
> Changes in v2:
> - add supported PHY modes
> - change to dual license
> 
>  .../bindings/net/nvidia,tegra234-mgbe.yaml    | 169 ++++++++++++++++++
>  1 file changed, 169 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.example.dts:53.34-35 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:383: Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.example.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1404: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

