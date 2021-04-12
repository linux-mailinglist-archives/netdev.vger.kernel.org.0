Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EF835C932
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242534AbhDLOv1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 10:51:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:5872 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240199AbhDLOv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:51:27 -0400
IronPort-SDR: yB/ejnOqAaisjrAuOxun9WeScIZ8ibucFv1Is2Jao84OKXlys2YQmeYjDQuuKgfQNY5MilLnLb
 sCGnXosrCsyg==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="174305552"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="174305552"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 07:51:09 -0700
IronPort-SDR: 9xgLoaWutoHkbsKsk5VCLeF4FI74Et21DQMrRwTYzk7ucQhpoKsHisxjU0LD3+PpdFcPTQigNg
 V9EjFTU6H+tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="521209430"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 12 Apr 2021 07:50:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:50:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:50:52 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Mon, 12 Apr 2021 07:50:52 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Lacombe, John S" <john.s.lacombe@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v4 05/23] ice: Add devlink params support
Thread-Index: AQHXKyglet/OMpr4HUC3+2oFUaS+kaqpm5SA///RCKCAALIhgIABT5TA
Date:   Mon, 12 Apr 2021 14:50:51 +0000
Message-ID: <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
 <20210407224631.GI282464@nvidia.com>
In-Reply-To: <20210407224631.GI282464@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> 
> On Wed, Apr 07, 2021 at 08:58:25PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> > >
> > > On Tue, Apr 06, 2021 at 04:01:07PM -0500, Shiraz Saleem wrote:
> > > > Add a new generic runtime devlink parameter 'rdma_protocol'
> > > > and use it in ice PCI driver. Configuration changes result in
> > > > unplugging the auxiliary RDMA device and re-plugging it with
> > > > updated values for irdma auxiiary driver to consume at
> > > > drv.probe()
> > > >
> > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > >  .../networking/devlink/devlink-params.rst          |  6 ++
> > > >  Documentation/networking/devlink/ice.rst           | 13 +++
> > > >  drivers/net/ethernet/intel/ice/ice_devlink.c       | 92
> +++++++++++++++++++++-
> > > >  drivers/net/ethernet/intel/ice/ice_devlink.h       |  5 ++
> > > >  drivers/net/ethernet/intel/ice/ice_main.c          |  2 +
> > > >  include/net/devlink.h                              |  4 +
> > > >  net/core/devlink.c                                 |  5 ++
> > > >  7 files changed, 125 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/Documentation/networking/devlink/devlink-params.rst
> > > > b/Documentation/networking/devlink/devlink-params.rst
> > > > index 54c9f10..0b454c3 100644
> > > > +++ b/Documentation/networking/devlink/devlink-params.rst
> > > > @@ -114,3 +114,9 @@ own name.
> > > >         will NACK any attempt of other host to reset the device. This parameter
> > > >         is useful for setups where a device is shared by different hosts, such
> > > >         as multi-host setup.
> > > > +   * - ``rdma_protocol``
> > > > +     - string
> > > > +     - Selects the RDMA protocol selected for multi-protocol devices.
> > > > +        - ``iwarp`` iWARP
> > > > +	- ``roce`` RoCE
> > > > +	- ``ib`` Infiniband
> > >
> > > I'm still not sure this belongs in devlink.
> >
> > I believe you suggested we use devlink for protocol switch.
> 
> Yes, devlink is the right place, but selecting a *single* protocol doesn't seem right,
> or general enough.
> 
> Parav is talking about generic ways to customize the aux devices created and that
> would seem to serve the same function as this.

Is there an RFC or something posted for us to look at?

> 
> > > I know Parav is looking at the general problem of how to customize
> > > what aux devices are created, that may be a better fit for this.
> > >
> > > Can you remove the devlink parts to make progress?
> >
> > It is important since otherwise the customer will have no way to use RoCEv2 on
> this device.
> 
> I'm not saying to not having it eventually, I'm just getting tired of looking at 23
> patches. You can argue it out after
> 

Since this device cannot do concurrent protocols per function,
is having a driver specific devlink to switch between the 2 also a NACK?

There is something similar in another PCI driver.
https://www.kernel.org/doc/html/latest/networking/devlink/qed.html

Can we not adapt to Parav's solution (if it's a good fit) when it becomes available?

Shiraz




