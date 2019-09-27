Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA5FC078E
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfI0O2q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Sep 2019 10:28:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:7164 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfI0O2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 10:28:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 07:28:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="391180437"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga006.fm.intel.com with ESMTP; 27 Sep 2019 07:28:41 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Sep 2019 07:28:41 -0700
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.221]) by
 FMSMSX155.amr.corp.intel.com ([169.254.5.34]) with mapi id 14.03.0439.000;
 Fri, 27 Sep 2019 07:28:41 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Thread-Topic: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Thread-Index: AQHVdInYTQG+jfjOOUaMtwzDEA3cFqc+rlEA//+gRVCAARvagIAAImIw
Date:   Fri, 27 Sep 2019 14:28:41 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7AC70468F@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
 <20190926173710.GC14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BEA@fmsmsx123.amr.corp.intel.com>
 <20190927045029.GG14368@unreal>
In-Reply-To: <20190927045029.GG14368@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODM3M2EwNzQtNmU2Zi00Y2U5LWJlODctMjE1NGUwMWUzZThiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMTBjWk8zOEpob09oVzZFU3hYVGRnK0UweVFoeG95TzlkbEJ0akc5clNQd0ZFMnVHRGd4RzhvdXBVMGVpeDNzMSJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
> 
> On Thu, Sep 26, 2019 at 07:49:52PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb
> > > APIs
> > >
> > > On Thu, Sep 26, 2019 at 09:45:11AM -0700, Jeff Kirsher wrote:
> > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > >
> > > > Implement device supported verb APIs. The supported APIs vary
> > > > based on the underlying transport the ibdev is registered as (i.e.
> > > > iWARP or RoCEv2).
> > > >
> > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > ---
> > > >  drivers/infiniband/hw/irdma/verbs.c      | 4346 ++++++++++++++++++++++
> > > >  drivers/infiniband/hw/irdma/verbs.h      |  199 +
> > > >  include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
> > > >  3 files changed, 4546 insertions(+)  create mode 100644
> > > > drivers/infiniband/hw/irdma/verbs.c
> > > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> > > >
> > > > diff --git a/drivers/infiniband/hw/irdma/verbs.c
> > > > b/drivers/infiniband/hw/irdma/verbs.c
> > > > new file mode 100644
> > > > index 000000000000..025c21c722e2
> > > > --- /dev/null
> > > > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > > > @@ -0,0 +1,4346 @@
> > > > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > > > +/* Copyright (c) 2019, Intel Corporation. */
> > >
> > > <...>
> > >
> > > > +
> > > > +	size = sqdepth * sizeof(struct irdma_sq_uk_wr_trk_info) +
> > > > +	       (rqdepth << 3);
> > > > +	iwqp->kqp.wrid_mem = kzalloc(size, GFP_KERNEL);
> > > > +	if (!iwqp->kqp.wrid_mem)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	ukinfo->sq_wrtrk_array = (struct irdma_sq_uk_wr_trk_info *)
> > > > +				 iwqp->kqp.wrid_mem;
> > > > +	if (!ukinfo->sq_wrtrk_array)
> > > > +		return -ENOMEM;
> > >
> > > You are leaking resources here, forgot to do proper error unwinding.
> > >
> >
> > irdma_free_qp_rsrc() will free up that memory in case of an error.
> 
> I'm talking about kqp.wrid_mem you allocated a couple of lines above and didn't
> free in case of sq_wrtrk_array allocation failed.
> 
Yes, I am referring to kqp.wrid_mem as well
In case of err, all memory resources setup for
the QP is freed in the common utility irdma_free_qp_rsrc()
including the kqp.wrid_mem.
