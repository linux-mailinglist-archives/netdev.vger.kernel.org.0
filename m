Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263952506CA
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHXRqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:46:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgHXRqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 13:46:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAGXe-00Bfoh-6W; Mon, 24 Aug 2020 19:45:58 +0200
Date:   Mon, 24 Aug 2020 19:45:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1] net: phy: leds: Deduplicate link LED trigger
 registration
Message-ID: <20200824174558.GJ2403519@lunn.ch>
References: <20200824170904.60832-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824170904.60832-1-andriy.shevchenko@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 08:09:04PM +0300, Andy Shevchenko wrote:
> Refactor phy_led_trigger_register() and deduplicate its functionality
> when registering LED trigger for link.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Hi Andy

Please take a look at https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

    Andrew
