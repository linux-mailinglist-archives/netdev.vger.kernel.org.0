Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35D8163347
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgBRUnb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Feb 2020 15:43:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:47551 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgBRUnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 15:43:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 12:43:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="408201093"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga005.jf.intel.com with ESMTP; 18 Feb 2020 12:43:20 -0800
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 18 Feb 2020 12:43:18 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.69]) by
 FMSMSX109.amr.corp.intel.com ([169.254.15.123]) with mapi id 14.03.0439.000;
 Tue, 18 Feb 2020 12:43:18 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v4 18/25] RDMA/irdma: Implement device supported
 verb APIs
Thread-Topic: [RFC PATCH v4 18/25] RDMA/irdma: Implement device supported
 verb APIs
Thread-Index: AQHV4diqv+fJ7ydGkEi15OWUdWApfKgbT8yA//+r+/A=
Date:   Tue, 18 Feb 2020 20:43:17 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7C60C94CD@fmsmsx124.amr.corp.intel.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-19-jeffrey.t.kirsher@intel.com>
 <20200214145443.GU31668@ziepe.ca>
In-Reply-To: <20200214145443.GU31668@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTA4Y2U5ZGYtYTNmMC00NmNlLWExMDAtZmQxMjcxNjQyNGRlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMURvWWxtaVdPUEh0aG5wNmY2YWNMbE5wZ1BFRWZxRmxtRjFpbjNUd0ZBZTFTM0RmK09aWEs4K3RQMytMZmV1WCJ9
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

> Subject: Re: [RFC PATCH v4 18/25] RDMA/irdma: Implement device supported
> verb APIs
> 
> On Wed, Feb 12, 2020 at 11:14:17AM -0800, Jeff Kirsher wrote:
> 
> > +/**
> > + * irdma_ib_register_device - register irdma device to IB core
> > + * @iwdev: irdma device
> > + */
> > +int irdma_ib_register_device(struct irdma_device *iwdev) {
> > +	int ret;
> > +
> > +	ret = irdma_init_rdma_device(iwdev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	rdma_set_device_sysfs_group(&iwdev->ibdev, &irdma_attr_group);
> 
> New drivers are forbidden from calling this:
> 
OK. Agreed. What's exported via query device suffices.

