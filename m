Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7DB4E27B4
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347977AbiCUNg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347984AbiCUNgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:36:45 -0400
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF33457B1;
        Mon, 21 Mar 2022 06:35:20 -0700 (PDT)
Received: by mail-oo1-f48.google.com with SMTP id p10-20020a056820044a00b00320d7d4af22so19126499oou.4;
        Mon, 21 Mar 2022 06:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=5UU4N1/jkwKIKHDgJE8Xaunth0Jq4iesYl4vSjdvP6Y=;
        b=qK5Q3XxSupslhtSENzAM+l3k2Q+QECQFrcdN0K8V+GutjLodKMgqTSLCDjNH+H/lXM
         quGzqqFM815yOTaGq6Va31/CvI4187G3ZcWZMLu4PKxbuHo1ut/QB66BwQHogJjHW8YT
         eTLS4/ZY8Dot3kq+2M6CsbkPqjbyR3T7zcnx0/teuwZWVFPXNzUp0l1fIa/tw1zXhvx/
         o4hJiO7gbFVHf9xOcryMa2WGFHn5g7eVOMc9+YifLDSMyfCnVCApH2iNJ3X/jxESmcI1
         ocIl++leTqzC58O6tEEBFDazcPFxoBbGh8tolRrhXkbP/oUghP3bN+l1WqQt3mevVd46
         YWng==
X-Gm-Message-State: AOAM5322FDgSfm+6zNaKWh/yVrqx8byxlEeaWJ9l8vOpMVPCsPH733t4
        xBfFwa5+9sM53y0Wh7aUzQ==
X-Google-Smtp-Source: ABdhPJzfmSYuwsV67ZwxyLb5RUYtTVRmT0EHgTTZezQLdru8b+cuGc6RlbeGCMx5yctS3/FrA95Q3g==
X-Received: by 2002:a05:6870:3112:b0:ce:c0c9:62b with SMTP id v18-20020a056870311200b000cec0c9062bmr11623640oaa.125.1647869719305;
        Mon, 21 Mar 2022 06:35:19 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t15-20020a056808158f00b002e331356c87sm7572522oiw.39.2022.03.21.06.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 06:35:18 -0700 (PDT)
Received: (nullmailer pid 4125326 invoked by uid 1000);
        Mon, 21 Mar 2022 13:35:11 -0000
From:   Rob Herring <robh@kernel.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, andrew@aj.id.au,
        linux-arm-kernel@lists.infradead.org, andrew@lunn.ch,
        davem@davemloft.net, linux-aspeed@lists.ozlabs.org,
        BMC-SW@aspeedtech.com, kuba@kernel.org, p.zabel@pengutronix.de,
        hkallweit1@gmail.com, joel@jms.id.au, pabeni@redhat.com,
        linux@armlinux.org.uk
In-Reply-To: <20220321095648.4760-2-dylan_hung@aspeedtech.com>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com> <20220321095648.4760-2-dylan_hung@aspeedtech.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: net: add reset property for aspeed, ast2600-mdio binding
Date:   Mon, 21 Mar 2022 08:35:11 -0500
Message-Id: <1647869711.893197.4125325.nullmailer@robh.at.kernel.org>
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

On Mon, 21 Mar 2022 17:56:46 +0800, Dylan Hung wrote:
> The AST2600 MDIO bus controller has a reset control bit and must be
> deasserted before the manipulating the MDIO controller.
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Cc: stable@vger.kernel.org
> ---
>  .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml          | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1607671


mdio@1e650000: 'resets' is a required property
	arch/arm/boot/dts/aspeed-ast2600-evb-a1.dt.yaml
	arch/arm/boot/dts/aspeed-ast2600-evb.dt.yaml
	arch/arm/boot/dts/aspeed-bmc-inventec-transformers.dt.yaml

mdio@1e650008: 'resets' is a required property
	arch/arm/boot/dts/aspeed-ast2600-evb-a1.dt.yaml
	arch/arm/boot/dts/aspeed-ast2600-evb.dt.yaml
	arch/arm/boot/dts/aspeed-bmc-facebook-cloudripper.dt.yaml
	arch/arm/boot/dts/aspeed-bmc-facebook-fuji.dt.yaml

mdio@1e650010: 'resets' is a required property
	arch/arm/boot/dts/aspeed-ast2600-evb-a1.dt.yaml
	arch/arm/boot/dts/aspeed-ast2600-evb.dt.yaml

mdio@1e650018: 'resets' is a required property
	arch/arm/boot/dts/aspeed-ast2600-evb-a1.dt.yaml
	arch/arm/boot/dts/aspeed-ast2600-evb.dt.yaml
	arch/arm/boot/dts/aspeed-bmc-facebook-cloudripper.dt.yaml

