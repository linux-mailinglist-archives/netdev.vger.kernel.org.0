Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80CE2459D1
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgHPWQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:16:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55624 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgHPWQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 18:16:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7Qws-009dEk-Lh; Mon, 17 Aug 2020 00:16:18 +0200
Date:   Mon, 17 Aug 2020 00:16:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 6/7] net: dsa: wire up devlink info get
Message-ID: <20200816221618.GB2294711@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-7-andrew@lunn.ch>
 <20200816215630.l7rdynh4ymx426uq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816215630.l7rdynh4ymx426uq@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int dsa_devlink_info_get(struct devlink *dl,
> > +				struct devlink_info_req *req,
> > +				struct netlink_ext_ack *extack)
> > +{
> > +	struct dsa_switch *ds;
> > +
> > +	ds = dsa_devlink_to_ds(dl);
> > +
> 
> Why not place the declaration and the assignment on a single line?

This code went through a few refactors. Probably at some point i could
not keep reverse christmass tree so had to split it. And it then never
got put back together again.

I will fix it up for v2.

  Andrew
