Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC8B35E1BB
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245760AbhDMOlL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 10:41:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:64945 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244991AbhDMOlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:41:08 -0400
IronPort-SDR: W2mXsuixWWvhdN1bCHtAJ9Khzx/x+9qLwrpU46lTJ/2Cmmb+XVkrMm2qbSQZYVeiKGheRaopMf
 Y7rxT+Zk8ZHQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="214906567"
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="214906567"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 07:40:48 -0700
IronPort-SDR: uVgD13d3r1JzyJqyXTokw4qH5N0zyx8CP1qSDt2RvIuJjDOfT57ZUzupgZwJjjBEJKZ5XLMcwB
 SQQIpyxuwV9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="614949878"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 13 Apr 2021 07:40:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 13 Apr 2021 07:40:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 13 Apr 2021 07:40:47 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Tue, 13 Apr 2021 07:40:47 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Parav Pandit <parav@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
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
Thread-Index: AQHXKyglet/OMpr4HUC3+2oFUaS+kaqpm5SA///RCKCAALIhgIABT5TAgAZO+4CAAM18wA==
Date:   Tue, 13 Apr 2021 14:40:47 +0000
Message-ID: <8a7cd11994c2447a926cf2d3e60a019c@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
 <20210407224631.GI282464@nvidia.com>
 <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
 <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
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

> Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
> 
> 
> 
> > From: Saleem, Shiraz <shiraz.saleem@intel.com>
> > Sent: Monday, April 12, 2021 8:21 PM
> >
> > > Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> > >
> > > On Wed, Apr 07, 2021 at 08:58:25PM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> > > > >
> > > > > On Tue, Apr 06, 2021 at 04:01:07PM -0500, Shiraz Saleem wrote:
> > > > > > Add a new generic runtime devlink parameter 'rdma_protocol'
> > > > > > and use it in ice PCI driver. Configuration changes result in
> > > > > > unplugging the auxiliary RDMA device and re-plugging it with
> > > > > > updated values for irdma auxiiary driver to consume at
> > > > > > drv.probe()
> > > > > >
> > > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > >  .../networking/devlink/devlink-params.rst          |  6 ++
> > > > > >  Documentation/networking/devlink/ice.rst           | 13 +++
> > > > > >  drivers/net/ethernet/intel/ice/ice_devlink.c       | 92
> > > +++++++++++++++++++++-
> > > > > >  drivers/net/ethernet/intel/ice/ice_devlink.h       |  5 ++
> > > > > >  drivers/net/ethernet/intel/ice/ice_main.c          |  2 +
> > > > > >  include/net/devlink.h                              |  4 +
> > > > > >  net/core/devlink.c                                 |  5 ++
> > > > > >  7 files changed, 125 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git
> > > > > > a/Documentation/networking/devlink/devlink-params.rst
> > > > > > b/Documentation/networking/devlink/devlink-params.rst
> > > > > > index 54c9f10..0b454c3 100644
> > > > > > +++ b/Documentation/networking/devlink/devlink-params.rst
> > > > > > @@ -114,3 +114,9 @@ own name.
> > > > > >         will NACK any attempt of other host to reset the
> > > > > > device. This
> > parameter
> > > > > >         is useful for setups where a device is shared by
> > > > > > different hosts,
> > such
> > > > > >         as multi-host setup.
> > > > > > +   * - ``rdma_protocol``
> > > > > > +     - string
> > > > > > +     - Selects the RDMA protocol selected for multi-protocol devices.
> > > > > > +        - ``iwarp`` iWARP
> > > > > > +	- ``roce`` RoCE
> > > > > > +	- ``ib`` Infiniband
> > > > >
> > > > > I'm still not sure this belongs in devlink.
> > > >
> > > > I believe you suggested we use devlink for protocol switch.
> > >
> > > Yes, devlink is the right place, but selecting a *single* protocol
> > > doesn't seem right, or general enough.
> > >
> > > Parav is talking about generic ways to customize the aux devices
> > > created and that would seem to serve the same function as this.
> >
> > Is there an RFC or something posted for us to look at?
> I do not have polished RFC content ready yet.
> But coping the full config sequence snippet from the internal draft (changed for ice
> example) here as I like to discuss with you in this context.

Thanks Parav! Some comments below.

> 
> # (1) show auxiliary device types supported by a given devlink device.
> # applies to pci pf,vf,sf. (in general at devlink instance).
> $ devlink dev auxdev show pci/0000:06.00.0
> pci/0000:06.00.0:
>   current:
>     roce eth
>   new:
>   supported:
>     roce eth iwarp
> 
> # (2) enable iwarp and ethernet type of aux devices and disable roce.
> $ devlink dev auxdev set pci/0000:06:00.0 roce off iwarp on
> 
> # (3) now see which aux devices will be enable on next reload.
> $ devlink dev auxdev show pci/0000:06:00.0
> pci/0000:06:00.0:
>   current:
>     roce eth
>   new:
>     eth iwarp
>   supported:
>     roce eth iwarp
> 
> # (4) now reload the device and see which aux devices are created.
> At this point driver undergoes reconfig for removal of roce and adding iwarp.
> $ devlink reload pci/0000:06:00.0

I see this is modeled like devlink resource.

Do we really to need a PCI driver re-init to switch the type of the auxdev hanging off the PCI dev?

Why not just allow the setting to apply dynamically during a 'set' itself with an unplug/plug
of the auxdev with correct type.

Shiraz
