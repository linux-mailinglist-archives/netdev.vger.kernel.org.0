Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CF9455BC1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244116AbhKRMu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:50:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:60774 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244060AbhKRMuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 07:50:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637239643; x=1668775643;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9KwQ7Npk018pjBseLFPR3vxg+q/5Ffg8h7DXnhBz8Zs=;
  b=YMni4HAbowvc5aPQKu5qDtFtxJ/gxUJPS0CsFgvKZTlTuZFfkoJtfzNO
   bMGby7sVXIOrsVb8N7XLhzusffUGd88uyCDzhXeMqMNZ9UP9Vft4sNPVw
   cQEOe4zmQ+rYMAEomswrT0iKP3JNIQ+UoX0LCh6T2momNWQBnPR7TnH5s
   9iSz/lanV4TOi73vKUL7r0B95qgVv1e4tkvvq01Yl2C3E39cRmbGxFiE8
   aq/TfvoilO633qiTTjP285WSaoBmAi0R3qDCnaKpOBEhGzUyWcEY7HDcR
   VVQlfFgjgqyExeK/oLyn0PUpypku6qlYodyEoo8ioFLP406m93jh/zu9Q
   A==;
IronPort-SDR: F3h5FFtrSx7cPYhtrht9EBI2hP8hrAspRsodwAC1nAUkS4HuG4xC64rXeUW/ySaoj4sBBarQ51
 JAbiKB4UTbfUYZdjx44rU6K5CdDhAU7G7UxgJ4Wu5Kz5TM40Ul5VAENeEgnpffXEOXbnlBkGsc
 BW4gkvz1CQI3ZzP3BLxxkFg3/FXoAx4BdsfcVNpTgnTn3+JQnMPYPIU9KmvO8woH23LrG/S9r0
 LjsN08R9tPVwIwOr77/xCrDOsfxWmZWA5doUMsPVgrQNA5bVur8qtQmV/nQwlifOpDUCYlophV
 LSmM9wlMx4a2vOzPGiXHNyjn
X-IronPort-AV: E=Sophos;i="5.87,244,1631602800"; 
   d="scan'208";a="136997341"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Nov 2021 05:47:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 18 Nov 2021 05:47:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 18 Nov 2021 05:47:20 -0700
Date:   Thu, 18 Nov 2021 13:49:08 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/5] net: lan966x: add the basic lan966x driver
Message-ID: <20211118124908.672iif6n5x23fijw@soft-dev3-1.localhost>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-3-horatiu.vultur@microchip.com>
 <9ab98fba364f736b267dbd5e1d305d3e8426e877.camel@pengutronix.de>
 <20211117214231.yiv2s6nxl6yx4klq@soft-dev3-1.localhost>
 <cdb9c0c334823505a2ce499e36be9507112f4298.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <cdb9c0c334823505a2ce499e36be9507112f4298.camel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/18/2021 11:19, Philipp Zabel wrote:
> 
> Hi Horatiu,
> 
> On Wed, 2021-11-17 at 22:42 +0100, Horatiu Vultur wrote:
> > > On Wed, 2021-11-17 at 10:18 +0100, Horatiu Vultur wrote:
> > > > +static int lan966x_reset_switch(struct lan966x *lan966x)
> > > > +{
> > > > +     struct reset_control *reset;
> > > > +     int val = 0;
> > > > +     int ret;
> > > > +
> > > > +     reset = devm_reset_control_get_shared(lan966x->dev, "switch");
> > > > +     if (IS_ERR(reset))
> > > > +             dev_warn(lan966x->dev, "Could not obtain switch reset: %ld\n",
> > > > +                      PTR_ERR(reset));
> > > > +     else
> > > > +             reset_control_reset(reset);
> > >
> > > According to the device tree bindings, both resets are required.
> > > I'd expect this to return on error.
> > > Is there any chance of the device working with out the switch reset
> > > being triggered?
> >
> > The only case that I see is if the bootloader triggers this switch
> > reset and then when bootloader starts the kernel and doesn't set back
> > the switch in reset. Is this a valid scenario or is a bug in the
> > bootloader?
> 
> I'm not sure. In general, the kernel shouldn't rely on the bootloader to
> have put the devices into a certain working state. If the driver will
> not work or worse, if register access could hang the system if the
> bootloader has passed control to the kernel with the switch held in
> reset and no reset control is available to the driver, it should not
> continue after failure to get the reset handle.
> 
> I'd suggest to just use:
> 
>         reset = devm_reset_control_get_shared(lan966x->dev, "switch");
>         if (IS_ERR(reset))
>                 return dev_err_probe(lan966x->dev, PTR_ERR(reset),
>                                      "Could not obtain switch reset");
>         reset_control_reset(reset);
> 
> unless you have a good reason to do otherwise.

I agree with you. I will do like you suggested in the next version.

> 
> regards
> Philipp

-- 
/Horatiu
