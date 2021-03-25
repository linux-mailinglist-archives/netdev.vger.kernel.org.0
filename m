Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B17349ADB
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 21:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhCYUKm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Mar 2021 16:10:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:6571 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhCYUKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 16:10:16 -0400
IronPort-SDR: tuB3piw9glqmKkxo/A9cs6K+ezQVx4NGpUD29zFikFej6fiHTC/uQC9F6jZcEzaVh7NOzylcOy
 DCIlE8TEtSCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="178133054"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="178133054"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 13:10:14 -0700
IronPort-SDR: 3zfTNcpwKghnNrjL+Kt/vZtPoWveCvgZtMCd6fLp+gWMfyL3VlU3t5pFUNnVUBZRjVoR3yovxA
 AZDbnDCquy0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="375211688"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 13:10:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 13:10:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 13:10:13 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Thu, 25 Mar 2021 13:10:13 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Parav Pandit <parav@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v2 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v2 05/23] ice: Add devlink params support
Thread-Index: AQHXIEEcbZGM34aJmkKTShEWbKmaC6qTB12AgAH624A=
Date:   Thu, 25 Mar 2021 20:10:13 +0000
Message-ID: <9ae54c8e60fe4036bd3016cfa0798dac@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-6-shiraz.saleem@intel.com>
 <BY5PR12MB43228B823CA619460AAF2099DC639@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43228B823CA619460AAF2099DC639@BY5PR12MB4322.namprd12.prod.outlook.com>
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

> Subject: RE: [PATCH v2 05/23] ice: Add devlink params support
> 
> Hi Shiraz,
> 
> > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > Sent: Wednesday, March 24, 2021 5:30 AM
> >
> > Add two new runtime RDMA related devlink parameters to ice driver.
> > 'rdma_resource_limits_sel' is driver-specific while 'rdma_protocol' is generic.
> > Configuration changes result in unplugging the auxiliary RDMA device
> > and re- plugging it with updated values for irdma auxiiary driver to
> > consume at
> > drv.probe()
> >
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  .../networking/devlink/devlink-params.rst          |   6 +
> >  Documentation/networking/devlink/ice.rst           |  35 +++++
> >  drivers/net/ethernet/intel/ice/ice_devlink.c       | 146
> > ++++++++++++++++++++-
> >  drivers/net/ethernet/intel/ice/ice_devlink.h       |   6 +
> >  drivers/net/ethernet/intel/ice/ice_main.c          |   2 +
> >  include/net/devlink.h                              |   4 +
> >  net/core/devlink.c                                 |   5 +
> >  7 files changed, 202 insertions(+), 2 deletions(-)
> >
> 
> [..]
> > +.. list-table:: Driver-specific parameters implemented
> > +   :widths: 5 5 5 85
> > +
> > +   * - Name
> > +     - Type
> > +     - Mode
> > +     - Description
> > +   * - ``rdma_resource_limits_sel``
> > +     - string
> > +     - runtime
> > +     - Selector to limit the RDMA resources configured for the
> > + device. The
> > range
> > +       is between 0 and 7 with a default value equal to 3. Each
> > + selector
> > supports
> > +       up to the value specified in the table.
> > +          - 0: 128 QPs
> > +          - 1: 1K QPs
> > +          - 2: 2K QPs
> > +          - 3: 4K QPs
> > +          - 4: 16K QPs
> > +          - 5: 64K QPs
> > +          - 6: 128K QPs
> > +          - 7: 256K QPs
> 
> Resources are better represented as devlink resource.
> Such as,
> 
> $ devlink resource set pci/0000:06:00.0 /rdma/max_qps 16384 $ devlink resource
> set pci/0000:06:00.0 /rdma/max_cqs 8192 $ devlink resource set pci/0000:06:00.0
> /rdma/max_mrs 16384
> 

Hi Parav - Thank you for the feedback.

Maybe I am missing something but I see that a devlink hot reload is required to enforce the update?
There isn't really a de-init required of PCI driver entities in this case for this rdma param.
But only an unplug, plug of the auxdev with new value. Intuitively it feels more runtime-ish.

There is also a device powerof2 requirement on the maxqp which I don't see enforceable as it stands.

This is not super-critical for the initial submission but a nice to have. But I do want to brainstorm options.. 

Shiraz
