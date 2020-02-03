Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F44F15034D
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 10:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgBCJWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 04:22:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:60194 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgBCJWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 04:22:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 01:22:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,397,1574150400"; 
   d="scan'208";a="263351396"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga002.fm.intel.com with ESMTP; 03 Feb 2020 01:22:45 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1iyXwM-0004Pw-8z; Mon, 03 Feb 2020 11:22:46 +0200
Date:   Mon, 3 Feb 2020 11:22:46 +0200
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Matteo Croce <mcroce@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 4/7] device property: fwnode_get_phy_mode: Change API
 to solve int/unit warnings
Message-ID: <20200203092246.GX32742@smile.fi.intel.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-5-calvin.johnson@nxp.com>
 <CAHp75Vdnz79NiHs5MfxAevzOuk-A6ESHR+Epoym+v3Qo4XPvLw@mail.gmail.com>
 <AM0PR04MB5636C44D0943B7E5F01218DF93000@AM0PR04MB5636.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB5636C44D0943B7E5F01218DF93000@AM0PR04MB5636.eurprd04.prod.outlook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 03, 2020 at 09:13:42AM +0000, Calvin Johnson (OSS) wrote:
> > -----Original Message-----
> > From: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Subject: Re: [PATCH v1 4/7] device property: fwnode_get_phy_mode:
> > Change API to solve int/unit warnings
> > 
> > On Fri, Jan 31, 2020 at 5:38 PM Calvin Johnson <calvin.johnson@nxp.com>
> > wrote:
> > >
> > > From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > >
> > > API fwnode_get_phy_mode is modified to follow the changes made by
> > > Commit 0c65b2b90d13c1 ("net: of_get_phy_mode: Change API to solve
> > > int/unit warnings").
> > 
> > I think it would be good to base your series on Dan's fix patch.
> 
> This patch is based on Dan's fix patch https://www.spinics.net/lists/netdev/msg606487.html .
> Commit 0c65b2b90d13c1 ("net: of_get_phy_mode: Change API to solve int/unit warnings").
> Can you please give more clarity on what you meant? Please point to me, if there is some 
> specific patch that you are referring to.

Ah, sorry, I meant the "device property: change device_get_phy_mode() to
prevent signedess bugs" [1]. It fixes some PHY initialization issues with the
existing code (thus, should be backported).

[1]: https://lkml.org/lkml/2020/1/31/1

-- 
With Best Regards,
Andy Shevchenko


