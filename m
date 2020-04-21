Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6478E1B1AB4
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgDUA3T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 20:29:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:42971 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDUA3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 20:29:19 -0400
IronPort-SDR: RIDOzg6tBNtIqymTEjmtCHlzHCqG45p6d9bbS0oMc08Fak1y12ku9m0VFsdrdRZiYCTsO+fieK
 oUV2/Is8PqzA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 17:29:18 -0700
IronPort-SDR: GFrU2bphq8fbbyieWo/xF3lssZFlz5ivxT1aiwnxQjFJCMBZJMj13VEpH6y8jRU6gLTzQCmckc
 UoQNNBvAvyWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="258527808"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2020 17:29:16 -0700
Received: from fmsmsx157.amr.corp.intel.com (10.18.116.73) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 17:29:16 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 FMSMSX157.amr.corp.intel.com ([169.254.14.45]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 17:29:15 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 14/16] RDMA/irdma: Add ABI definitions
Thread-Topic: [RFC PATCH v5 14/16] RDMA/irdma: Add ABI definitions
Thread-Index: AQHWFNtzJfrlc+cOi0iSpR8LbIFurKh+LG8AgAQMx1A=
Date:   Tue, 21 Apr 2020 00:29:15 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD485D1@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-15-jeffrey.t.kirsher@intel.com>
 <20200417194300.GC3083@unreal>
In-Reply-To: <20200417194300.GC3083@unreal>
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

> Subject: Re: [RFC PATCH v5 14/16] RDMA/irdma: Add ABI definitions
> 
> On Fri, Apr 17, 2020 at 10:12:49AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add ABI definitions for irdma.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  include/uapi/rdma/irdma-abi.h | 140
> > ++++++++++++++++++++++++++++++++++
> >  1 file changed, 140 insertions(+)
> >  create mode 100644 include/uapi/rdma/irdma-abi.h
> >
> > diff --git a/include/uapi/rdma/irdma-abi.h
> > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > 000000000000..2eb253220161
> > --- /dev/null
> > +++ b/include/uapi/rdma/irdma-abi.h
> > @@ -0,0 +1,140 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR
> > +Linux-OpenIB) */
> > +/*
> > + * Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserved.
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
> > +
> > +enum irdma_memreg_type {
> > +	IW_MEMREG_TYPE_MEM  = 0,
> > +	IW_MEMREG_TYPE_QP   = 1,
> > +	IW_MEMREG_TYPE_CQ   = 2,
> > +	IW_MEMREG_TYPE_RSVD = 3,
> > +	IW_MEMREG_TYPE_MW   = 4,
> > +};
> > +
> > +struct irdma_alloc_ucontext_req {
> > +	__u32 rsvd32;
> > +	__u8 userspace_ver;
> > +	__u8 rsvd8[3];
> > +};
> > +
> > +struct i40iw_alloc_ucontext_req {
> > +	__u32 rsvd32;
> > +	__u8 userspace_ver;
> > +	__u8 rsvd8[3];
> > +};
> > +
> > +struct irdma_alloc_ucontext_resp {
> > +	__aligned_u64 feature_flags;
> > +	__aligned_u64 db_mmap_key;
> > +	__u32 max_hw_wq_frags;
> > +	__u32 max_hw_read_sges;
> > +	__u32 max_hw_inline;
> > +	__u32 max_hw_rq_quanta;
> > +	__u32 max_hw_wq_quanta;
> > +	__u32 min_hw_cq_size;
> > +	__u32 max_hw_cq_size;
> > +	__u32 rsvd1[7];
> > +	__u16 max_hw_sq_chunk;
> > +	__u16 rsvd2[11];
> > +	__u8 kernel_ver;
> 
> Why do you need to copy this kernel_ver from i40iw?
> Especially given the fact that i40iw didn't use it too much
>  120 static int i40iw_alloc_ucontext(struct ib_ucontext *uctx,
>  121                                 struct ib_udata *udata)
>  <...>
>  140         uresp.kernel_ver = req.userspace_ver;
> 
Its used to pass the current driver ABI ver. to user-space so that
there is compatibility check in user-space as well.
for example: old i40iw user-space provider wont bind to gen_2 devices
by checking the kernel_ver and finding its incompatible. It will bind with
gen_1 devices though..
 
