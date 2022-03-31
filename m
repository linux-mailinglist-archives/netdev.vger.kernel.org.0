Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7FA4EE2B6
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 22:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241468AbiCaUg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 16:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241456AbiCaUgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 16:36:54 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F27AD4470;
        Thu, 31 Mar 2022 13:35:03 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-deb9295679so529437fac.6;
        Thu, 31 Mar 2022 13:35:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7o8q97xCtSsryTgEf+sdFsnMX0/U036sQhYghPoefl4=;
        b=iPJMIel6KouTEDry7C1kbBk8yMK/XG0f8n5a/xdpTicgN470n1MAIZqq0O9XIQkTQT
         1iAELBGJ99xBVFuBGbsK66w77QlYA4Y9z7bSbwe064IL8vRgvZQGNIJOgb8klFDl6yyb
         mOTYM2AgQPuSVzZ0xUp2PqQIGS2vA9vKOIKyuLChLPNuVD2d6h297HDDKQy/4P+BDFyA
         VG8AbLUNJK1Nr0BKgwjIuypNESUa7lk7vmMryzHIdlI6sY9ljUtvrxBCA7f+oC07LQSF
         Qs3PqTOguNnRiVdnhVMTWUcZXWhU8sJ5a5FIKPQCLvWnl3ZMEQG6C0We+GGB/XGJEPWR
         P2/Q==
X-Gm-Message-State: AOAM532BTv+JLmhPhYRdJu1nFGVk2U16AQRXbCyCqXhV/q7iFgS1ZSWI
        WVaDs2lxCAejO6OyUHA4LQ==
X-Google-Smtp-Source: ABdhPJyOtg9v8M3rgMoWnDenrT80lRaoyYQt7XKsnQHhmcrqEG9E/JNZKDO/sxj1EcCQH8b9oxX0lA==
X-Received: by 2002:a05:6870:79d:b0:da:56e3:fe99 with SMTP id en29-20020a056870079d00b000da56e3fe99mr3441337oab.95.1648758902507;
        Thu, 31 Mar 2022 13:35:02 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r35-20020a056870582300b000df0dc42ff5sm219227oap.0.2022.03.31.13.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 13:35:00 -0700 (PDT)
Received: (nullmailer pid 1446207 invoked by uid 1000);
        Thu, 31 Mar 2022 20:34:59 -0000
Date:   Thu, 31 Mar 2022 15:34:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, alsa-devel@alsa-project.org,
        Georgi Djakov <djakov@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-tegra@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Subject: Re: [PATCH] dt-bindings: Fix incomplete if/then/else schemas
Message-ID: <YkYQc/r8P5LYI6dt@robh.at.kernel.org>
References: <20220330145741.3044896-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330145741.3044896-1-robh@kernel.org>
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

On Wed, 30 Mar 2022 09:57:41 -0500, Rob Herring wrote:
> A recent review highlighted that the json-schema meta-schema allows any
> combination of if/then/else schema keywords even though if, then or else
> by themselves makes little sense. With an added meta-schema to only
> allow valid combinations, there's a handful of schemas found which need
> fixing in a variety of ways. Incorrect indentation is the most common
> issue.
> 
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Michael Hennerich <Michael.Hennerich@analog.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
> Cc: Olivier Moysan <olivier.moysan@foss.st.com>
> Cc: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Georgi Djakov <djakov@kernel.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Dmitry Osipenko <digetx@gmail.com>
> Cc: linux-iio@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-phy@lists.infradead.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/iio/adc/adi,ad7476.yaml          |  1 +
>  .../bindings/iio/adc/st,stm32-dfsdm-adc.yaml  |  8 +-
>  .../bindings/iio/dac/adi,ad5360.yaml          |  6 +-
>  .../bindings/interconnect/qcom,rpm.yaml       | 84 +++++++++----------
>  .../bindings/mmc/nvidia,tegra20-sdhci.yaml    |  2 +
>  .../bindings/net/ti,davinci-mdio.yaml         |  1 +
>  .../bindings/phy/nvidia,tegra20-usb-phy.yaml  | 20 ++---
>  .../bindings/phy/qcom,usb-hs-phy.yaml         | 36 ++++----
>  .../bindings/regulator/fixed-regulator.yaml   | 34 ++++----
>  .../bindings/sound/st,stm32-sai.yaml          |  6 +-
>  .../devicetree/bindings/sram/sram.yaml        | 16 ++--
>  11 files changed, 108 insertions(+), 106 deletions(-)
> 

Applied, thanks!
