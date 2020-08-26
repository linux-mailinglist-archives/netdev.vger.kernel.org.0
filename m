Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87CB2533C9
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 17:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgHZPem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 11:34:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:39603 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgHZPek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 11:34:40 -0400
IronPort-SDR: JEUcXh4RdGRK7ew+bzXUHHwohoZKHUIEUN8p0NgpDawgaDB8l8e0Gpj2lp7ghK7Z/Zo2cJZ1eS
 RpTfhRBzX1gw==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="220570118"
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="220570118"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 08:34:40 -0700
IronPort-SDR: Pv89IEWyYtSikfxkdvHdAzvYoScd//ZpCUABwnfJfyNING718wd5yxca7sFFTAXsHQV7PbXn1l
 EVYslzf+8GIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="329265570"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 26 Aug 2020 08:34:38 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kAxEw-00Bax6-RX; Wed, 26 Aug 2020 18:21:30 +0300
Date:   Wed, 26 Aug 2020 18:21:30 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1] net: phy: leds: Deduplicate link LED trigger
 registration
Message-ID: <20200826152130.GT1891694@smile.fi.intel.com>
References: <20200824170904.60832-1-andriy.shevchenko@linux.intel.com>
 <20200824174558.GJ2403519@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824174558.GJ2403519@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 07:45:58PM +0200, Andrew Lunn wrote:
> On Mon, Aug 24, 2020 at 08:09:04PM +0300, Andy Shevchenko wrote:
> > Refactor phy_led_trigger_register() and deduplicate its functionality
> > when registering LED trigger for link.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks!

> Hi Andy
> 
> Please take a look at https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

Anything particular? I suspect you want me to put net-next prefix...

-- 
With Best Regards,
Andy Shevchenko


