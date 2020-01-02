Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E0312E991
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 18:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgABRur convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jan 2020 12:50:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:31106 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgABRur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 12:50:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 09:50:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="231872348"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga002.jf.intel.com with ESMTP; 02 Jan 2020 09:50:46 -0800
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jan 2020 09:50:46 -0800
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.87]) by
 FMSMSX155.amr.corp.intel.com ([169.254.5.244]) with mapi id 14.03.0439.000;
 Thu, 2 Jan 2020 09:50:46 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: RE: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
 i40iw
Thread-Topic: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
 i40iw
Thread-Index: AQHVruL28gEIgb9lXUm9x+ExMCj0FKe15AgAgAJKZ3CABzTwAIAYQRoAgAChPQD//332kA==
Date:   Thu, 2 Jan 2020 17:50:45 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7C1DEF79B@fmsmsx123.amr.corp.intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-20-jeffrey.t.kirsher@intel.com>
 <20191211200200.GA13279@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7B6B9343F@fmsmsx124.amr.corp.intel.com>
 <20191217210406.GC17227@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7C1DEF259@fmsmsx123.amr.corp.intel.com>
 <20200102170426.GA9282@ziepe.ca>
In-Reply-To: <20200102170426.GA9282@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjcxMDNlMjMtZTViMS00NjdmLWE1NjYtZjMwYzYwODAxY2JiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRHVHeUJYR0ZvQUJHdW5BR2MxWnpwdG9CeGhQb1wvV0tEOEdkZVhxYWYrUElySnpUQUUyekd6ejZkNGFNa1NXd1wvIn0=
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

> Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
> i40iw
> 
> On Thu, Jan 02, 2020 at 04:00:37PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and
> > > remove i40iw
> > >
> > >
> > > > >  - The whole cqp_compl_thread thing looks really weird
> > > > What is the concern?
> > >
> > > It looks like an open coded work queue
> > >
> >
> > The cqp_compl_thread is not a work queue in the sense that no work is
> > queued to it. It is a thread that is signaled to check for and handle
> > CQP completion events if present.
> 
> How is that not a work queue? The work is the signal to handle CQP completion
> events.
> 

Yes we could use the work as a signal. But this would mean,
we allocate a work item, initialize it to an 'identical' value,
queue it up and then free it.
Why is this better than using a single kthread that just
wake ups to handle the CQP completion?

