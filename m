Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334D1309138
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 02:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhA3BVr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jan 2021 20:21:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:24653 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233066AbhA3BTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 20:19:36 -0500
IronPort-SDR: V+AjJQUEkUti5N0YWfgqkssKVhQMw1k4Rsdn43BQwZ/HtFc3Qxf3IN7pG99uUuHfa8SXffoEXc
 CxVXgZaGoZxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="177942138"
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="177942138"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 17:18:38 -0800
IronPort-SDR: 8gT7A+DUAM5lnwTEX+gzLtmSyRTvcxwj6dNwz6ICzTkFNtS7PQnr+zAUrLh0BUs8xb+LYe9LCI
 9A2HrbwuFxrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="365563152"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jan 2021 17:18:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:18:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:18:37 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Fri, 29 Jan 2021 17:18:37 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 20/22] RDMA/irdma: Add ABI definitions
Thread-Topic: [PATCH 20/22] RDMA/irdma: Add ABI definitions
Thread-Index: AQHW8RlkdRkNgNRDEUiQqAbZnBRzCao5SR2AgAWJrnA=
Date:   Sat, 30 Jan 2021 01:18:36 +0000
Message-ID: <04dcd32fcecd4492900f0bde0e45e5dc@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-21-shiraz.saleem@intel.com>
 <20210125194515.GY4147@nvidia.com>
In-Reply-To: <20210125194515.GY4147@nvidia.com>
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

> Subject: Re: [PATCH 20/22] RDMA/irdma: Add ABI definitions
> 
> On Fri, Jan 22, 2021 at 05:48:25PM -0600, Shiraz Saleem wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add ABI definitions for irdma.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > include/uapi/rdma/irdma-abi.h | 140
> > ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 140 insertions(+)
> >  create mode 100644 include/uapi/rdma/irdma-abi.h
> >
> > diff --git a/include/uapi/rdma/irdma-abi.h
> > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > 0000000..d9c8ce1
> > +++ b/include/uapi/rdma/irdma-abi.h
> > @@ -0,0 +1,140 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR
> > +Linux-OpenIB) */
> > +/*
> > + * Copyright (c) 2006 - 2021 Intel Corporation.  All rights reserved.
> > + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> > + */
> > +
> > +#ifndef IRDMA_ABI_H
> > +#define IRDMA_ABI_H
> > +
> > +#include <linux/types.h>
> > +
> > +/* irdma must support legacy GEN_1 i40iw kernel
> > + * and user-space whose last ABI ver is 5  */ #define IRDMA_ABI_VER 6
> 
> I don't want to see this value increase, either this is ABI compatible with i40iw or it
> is not and should be a new driver_id.

I am not sure I understand how it's possible without a ver. bump.
We support user-space libirdma with this driver as well as libi40iw. 

libi40iw - legacy support which is ABIv 4 & 5. GEN_1 devices only
libirdma - replaces libi40iw; supports i40iw (GEN1) driver and irdma

> 
> This should have a small diff against include/uapi/rdma/i40iw-abi.h that is
> obviously compatible
> 
> > +struct irdma_create_qp_resp {
> > +	__u32 qp_id;
> > +	__u32 actual_sq_size;
> > +	__u32 actual_rq_size;
> > +	__u32 irdma_drv_opt;
> > +	__u32 qp_caps;
> > +	__u16 rsvd1;
> > +	__u8 lsmm;
> > +	__u8 rsvd2;
> > +};
> 
> > +struct i40iw_create_qp_resp {
> > +	__u32 qp_id;
> > +	__u32 actual_sq_size;
> > +	__u32 actual_rq_size;
> > +	__u32 i40iw_drv_opt;
> > +	__u16 push_idx;
> > +	__u8 lsmm;
> > +	__u8 rsvd;
> > +};
> 
> For instance these are almost the same, why put qp_caps in the middle?
> Add it to the end so the whole thing is properly compatible with a single structure.
> 
> Jason
