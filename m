Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBD550C31A
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiDVWT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiDVWSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:18:49 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6627319FA88;
        Fri, 22 Apr 2022 14:10:50 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id t15so10433523oie.1;
        Fri, 22 Apr 2022 14:10:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=ga2tgBX0PUJR1Zp9dNHUDhZ65+RalcaTSUDM/UaOuB0=;
        b=BTlKvE1DljZL73xoXGj+rYz4KSGKZikh3QkQfYnHcgFlN/iirUdQCg3Lmcz+LqDyAh
         LQXCy4mtqd+zNTmWoZGnrAPtG1zioKO7vB96GPMq/xSWQqQ8wGmWk0XRe9aQMU9Dqy7q
         L9c3TobdfdBlBcyXl+M8w6Z7alik83Z8C9Hm0rq9eqmCtgoNRywYhnAUG3c4cWnAqRtv
         YconLNfSpRnucpxNb+Eum9pcZKRSAcrilPfOakXlKYtAMU3exwJTKAX6d/Q+tOIYlbaB
         8XzLLkPIDGrmZGbsLO41BWZsnYfmvfgvBN5VqqGVv8ljUrpIIkBxENXLmORwWQgmQ6rD
         QWqQ==
X-Gm-Message-State: AOAM531adRC5rISUA9OjpQDVtxB6pRcT+TAxw2yhgDeHYxMMGvK8e49G
        O326g2/zoAC5Q16NuoI8GA==
X-Google-Smtp-Source: ABdhPJzFHB9JO0IzPSFAchdfBVlM9sHQgwENS+VHWa+J8qyq8EMl+Sc62ZjBkTrPhKSMWIQmP8rNAA==
X-Received: by 2002:a05:6808:1992:b0:322:ca0b:cce3 with SMTP id bj18-20020a056808199200b00322ca0bcce3mr3152103oib.168.1650661849712;
        Fri, 22 Apr 2022 14:10:49 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i22-20020a056808031600b003229333b14esm1154598oie.47.2022.04.22.14.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 14:10:49 -0700 (PDT)
Received: (nullmailer pid 2784290 invoked by uid 1000);
        Fri, 22 Apr 2022 21:10:47 -0000
From:   Rob Herring <robh@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Andrew Lunn <andrew@lunn.ch>, thomas.petazzoni@bootlin.com,
        devicetree@vger.kernel.org
In-Reply-To: <20220422180305.301882-5-maxime.chevallier@bootlin.com>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com> <20220422180305.301882-5-maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next 4/5] net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
Date:   Fri, 22 Apr 2022 16:10:47 -0500
Message-Id: <1650661847.285325.2784289.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 20:03:04 +0200, Maxime Chevallier wrote:
> Add the DT binding for the IPQESS Ethernet Controller. This is a simple
> controller, only requiring the phy-mode, interrupts, clocks, and
> possibly a MAC address setting.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  .../devicetree/bindings/net/qcom,ipqess.yaml  | 94 +++++++++++++++++++
>  1 file changed, 94 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipqess.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/qcom,ipqess.example.dts:26.27-28 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:364: Documentation/devicetree/bindings/net/qcom,ipqess.example.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1401: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

