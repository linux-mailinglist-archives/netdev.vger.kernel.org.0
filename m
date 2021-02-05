Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2332931120E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 21:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhBEScy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Feb 2021 13:32:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:30271 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233425AbhBESas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 13:30:48 -0500
IronPort-SDR: r65CiwwIZNTceVn3j8gJb8CBUBxIqOPgZdpaFmZyiwnIz/rbP5hYUM1VEEPgUvVk92sNkDDLht
 co789mVOk1UA==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="168602584"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="168602584"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:12:29 -0800
IronPort-SDR: yBuA5GxZSnIOMcZSJ9ZhBhg0XusNgdWaahklvnntGxw9SXudXabFzSOFDhx2wTgb/rk0XLT4Qp
 GVYSwml+dKQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="393998187"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 05 Feb 2021 12:12:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 12:12:28 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 12:12:28 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Fri, 5 Feb 2021 12:12:28 -0800
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
Thread-Index: AQHW8RlkdRkNgNRDEUiQqAbZnBRzCao5SR2AgAWJrnCABW/2gIADKWiQ
Date:   Fri, 5 Feb 2021 20:12:28 +0000
Message-ID: <95c86ea5f5e94d068e6e0467ccba33a0@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-21-shiraz.saleem@intel.com>
 <20210125194515.GY4147@nvidia.com>
 <04dcd32fcecd4492900f0bde0e45e5dc@intel.com>
 <20210201192121.GQ4247@nvidia.com>
In-Reply-To: <20210201192121.GQ4247@nvidia.com>
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
> On Sat, Jan 30, 2021 at 01:18:36AM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH 20/22] RDMA/irdma: Add ABI definitions
> > >
> > > On Fri, Jan 22, 2021 at 05:48:25PM -0600, Shiraz Saleem wrote:
> > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > >
> > > > Add ABI definitions for irdma.
> > > >
> > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > include/uapi/rdma/irdma-abi.h | 140
> > > > ++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 140 insertions(+)  create mode 100644
> > > > include/uapi/rdma/irdma-abi.h
> > > >
> > > > diff --git a/include/uapi/rdma/irdma-abi.h
> > > > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > > > 0000000..d9c8ce1
> > > > +++ b/include/uapi/rdma/irdma-abi.h
> > > > @@ -0,0 +1,140 @@
> > > > +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR
> > > > +Linux-OpenIB) */
> > > > +/*
> > > > + * Copyright (c) 2006 - 2021 Intel Corporation.  All rights reserved.
> > > > + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> > > > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > > > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> > > > + */
> > > > +
> > > > +#ifndef IRDMA_ABI_H
> > > > +#define IRDMA_ABI_H
> > > > +
> > > > +#include <linux/types.h>
> > > > +
> > > > +/* irdma must support legacy GEN_1 i40iw kernel
> > > > + * and user-space whose last ABI ver is 5  */ #define
> > > > +IRDMA_ABI_VER 6
> > >
> > > I don't want to see this value increase, either this is ABI
> > > compatible with i40iw or it is not and should be a new driver_id.
> >
> > I am not sure I understand how it's possible without a ver. bump.
> > We support user-space libirdma with this driver as well as libi40iw.
> 
> Well, start by not making gratuitous changes to the structure layouts and then ask
> how to handle what you have left over.
> 

Took a while but following now. We ll PoC and see how this shapes out. Thanks! 
