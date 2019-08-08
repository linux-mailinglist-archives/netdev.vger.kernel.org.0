Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9B385CFC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbfHHIgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 04:36:40 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42677 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730994AbfHHIgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 04:36:40 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1hvduZ-0002s3-BJ; Thu, 08 Aug 2019 10:36:39 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1hvduX-0002NV-Vd; Thu, 08 Aug 2019 10:36:37 +0200
Date:   Thu, 8 Aug 2019 10:36:37 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Yuiko.Oshino@microchip.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        kernel@pengutronix.de, hkallweit1@gmail.com,
        Ravi.Hegde@microchip.com, Tristram.Ha@microchip.com
Subject: Re: net: micrel: confusion about phyids used in driver
Message-ID: <20190808083637.g77loqpgkzi63u55@pengutronix.de>
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
 <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Jul 02, 2019 at 08:55:07PM +0000, Yuiko.Oshino@microchip.com wrote:
> >On Fri, May 10, 2019 at 09:22:43AM +0200, Uwe Kleine-König wrote:
> >> On Thu, May 09, 2019 at 11:07:45PM +0200, Andrew Lunn wrote:
> >> > On Thu, May 09, 2019 at 10:55:29PM +0200, Heiner Kallweit wrote:
> >> > > On 09.05.2019 22:29, Uwe Kleine-König wrote:
> >> > > > I have a board here that has a KSZ8051MLL (datasheet:
> >> > > > http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
> >> > > > 0x0022155x) assembled. The actual phyid is 0x00221556.
> >> > >
> >> > > I think the datasheets are the source of the confusion. If the
> >> > > datasheets for different chips list 0x0022155x as PHYID each, and
> >> > > authors of support for additional chips don't check the existing
> >> > > code, then happens what happened.
> >> > >
> >> > > However it's not a rare exception and not Microchip-specific that
> >> > > sometimes vendors use the same PHYID for different chips.
> >>
> >> From the vendor's POV it is even sensible to reuse the phy IDs iff the
> >> chips are "compatible".
> >>
> >> Assuming that the last nibble of the phy ID actually helps to
> >> distinguish the different (not completely) compatible chips, we need
> >> some more detailed information than available in the data sheets I have.
> >> There is one person in the recipents of this mail with an
> >> @microchip.com address (hint, hint!).
> >
> >can you give some input here or forward to a person who can?
>
> I forward this to the team.

This thread still sits in my inbox waiting for some feedback. Did
something happen on your side?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
