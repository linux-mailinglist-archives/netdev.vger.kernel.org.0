Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1C655E42F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbiF1NPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345595AbiF1NP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:15:27 -0400
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D822CDD1;
        Tue, 28 Jun 2022 06:15:26 -0700 (PDT)
Received: by mail-il1-f175.google.com with SMTP id o4so8111188ilm.9;
        Tue, 28 Jun 2022 06:15:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=seJbEPSZZ1oPKMlcZ7LVvOigbkxOOLRfiPmd+7jzfLU=;
        b=yustL8ueACXOIGxt1g6Okbp+1/aQZ4RhgkH/GP7ZKiaj4umFEphSDPMkhmccbBjA9W
         ZNbVqHwVvos5zKbEPA9U7YpvbkhLmZHh0JFKp4kL9fkQT2C4LiaVkpvB9S71HbnwBk4F
         xvTz0RNv+ubO0uYjYHbViq7IV4FUo++7deGKEzNz1FPMsZsfCevoGI+nr7kaCrxXw0Hp
         kmA635gyUt5k8eawpPmBZAOgMn3VUvoX5XAe3s+sb7n81XjMplbowkEfFkOqr+R4sWPi
         XlUsOxKvpKhSmlNNMAC0a7F/Ud2F3JtCo5H4iKY/GTfrV++t/RByjEfSvk0qc4LS0Wg0
         cOLw==
X-Gm-Message-State: AJIora/hJxjVmgDW4YwuVRNIbZO8aocQ0szoiQT4R1yjdvnAQiIgtsBB
        +6gKs6BmhvOrtBQh43jFTg==
X-Google-Smtp-Source: AGRyM1shbhhTUzPKXR6WRP7M3rKcxslLqTEYSXzXTb7Y4hsk6MgLaTL2jrtWoe2oVp+PvwnkU2STTQ==
X-Received: by 2002:a05:6e02:1aaa:b0:2da:8e4b:65a5 with SMTP id l10-20020a056e021aaa00b002da8e4b65a5mr7110050ilv.71.1656422126156;
        Tue, 28 Jun 2022 06:15:26 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id x21-20020a026f15000000b00339e452c0d2sm5899953jab.82.2022.06.28.06.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:15:25 -0700 (PDT)
Received: (nullmailer pid 313745 invoked by uid 1000);
        Tue, 28 Jun 2022 13:15:23 -0000
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Terry Bowman <terry.bowman@amd.com>, UNGLinuxDriver@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        linux-gpio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lee Jones <lee.jones@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
In-Reply-To: <20220628081709.829811-9-colin.foster@in-advantage.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com> <20220628081709.829811-9-colin.foster@in-advantage.com>
Subject: Re: [PATCH v11 net-next 8/9] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Tue, 28 Jun 2022 07:15:23 -0600
Message-Id: <1656422123.508891.313744.nullmailer@robh.at.kernel.org>
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

On Tue, 28 Jun 2022 01:17:08 -0700, Colin Foster wrote:
> Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
> VSC7512.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 161 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/mfd/mscc,ocelot.example.dtb:0:0: /example-0/spi/switch@0: failed to match any schema with compatible: ['mscc,vsc7512']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

