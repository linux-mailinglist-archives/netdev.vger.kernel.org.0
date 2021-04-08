Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86873589F9
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhDHQpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:45:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40804 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhDHQpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:45:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUXm2-00FYeU-QG; Thu, 08 Apr 2021 18:44:54 +0200
Date:   Thu, 8 Apr 2021 18:44:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG8zBgSuFW0tmrYr@lunn.ch>
References: <20210408091543.22369-1-decui@microsoft.com>
 <a44419b3-8ae9-ae42-f1fc-24e308499263@infradead.org>
 <BL0PR2101MB09301FF0A115F3C8D9BEBC7DCA749@BL0PR2101MB0930.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR2101MB09301FF0A115F3C8D9BEBC7DCA749@BL0PR2101MB0930.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > diff --git a/drivers/net/ethernet/microsoft/Kconfig
> > b/drivers/net/ethernet/microsoft/Kconfig
> > > new file mode 100644
> > > index 000000000000..12ef6b581566
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/microsoft/Kconfig
> > > @@ -0,0 +1,30 @@
> > > +#
> > > +# Microsoft Azure network device configuration
> > > +#
> > > +
> > > +config NET_VENDOR_MICROSOFT
> > > +	bool "Microsoft Azure Network Device"
> > 
> > Seems to me that should be generalized, more like:
> > 
> > 	bool "Microsoft Network Devices"
> This device is planned for Azure cloud at this time.
> We will update the wording if things change.

This section is about the Vendor. Broadcom, Marvell, natsemi, toshiba,
etc. Microsoft is the Vendor here and all Microsoft Ethernet drivers
belong here. It does not matter what platform they are for.

       Andrew
