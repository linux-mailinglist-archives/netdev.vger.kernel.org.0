Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7747D5B1D28
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiIHMfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiIHMfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:35:03 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B415948EBB;
        Thu,  8 Sep 2022 05:35:02 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1274ec87ad5so29014548fac.0;
        Thu, 08 Sep 2022 05:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oR89XIUSMxR/GNj2hiLhHDeN2pBkc9JmGP6t/dlgZIg=;
        b=41uTD9c9Sb4teMRSgFlONiX+7ClJW7UxF9qg+UsanPwwDLjf/Re7XEPNAVNp9hlA9p
         iRuF2TwqS0mtE8hw4ZHsGpDysopDLfWrsQvCv7FKYhrTSS9mASyBF/OKX+BwYjbz4nG3
         5IsmdORqybJmkQRqgOIn/i7NoT544t4DaOspdimAoHRi8N/0F+1sJiIdSI50wRbIIPOW
         38MlYpAImSR4PTiSWB8yoS2pFjeFFseHgCrg3SEVLUG72hNAPR+8M+W5iE2v2LQmHhoL
         4RMLPpPfrfJOjWjBrlcgH7zAKlV3Pl5MXWhNgiuuKcgQ+SggpANiB394rYNPIke50MWk
         E6iw==
X-Gm-Message-State: ACgBeo1oOPRztiYpBKRDdIbYA04gaS6JfPh4zL/aabZ6oB1V54Tc0kd5
        z+KAgHtKXFFtWkrJZGnzJV+LZeDMkg==
X-Google-Smtp-Source: AA6agR46TYLmwq0cQXb1P70BXA1rNspo2AAAKrCxMS3RglYUz0YyWLcZEDAN6MN4PgzKQ7TcytH5lw==
X-Received: by 2002:a05:6808:34d:b0:344:bb33:95bc with SMTP id j13-20020a056808034d00b00344bb3395bcmr1379118oie.202.1662640501330;
        Thu, 08 Sep 2022 05:35:01 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v8-20020a05687105c800b001267a921ae5sm7166501oan.34.2022.09.08.05.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:35:01 -0700 (PDT)
Received: (nullmailer pid 2262533 invoked by uid 1000);
        Thu, 08 Sep 2022 12:35:00 -0000
From:   Rob Herring <robh@kernel.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     agross@kernel.org, Vinod Koul <vkoul@kernel.org>,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, bhupesh.linux@gmail.com,
        Bjorn Andersson <andersson@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
In-Reply-To: <20220907204924.2040384-2-bhupesh.sharma@linaro.org>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org> <20220907204924.2040384-2-bhupesh.sharma@linaro.org>
Subject: Re: [PATCH 1/4] dt-bindings: net: qcom,ethqos: Convert bindings to yaml
Date:   Thu, 08 Sep 2022 07:35:00 -0500
Message-Id: <1662640500.274487.2262529.nullmailer@robh.at.kernel.org>
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

On Thu, 08 Sep 2022 02:19:21 +0530, Bhupesh Sharma wrote:
> Convert Qualcomm ETHQOS Ethernet devicetree binding to YAML.
> 
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  .../devicetree/bindings/net/qcom,ethqos.txt   |  66 ---------
>  .../devicetree/bindings/net/qcom,ethqos.yaml  | 139 ++++++++++++++++++
>  2 files changed, 139 insertions(+), 66 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.example.dtb: ethernet@20000: compatible: ['qcom,sm8150-ethqos'] does not contain items matching the given schema
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.example.dtb: ethernet@20000: reg: [[0, 131072], [0, 65536], [0, 221184], [0, 256]] is too long
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.example.dtb: ethernet@20000: interrupt-names:1: 'eth_wake_irq' was expected
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.example.dtb: ethernet@20000: Unevaluated properties are not allowed ('max-speed', 'snps,mtl-rx-config', 'snps,mtl-tx-config', 'snps,reset-active-low', 'snps,reset-delays-us' were unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/qcom,ethqos.example.dtb: phy@7: '#phy-cells' is a required property
	From schema: /usr/local/lib/python3.10/dist-packages/dtschema/schemas/phy/phy-provider.yaml

doc reference errors (make refcheckdocs):
MAINTAINERS: Documentation/devicetree/bindings/net/qcom,ethqos.txt

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

