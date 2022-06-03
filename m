Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2865253D1A2
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbiFCSgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347499AbiFCSgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:36:18 -0400
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEC613CFE;
        Fri,  3 Jun 2022 11:30:07 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-f3381207a5so11661837fac.4;
        Fri, 03 Jun 2022 11:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=I7SGBEQXCUibuD73vM0CHY2eGNwkmF13THVdJfw1SR0=;
        b=helJqc8zqX6zbSfEbH4SWyTFWVEJ3J1l8FPVvktuhm/I99DoqkP8JVroRDCQuuMxh6
         o1BmZN49KOcGT+XlPCnRjyRN5YldPD7vlYqwxbLnWxgzqdYK8Pg+iL68NLMONqxn1A15
         E7Z32QOhW2IYILlMzmNIdHOmzBG6sNMvwLRGAET8ClYQ83wQFMS0usAvz/Xdwv5u5YfG
         Ehi0LkctJ6tyXIfLa+X6L5/5hP55z3nBbxANIf0ip0wnAIlAw+7yynRpQQK3BETm/XiA
         h1c2Uq2cvMBuN/dWBRJwCxEiZLpdN2SlbzFbCkRMIpMBQWDxABkY4EwrCLNng2vFhIrA
         P5Tg==
X-Gm-Message-State: AOAM532OWXrCbIcctoZn41+A9tqDkxW0ehzVzmvvqo4jcIMuAdd/BCzb
        cKphWP+jeNcCozCnpcgVAA==
X-Google-Smtp-Source: ABdhPJzurdHrLRcPetBePDn+vKDT2DZNlz06HHGkbGle2OmyEXWhxj77Y4tWwxQDz7yoqzlBmWHgFg==
X-Received: by 2002:a05:6870:311:b0:f2:d46a:b370 with SMTP id m17-20020a056870031100b000f2d46ab370mr24040400oaf.169.1654281006668;
        Fri, 03 Jun 2022 11:30:06 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m11-20020a9d644b000000b0060b350fd549sm3860552otl.65.2022.06.03.11.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:30:06 -0700 (PDT)
Received: (nullmailer pid 680143 invoked by uid 1000);
        Fri, 03 Jun 2022 18:30:04 -0000
From:   Rob Herring <robh@kernel.org>
To:     Johan Jonker <jbx6244@gmail.com>
Cc:     netdev@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-rockchip@lists.infradead.org, heiko@sntech.de,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org
In-Reply-To: <20220603163539.537-1-jbx6244@gmail.com>
References: <20220603163539.537-1-jbx6244@gmail.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: net: convert emac_rockchip.txt to YAML
Date:   Fri, 03 Jun 2022 13:30:04 -0500
Message-Id: <1654281004.034832.680142.nullmailer@robh.at.kernel.org>
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

On Fri, 03 Jun 2022 18:35:37 +0200, Johan Jonker wrote:
> Convert emac_rockchip.txt to YAML.
> 
> Changes against original bindings:
>   Add mdio sub node.
>   Add extra clock for rk3036
> 
> Signed-off-by: Johan Jonker <jbx6244@gmail.com>
> ---
> 
> Changed V2:
>   use phy
>   rename to rockchip,emac.yaml
>   add more requirements
> ---
>  .../devicetree/bindings/net/emac_rockchip.txt |  52 --------
>  .../bindings/net/rockchip,emac.yaml           | 115 ++++++++++++++++++
>  2 files changed, 115 insertions(+), 52 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/emac_rockchip.txt
>  create mode 100644 Documentation/devicetree/bindings/net/rockchip,emac.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/


ethernet@10200000: compatible: ['rockchip,rk3036-emac', 'snps,arc-emac'] is too long
	arch/arm/boot/dts/rk3036-evb.dtb
	arch/arm/boot/dts/rk3036-kylin.dtb

ethernet@10200000: 'mdio' is a required property
	arch/arm/boot/dts/rk3036-evb.dtb
	arch/arm/boot/dts/rk3036-kylin.dtb

ethernet@10204000: 'mdio' is a required property
	arch/arm/boot/dts/rk3066a-marsboard.dtb
	arch/arm/boot/dts/rk3066a-rayeager.dtb
	arch/arm/boot/dts/rk3188-radxarock.dtb

