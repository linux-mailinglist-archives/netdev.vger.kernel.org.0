Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFA42F568B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbhANBtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:49:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39322 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbhANBtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:49:14 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzrkS-000Rcf-KU; Thu, 14 Jan 2021 02:48:28 +0100
Date:   Thu, 14 Jan 2021 02:48:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] dsa: add support for Arrow XRS700x tag
 trailer
Message-ID: <X/+i7LwLurfzn51t@lunn.ch>
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-2-george.mccollister@gmail.com>
 <20210114010519.td6q2pzy4mg6viuh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114010519.td6q2pzy4mg6viuh@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 03:05:19AM +0200, Vladimir Oltean wrote:
> On Wed, Jan 13, 2021 at 08:59:20AM -0600, George McCollister wrote:
> > Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
> > is modeled on tag_trailer.c which works in a similar way.
> > 
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> A few comments below.
> 
> > diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
> > new file mode 100644
> > index 000000000000..4ee7c260a8a9
> > --- /dev/null
> > +++ b/net/dsa/tag_xrs700x.c
> > @@ -0,0 +1,67 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * XRS700x tag format handling
> > + * Copyright (c) 2008-2009 Marvell Semiconductor
> 
> Why does Marvell get copyright?

Probably because it started life as tag_trailer.c?

	 Andrew
