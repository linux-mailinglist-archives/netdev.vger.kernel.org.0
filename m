Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6494AF562
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiBIPfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbiBIPfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:35:12 -0500
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222E4C0613C9;
        Wed,  9 Feb 2022 07:35:13 -0800 (PST)
Received: by mail-oo1-f48.google.com with SMTP id f11-20020a4abb0b000000b002e9abf6bcbcso2909397oop.0;
        Wed, 09 Feb 2022 07:35:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=zQuG1gNmLxtVzGRukrbPQaSats/LPmqZjnzNcnI9U2Y=;
        b=clbTim+J8UJLar3A5G+83D3qTtcn7U2QuudLssdJ469hYrwgELBZQ4lbTdrzptgNoo
         4Q1vtl92jgrohwRNzuTSgBzTCcinvuRE/ZwJ5ZgoU2G2o0pLimISLADFKK0z+oTOTyRI
         f/sUgMRQXua3yWeNQ2jEbVJ+k/UvYV4kOhnrZ6CuPfXCizrRNHTVuHw27gsNu+Pe+xHl
         hSxCUjuLio3CpztN3zlLcl5tNS/+HeQ8HfgSrhBdbZK9XfvflIz8e0SrigTPT0L9LLIy
         GG+RwWljux51ZmYc9dh07u2Z2Uj3Ex3nKHWDPixbx/hSqNPF4QtYSfy/PZAuLUof2lSi
         0EMQ==
X-Gm-Message-State: AOAM530XvNRASLsrqEysPdW/9wZ5RYlOjFWdCSdzKVCrKwsI4iHyJIz7
        19FtzK55gvaHehgAVF+kaQ==
X-Google-Smtp-Source: ABdhPJzwiejWzZl6kEqUPNuq5xhaz6Uf7XTFMECQDOn9nmikk6iyqJxgN6O6dhy6d1aNee8cWqbpAQ==
X-Received: by 2002:a05:6870:822b:: with SMTP id n43mr893622oae.271.1644420912117;
        Wed, 09 Feb 2022 07:35:12 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q9sm6827864oif.9.2022.02.09.07.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 07:35:11 -0800 (PST)
Received: (nullmailer pid 391821 invoked by uid 1000);
        Wed, 09 Feb 2022 15:35:08 -0000
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20220209081025.2178435-3-o.rempel@pengutronix.de>
References: <20220209081025.2178435-1-o.rempel@pengutronix.de> <20220209081025.2178435-3-o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next v2 2/2] dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet controllers
Date:   Wed, 09 Feb 2022 09:35:08 -0600
Message-Id: <1644420908.431570.391820.nullmailer@robh.at.kernel.org>
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

On Wed, 09 Feb 2022 09:10:25 +0100, Oleksij Rempel wrote:
> Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> import all currently supported USB IDs form drivers/net/usb/smsc95xx.c
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../bindings/net/microchip,lan95xx.yaml       | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1590223


smsc@2: $nodename:0: 'smsc@2' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/tegra30-ouya.dt.yaml

usbether@1: $nodename:0: 'usbether@1' does not match '^ethernet(@.*)?$'
	arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dt.yaml
	arch/arm/boot/dts/bcm2835-rpi-b.dt.yaml
	arch/arm/boot/dts/bcm2835-rpi-b-plus.dt.yaml
	arch/arm/boot/dts/bcm2835-rpi-b-rev2.dt.yaml
	arch/arm/boot/dts/bcm2836-rpi-2-b.dt.yaml
	arch/arm/boot/dts/bcm2837-rpi-3-b.dt.yaml
	arch/arm/boot/dts/omap3-beagle-xm-ab.dt.yaml
	arch/arm/boot/dts/omap3-beagle-xm.dt.yaml
	arch/arm/boot/dts/omap4-panda-a4.dt.yaml
	arch/arm/boot/dts/omap4-panda.dt.yaml
	arch/arm/boot/dts/omap4-panda-es.dt.yaml

usbether@3: $nodename:0: 'usbether@3' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/omap5-uevm.dt.yaml

