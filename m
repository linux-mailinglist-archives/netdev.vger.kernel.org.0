Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC5EAF959
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfIKJqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:46:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:17217 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfIKJqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 05:46:24 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 02:46:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="196844304"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga002.jf.intel.com with ESMTP; 11 Sep 2019 02:46:20 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i7zCd-0005c0-E6; Wed, 11 Sep 2019 12:46:19 +0300
Date:   Wed, 11 Sep 2019 12:46:19 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 04/11] net: phylink: switch to using
 fwnode_gpiod_get_index()
Message-ID: <20190911094619.GN2680@smile.fi.intel.com>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <20190911075215.78047-5-dmitry.torokhov@gmail.com>
 <20190911092514.GM2680@smile.fi.intel.com>
 <20190911093914.GT13294@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911093914.GT13294@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 10:39:14AM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Sep 11, 2019 at 12:25:14PM +0300, Andy Shevchenko wrote:
> > On Wed, Sep 11, 2019 at 12:52:08AM -0700, Dmitry Torokhov wrote:
> > > Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
> > > the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), bit
> > > works with arbitrary firmware node.
> > 
> > I'm wondering if it's possible to step forward and replace
> > fwnode_get_gpiod_index by gpiod_get() / gpiod_get_index() here and
> > in other cases in this series.
> 
> No, those require a struct device, but we have none.  There are network
> drivers where there is a struct device for the network complex, but only
> DT nodes for the individual network interfaces.  So no, gpiod_* really
> doesn't work.

In the following patch the node is derived from struct device. So, I believe
some cases can be handled differently.

-- 
With Best Regards,
Andy Shevchenko


