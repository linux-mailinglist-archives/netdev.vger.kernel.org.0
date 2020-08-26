Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17672533CE
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgHZPgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 11:36:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:43743 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgHZPgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 11:36:19 -0400
IronPort-SDR: OvHMd2fob9Hji4lxxdDEjCTIVgZSysLqjB2n7OdYgvS6z+mDzjWYZik/nlAHHC/LnHl9Uf3zTJ
 CtBn5tUaFfEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="155572481"
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="155572481"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 08:36:18 -0700
IronPort-SDR: 4p0QkaxlsUMImWvxCxkAYDt41Q/z5PPZD1KvkG0tC7ROFqd0Csf8PXrL5iFr0xyUCcOAWVrREL
 2BbQy66xY4Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="329266056"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 26 Aug 2020 08:36:17 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kAxER-00Bawg-1O; Wed, 26 Aug 2020 18:20:59 +0300
Date:   Wed, 26 Aug 2020 18:20:59 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH v1] net: phy: leds: Deduplicate link LED trigger
 registration
Message-ID: <20200826152059.GS1891694@smile.fi.intel.com>
References: <20200824170904.60832-1-andriy.shevchenko@linux.intel.com>
 <20200825.074015.165950235545895585.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200825.074015.165950235545895585.davem@davemloft.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 07:40:15AM -0700, David Miller wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date: Mon, 24 Aug 2020 20:09:04 +0300
> 
> > Refactor phy_led_trigger_register() and deduplicate its functionality
> > when registering LED trigger for link.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

My bad... Missed LED_CLASS and saw even something has been built in
drivers/net/ but apparently wasn't enough to get this one compiled.

v2 will fix that.
Thanks!

> This doesn't compile:
> 
>   CC [M]  drivers/net/phy/phy_led_triggers.o
> drivers/net/phy/phy_led_triggers.c: In function ‘phy_led_triggers_register’:
> drivers/net/phy/phy_led_triggers.c:102:38: error: passing argument 2 of ‘phy_led_trigger_register’ from incompatible pointer type [-Werror=incompatible-pointer-types]
>   102 |  err = phy_led_trigger_register(phy, &phy->led_link_trigger, 0, "link");
>       |                                      ^~~~~~~~~~~~~~~~~~~~~~
>       |                                      |
>       |                                      struct phy_led_trigger **
> drivers/net/phy/phy_led_triggers.c:68:33: note: expected ‘struct phy_led_trigger *’ but argument is of type ‘struct phy_led_trigger **’
>    68 |         struct phy_led_trigger *plt,
>       |         ~~~~~~~~~~~~~~~~~~~~~~~~^~~
> 

-- 
With Best Regards,
Andy Shevchenko


