Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464BA357667
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhDGU7D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Apr 2021 16:59:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:61743 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhDGU7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:59:02 -0400
IronPort-SDR: iZnFphsfkZZNeN3BGAvJ/9/xGVr2Vw7k313MWCxgtLria1aKYrRwlxgYOvQwHCpsnEkcdwMylW
 Ig+BoxtMEoFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="193440584"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="193440584"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:58:50 -0700
IronPort-SDR: jZf5jgVsUDNG49mh7O1Bo4E7i/D592hw+KaqL4kbfq4XrqFf1REUIoM8VaXO3IVHeGZ+YcFu/s
 +7ESFNCxvlSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="421867343"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 07 Apr 2021 13:58:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 13:58:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 13:58:49 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Wed, 7 Apr 2021 13:58:49 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Topic: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Index: AQHXKygiEMWtUC1Uo0mj4KR4ZXyZX6qpqNQA///J7iA=
Date:   Wed, 7 Apr 2021 20:58:49 +0000
Message-ID: <1e61169b83ac458aa9357298ecfab846@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407154430.GA502757@nvidia.com>
In-Reply-To: <20210407154430.GA502757@nvidia.com>
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
> On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:
> 
> > +/* Following APIs are implemented by core PCI driver */ struct
> > +iidc_core_ops {
> > +	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
> > +	 * completion queues, Tx/Rx queues, etc...
> > +	 */
> > +	int (*alloc_res)(struct iidc_core_dev_info *cdev_info,
> > +			 struct iidc_res *res,
> > +			 int partial_acceptable);
> > +	int (*free_res)(struct iidc_core_dev_info *cdev_info,
> > +			struct iidc_res *res);
> > +
> > +	int (*request_reset)(struct iidc_core_dev_info *cdev_info,
> > +			     enum iidc_reset_type reset_type);
> > +
> > +	int (*update_vport_filter)(struct iidc_core_dev_info *cdev_info,
> > +				   u16 vport_id, bool enable);
> > +	int (*vc_send)(struct iidc_core_dev_info *cdev_info, u32 vf_id, u8 *msg,
> > +		       u16 len);
> > +};
> 
> What is this? There is only one implementation:
> 
> static const struct iidc_core_ops ops = {
> 	.alloc_res			= ice_cdev_info_alloc_res,
> 	.free_res			= ice_cdev_info_free_res,
> 	.request_reset			= ice_cdev_info_request_reset,
> 	.update_vport_filter		= ice_cdev_info_update_vsi_filter,
> 	.vc_send			= ice_cdev_info_vc_send,
> };
> 
> So export and call the functions directly.

No. Then we end up requiring ice to be loaded even when just want to use irdma with x722 [whose ethernet driver is "i40e"].
This will not allow us to be a unified RDMA driver.

> 
> We just had this very same discussion with Broadcom.

Yes, but they only have a single ethernet driver today I presume.

Here we have a single RDMA driver and 2 ethernet drivers, i40e and ice.

Shiraz
