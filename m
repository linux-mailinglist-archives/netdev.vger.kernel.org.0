Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99F589894
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfHLIRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:17:35 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:60661 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfHLIRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:17:35 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id DCC74100002;
        Mon, 12 Aug 2019 08:17:31 +0000 (UTC)
Date:   Mon, 12 Aug 2019 10:17:31 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 2/9] net: macsec: move some definitions in a
 dedicated header
Message-ID: <20190812081731.GE3698@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-3-antoine.tenart@bootlin.com>
 <9f65de8e-bf62-f9b0-5aba-69c0f92df1ca@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f65de8e-bf62-f9b0-5aba-69c0f92df1ca@aquantia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor,

On Sat, Aug 10, 2019 at 12:19:36PM +0000, Igor Russkikh wrote:
> > +/**
> > + * struct macsec_tx_sa - transmit secure association
> > + * @active:
> > + * @next_pn: packet number to use for the next packet
> > + * @lock: protects next_pn manipulations
> > + * @key: key structure
> > + * @stats: per-SA stats
> > + */
> > +struct macsec_tx_sa {
> > +	struct macsec_key key;
> > +	spinlock_t lock;
> > +	u32 next_pn;
> > +	refcount_t refcnt;
> > +	bool active;
> > +	bool offloaded;
> 
> I don't see this `offloaded` field being used anywhere. Is this needed?

You're right it's not and was only used in previous versions of this
patchset. I'll remove it.

Thanks for spotting this!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
