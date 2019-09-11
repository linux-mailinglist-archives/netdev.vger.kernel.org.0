Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A942DB021A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfIKQw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:52:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:51603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbfIKQw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:52:29 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:52:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,494,1559545200"; 
   d="scan'208";a="184538858"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga008.fm.intel.com with ESMTP; 11 Sep 2019 09:52:23 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i85qy-0001nV-3A; Wed, 11 Sep 2019 19:52:24 +0300
Date:   Wed, 11 Sep 2019 19:52:24 +0300
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
Message-ID: <20190911165224.GR2680@smile.fi.intel.com>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <20190911075215.78047-5-dmitry.torokhov@gmail.com>
 <20190911092514.GM2680@smile.fi.intel.com>
 <20190911093914.GT13294@shell.armlinux.org.uk>
 <20190911094619.GN2680@smile.fi.intel.com>
 <20190911094929.GV13294@shell.armlinux.org.uk>
 <20190911095511.GB108334@dtor-ws>
 <20190911101016.GW13294@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911101016.GW13294@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 11:10:16AM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Sep 11, 2019 at 02:55:11AM -0700, Dmitry Torokhov wrote:
> > On Wed, Sep 11, 2019 at 10:49:29AM +0100, Russell King - ARM Linux admin wrote:
> > > On Wed, Sep 11, 2019 at 12:46:19PM +0300, Andy Shevchenko wrote:
> > > > On Wed, Sep 11, 2019 at 10:39:14AM +0100, Russell King - ARM Linux admin wrote:
> > > > > On Wed, Sep 11, 2019 at 12:25:14PM +0300, Andy Shevchenko wrote:
> > > > > > On Wed, Sep 11, 2019 at 12:52:08AM -0700, Dmitry Torokhov wrote:
> > > > > > > Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
> > > > > > > the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), bit
> > > > > > > works with arbitrary firmware node.
> > > e > > 
> > > > > > I'm wondering if it's possible to step forward and replace
> > > > > > fwnode_get_gpiod_index by gpiod_get() / gpiod_get_index() here and
> > > > > > in other cases in this series.
> > > > > 
> > > > > No, those require a struct device, but we have none.  There are network
> > > > > drivers where there is a struct device for the network complex, but only
> > > > > DT nodes for the individual network interfaces.  So no, gpiod_* really
> > > > > doesn't work.
> > > > 
> > > > In the following patch the node is derived from struct device. So, I believe
> > > > some cases can be handled differently.

> Referring back to my comment, notice that I said we have none for the
> phylink case, so it's not possible there.
> 
> I'm not sure why Andy replied the way he did, unless he mis-read my
> comment.

It is a first patch which does the change. Mostly my reply was to Dmitry and
your comment clarifies the case with this patch, thanks!

-- 
With Best Regards,
Andy Shevchenko


