Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84315648DE
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 20:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiGCSA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 14:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGCSA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 14:00:27 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF9C60D1;
        Sun,  3 Jul 2022 11:00:27 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id r133so6794929iod.3;
        Sun, 03 Jul 2022 11:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=0oH4Qv2b3hpacaeJbha5xxiRLG21WNmxbvy8dgQr22s=;
        b=AOdSmEqL9Y8VBUpOZIj0YWcHxqSgD8G34oP4xKwAYbD/yD+tr4pbjAfSofsdVu5PKl
         S6pFfxRkF3LZfCd0jy+hh2DGblxHGgpXN9wRw/jQO7ndIMxoXpg25CUoZdTLL35YQsmN
         sMTNdQyqXDJeYSFeYiSVZ+wL0D1510itUVv+fJSU82LyaW7o5kvFnelk3biCfQx7Cjrg
         EL3upJq+M7lgOVPTLTvBuC7ZT6lZu0JgCzLl9isHhkZbzWIYwr3DE4c31DofmGsvCilL
         bBEawBrHeIpgDJFzbwT5dC5nuhc/mJvYWpU+i1VdqTeHzvwmpfSqTUMWdBN2Vtfb+wDm
         brLA==
X-Gm-Message-State: AJIora97s5xsLgxyO1ejAwKhYWCbULXC59hS2Lj3I2kWdCK1GFCsaY8o
        NZKz85AdclsEyKgxeRxXQg==
X-Google-Smtp-Source: AGRyM1uyZ/IzOLxMLM1fHCuuqlCDAZS8xqzT04cCI/FH8YEh27fssyASXY5sxh0osk4DmVvORf72xw==
X-Received: by 2002:a5e:c908:0:b0:675:7f2c:b266 with SMTP id z8-20020a5ec908000000b006757f2cb266mr13808388iol.7.1656871226347;
        Sun, 03 Jul 2022 11:00:26 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id z7-20020a923207000000b002d1d3b1abbesm11176112ile.80.2022.07.03.11.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 11:00:25 -0700 (PDT)
Received: (nullmailer pid 1705438 invoked by uid 1000);
        Sun, 03 Jul 2022 18:00:23 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Biju Das <biju.das@bp.renesas.com>, linux-can@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Paolo Abeni <pabeni@redhat.com>,
        =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
In-Reply-To: <20220703104705.341070-2-biju.das.jz@bp.renesas.com>
References: <20220703104705.341070-1-biju.das.jz@bp.renesas.com> <20220703104705.341070-2-biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH v2 1/6] dt-bindings: can: sja1000: Convert to json-schema
Date:   Sun, 03 Jul 2022 12:00:23 -0600
Message-Id: <1656871223.903187.1705437.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 03 Jul 2022 11:47:00 +0100, Biju Das wrote:
> Convert the NXP SJA1000 CAN Controller Device Tree binding
> documentation to json-schema.
> 
> Update the example to match reality.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v1->v2:
>  * Moved $ref: can-controller.yaml# to top along with if conditional to
>    avoid multiple mapping issues with the if conditional in the subsequent
>    patch.
> ---
>  .../bindings/net/can/nxp,sja1000.yaml         | 102 ++++++++++++++++++
>  .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
>  2 files changed, 102 insertions(+), 58 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/


can@4,0: nxp,tx-output-config:0:0: 22 is not one of [1, 2, 4, 6, 8, 16, 32, 48]
	arch/arm/boot/dts/imx27-phytec-phycore-rdk.dtb

can@4,0: 'reg-io-width' is a required property
	arch/arm/boot/dts/imx27-phytec-phycore-rdk.dtb

