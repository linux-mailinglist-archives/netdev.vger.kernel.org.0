Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE4A22FA0D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgG0U2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:28:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728863AbgG0U2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 16:28:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k09jn-0079Sh-82; Mon, 27 Jul 2020 22:28:43 +0200
Date:   Mon, 27 Jul 2020 22:28:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 0/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200727202843.GA1698018@lunn.ch>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
 <400c65b5-718e-64f5-a2a2-3b26108a93d5@gmail.com>
 <VI1PR0402MB387150745E6EB735F5A4D538E0720@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <6b3b9150-db4f-ae5e-90e1-96004ac46487@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b3b9150-db4f-ae5e-90e1-96004ac46487@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew, what directory structure do you have in mind such that Ioana can
> already start putting the PCS drivers in the right location?

Hi Florian

I will push out an RFC soon. It will need some build testing, just to
make sure i've not broken any Kconfig dependencies.

     Andrew
