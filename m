Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4AB1B2EE4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgDUSTK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 14:19:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:31362 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDUSTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 14:19:09 -0400
IronPort-SDR: 3aSFHUG9/6LdmgXiPzF/Zy4PjEmo58ukJyvCi1Cczz3CZuqp6EzywVNAD8tB8L7dk0oEgNqRzF
 dYJ6SwW/n5aw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 11:19:08 -0700
IronPort-SDR: iStkaU/kMMZL+66F3ELUhcNNYH+kYeaxlCMkdWywj9mJwrKyIyZMEeAAUG/GjjM4szn1Zy9Eds
 gDzI3uzv2K5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="258794871"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2020 11:19:08 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 11:19:08 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 fmsmsx115.amr.corp.intel.com ([169.254.4.151]) with mapi id 14.03.0439.000;
 Tue, 21 Apr 2020 11:19:08 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Topic: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHWFNtu4ugEuh6AnUe8PZpOjYV9PKh+KgSAgAPqlNCAASOfAIAAk97A
Date:   Tue, 21 Apr 2020 18:19:07 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
 <20200421004628.GQ26002@ziepe.ca>
In-Reply-To: <20200421004628.GQ26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> definitions
> 
> On Tue, Apr 21, 2020 at 12:23:45AM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > > definitions
> > >
> > > On Fri, Apr 17, 2020 at 10:12:36AM -0700, Jeff Kirsher wrote:
> > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > >
> > > > Register irdma as a virtbus driver capable of supporting virtbus
> > > > devices from multi-generation RDMA capable Intel HW. Establish the
> > > > interface with all supported netdev peer drivers and initialize HW.
> > > >
> > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > drivers/infiniband/hw/irdma/i40iw_if.c | 228 ++++++++++
> > > > drivers/infiniband/hw/irdma/irdma_if.c | 449 ++++++++++++++++++
> > > >  drivers/infiniband/hw/irdma/main.c     | 573 +++++++++++++++++++++++
> > > >  drivers/infiniband/hw/irdma/main.h     | 599
> +++++++++++++++++++++++++
> > > >  4 files changed, 1849 insertions(+)  create mode 100644
> > > > drivers/infiniband/hw/irdma/i40iw_if.c
> > > >  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
> > > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > > >
> > >
> > > I didn't look in too much details, but three things caught my attention
> immediately:
> > > 1. Existence of ARP cache management logic in RDMA driver.
> >
> > Our HW has an independent ARP table for the rdma block.
> > driver needs to add an ARP table entry via an rdma admin queue command
> > before QP transitions to RTS.
> >
> > > 2. Extensive use of dev_*() prints while we have ibdev_*() prints
> > The ib device object is not available till the end of the device init
> > similarly its unavailable early on in device deinit flows. So dev_* is
> > all we can use in those places.
> 
> hns guys were thinking about changing this. It looks fine to just move the name
> assignment to the device allocation, then we don't have this weirdness

Did you mean moving name setting from ib_register_device to ib_device_alloc?
Will that work ok for how rvt is handling the names in rvt_set_ibdev_name
and its register?

This could migrate a lot of the dev_* to ibdev_* but there is still going to be a handful of
dev_* usages from our HW initialization in irdma_prob_dev since ib device allocation is
done in irdma_open.

> 
> Alternatively, you could do as netdev does and have a special name string when
> the name is NULL

Not sure I found what your referring to. 
Did you mean similar to use of netdev_name in __netdev_printk?

> 
> Either way, I feel like this should be fixed up it is very fragile to have two different
> print functions running around.
> 
> Jason
