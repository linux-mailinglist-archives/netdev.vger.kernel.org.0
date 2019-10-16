Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E05D8C3D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 11:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391906AbfJPJJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 05:09:58 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36629 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390007AbfJPJJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 05:09:57 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1iKfJc-0005bW-7u; Wed, 16 Oct 2019 11:09:56 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1iKfJb-00082O-4R; Wed, 16 Oct 2019 11:09:55 +0200
Date:   Wed, 16 Oct 2019 11:09:55 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Woojung.Huh@microchip.com, Yuiko.Oshino@microchip.com
Cc:     Allan.Nielsen@microchip.com, f.fainelli@gmail.com,
        Nicolas.Ferre@microchip.com, netdev@vger.kernel.org,
        andrew@lunn.ch, kernel@pengutronix.de, hkallweit1@gmail.com,
        Ravi.Hegde@microchip.com, Tristram.Ha@microchip.com
Subject: Re: net: micrel: confusion about phyids used in driver
Message-ID: <20191016090955.np6m3heyv4qqdo4l@pengutronix.de>
References: <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
 <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
 <20190808083637.g77loqpgkzi63u55@pengutronix.de>
 <20190820202503.xauhbrj24p3vcoxp@pengutronix.de>
 <1057c2c2-e1f0-75ba-3878-dbd52805e0cc@gmail.com>
 <20190821184947.43iilefgrjn4zrtl@lx-anielsen.microsemi.net>
 <BL0PR11MB3012CC53F680EDF4C5146652E7AA0@BL0PR11MB3012.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL0PR11MB3012CC53F680EDF4C5146652E7AA0@BL0PR11MB3012.namprd11.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 07:53:29PM +0000, Woojung.Huh@microchip.com wrote:
> Hi Allan & Florian,
> 
> > > > So we're in need of someone who can get their hands on some more
> > > > detailed documentation than publicly available to allow to make the
> > > > driver handle the KSZ8051MLL correctly without breaking other stuff.
> > > >
> > > > I assume you are in a different department of Microchip than the people
> > > > caring for PHYs, but maybe you can still help finding someone who cares?
> > >
> > > Allan, is this something you could help with? Thanks!
> > Sorry, I'm new in Microchip (was aquired through Microsemi), and I know next to
> > nothing about the Micrel stuff.
> > 
> > Woojung: Can you comment on this, or try to direct this to someone who knows
> > something...
> 
> Forwarded to Yuiko. Will do follow-up.

Nothing happend here, right? Would it be possible to get more detailed
documentation about the affected chips than available on the website
such that someone outside of microchip can address the problems?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
