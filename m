Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23021E3519
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgE0B6E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 21:58:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:46894 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgE0B6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:58:03 -0400
IronPort-SDR: 3L+qYZ0E7pflgVGqGS8iskkI2Or+jZrAMifE20uuiRndxK0NKNqUkurKZd2Il81WdQPOElFngR
 98vlk3BUXpVg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 18:58:02 -0700
IronPort-SDR: ijwinUpFICZozJu/U7i7bQS5xSSi8DncGSvingo3CCwVpEC5+3BEPyGUg7q8BVDkX29Mv3r5/x
 3BhSvJTDLjQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="256629165"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga008.fm.intel.com with ESMTP; 26 May 2020 18:58:02 -0700
Received: from fmsmsx123.amr.corp.intel.com (10.18.125.38) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 18:58:02 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.63]) by
 fmsmsx123.amr.corp.intel.com ([169.254.7.123]) with mapi id 14.03.0439.000;
 Tue, 26 May 2020 18:58:02 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>
Subject: RE: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
Thread-Topic: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
Thread-Index: AQHWL3n2Pw6kzLOq1Ui4t0VQsTHX2qi6bFjA
Date:   Wed, 27 May 2020 01:58:01 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7EE04047F@fmsmsx124.amr.corp.intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200521141247.GQ24561@mellanox.com>
In-Reply-To: <20200521141247.GQ24561@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
> 
> On Wed, May 20, 2020 at 12:03:59AM -0700, Jeff Kirsher wrote:
> > This patch set adds a unified Intel Ethernet Protocol Driver for RDMA
> > that supports a new network device E810 (iWARP and RoCEv2 capable) and
> > the existing X722 iWARP device. The driver architecture provides the
> > extensibility for future generations of Intel HW supporting RDMA.
> >
> > This driver replaces the legacy X722 driver i40iw and extends the ABI
> > already defined for i40iw. It is backward compatible with legacy X722
> > rdma-core provider (libi40iw).
> >
> > This series was built against the rdma for-next branch.  This series
> > is dependant upon the v4 100GbE Intel Wired LAN Driver Updates
> > 2020-05-19
> > 12 patch series, which adds virtual_bus interface and ice/i40e LAN
> > driver changes.
> >
> > v5-->v6:
> > *Convert irdma destroy QP to a synchronous API *Drop HMC obj macros
> > for use counts like IRDMA_INC_SD_REFCNT et al.
> > *cleanup unneccesary 'mem' variable in irdma_create_qp *cleanup unused
> > headers such as linux/moduleparam.h et. al *set kernel_ver in
> > irdma_ualloc_resp struct to current ABI ver. Placeholder to  support
> > user-space compatbility checks in future *GENMASK/FIELD_PREP scheme to
> > set WQE descriptor fields considered for irdma  driver but decision to
> > drop. The FIELD_PREP macro cannot be used on the device  bitfield mask
> > array maintained for common WQE descriptors and initialized  based on
> > HW generation. The macro expects compile time constants only.
> 
> The request was to use GENMASK for the #define constants. If you move to a
> code environment then the spot the constant appears in the C code should be
> FIELD_PREP'd into the something dynamic code can use.
>

Maybe I am missing something here, but from what I understood,
the vantage point of using GENMASK for the masks
was so that we could get rid of open coding the shift constants and use the
FIELD_PREP macro to place the value in the field of a descriptor.
This should work for the static masks. So something like --

-#define IRDMA_UDA_QPSQ_INLINEDATALEN_S 48
-#define IRDMA_UDA_QPSQ_INLINEDATALEN_M \
-       ((u64)0xff << IRDMA_UDA_QPSQ_INLINEDATALEN_S)
+#define IRDMA_UDA_QPSQ_INLINEDATALEN_M GENMASK_ULL(55, 48)

-#define LS_64(val, field)      (((u64)(val) << field ## _S) & (field ## _M))
+#define LS_64(val, field)      (FIELD_PREP(val,(field ## _M)))

However we have device's dynamically computed bitfield mask array and shifts
for some WQE descriptor fields --
see icrdma_init_hw.c
https://lore.kernel.org/linux-rdma/20200520070415.3392210-3-jeffrey.t.kirsher@intel.com/#Z30drivers:infiniband:hw:irdma:icrdma_hw.c

we still need to use the custom macro FLD_LS_64 without FIELD_PREP in this case
as FIELD_PREP expects compile time constants.
+#define FLD_LS_64(dev, val, field)	\
+	(((u64)(val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field 
+## _M])
And the shifts are still required for these fields which causes a bit of
inconsistency



