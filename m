Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8DA6121D
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 18:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfGFQPW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 6 Jul 2019 12:15:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:61174 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfGFQPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jul 2019 12:15:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 09:15:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,459,1557212400"; 
   d="scan'208";a="165071593"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jul 2019 09:15:20 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 6 Jul 2019 09:15:20 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.213]) by
 fmsmsx158.amr.corp.intel.com ([169.254.15.188]) with mapi id 14.03.0439.000;
 Sat, 6 Jul 2019 09:15:20 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "Ertman, David M" <david.m.ertman@intel.com>
Subject: RE: [rdma 14/16] RDMA/irdma: Add ABI definitions
Thread-Topic: [rdma 14/16] RDMA/irdma: Add ABI definitions
Thread-Index: AQHVMg3zRd8VsRoltkutexKRUKIO/aa6iLSAgABOBQCAAWQucIAAgTaAgAEIy0A=
Date:   Sat, 6 Jul 2019 16:15:20 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A68512AA@fmsmsx124.amr.corp.intel.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
 <20190704021259.15489-16-jeffrey.t.kirsher@intel.com>
 <20190704074021.GH4727@mtr-leonro.mtl.com>
 <20190704121933.GD3401@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7A684DAAA@fmsmsx124.amr.corp.intel.com>
 <20190705171650.GI31525@mellanox.com>
In-Reply-To: <20190705171650.GI31525@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMWQ0YjdjYTQtZWY1Ni00NjcxLWE4NmEtNTAwOTBkNzBmYWViIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMmhhYW5PNnphWlZcL0V3XC9PeEpXbFwvTWtFazFTdUJRejhiUGtPMlBub3FYNEpIZ3o4SzVzY0h4a2JUazZGcVNBTCJ9
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> 
> On Fri, Jul 05, 2019 at 04:42:19PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> > >
> > > On Thu, Jul 04, 2019 at 10:40:21AM +0300, Leon Romanovsky wrote:
> > > > On Wed, Jul 03, 2019 at 07:12:57PM -0700, Jeff Kirsher wrote:
> > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > >
> > > > > Add ABI definitions for irdma.
> > > > >
> > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > include/uapi/rdma/irdma-abi.h | 130
> > > > > ++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 130 insertions(+)  create mode 100644
> > > > > include/uapi/rdma/irdma-abi.h
> > > > >
> > > > > diff --git a/include/uapi/rdma/irdma-abi.h
> > > > > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > > > > 000000000000..bdfbda4c829e
> > > > > +++ b/include/uapi/rdma/irdma-abi.h
> > > > > @@ -0,0 +1,130 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> > > > > +/* Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserved.
> > > > > + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> > > > > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > > > > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> > > > > + */
> > > > > +
> > > > > +#ifndef IRDMA_ABI_H
> > > > > +#define IRDMA_ABI_H
> > > > > +
> > > > > +#include <linux/types.h>
> > > > > +
> > > > > +/* irdma must support legacy GEN_1 i40iw kernel
> > > > > + * and user-space whose last ABI ver is 5  */ #define
> > > > > +IRDMA_ABI_VER
> > > > > +6
> > > >
> > > > Can you please elaborate about it more?
> > > > There is no irdma code in RDMA yet, so it makes me wonder why new
> > > > define shouldn't start from 1.
> > >
> > > It is because they are ABI compatible with the current user space,
> > > which raises the question why we even have this confusing header file..
> >
> > It is because we need to support current providers/i40iw user-space.
> > Our user-space patch series will introduce a new provider (irdma)
> > whose ABI ver. is also 6 (capable of supporting X722 and which will
> > work with i40iw driver on older kernels) and removes providers/i40iw from rdma-
> core.
> 
> Why on earth would we do that?
> 
A unified library providers/irdma to go in hand with the driver irdma and uses the ABI header.
It can support the new network device e810 and existing x722 iWARP device. It obsoletes
providers/i40iw and extends its ABI. So why keep providers/i40iw around in rdma-core?

Shiraz 

