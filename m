Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FB760D52E
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 22:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiJYUFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 16:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiJYUFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 16:05:05 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BACB1B1EB;
        Tue, 25 Oct 2022 13:05:04 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id o64so15746700oib.12;
        Tue, 25 Oct 2022 13:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QLRJG7zY0JAEptvz+m8vckaJwnRqZSqYUd2xM523SOI=;
        b=Q+DHAuBGQWbsNK/ccE+uo+jUGsn2EAbxZ6xNagISworT18d3A+SQHXoefCwBWooFfy
         coO/EDyvAacsfdz5v9jYNV0ZtlrmLH4ZShS8MlXfn+NZ56itT1FxYIk5Y391P04mLkTI
         RJKfUS6Egg6GIg5jqqIWaTLrFv+5R2orK/FHyLNkMaumW5mVij1M0+gfQCVb38Gdpi7W
         A8FMHsDOhiUAMFQ7amF2EimbigfpYQwnCdUk7XcY04sb2DhBlxVayk/+nRMq9O6rztEC
         xTtaEq6YUoJHiU6EnEvzMH+ZEwm7D2WsE0aPyrHP5iZKuj1T1+WT+OVHG2k8UuuZkwqs
         GilQ==
X-Gm-Message-State: ACrzQf15KJRQ0MGkSSb08mR257CS/tkk09pTz0oylEzK38LH1+HUJgSs
        aAx4eFD0ESNi2RkWhTlcndebjTkmmg==
X-Google-Smtp-Source: AMsMyM7+pyOTSb/iI/TPXj3oPVsA7J8gcQSboT6REpmeVgWrD6HL9Q6EUyxzn9vsLehZFdX/QWx9Dg==
X-Received: by 2002:a05:6808:316:b0:357:65d7:13a1 with SMTP id i22-20020a056808031600b0035765d713a1mr6240777oie.233.1666728303779;
        Tue, 25 Oct 2022 13:05:03 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id bk34-20020a0568081a2200b00354e8bc0236sm1293164oib.34.2022.10.25.13.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 13:05:03 -0700 (PDT)
Received: (nullmailer pid 3155082 invoked by uid 1000);
        Tue, 25 Oct 2022 20:05:02 -0000
From:   Rob Herring <robh@kernel.org>
To:     Camel Guo <camel.guo@axis.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        kernel@axis.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>
In-Reply-To: <20221025135243.4038706-2-camel.guo@axis.com>
References: <20221025135243.4038706-1-camel.guo@axis.com> <20221025135243.4038706-2-camel.guo@axis.com>
Message-Id: <166672723479.3138623.7338069718402647563.robh@kernel.org>
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW Series switches
Date:   Tue, 25 Oct 2022 15:05:02 -0500
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 15:52:40 +0200, Camel Guo wrote:
> Add documentation and an example for Maxlinear's GSW Series Ethernet
> switches.
> 
> Signed-off-by: Camel Guo <camel.guo@axis.com>
> ---
>  .../devicetree/bindings/net/dsa/mxl,gsw.yaml  | 140 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  MAINTAINERS                                   |   6 +
>  3 files changed, 148 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml: properties:mdio:allOf:0:$ref: 'http://devicetree.org/schemas/net/ethernet-phy.yaml#' should not be valid under {'pattern': '^https?://'}
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/mxl,gsw.example.dtb: switch@0: mdio: 'reg' is a required property
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

