Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD6B4FE241
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351675AbiDLNX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356417AbiDLNXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:23:10 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D785F56;
        Tue, 12 Apr 2022 06:14:07 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id a17-20020a9d3e11000000b005cb483c500dso13351016otd.6;
        Tue, 12 Apr 2022 06:14:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=4Hu29V9bbNGQ7NeMGoWiDLgZuDde0wP79E71crt9DdM=;
        b=6xDjFtAoU9TZO0esno4Hf4cS5FCI+aIIpNOUkbHDbAuuFwTt4JaIR20bDh9d6DSjfs
         kAsGSx5LffWFabhBQ7aTEoMNwg1PSL5ed77c9J6xP9GlMkMjvYhtFLxi3tRSmKZWe9gH
         Euc77qwslSDI9a5R8ODHwNjD43tmFQ6vZcYUFlaNJRFrXOol400alUhSwpI3SmzOSMl0
         BhI/kargNL8AMuBC4jLIoGZrutqqr+34SjGLtbgMSIj/pNV+KgaMU2nHpA9/6rzSRdBT
         pp8G7HePqq5VK33vCIP6SBf8i/keNDmT0K1IPrcoqSdwVo3INlQLZPVsV1AocB4KqI2P
         MLpQ==
X-Gm-Message-State: AOAM5334wWwbGUWYGN1J6buNWOhED6p1FJzd82JcMM7ueKBP2a0Hcs+L
        TLuCsqSMAHVVp/kw/bl2Dw==
X-Google-Smtp-Source: ABdhPJy/ZMhWQUc529yUtvgnyCadjBqr7fjsWtZYK6b6y58vnNMwVPuq1IYac7H3Y8QrDWl4AkwVgw==
X-Received: by 2002:a05:6830:2aa1:b0:5e6:cccf:419b with SMTP id s33-20020a0568302aa100b005e6cccf419bmr6816302otu.208.1649769246965;
        Tue, 12 Apr 2022 06:14:06 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id n62-20020acaef41000000b002ef646e6690sm12947467oih.53.2022.04.12.06.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:14:06 -0700 (PDT)
Received: (nullmailer pid 3815484 invoked by uid 1000);
        Tue, 12 Apr 2022 13:14:05 -0000
From:   Rob Herring <robh@kernel.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-aspeed@lists.ozlabs.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, joel@jms.id.au, hkallweit1@gmail.com,
        pabeni@redhat.com, linux-arm-kernel@lists.infradead.org,
        andrew@aj.id.au, robh+dt@kernel.org, p.zabel@pengutronix.de,
        krzk+dt@kernel.org, linux-kernel@vger.kernel.org, andrew@lunn.ch,
        BMC-SW@aspeedtech.com, linux@armlinux.org.uk, davem@davemloft.net
In-Reply-To: <20220412065611.8930-2-dylan_hung@aspeedtech.com>
References: <20220412065611.8930-1-dylan_hung@aspeedtech.com> <20220412065611.8930-2-dylan_hung@aspeedtech.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: add reset property for aspeed, ast2600-mdio binding
Date:   Tue, 12 Apr 2022 08:14:05 -0500
Message-Id: <1649769245.688561.3815481.nullmailer@robh.at.kernel.org>
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

On Tue, 12 Apr 2022 14:56:09 +0800, Dylan Hung wrote:
> The AST2600 MDIO bus controller has a reset control bit and must be
> deasserted before manipulating the MDIO controller. By default, the
> hardware asserts the reset so the driver only need to deassert it.
> 
> Regarding to the old DT blobs which don't have reset property in them,
> the reset deassertion is usually done by the bootloader so the reset
> property is optional to work with them.
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.example.dts:25.35-36 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:364: Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.example.dtb] Error 1
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

