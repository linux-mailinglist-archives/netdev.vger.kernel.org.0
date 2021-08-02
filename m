Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73ED3DE043
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhHBTp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:45:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhHBTp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 15:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MUZNsDfGKRYBiGTVq1DSjcKaGnXi5YAFEO+SQ2j/yPg=; b=sv+uNh5SvFu5R3uY1pzfPSReZv
        Nyc7FeOQv2KVJZ7tVbNoMbhanTbY98hZHVIrUgQkyCfm42SetAJs25j9dBaueNsNgkCA9kVdqTaoL
        M6U+03m5lJI7T7w4eefTRADyagNT9kAn1La8hZm18A87nX3Iv7VHDFsjfV179eg5cl+g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAdsA-00FrsC-NB; Mon, 02 Aug 2021 21:45:14 +0200
Date:   Mon, 2 Aug 2021 21:45:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/6] net: dsa: qca: ar9331: make proper
 initial port defaults
Message-ID: <YQhLSg3Vr1pvVHsW@lunn.ch>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-3-o.rempel@pengutronix.de>
 <20210802140345.zreovwix6nuyjwjy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802140345.zreovwix6nuyjwjy@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +/* AGE_TIME_COEF is not documented. This is "works for me" value */
> > +#define AR9331_SW_AT_AGE_TIME_COEF		6900
> 
> Not documented, not used either, it seems.
> "Works for you" based on what?

It is used in a later patch. Ideally it would of been introduced in
that patch to make this more obvious.

> >  #define AR9331_SW_REG_MDIO_CTRL			0x98
> >  #define AR9331_SW_MDIO_CTRL_BUSY		BIT(31)
> >  #define AR9331_SW_MDIO_CTRL_MASTER_EN		BIT(30)
> > @@ -101,6 +111,46 @@
> >  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN | \
> >  	 AR9331_SW_PORT_STATUS_SPEED_M)
> 
> Is this patch material for "net"? If standalone ports is all that ar9331
> supports, then it would better not do packet forwarding in lack of a
> bridge device.

It does seem like this patch should be considered for stable, if by
default all ports can talk with all ports when not part of a bridge.

	Andrew
