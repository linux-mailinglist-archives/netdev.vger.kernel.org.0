Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FDD4AF5F8
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiBIQCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiBIQCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:02:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC65C0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 08:02:57 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHpQi-00080I-NA; Wed, 09 Feb 2022 17:02:52 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHpQi-0001Sc-AO; Wed, 09 Feb 2022 17:02:52 +0100
Date:   Wed, 9 Feb 2022 17:02:52 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 2/2] dt-bindings: net: add schema for
 Microchip/SMSC LAN95xx USB Ethernet controllers
Message-ID: <20220209160252.GB26024@pengutronix.de>
References: <20220209081025.2178435-1-o.rempel@pengutronix.de>
 <20220209081025.2178435-3-o.rempel@pengutronix.de>
 <1644420908.431570.391820.nullmailer@robh.at.kernel.org>
 <CAL_JsqL1AAMq4u3Ruj2d5AUe-JnP8FDp8bUE0KcY_8fusxC9dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_JsqL1AAMq4u3Ruj2d5AUe-JnP8FDp8bUE0KcY_8fusxC9dg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:57:17 up 61 days, 42 min, 82 users,  load average: 0.20, 0.19,
 0.17
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 09:38:57AM -0600, Rob Herring wrote:
> On Wed, Feb 9, 2022 at 9:35 AM Rob Herring <robh@kernel.org> wrote:
> >
> > On Wed, 09 Feb 2022 09:10:25 +0100, Oleksij Rempel wrote:
> > > Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> > > import all currently supported USB IDs form drivers/net/usb/smsc95xx.c
> > >
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > >  .../bindings/net/microchip,lan95xx.yaml       | 80 +++++++++++++++++++
> > >  1 file changed, 80 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> > >
> >
> > Running 'make dtbs_check' with the schema in this patch gives the
> > following warnings. Consider if they are expected or the schema is
> > incorrect. These may not be new warnings.
> >
> > Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> > This will change in the future.
> >
> > Full log is available here: https://patchwork.ozlabs.org/patch/1590223
> >
> >
> > smsc@2: $nodename:0: 'smsc@2' does not match '^ethernet(@.*)?$'
> >         arch/arm/boot/dts/tegra30-ouya.dt.yaml
> >
> > usbether@1: $nodename:0: 'usbether@1' does not match '^ethernet(@.*)?$'
> >         arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dt.yaml
> >         arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dt.yaml
> >         arch/arm/boot/dts/bcm2835-rpi-b.dt.yaml
> >         arch/arm/boot/dts/bcm2835-rpi-b-plus.dt.yaml
> >         arch/arm/boot/dts/bcm2835-rpi-b-rev2.dt.yaml
> >         arch/arm/boot/dts/bcm2836-rpi-2-b.dt.yaml
> >         arch/arm/boot/dts/bcm2837-rpi-3-b.dt.yaml
> >         arch/arm/boot/dts/omap3-beagle-xm-ab.dt.yaml
> >         arch/arm/boot/dts/omap3-beagle-xm.dt.yaml
> >         arch/arm/boot/dts/omap4-panda-a4.dt.yaml
> >         arch/arm/boot/dts/omap4-panda.dt.yaml
> >         arch/arm/boot/dts/omap4-panda-es.dt.yaml
> >
> > usbether@3: $nodename:0: 'usbether@3' does not match '^ethernet(@.*)?$'
> >         arch/arm/boot/dts/omap5-uevm.dt.yaml
> 
> So this binding is already in use, but was undocumented?

Ack.

> Or did you forget to remove the .txt file?

No, there was no documentation.

> The commit message should highlight all this.
> 
> (I don't expect you to fix all these warnings, I was just surprised to
> see them given this is an 'initial schema'.)

This patches was create before I needed to use it. Should I resent it
with new commit message?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
