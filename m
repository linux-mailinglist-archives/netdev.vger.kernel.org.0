Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0A789897
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 10:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfHLISn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 04:18:43 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:41327 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfHLISn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 04:18:43 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 9C64520010;
        Mon, 12 Aug 2019 08:18:39 +0000 (UTC)
Date:   Mon, 12 Aug 2019 10:18:39 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com
Subject: Re: [PATCH net-next v2 4/9] net: introduce MACsec ops and add a
 reference in net_device
Message-ID: <20190812081839.GF3698@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-5-antoine.tenart@bootlin.com>
 <20190809133509.12dbead1@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809133509.12dbead1@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Aug 09, 2019 at 01:35:09PM -0700, Jakub Kicinski wrote:
> On Thu,  8 Aug 2019 16:05:55 +0200, Antoine Tenart wrote:
> >  
> > +#if defined(CONFIG_MACSEC)
> > +struct macsec_ops {
> 
> I think it'd be cleaner to have macsec_ops declared in macsec.h
> and forward declare macsec_ops rather than macsec_context.

That makes sense, I'll move this declaration in macsec.h

> > +	/* Device wide */
> > +	int (*mdo_dev_open)(struct macsec_context *ctx);
> > +	int (*mdo_dev_stop)(struct macsec_context *ctx);
> > +	/* SecY */
> > +	int (*mdo_add_secy)(struct macsec_context *ctx);
> > +	int (*mdo_upd_secy)(struct macsec_context *ctx);
> > +	int (*mdo_del_secy)(struct macsec_context *ctx);
> > +	/* Security channels */
> > +	int (*mdo_add_rxsc)(struct macsec_context *ctx);
> > +	int (*mdo_upd_rxsc)(struct macsec_context *ctx);
> > +	int (*mdo_del_rxsc)(struct macsec_context *ctx);
> > +	/* Security associations */
> > +	int (*mdo_add_rxsa)(struct macsec_context *ctx);
> > +	int (*mdo_upd_rxsa)(struct macsec_context *ctx);
> > +	int (*mdo_del_rxsa)(struct macsec_context *ctx);
> > +	int (*mdo_add_txsa)(struct macsec_context *ctx);
> > +	int (*mdo_upd_txsa)(struct macsec_context *ctx);
> > +	int (*mdo_del_txsa)(struct macsec_context *ctx);
> > +};
> > +#endif

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
