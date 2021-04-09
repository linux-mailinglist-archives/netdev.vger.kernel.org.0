Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC3B359185
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 03:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhDIBiy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Apr 2021 21:38:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:26354 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhDIBiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 21:38:51 -0400
IronPort-SDR: Gc/6z8d+MitVd4wGqawR6widHEa5X9ZwMV9KbJt05ZtvBWqqU61rzInIi0aoH84a5XOciFAaT0
 L8MB1E8F5g3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="180797208"
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="180797208"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 18:38:38 -0700
IronPort-SDR: Y5ex5MMj4g1rD1ZcgQjZ6ux4YEdidqWECLVbq+k/JCp/aLfiXsaXEBICFuvAF6vchT+w3TKS4k
 Z4/g7UptzWDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="520086833"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 08 Apr 2021 18:38:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 18:38:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 18:38:37 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Thu, 8 Apr 2021 18:38:37 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Topic: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Index: AQHXKygiEMWtUC1Uo0mj4KR4ZXyZX6qpqNQA///J7iCAAKscAIAAjuGAgACXTJA=
Date:   Fri, 9 Apr 2021 01:38:37 +0000
Message-ID: <61852f3ff556421c9fd89edc0ee50417@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407154430.GA502757@nvidia.com>
 <1e61169b83ac458aa9357298ecfab846@intel.com>
 <20210407224324.GH282464@nvidia.com> <YG6tZ/iRFpt3OELK@unreal>
In-Reply-To: <YG6tZ/iRFpt3OELK@unreal>
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
> On Wed, Apr 07, 2021 at 07:43:24PM -0300, Jason Gunthorpe wrote:
> > On Wed, Apr 07, 2021 at 08:58:49PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> > > >
> > > > On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:
> > > >
> > > > > +/* Following APIs are implemented by core PCI driver */ struct
> > > > > +iidc_core_ops {
> > > > > +	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
> > > > > +	 * completion queues, Tx/Rx queues, etc...
> > > > > +	 */
> > > > > +	int (*alloc_res)(struct iidc_core_dev_info *cdev_info,
> > > > > +			 struct iidc_res *res,
> > > > > +			 int partial_acceptable);
> > > > > +	int (*free_res)(struct iidc_core_dev_info *cdev_info,
> > > > > +			struct iidc_res *res);
> > > > > +
> > > > > +	int (*request_reset)(struct iidc_core_dev_info *cdev_info,
> > > > > +			     enum iidc_reset_type reset_type);
> > > > > +
> > > > > +	int (*update_vport_filter)(struct iidc_core_dev_info *cdev_info,
> > > > > +				   u16 vport_id, bool enable);
> > > > > +	int (*vc_send)(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8
> *msg,
> > > > > +		       u16 len);
> > > > > +};
> > > >
> > > > What is this? There is only one implementation:
> > > >
> > > > static const struct iidc_core_ops ops = {
> > > > 	.alloc_res			= ice_cdev_info_alloc_res,
> > > > 	.free_res			= ice_cdev_info_free_res,
> > > > 	.request_reset			= ice_cdev_info_request_reset,
> > > > 	.update_vport_filter		= ice_cdev_info_update_vsi_filter,
> > > > 	.vc_send			= ice_cdev_info_vc_send,
> > > > };
> > > >
> > > > So export and call the functions directly.
> > >
> > > No. Then we end up requiring ice to be loaded even when just want to
> > > use irdma with x722 [whose ethernet driver is "i40e"].
> >
> > So what? What does it matter to load a few extra kb of modules?
> 
> And if user cares about it, he will blacklist that module anyway.
> 
 blacklist ice when you just have an x722 card? How does that solve anything? You wont be able to load irdma then.

Shiraz
