Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748F91B514F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDWAdF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 20:33:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:37228 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgDWAdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 20:33:05 -0400
IronPort-SDR: NxhMtxUK3DSRCv0a9furjiqwig95Thl4iTJyWYtOmoDwvGkMIe5MQ1TA0uSZq/6soxeQTc9BLx
 8QiYcPN6Fubw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 17:33:04 -0700
IronPort-SDR: nfkGmtoxHtrLVANLdhhRvcF9FJy8FqSDe5Zeusy0ck9RapY1t2xtbVCOMjTO8SXaliDCFb8rz6
 aVsIeEquYA8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="244692979"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga007.jf.intel.com with ESMTP; 22 Apr 2020 17:33:04 -0700
Received: from fmsmsx114.amr.corp.intel.com (10.18.116.8) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Apr 2020 17:32:49 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 FMSMSX114.amr.corp.intel.com ([169.254.6.13]) with mapi id 14.03.0439.000;
 Wed, 22 Apr 2020 17:32:48 -0700
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
Thread-Index: AQHWFNtu4ugEuh6AnUe8PZpOjYV9PKh+KgSAgAPqlNCAASOfAIAAk97AgACTTgD//+mbEA==
Date:   Thu, 23 Apr 2020 00:32:48 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD4DB92@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
 <20200421004628.GQ26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
 <20200421182256.GT26002@ziepe.ca>
In-Reply-To: <20200421182256.GT26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
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
> On Tue, Apr 21, 2020 at 06:19:07PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > > definitions
> > >
> > > On Tue, Apr 21, 2020 at 12:23:45AM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver
> > > > > framework definitions
> > > > >
> > > > > On Fri, Apr 17, 2020 at 10:12:36AM -0700, Jeff Kirsher wrote:
> > > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > >
> > > > > > Register irdma as a virtbus driver capable of supporting
> > > > > > virtbus devices from multi-generation RDMA capable Intel HW.
> > > > > > Establish the interface with all supported netdev peer drivers and
> initialize HW.
> > > > > >
> > > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > > drivers/infiniband/hw/irdma/i40iw_if.c | 228 ++++++++++
> > > > > > drivers/infiniband/hw/irdma/irdma_if.c | 449 ++++++++++++++++++
> > > > > >  drivers/infiniband/hw/irdma/main.c     | 573
> +++++++++++++++++++++++
> > > > > >  drivers/infiniband/hw/irdma/main.h     | 599
> > > +++++++++++++++++++++++++
> > > > > >  4 files changed, 1849 insertions(+)  create mode 100644
> > > > > > drivers/infiniband/hw/irdma/i40iw_if.c
> > > > > >  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
> > > > > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > > > > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > > > > >
> > > > >
> > > > > I didn't look in too much details, but three things caught my
> > > > > attention
> > > immediately:
> > > > > 1. Existence of ARP cache management logic in RDMA driver.
> > > >
> > > > Our HW has an independent ARP table for the rdma block.
> > > > driver needs to add an ARP table entry via an rdma admin queue
> > > > command before QP transitions to RTS.
> > > >
> > > > > 2. Extensive use of dev_*() prints while we have ibdev_*()
> > > > > prints
> > > > The ib device object is not available till the end of the device
> > > > init similarly its unavailable early on in device deinit flows. So
> > > > dev_* is all we can use in those places.
> > >
> > > hns guys were thinking about changing this. It looks fine to just
> > > move the name assignment to the device allocation, then we don't
> > > have this weirdness
> >
> > Did you mean moving name setting from ib_register_device to ib_device_alloc?
> > Will that work ok for how rvt is handling the names in
> > rvt_set_ibdev_name and its register?
> 
> I don't see why not? rvt_set_ibdev_name is always directly after rvt_alloc_device,
> which is the thing that calls ib_alloc_device
> 
> > This could migrate a lot of the dev_* to ibdev_* but there is still
> > going to be a handful of dev_* usages from our HW initialization in
> > irdma_prob_dev since ib device allocation is done in irdma_open.
> 
> Don't do that?

we have a split initialization design for gen2 and future products.
phase1 is control path resource initialization in irdma_probe_dev
and phase-2 is the rest of the resources with the ib registration
at the end of irdma_open. irdma_close must de-register the ib device
which will take care of ibdev free too. So it makes sense to keep
allocation of the ib device in irdma_open.

Is it so bad to use dev_* prints for a few of those init stuff in
irdma_probe_dev when ib device is unavailable? Isnt that what all drivers
are expected to do? similar to the rule of using dev_* when struct device
object is available, otherwise pr_*

> 
> > > Alternatively, you could do as netdev does and have a special name
> > > string when the name is NULL
> >
> > Not sure I found what your referring to.
> > Did you mean similar to use of netdev_name in __netdev_printk?
> 
> Yes
 
OK. Thanks!
