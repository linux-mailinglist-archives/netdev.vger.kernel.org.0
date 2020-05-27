Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBCF1E351B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgE0B6S convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 21:58:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:42453 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgE0B6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:58:17 -0400
IronPort-SDR: Kq8UoDe6XBdkxdmWsf+/KM2iqE/L5Va9h4BvhKhGvj1Wgfrm4UkvEsNnAM7kuep6UBuEo92lAE
 JmRduhrcwahA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 18:58:15 -0700
IronPort-SDR: kO8DgwYAnOXEUG6uUR4yAuO/vUZgV2TkTww45f0ZARNJdwQkTcdFePzkJDcKCNTKiWQinwDj5F
 OipSJ1BMk0dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="255329106"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga007.fm.intel.com with ESMTP; 26 May 2020 18:58:14 -0700
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 18:58:14 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.63]) by
 fmsmsx121.amr.corp.intel.com ([169.254.6.200]) with mapi id 14.03.0439.000;
 Tue, 26 May 2020 18:58:14 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Gal Pressman <galpress@amazon.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>
Subject: RE: [RDMA RFC v6 14/16] RDMA/irdma: Add ABI definitions
Thread-Topic: [RDMA RFC v6 14/16] RDMA/irdma: Add ABI definitions
Thread-Index: AQHWLnTlGG6NNW3f40WB1AVnR6pJe6ixEDGAgAAQOACAAALUgIAAPAcAgAHmhsA=
Date:   Wed, 27 May 2020 01:58:14 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7EE04048D@fmsmsx124.amr.corp.intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-15-jeffrey.t.kirsher@intel.com>
 <34ea2c1d-538c-bcb7-b312-62524f31a8dd@amazon.com>
 <20200520085228.GF2837844@kroah.com>
 <a0240054-7a5c-5698-d213-b2070756c846@amazon.com>
 <20200520123726.GD24561@mellanox.com>
In-Reply-To: <20200520123726.GD24561@mellanox.com>
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

> Subject: Re: [RDMA RFC v6 14/16] RDMA/irdma: Add ABI definitions
> 
> On Wed, May 20, 2020 at 12:02:35PM +0300, Gal Pressman wrote:
> > On 20/05/2020 11:52, Greg KH wrote:
> > > On Wed, May 20, 2020 at 10:54:25AM +0300, Gal Pressman wrote:
> > >> On 20/05/2020 10:04, Jeff Kirsher wrote:
> > >>> +struct i40iw_create_qp_resp {
> > >>> +   __u32 qp_id;
> > >>> +   __u32 actual_sq_size;
> > >>> +   __u32 actual_rq_size;
> > >>> +   __u32 i40iw_drv_opt;
> > >>> +   __u16 push_idx;
> > >>> +   __u8 lsmm;
> > >>> +   __u8 rsvd;
> > >>> +};
> > >>
> > >> This struct size should be 8 bytes aligned.
> > >
> > > Aligned in what way?  Seems sane to me, what would you want it to
> > > look like instead?
> >
> > The uverbs ABI structs sizes are assumed to be padded to 8 bytes
> > alignment, I would expect the reserved field to be an array of 5 bytes
> > as done in other structs in this file (irdma_modify_qp_req for example).
> > Jason could correct me if I'm wrong?
> 
> "it is complicated"
> 
> The udata structs must have alignment that is compatible with the core struct that
> prefixes them. Of course we have a mess here, and nothing is uniform..
> 
> In this case struct ib_uverbs_create_qp_resp has a '__u32 driver_data[0]' aligned
> to 8 bytes thus the alignment of this struct can be 4 or 8.
> 
> I generally don't recommend relying on this weird side effect, and encourage
> explicit padding when possible, but since the intent of this new driver is to be ABI
> compatible with the old driver, it should be kept the same.
> 
> The userspace has a number of static_asserts which are designed to automatically
> check these various cases. I assume Intel has revised the userspace to use the
> new struct names and tested it..
> 

Thanks Jason for the explanation! Yes these abi structs are kept the same for old user-space compatibility. And yes its been tested with old user-space.
