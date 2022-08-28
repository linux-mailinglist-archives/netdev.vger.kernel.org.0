Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1075A3E03
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 16:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiH1OV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 10:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiH1OV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 10:21:27 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61775192AE;
        Sun, 28 Aug 2022 07:21:24 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id n124so7729666oih.7;
        Sun, 28 Aug 2022 07:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=Q5Bc5FZPo9xDw7LHXtSCc4yqGa5GrN6FlG7RHElDxNk=;
        b=R8O9CONTCZIpx1gl1pK6rNoALc1Ypjc+6VqJjIjYJZHoOHZLyO4GjcjthC7In6HSYm
         Nu70/swOdwc7qHZpSQWrNT2UFgbjE5qfRa948KF4sN5MUCnjMEr+LHChJNyZqWnbnShb
         IF+v4lpvYqbh0J4GxVVeJLoessXbDAlj8p5EaZ5iJiFif9OjEhupbWh+XWjgWmyG7v6o
         OWEB3+4qDHGxUTDqANtNigJABVGnpPWlrUT5Wrmvene3ToaBEylacKxKYawqOs45c9xh
         iOBf4P3viUmcXtJEylPgb5smwjA9F8tnx7ZB8fWSz9oJm8OHYyPRDg8Z5P47IxinUOuh
         Jxhg==
X-Gm-Message-State: ACgBeo0X16CZb6iEsaxBD9QD5TsY0Kc72wNg7mSNE+rc61aTBqcY6hNC
        DDAKENfUpkgpTKYDr1JROg==
X-Google-Smtp-Source: AA6agR41TAPZjmJinjP6h5JISv8Jmi9exlcKPxNGFmorLt4lJm7OrzRM9R4/PZ25sGnlQL6s4qP7DQ==
X-Received: by 2002:a05:6808:647:b0:343:43b8:3a18 with SMTP id z7-20020a056808064700b0034343b83a18mr5247052oih.57.1661696483105;
        Sun, 28 Aug 2022 07:21:23 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r2-20020a056830134200b006370815815asm4024921otq.61.2022.08.28.07.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 07:21:22 -0700 (PDT)
Received: (nullmailer pid 3159702 invoked by uid 1000);
        Sun, 28 Aug 2022 14:21:16 -0000
From:   Rob Herring <robh@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
In-Reply-To: <20220826154650.615582-5-maxime.chevallier@bootlin.com>
References: <20220826154650.615582-1-maxime.chevallier@bootlin.com> <20220826154650.615582-5-maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next v3 4/5] net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
Date:   Sun, 28 Aug 2022 09:21:16 -0500
Message-Id: <1661696476.855610.3159701.nullmailer@robh.at.kernel.org>
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

On Fri, 26 Aug 2022 17:46:49 +0200, Maxime Chevallier wrote:
> Add the DT binding for the IPQESS Ethernet Controller. This is a simple
> controller, only requiring the phy-mode, interrupts, clocks, and
> possibly a MAC address setting.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V2->V3:
>  - Cleanup on reset and clock names
> V1->V2:
>  - Fixed the example
>  - Added reset and clocks
>  - Removed generic ethernet attributes
> 
>  .../devicetree/bindings/net/qcom,ipqess.yaml  | 95 +++++++++++++++++++
>  1 file changed, 95 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/net/qcom,ipqess.example.dtb:0:0: /example-0/ethernet@c080000: failed to match any schema with compatible: ['qcom,ipq4019-ess-edma']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

