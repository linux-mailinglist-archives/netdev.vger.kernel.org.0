Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F553BFA48
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfIZTtg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 15:49:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:14133 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728625AbfIZTtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 15:49:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 12:49:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="364909327"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2019 12:49:34 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Sep 2019 12:49:33 -0700
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.221]) by
 FMSMSX112.amr.corp.intel.com ([169.254.5.177]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 12:49:33 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [RFC 15/20] RDMA/irdma: Add miscellaneous utility definitions
Thread-Topic: [RFC 15/20] RDMA/irdma: Add miscellaneous utility definitions
Thread-Index: AQHVdInYy/vYjAduBU+8gyjFHj1dw6c+sdkA//+eYfA=
Date:   Thu, 26 Sep 2019 19:49:33 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7AC702BC6@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-16-jeffrey.t.kirsher@intel.com>
 <20190926174948.GE14368@unreal>
In-Reply-To: <20190926174948.GE14368@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDVjNjc1M2EtMmM0My00MmVjLTkzYmUtNWI5NWZhYTUzNWIwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaXNKdXVkY0Q1cnFFS3JzclRkcGRTVTJsS1pRRUpmdm9LYUYwS01PM2g1cVkrUmpQQ0RrQURWY0V0OXg5XC9PY0MifQ==
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

> Subject: Re: [RFC 15/20] RDMA/irdma: Add miscellaneous utility definitions
> 
> On Thu, Sep 26, 2019 at 09:45:14AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add miscellaneous utility functions and headers.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  drivers/infiniband/hw/irdma/osdep.h  |  108 ++
> >  drivers/infiniband/hw/irdma/protos.h |   96 ++
> >  drivers/infiniband/hw/irdma/status.h |   70 +
> >  drivers/infiniband/hw/irdma/utils.c  | 2333
> > ++++++++++++++++++++++++++
> >  4 files changed, 2607 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
> >  create mode 100644 drivers/infiniband/hw/irdma/protos.h
> >  create mode 100644 drivers/infiniband/hw/irdma/status.h
> >  create mode 100644 drivers/infiniband/hw/irdma/utils.c
> >
> > diff --git a/drivers/infiniband/hw/irdma/osdep.h
> > b/drivers/infiniband/hw/irdma/osdep.h
> > new file mode 100644
> > index 000000000000..5885b6fa413d
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/irdma/osdep.h
> > @@ -0,0 +1,108 @@
> > +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> > +/* Copyright (c) 2019, Intel Corporation. */
> > +
> > +#ifndef IRDMA_OSDEP_H
> > +#define IRDMA_OSDEP_H
> > +
> > +#include <linux/version.h>
> > +#include <linux/kernel.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/string.h>
> > +#include <linux/bitops.h>
> > +#include <linux/pci.h>
> > +#include <net/tcp.h>
> > +#include <crypto/hash.h>
> > +/* get readq/writeq support for 32 bit kernels, use the low-first
> > +version */ #include <linux/io-64-nonatomic-lo-hi.h>
> > +
> > +#define MAKEMASK(m, s) ((m) << (s))
> 
> It is a little bit over-macro.
> 

Why is this a problem?
We are not translating any basic kernel construct here.
