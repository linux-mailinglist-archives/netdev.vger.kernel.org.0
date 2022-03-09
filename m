Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2254D3CCE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbiCIWWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238607AbiCIWWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:22:00 -0500
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928F6119859;
        Wed,  9 Mar 2022 14:21:00 -0800 (PST)
Received: by mail-oi1-f180.google.com with SMTP id h10so4138007oia.4;
        Wed, 09 Mar 2022 14:21:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=yF9ediEFayMfZ9+RKb1DdVRXctEVXCbctlmQh++NDoU=;
        b=O8ysOKVGsDFy1drHQ98EfAeupj15+4hTGT5w8p+GU3RswYdEJEcNv7G+CQDnx05p4F
         4paI2O6JfXJEDWQKo7CVv1/xAqU3Vu+EbEcKnsmBL/MKsv2t04D8talnIIjN64wCS1iO
         zZp6WDxGgJ1L6G2e3gHKT3Zf6yHLiMEaXdVgw1ileDQqS9NhSLib3t3UQn9onUHESAar
         EkmQGrGR8xwdDY6VtQfO4sBeqSsCqkViQbzUGVEhv2gsWe5amNAu2LM7bhGb78gCKMMy
         8KkRiuVP9fNZVuINfKNVKBjClAtGaTcIDiJBa+wzTCD83mRg2QSCm8djid0N+tRZ0OJb
         qAhg==
X-Gm-Message-State: AOAM531H4BU/inUGworbUNq/Y227wkDw+M2fayex8QB9VkWEEamw1/vE
        1eAKDDpoHV21Jsc5T2WJ+g==
X-Google-Smtp-Source: ABdhPJw+dfId+0ndY8HM1NpzRpBMl/Yi9AFqGIRET9W7tu2Mw2RRu3B73M+BSL7CSoIjQlqwsDaCFw==
X-Received: by 2002:a05:6808:2394:b0:2d9:d2ad:c85c with SMTP id bp20-20020a056808239400b002d9d2adc85cmr1187861oib.4.1646864459865;
        Wed, 09 Mar 2022 14:20:59 -0800 (PST)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o45-20020a9d2230000000b005b2426c3577sm1527948ota.79.2022.03.09.14.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 14:20:59 -0800 (PST)
Received: (nullmailer pid 326443 invoked by uid 1000);
        Wed, 09 Mar 2022 22:20:55 -0000
From:   Rob Herring <robh@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux-phy@lists.infradead.org, vkoul@kernel.org,
        davem@davemloft.net, leoyang.li@nxp.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, shawnguo@kernel.org, hongxing.zhu@nxp.com,
        kishon@ti.com, linux@armlinux.org.uk, kuba@kernel.org
In-Reply-To: <20220309172748.3460862-3-ioana.ciornei@nxp.com>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com> <20220309172748.3460862-3-ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 2/8] dt-bindings: phy: add the "fsl,lynx-28g" compatible
Date:   Wed, 09 Mar 2022 16:20:55 -0600
Message-Id: <1646864455.145844.326442.nullmailer@robh.at.kernel.org>
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

On Wed, 09 Mar 2022 19:27:42 +0200, Ioana Ciornei wrote:
> Describe the "fsl,lynx-28g" compatible used by the Lynx 28G SerDes PHY
> driver on Layerscape based SoCs.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
> 	- none
> 
>  .../devicetree/bindings/phy/fsl,lynx-28g.yaml | 71 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 72 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/fsl,lynx-28g.example.dt.yaml: example-0: serdes_phy@1ea0000:reg:0: [0, 32112640, 0, 7728] is too long
	From schema: /usr/local/lib/python3.8/dist-packages/dtschema/schemas/reg.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/fsl,lynx-28g.example.dt.yaml: serdes_phy@1ea0000: #phy-cells:0:0: 0 was expected
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/fsl,lynx-28g.example.dt.yaml: serdes_phy@1ea0000: '#address-cells', '#size-cells', 'phy@0', 'phy@1', 'phy@2', 'phy@3', 'phy@4', 'phy@5', 'phy@6', 'phy@7' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1603505

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

