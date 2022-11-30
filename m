Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3376A63CEBE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiK3Feo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiK3Fem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:34:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16B26C73F
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:34:39 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p0Fjx-0008QZ-6e; Wed, 30 Nov 2022 06:34:37 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p0Fju-0005mu-8m; Wed, 30 Nov 2022 06:34:34 +0100
Date:   Wed, 30 Nov 2022 06:34:34 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v1 00/26] net: dsa: microchip: stats64, fdb, error
Message-ID: <20221130053434.GA19642@pengutronix.de>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
 <7f0a7acc-4b6b-8e33-7098-e5dfcb67945f@intel.com>
 <20221129053539.GA25526@pengutronix.de>
 <Y4YT5wfckSO1sfRw@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y4YT5wfckSO1sfRw@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 03:15:03PM +0100, Andrew Lunn wrote:
> On Tue, Nov 29, 2022 at 06:35:39AM +0100, Oleksij Rempel wrote:
> > On Mon, Nov 28, 2022 at 03:09:19PM -0800, Jacob Keller wrote:
> > > 
> > > My understanding is that we typically limit series to 15 patches. Do you
> > > have some justification for why this goes over 15 and can't reasonably be
> > > split into two series?
> > > 
> > > At a glance it seems like a bunch of smaller cleanups.
> > 
> > The previous patch set got request to do more clean ups:
> > https://lore.kernel.org/all/20221124101458.3353902-1-o.rempel@pengutronix.de/
> > 
> > I need to show, there are already more patches in the queue.
> 
> There is some psychology involved here. I see 26 patches and decide i
> need to allocate 30 minutes to this sometime, and put the review off
> until later, without even looking at them. If i get 5 patches, i
> probably just do it, knowing i will be finished pretty quickly. My
> guess is, 5 patches a day for 5 days will be merged faster than 26
> patches in one go.

Good point. Thx!

I'll split this patch set.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
