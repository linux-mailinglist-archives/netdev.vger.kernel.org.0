Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BEEBFA4C
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfIZTty convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 15:49:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:5188 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbfIZTtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 15:49:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 12:49:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="364909400"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2019 12:49:53 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Sep 2019 12:49:52 -0700
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.221]) by
 FMSMSX153.amr.corp.intel.com ([169.254.9.127]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 12:49:52 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Thread-Topic: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Thread-Index: AQHVdInYTQG+jfjOOUaMtwzDEA3cFqc+rlEA//+gRVA=
Date:   Thu, 26 Sep 2019 19:49:52 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7AC702BEA@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
 <20190926173710.GC14368@unreal>
In-Reply-To: <20190926173710.GC14368@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMTk4ZThjZTctNDk2NS00ODUxLWJhYmYtMGVjMjJmOWI5ZDVmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTG5ObTBXUHczbFUxMUNiUE84bTBiZXN6XC9Icnl2M2UwcENkbmJcL05EQzljbkwxNHZlNm81bGYwcmJoMmtXRU0xIn0=
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

> Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
> 
> On Thu, Sep 26, 2019 at 09:45:11AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Implement device supported verb APIs. The supported APIs vary based on
> > the underlying transport the ibdev is registered as (i.e. iWARP or
> > RoCEv2).
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  drivers/infiniband/hw/irdma/verbs.c      | 4346 ++++++++++++++++++++++
> >  drivers/infiniband/hw/irdma/verbs.h      |  199 +
> >  include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
> >  3 files changed, 4546 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
> >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> >
> > diff --git a/drivers/infiniband/hw/irdma/verbs.c
> > b/drivers/infiniband/hw/irdma/verbs.c
> > new file mode 100644
> > index 000000000000..025c21c722e2
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > @@ -0,0 +1,4346 @@
> > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > +/* Copyright (c) 2019, Intel Corporation. */
> 
> <...>
> 
> > +
> > +	size = sqdepth * sizeof(struct irdma_sq_uk_wr_trk_info) +
> > +	       (rqdepth << 3);
> > +	iwqp->kqp.wrid_mem = kzalloc(size, GFP_KERNEL);
> > +	if (!iwqp->kqp.wrid_mem)
> > +		return -ENOMEM;
> > +
> > +	ukinfo->sq_wrtrk_array = (struct irdma_sq_uk_wr_trk_info *)
> > +				 iwqp->kqp.wrid_mem;
> > +	if (!ukinfo->sq_wrtrk_array)
> > +		return -ENOMEM;
> 
> You are leaking resources here, forgot to do proper error unwinding.
> 

irdma_free_qp_rsrc() will free up that memory in case of an error.
