Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2C4983D7
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 21:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfHUS5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 14:57:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49774 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfHUS5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 14:57:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vFX90YRsBTJK5AWhBMwuW2ac3NGFvVKSagxrVlHCSC4=; b=4+I01uoyADD27LQ/mt2GEBa42Y
        HbuAEganfQyti5Uyxbt1dwaEQJZoXKHtwdpYz5CtuSBCFxQlu/c8juqgI1QyrIciBjofrSemh+cSI
        a8qz9fC1h24ok064o74smCEVH86GnLus30Mi+BW+s10gxj859SXSSII/L0TZ3r+BUSf8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0VnH-0007Ea-II; Wed, 21 Aug 2019 20:57:15 +0200
Date:   Wed, 21 Aug 2019 20:57:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Christian Herber <christian.herber@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Message-ID: <20190821185715.GA16401@lunn.ch>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
 <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <13e65051-fe4f-5964-30b3-75285e6d2eee@gmail.com>
 <AM6PR0402MB3798FCBF1EE592687B13A3C386AB0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <5c920846-b8f5-d087-cea4-a8ca3f816127@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c920846-b8f5-d087-cea4-a8ca3f816127@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The current patch set IMO is a little bit hacky. I'm not 100% happy
> with the implicit assumption that there can't be devices supporting
> T1 and classic BaseT modes or fiber modes.
> 
> Andrew: Do you have an opinion on that?

Hi Heiner

I would also like cleaner integration. I doubt here is anything in the
standard which says you cannot combine these modes. It is more a
marketing question if anybody would build such a device. Maybe not
directly into a vehicle, but you could imaging a mobile test device
which uses T1 to talk to the car and T4 to connect to the garage
network?

So i don't think we should limit ourselves. phylib should provide a
clean, simple set of helpers to perform standard operations for
various modes. Drivers can make use of those helpers. That much should
be clear. If we try to make genphy support them all simultaneously, is
less clear.

     Andrew
