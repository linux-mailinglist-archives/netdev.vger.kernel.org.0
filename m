Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFA21BB261
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgD0X5x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Apr 2020 19:57:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:54089 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgD0X5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 19:57:53 -0400
IronPort-SDR: wDVVRGRmAiQs8d3w4KDTyr3v1Y2H0XalEC3HuNPnpXmiPG0gT1Ogpk3swY2EG76m/OG3fc3iXw
 7cdBcuYP/bpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 16:57:53 -0700
IronPort-SDR: UweXtgoOawm0anxZcbs0jV6+I02FfhLG1FM4tbwfk1POAaW01Yoj8VwvMkNK+WD6gObWyEfz2S
 nNuz5yUdHJqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="257442073"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga003.jf.intel.com with ESMTP; 27 Apr 2020 16:57:52 -0700
Received: from fmsmsx163.amr.corp.intel.com (10.18.125.72) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 27 Apr 2020 16:57:52 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 fmsmsx163.amr.corp.intel.com ([169.254.6.217]) with mapi id 14.03.0439.000;
 Mon, 27 Apr 2020 16:57:51 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Sharp, Robert O" <robert.o.sharp@intel.com>,
        "Lacombe, John S" <john.s.lacombe@intel.com>
Subject: RE: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Topic: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHWFNtu4ugEuh6AnUe8PZpOjYV9PKh+KgSAgAPqlNCAASOfAIAAk97AgACTTgD//+mbEIADAuyA//+LpnCAALfQAP//uFWAABUD5oAAtxBqEA==
Date:   Mon, 27 Apr 2020 23:57:51 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD5588C@fmsmsx124.amr.corp.intel.com>
References: <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
 <20200421004628.GQ26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4A3E9@fmsmsx124.amr.corp.intel.com>
 <20200421182256.GT26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4DB92@fmsmsx124.amr.corp.intel.com>
 <20200423150201.GY26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4ED27@fmsmsx124.amr.corp.intel.com>
 <20200423190327.GC26002@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7DCD4FD03@fmsmsx124.amr.corp.intel.com>
 <20200424004841.GD26002@ziepe.ca>
In-Reply-To: <20200424004841.GD26002@ziepe.ca>
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

> Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> definitions
> 
> On Thu, Apr 23, 2020 at 11:54:18PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > > definitions
> > >
> > > On Thu, Apr 23, 2020 at 05:15:22PM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver
> > > > > framework definitions
> > > > >
> > > > > On Thu, Apr 23, 2020 at 12:32:48AM +0000, Saleem, Shiraz wrote:
> > > > >
> > > > > > we have a split initialization design for gen2 and future products.
> > > > > > phase1 is control path resource initialization in
> > > > > > irdma_probe_dev and
> > > > > > phase-2 is the rest of the resources with the ib registration
> > > > > > at the end of irdma_open. irdma_close must de-register the ib
> > > > > > device which will take care of ibdev free too. So it makes
> > > > > > sense to keep allocation of the ib device in irdma_open.
> > > > >
> > > > > The best driver pattern is to allocate the ib_device at the very
> > > > > start of probe() and use this to anchor all the device resources and
> memories.
> > > > >
> > > > > The whole close/open thing is really weird, you should get rid of it.
> > > > maybe I missing something. But why is it weird?
> > >
> > > Because the RDMA driver should exist as its own entity. It does not
> > > shutdown unless the remove() method on is struct device_driver is closed.
> > > So what exactly are open/cose supposed to be doing? I think it is a
> > > left over of trying to re-implement the driver model.
> > >
> > > > underlying configuration changes and reset management for the
> > > > physical function need a light-weight mechanism which is realized
> > > > with the close/open from netdev PCI drv --> rdma drv.
> > >
> > > > Without a teardown and re-add of virtual device off the bus.
> > >
> > > Yes, that is exactly right. If you have done something so disruptive
> > > that the ib_device needs to be destroyed then you should
> > > unplug/replug the entire virtual bus device, that is the correct and sane thing to
> do.
> >
> > Well we have resources created in rdma driver probe which are used by
> > any VF's regardless of the registration of the ib device on the PF.
> 
> Ugh, drivers that have the VF driver require the PF driver have a lot of problems.
> 
> But, even so, with your new split design, resources held for a VF belong in the
> core pci driver, not the rdma virtual bus device.
> 

This is not a new design per se but been this way from the get go in our first
submission.

What your suggesting makes sense if we had a core PCI driver and
function specific drivers (i.e netdev and rdma driver in our case).
The resources held for VF, device IRQs and other common resource
initialization would be done by this core PCI driver. Function specific
drivers would bind to their virtual devices and access their slice of
resources. It sounds architecturally more clean but this is a major
undertaking that needs a re-write of both netdev and rdma drivers.
Moreover not sure if we are solving any problem here and the current
design is proven out to work for us.

As it stands now, the netdev driver is the pci driver and moving rdma
specific admin queues / resources out of rdma PF driver to be managed
by the netdev driver does not make a lot of sense in the present design.
We want rdma VF specific resources be managed by rdma PF driver.
And netdev specific VF resources by netdev PF driver.

Shiraz
