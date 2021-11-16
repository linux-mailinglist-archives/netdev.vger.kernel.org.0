Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53982452F31
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhKPKhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:37:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:10019 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234199AbhKPKha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 05:37:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="213700719"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="213700719"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 02:34:33 -0800
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="454200794"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 02:34:26 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mmvn7-007O4Y-CJ;
        Tue, 16 Nov 2021 12:34:17 +0200
Date:   Tue, 16 Nov 2021 12:34:17 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Colin Foster <colin.foster@in-advantage.com>,
        Daniel Scally <djrscally@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Message-ID: <YZOJKZZSVQ9wvUTS@smile.fi.intel.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 10:23:05PM -0800, Colin Foster wrote:
> My apologies for this next RFC taking so long. Life got in the way.
> 
> 
> The patch set in general is to add support for the VSC7511, VSC7512,
> VSC7513 and VSC7514 devices controlled over SPI. The driver is
> relatively functional for the internal phy ports (0-3) on the VSC7512.
> As I'll discuss, it is not yet functional for other ports yet.


Since series touches fwnode, please Cc next time to Daniel Scally.
It also appears [1] that somewhere in PHY code a bug is hidden
(at least I think so).

[1]: https://lore.kernel.org/lkml/20211113204141.520924-1-djrscally@gmail.com/T/#u

-- 
With Best Regards,
Andy Shevchenko


