Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9875211EE33
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfLMXGt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Dec 2019 18:06:49 -0500
Received: from mga05.intel.com ([192.55.52.43]:1208 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfLMXGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 18:06:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 15:06:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,311,1571727600"; 
   d="scan'208";a="208606346"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2019 15:06:46 -0800
Received: from fmsmsx163.amr.corp.intel.com (10.18.125.72) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 13 Dec 2019 15:06:45 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.10]) by
 fmsmsx163.amr.corp.intel.com ([169.254.6.237]) with mapi id 14.03.0439.000;
 Fri, 13 Dec 2019 15:06:45 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
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
Thread-Index: AQHVruL28gEIgb9lXUm9x+ExMCj0FKe15AgAgAJKZ3A=
Date:   Fri, 13 Dec 2019 23:06:45 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7B6B9343F@fmsmsx124.amr.corp.intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-20-jeffrey.t.kirsher@intel.com>
 <20191211200200.GA13279@ziepe.ca>
In-Reply-To: <20191211200200.GA13279@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTA3YzM2YTUtZjM0NS00YjBiLTk1ZTctMDAxMWQ2NjQxYTRlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMnlJa0VhTG9qb25kXC84Vzh1UlVSbnM3UERhN1ZOZFU2R2NcLzB0dlZJSDl0Y3NudlhOczNFUXd3QXlCMkhOUTBvIn0=
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
> On Mon, Dec 09, 2019 at 02:49:34PM -0800, Jeff Kirsher wrote:
> > From: Shiraz Saleem <shiraz.saleem@intel.com>
> >
> > Add Kconfig and Makefile to build irdma driver.
> >
> > Remove i40iw driver. irdma is the replacement driver that supports
> > X722.
> 
> I looked through this for a litle while, it is very very big. I'd like some of the other
> people who have sent drivers lately to give it a go over as well..
> 
> A few broad comments
>  - Do not use the 'err1', 'err2', etc labels for goto unwind
>  - Please check all uses of rcu, I could not see why some existed
>  - Use the new rdma mmap api. The whole mmap flow looked wonky to me
Presume your referring to this series?
https://github.com/jgunthorpe/linux/commits/rdma_mmap

At the time it was published, I didn't think it applied to irdma, but rather
benefit those drivers that keyed off an mmap database in their mmap function.

In irdma, there is a doorbell and a push page that are mapped. And the offset
passed in is used to distinguish the 2 (0-for doorbell) and determine the address
to map. Also, in the db scheme, I think there is presumption the mmap comes
down with the key passed back in kernel response struct. For the doorbell page
at least, the mmap in library provider just uses 0.

[....]
>  - New drivers should use the ops->driver_unregister flow
https://www.spinics.net/lists/linux-rdma/msg75466.html
"These APIs are intended to support drivers that exist outside the usual
driver core probe()/remove() callbacks. Normally the driver core will
prevent remove() from running concurrently with probe(), once this safety
is lost drivers need more support to get the locking and lifetimes right."

As per this description, it seems ib_unregister_driver() would be
redundant for irdma to use in module exit? virtbus_driver_unregister
should guarantee the remove() callbacks and ib device unregistration. 
Or did you mean just instrument ops->dealloc_driver?
Surely I am missing something.

[....]
>  - The whole cqp_compl_thread thing looks really weird
What is the concern?

Thanks for the feedback. Will work on it.

Shiraz
