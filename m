Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C954B2AEC
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 17:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348209AbiBKQtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 11:49:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiBKQtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 11:49:52 -0500
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EC58D;
        Fri, 11 Feb 2022 08:49:50 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id b5so9523989qtq.11;
        Fri, 11 Feb 2022 08:49:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+tFu3vkbTQIySarpIIX7Tezye9s6YZGK6OMSaOHlyY4=;
        b=jknmwU3KP7JlR+SE4RCbBxJuYmfXJSR1M11ajJzjA8+EVuWWCk2hqKZ6MgilfNC787
         t4aLhW9y9ksUARTmHkptVvoGatrGQgEHGS5od2RRp40G9RYz33UvY3xv1rPec72pajEO
         0N4bnaTq9mYLonVWlKRRhenPnpCGwYjpNMzrtQp8DZB8DFtXlSF2iWkh8MYV9wZ9Pw9G
         +Uxy0ZiioPYEoLx3XFnyLrFr1Zrn/x6zrmZ4lrI8XmrHgqW1YBCWimeJVtEmPtPQvasz
         dsWYToTr/BIPlTeM5+2LdbolLaAmKBKWyOy0iMfzh4AiH6DYtAuI37hufZpDkL8ZuQeW
         f7/w==
X-Gm-Message-State: AOAM532zmzA8YSzI/unCdLn/XzhtewxUxrFjBVhafxOP9nOwtFbCIvx9
        Dm0LGWFVTU6imVly7Vxmpw==
X-Google-Smtp-Source: ABdhPJwrK4i0id3TCyebwPom3Nt5279eNZ7MttB2p50A+Y+8mKUPs7WBlXNbYfUW8gLI0GKtfduj8g==
X-Received: by 2002:ac8:5950:: with SMTP id 16mr1742609qtz.104.1644598189334;
        Fri, 11 Feb 2022 08:49:49 -0800 (PST)
Received: from robh.at.kernel.org ([2607:fb90:5fee:dfce:b6df:c3e1:b1e5:d6d8])
        by smtp.gmail.com with ESMTPSA id g17sm10065226qkl.122.2022.02.11.08.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:49:48 -0800 (PST)
Received: (nullmailer pid 503767 invoked by uid 1000);
        Fri, 11 Feb 2022 16:49:46 -0000
Date:   Fri, 11 Feb 2022 10:49:46 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 2/2] dt-bindings: net: add schema for
 Microchip/SMSC LAN95xx USB Ethernet controllers
Message-ID: <YgaTqpmmb67mCdlc@robh.at.kernel.org>
References: <20220209081025.2178435-1-o.rempel@pengutronix.de>
 <20220209081025.2178435-3-o.rempel@pengutronix.de>
 <1644420908.431570.391820.nullmailer@robh.at.kernel.org>
 <CAL_JsqL1AAMq4u3Ruj2d5AUe-JnP8FDp8bUE0KcY_8fusxC9dg@mail.gmail.com>
 <20220209160252.GB26024@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209160252.GB26024@pengutronix.de>
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

On Wed, Feb 09, 2022 at 05:02:52PM +0100, Oleksij Rempel wrote:
> On Wed, Feb 09, 2022 at 09:38:57AM -0600, Rob Herring wrote:
> > On Wed, Feb 9, 2022 at 9:35 AM Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Wed, 09 Feb 2022 09:10:25 +0100, Oleksij Rempel wrote:
> > > > Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> > > > import all currently supported USB IDs form drivers/net/usb/smsc95xx.c
> > > >
> > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > ---
> > > >  .../bindings/net/microchip,lan95xx.yaml       | 80 +++++++++++++++++++
> > > >  1 file changed, 80 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> > > >
> > >
> > > Running 'make dtbs_check' with the schema in this patch gives the
> > > following warnings. Consider if they are expected or the schema is
> > > incorrect. These may not be new warnings.
> > >
> > > Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> > > This will change in the future.
> > >
> > > Full log is available here: https://patchwork.ozlabs.org/patch/1590223
> > >
> > >
> > > smsc@2: $nodename:0: 'smsc@2' does not match '^ethernet(@.*)?$'
> > >         arch/arm/boot/dts/tegra30-ouya.dt.yaml
> > >
> > > usbether@1: $nodename:0: 'usbether@1' does not match '^ethernet(@.*)?$'
> > >         arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dt.yaml
> > >         arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dt.yaml
> > >         arch/arm/boot/dts/bcm2835-rpi-b.dt.yaml
> > >         arch/arm/boot/dts/bcm2835-rpi-b-plus.dt.yaml
> > >         arch/arm/boot/dts/bcm2835-rpi-b-rev2.dt.yaml
> > >         arch/arm/boot/dts/bcm2836-rpi-2-b.dt.yaml
> > >         arch/arm/boot/dts/bcm2837-rpi-3-b.dt.yaml
> > >         arch/arm/boot/dts/omap3-beagle-xm-ab.dt.yaml
> > >         arch/arm/boot/dts/omap3-beagle-xm.dt.yaml
> > >         arch/arm/boot/dts/omap4-panda-a4.dt.yaml
> > >         arch/arm/boot/dts/omap4-panda.dt.yaml
> > >         arch/arm/boot/dts/omap4-panda-es.dt.yaml
> > >
> > > usbether@3: $nodename:0: 'usbether@3' does not match '^ethernet(@.*)?$'
> > >         arch/arm/boot/dts/omap5-uevm.dt.yaml
> > 
> > So this binding is already in use, but was undocumented?
> 
> Ack.
> 
> > Or did you forget to remove the .txt file?
> 
> No, there was no documentation.
> 
> > The commit message should highlight all this.
> > 
> > (I don't expect you to fix all these warnings, I was just surprised to
> > see them given this is an 'initial schema'.)
> 
> This patches was create before I needed to use it. Should I resent it
> with new commit message?

Yes, please.

Rob
