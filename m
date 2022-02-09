Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF24AF586
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiBIPjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbiBIPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:39:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44804C05CB86;
        Wed,  9 Feb 2022 07:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D289A61668;
        Wed,  9 Feb 2022 15:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C5AC36AE3;
        Wed,  9 Feb 2022 15:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644421151;
        bh=Dt/0zvIMo6USyC1wtMp2YLZZQY4k2sJ437QqqRW8tyk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EKm1b0r5/QpGDqtupZOkYHbnvqcPqrPGA3zbEJhi5DxcXhWqMV2kDPjcwdSK3LLO8
         eJ1mmOy1WFJYlufnvl8lZ05G9wtvDYqRj+Q57W/LHrcKew0qnrUQj1nxK/ZIgpKDZg
         8Ypt1+1T/vYMCtkjqB1o4cTdTnW69MgameeY4z840Z4+ID9jvVc5H8zpy+5OIugyz6
         vzJC4DKG4liEKJ5zsWFOxLmwcbxnNjX0VmCdbV3e1Z92yhRsyuEnSbJ9zsAVEdCKMy
         XqsQU3JRnMTeoPe5I5ZJnkOGot6WJG0jiGYPbaUTOceg9PHIJKjM2btbXCc9cKBXs0
         iJJiHBfLPfE0g==
Received: by mail-ed1-f46.google.com with SMTP id cf2so5853985edb.9;
        Wed, 09 Feb 2022 07:39:11 -0800 (PST)
X-Gm-Message-State: AOAM5302WaRpQK/iOwI3G2oBWwsQ9k15BZnb3fp0o2ZaHPsNw8o5O2mK
        FXigpSadshjm/vxEhMKeIREhLGzAlCDVLlohcA==
X-Google-Smtp-Source: ABdhPJx+fr9fqoaO70e2OTG9XC57XY16GD5sYWt0hhPHAgnNaxh7uHZG12kKxpJrkEa5Xt3/3Q9Jg5mxXBjEM7bVXMs=
X-Received: by 2002:a05:6402:1e8b:: with SMTP id f11mr3208189edf.322.1644421149527;
 Wed, 09 Feb 2022 07:39:09 -0800 (PST)
MIME-Version: 1.0
References: <20220209081025.2178435-1-o.rempel@pengutronix.de>
 <20220209081025.2178435-3-o.rempel@pengutronix.de> <1644420908.431570.391820.nullmailer@robh.at.kernel.org>
In-Reply-To: <1644420908.431570.391820.nullmailer@robh.at.kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 9 Feb 2022 09:38:57 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL1AAMq4u3Ruj2d5AUe-JnP8FDp8bUE0KcY_8fusxC9dg@mail.gmail.com>
Message-ID: <CAL_JsqL1AAMq4u3Ruj2d5AUe-JnP8FDp8bUE0KcY_8fusxC9dg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] dt-bindings: net: add schema for
 Microchip/SMSC LAN95xx USB Ethernet controllers
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 9:35 AM Rob Herring <robh@kernel.org> wrote:
>
> On Wed, 09 Feb 2022 09:10:25 +0100, Oleksij Rempel wrote:
> > Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> > import all currently supported USB IDs form drivers/net/usb/smsc95xx.c
> >
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  .../bindings/net/microchip,lan95xx.yaml       | 80 +++++++++++++++++++
> >  1 file changed, 80 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> >
>
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
>
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
>
> Full log is available here: https://patchwork.ozlabs.org/patch/1590223
>
>
> smsc@2: $nodename:0: 'smsc@2' does not match '^ethernet(@.*)?$'
>         arch/arm/boot/dts/tegra30-ouya.dt.yaml
>
> usbether@1: $nodename:0: 'usbether@1' does not match '^ethernet(@.*)?$'
>         arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dt.yaml
>         arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dt.yaml
>         arch/arm/boot/dts/bcm2835-rpi-b.dt.yaml
>         arch/arm/boot/dts/bcm2835-rpi-b-plus.dt.yaml
>         arch/arm/boot/dts/bcm2835-rpi-b-rev2.dt.yaml
>         arch/arm/boot/dts/bcm2836-rpi-2-b.dt.yaml
>         arch/arm/boot/dts/bcm2837-rpi-3-b.dt.yaml
>         arch/arm/boot/dts/omap3-beagle-xm-ab.dt.yaml
>         arch/arm/boot/dts/omap3-beagle-xm.dt.yaml
>         arch/arm/boot/dts/omap4-panda-a4.dt.yaml
>         arch/arm/boot/dts/omap4-panda.dt.yaml
>         arch/arm/boot/dts/omap4-panda-es.dt.yaml
>
> usbether@3: $nodename:0: 'usbether@3' does not match '^ethernet(@.*)?$'
>         arch/arm/boot/dts/omap5-uevm.dt.yaml

So this binding is already in use, but was undocumented? Or did you
forget to remove the .txt file? The commit message should highlight
all this.

(I don't expect you to fix all these warnings, I was just surprised to
see them given this is an 'initial schema'.)

Rob
