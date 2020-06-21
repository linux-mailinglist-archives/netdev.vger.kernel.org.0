Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85087202CCA
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 22:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgFUUqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 16:46:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50984 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbgFUUqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 16:46:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jn6rH-001YQM-Tp; Sun, 21 Jun 2020 22:46:31 +0200
Date:   Sun, 21 Jun 2020 22:46:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 0/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200621204631.GE338481@lunn.ch>
References: <20200621110005.23306-1-ioana.ciornei@nxp.com>
 <20200621155153.GC338481@lunn.ch>
 <VI1PR0402MB3871F57E22774625FA9A0C0EE0960@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3871F57E22774625FA9A0C0EE0960@VI1PR0402MB3871.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sure, I will change the file to be named pcs-lynx.c and the Kconfig accordingly.
> Should I wait for you to send the patch moving xpcs to another folder?

Please send it whenever things are agreed with Russell.

It will be a few days before i move stuff around. I have another
patchset making all the phy code C=1 W=1 clean which i would like to
get merged first.

    Andrew
