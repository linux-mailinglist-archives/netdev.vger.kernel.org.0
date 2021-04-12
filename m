Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC235C92E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242133AbhDLOvL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 10:51:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:13047 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240199AbhDLOvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:51:11 -0400
IronPort-SDR: pZZUlTPv/5fkU2hNnfM56lReTAei8WgfsqbXA7krEHkE/0YH5CMGoBAO5akM8wJtNCNfvJorHj
 m0PWApYW3xqQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="194237685"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="194237685"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 07:50:52 -0700
IronPort-SDR: 34tC81c7CaA0/PBVZxJyzPqUgtNFayJHoK4LMdg2R+ww3KoAccjvOG051w+tRCmd3CmE1/hJB/
 fE9Raf3NHmFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="521209362"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 12 Apr 2021 07:50:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:50:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:50:44 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Mon, 12 Apr 2021 07:50:44 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Lacombe, John S" <john.s.lacombe@intel.com>
Subject: RE: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Topic: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Index: AQHXKygiEMWtUC1Uo0mj4KR4ZXyZX6qpqNQA///J7iCAAKscAIABP3oQ
Date:   Mon, 12 Apr 2021 14:50:43 +0000
Message-ID: <2339b8bb35b74aabbb708fcd1a6ab40f@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407154430.GA502757@nvidia.com>
 <1e61169b83ac458aa9357298ecfab846@intel.com>
 <20210407224324.GH282464@nvidia.com>
In-Reply-To: <20210407224324.GH282464@nvidia.com>
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

> Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> 
> On Wed, Apr 07, 2021 at 08:58:49PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> > >
> > > On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:
> > >
> > > > +/* Following APIs are implemented by core PCI driver */ struct
> > > > +iidc_core_ops {
> > > > +	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
> > > > +	 * completion queues, Tx/Rx queues, etc...
> > > > +	 */
> > > > +	int (*alloc_res)(struct iidc_core_dev_info *cdev_info,
> > > > +			 struct iidc_res *res,
> > > > +			 int partial_acceptable);
> > > > +	int (*free_res)(struct iidc_core_dev_info *cdev_info,
> > > > +			struct iidc_res *res);
> > > > +
> > > > +	int (*request_reset)(struct iidc_core_dev_info *cdev_info,
> > > > +			     enum iidc_reset_type reset_type);
> > > > +
> > > > +	int (*update_vport_filter)(struct iidc_core_dev_info *cdev_info,
> > > > +				   u16 vport_id, bool enable);
> > > > +	int (*vc_send)(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8 *msg,
> > > > +		       u16 len);
> > > > +};
> > >
> > > What is this? There is only one implementation:
> > >
> > > static const struct iidc_core_ops ops = {
> > > 	.alloc_res			= ice_cdev_info_alloc_res,
> > > 	.free_res			= ice_cdev_info_free_res,
> > > 	.request_reset			= ice_cdev_info_request_reset,
> > > 	.update_vport_filter		= ice_cdev_info_update_vsi_filter,
> > > 	.vc_send			= ice_cdev_info_vc_send,
> > > };
> > >
> > > So export and call the functions directly.
> >
> > No. Then we end up requiring ice to be loaded even when just want to
> > use irdma with x722 [whose ethernet driver is "i40e"].
> 
> So what? What does it matter to load a few extra kb of modules?

Because it is an unnecessary thing to force a user to build/load drivers for
which they don't have the HW for? The problem gets compounded if we have to
do it for all future HW Intel PCI drivers, i.e. depends on ICE && ....

IIDC is Intel's converged and generic RDMA <--> PCI driver channel interface; which
we intend to use moving forward. And these .ops callbacks are part of this interface which will
have different implementations by each HW generation PCI core driver. It is extensible
with new ops added to the table for new HW and where implementations of the certain ops on some
HW will be NULL.

There is a near-term Intel ethernet VF driver which will use IIDC to provide RDMA in the VF,
and implement some of these .ops callbacks. There is also intent to move i40e to IIDC. 

And yes, it allows to load a unified irdma driver without having all the mulit-gen PCI core drivers to be
built/loaded as a pre-requisite which is solving a pain-point to the user and does not unnecessarily
add a memory foot-print.

In the past, with i40e <-> i40iw, I acknowledge such a dependency was decoupled
for the wrong reasons [1] and understand where your frustration is coming from. But in
a unified irdma driver model connecting to multiple PCI gen drivers, I do think it serves
a reason. This has also been voiced over the years in some of our discussions [2] leading to
the auxiliary bus and been part of our submissions from the get go. In fact, use of such domain
specific .ops from the parent device is an assumption baked into the design when the auxiliary bus
was conceived and in the documentation [3] (See Example Usage).

[1] https://lore.kernel.org/linux-rdma/20180522205612.GD7502@mellanox.com/
[2] https://lore.kernel.org/linux-rdma/2B0E3F215D1AB84DA946C8BEE234CCC97B2E1D29@ORSMSX101.amr.corp.intel.com/
[3] https://www.kernel.org/doc/html/latest/driver-api/auxiliary_bus.html

Shiraz
