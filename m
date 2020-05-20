Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77F71DB82F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgETPaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:30:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETPaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P9xFjvln5lpqcUDkT0S9S25W/sDf22BHHJpouhC0kjw=; b=ho35PXiIJo7px+vRDFJbiNSyPG
        g460BkSQ51Cj7WYav6WFv2A6Z/8Z6e/HXCCCqrPp6Lqq4QixTimXy/vAzsuR5xrDCkrSn6/N8G6Lt
        Dr/g/SuYro3sJ4wi3dlL55BwRqF7v9IuM2PQkdGvp09q1dYPKwsi6zLdGt68nzsXDZPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbQfR-002onb-TD; Wed, 20 May 2020 17:30:01 +0200
Date:   Wed, 20 May 2020 17:30:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200520153001.GG652285@lunn.ch>
References: <20200520062915.29493-1-o.rempel@pengutronix.de>
 <20200520062915.29493-2-o.rempel@pengutronix.de>
 <20200520144544.GB8771@lion.mk-sys.cz>
 <20200520150711.rj4b22g3zhzej2aw@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520150711.rj4b22g3zhzej2aw@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I'm not sure if it's a good idea to define two separate callbacks. It
> > means adding two pointers instead of one (for every instance of the
> > structure, not only those implementing them), doing two calls, running
> > the same checks twice, locking twice, checking the result twice.
> > 
> > Also, passing a structure pointer would mean less code changed if we
> > decide to add more related state values later.
> > 
> > What do you think?
> > 
> > If you don't agree, I have no objections so
> > 
> > Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> 
> I have no strong opinion on it. Should I rework it?

It is an internal API, so we can change it any time we want.

I did wonder if MAX should just be a static value. It seems odd it
would change at run time. But we can re-evaulate this once we got some
more users.

     Andrew
