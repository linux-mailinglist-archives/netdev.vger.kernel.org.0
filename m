Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF7357662
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhDGU6A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Apr 2021 16:58:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:7384 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhDGU6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:58:00 -0400
IronPort-SDR: UFx+9ZdaqXgsBrEeXM8TdBR33wamgRdPIp0y7SrIUp4GsuRatU3n+dMBxx8+edze4IN1m75NMh
 icZ157R7luhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="190191507"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="190191507"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:57:49 -0700
IronPort-SDR: fVLd8J2vn5ntl6ZMv1okATtVh8G56197l5s7VNnm6Bzb/CcJf55MM7Ij/2iU3KF44nfE/lc1wT
 3p0Gu9Ay499A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="421866929"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 07 Apr 2021 13:57:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 13:57:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 13:57:47 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Wed, 7 Apr 2021 13:57:47 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH v4 resend 21/23] RDMA/irdma: Add ABI definitions
Thread-Topic: [PATCH v4 resend 21/23] RDMA/irdma: Add ABI definitions
Thread-Index: AQHXK0M5OCiQP5QpKUub4mrB8DCt/6qpotaA///Na3A=
Date:   Wed, 7 Apr 2021 20:57:47 +0000
Message-ID: <7bdafebdab4a423a8c6fecd0684fedbb@intel.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
 <20210407001502.1890-22-shiraz.saleem@intel.com>
 <20210407152349.GA502118@nvidia.com>
In-Reply-To: <20210407152349.GA502118@nvidia.com>
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

> Subject: Re: [PATCH v4 resend 21/23] RDMA/irdma: Add ABI definitions
> 
> On Tue, Apr 06, 2021 at 07:15:00PM -0500, Shiraz Saleem wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add ABI definitions for irdma.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > include/uapi/rdma/irdma-abi.h | 116
> > ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 116 insertions(+)
> >  create mode 100644 include/uapi/rdma/irdma-abi.h
> >
> > diff --git a/include/uapi/rdma/irdma-abi.h
> > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > 0000000..d994b0b
> > +++ b/include/uapi/rdma/irdma-abi.h
> > @@ -0,0 +1,116 @@
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
> > + * and user-space whose last ABI ver is 5  */ #define IRDMA_ABI_VER 5
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
> > +struct irdma_alloc_ucontext_resp {
> > +	__u32 max_pds;
> > +	__u32 max_qps;
> > +	__u32 wq_size; /* size of the WQs (SQ+RQ) in the mmaped area */
> > +	__u8 kernel_ver;
> > +	__u8 rsvd[3];
> 
> So this reserved is to align and for compat with i40iw
> 
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
> 
> But what is this for?
> 
> > +	__u16 max_hw_sq_chunk;
> > +	__u16 rsvd2[11];
> 
> And this?
> 
> Reserved should only be used for alignment reasons.

Understood.

> 
> You saw the other explosive thread with Intel about this topic, right?
> 
> > +struct irdma_mem_reg_req {
> > +	__u16 reg_type; /* Memory, QP or CQ */
> 
> Comment is better to clarify this is an enum irdma_memreg_type, especially since
> it seems to be wrong?
> 
> Why is that enum prefixed with IW_?
> 

Will fix.
