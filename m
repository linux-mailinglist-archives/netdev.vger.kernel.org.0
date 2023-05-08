Return-Path: <netdev+bounces-866-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C212A6FB0A9
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF5DE1C209C0
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98E11362;
	Mon,  8 May 2023 12:53:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFD61361
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:53:10 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD883918C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 05:53:09 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <sha@pengutronix.de>)
	id 1pw0MJ-0003YG-1s; Mon, 08 May 2023 14:52:55 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <sha@pengutronix.de>)
	id 1pw0MH-0003Ns-Hm; Mon, 08 May 2023 14:52:53 +0200
Date: Mon, 8 May 2023 14:52:53 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/11] leds: introduce new LED hw control APIs
Message-ID: <20230508125253.GW29365@pengutronix.de>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
 <ZFjqKoZtgOAWrkP+@pengutronix.de>
 <6458ec16.050a0220.21ddf.3955@mx.google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6458ec16.050a0220.21ddf.3955@mx.google.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 02:33:25PM +0200, Christian Marangi wrote:
> On Mon, May 08, 2023 at 02:25:14PM +0200, Sascha Hauer wrote:
> > Hi Christian,
> > 
> > On Thu, Apr 27, 2023 at 02:15:30AM +0200, Christian Marangi wrote:
> > > This is a continue of [1]. It was decided to take a more gradual
> > > approach to implement LEDs support for switch and phy starting with
> > > basic support and then implementing the hw control part when we have all
> > > the prereq done.
> > 
> > I tried to apply this series to give it a try. To what tree should this
> > series be applied upon?
> >
> 
> Hi,
> since this feature affect multiple branch, the prereq of this branch are
> still not in linux-next. (the prereq series got accepted but still has
> to be merged)
> 
> Lee created a branch.

Ok, this explains it, thanks.

> 
> We are waiting for RC stage to request a stable branch so we can
> reference ti to correctly test this.
> 
> Anyway you should be able to apply this series on top of this branch [1]
> 
> Consider that a v2 is almost ready with some crucial changes that should
> improve the implementation. (so if you are planning on adding support
> for other device I advice to check also v2, just an additional ops to
> implement)

I'll wait for v2 then. My ultimate goal is to implement LED trigger support
for the DP83867 phy. It would be great if you could Cc me on v2 so I get
a trigger once it's out.

Thanks for working on this topic. It pops up here every once in a while
and it would be good to get it solved.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

