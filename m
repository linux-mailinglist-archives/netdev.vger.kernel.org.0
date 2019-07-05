Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287B060A4C
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfGEQdK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Jul 2019 12:33:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:40492 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbfGEQdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 12:33:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jul 2019 09:33:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,455,1557212400"; 
   d="scan'208";a="169705915"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga006.jf.intel.com with ESMTP; 05 Jul 2019 09:33:08 -0700
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 5 Jul 2019 09:33:07 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.213]) by
 FMSMSX109.amr.corp.intel.com ([169.254.15.78]) with mapi id 14.03.0439.000;
 Fri, 5 Jul 2019 09:33:07 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Thread-Topic: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Thread-Index: AQHVMg3qri6Tz8b1aEeFf5rry/wSLqa61emAgAADrACAAAIogIAAAXaAgAABmICAABAgAIABRqlw
Date:   Fri, 5 Jul 2019 16:33:07 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A684DA23@fmsmsx124.amr.corp.intel.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
 <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
 <20190704121632.GB3401@mellanox.com> <20190704122950.GA6007@kroah.com>
 <20190704123729.GF3401@mellanox.com> <20190704124247.GA6807@kroah.com>
 <20190704124824.GK3401@mellanox.com> <20190704134612.GB10963@kroah.com>
In-Reply-To: <20190704134612.GB10963@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOWZjMDRjZTEtNzQ2OC00MTFiLWI5ODktNDg4ZjlmZmEyMDYxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidVlZVkd6NHYxbFhTVUdQNFJPb09tcXcxcXJ2N09lUDJQcEoyNVpGNElTR2t2cGsyZE0wR1wvT1BQWUpMVjVPQjQifQ==
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [net-next 1/3] ice: Initialize and register platform device to provide
> RDMA
> 
> On Thu, Jul 04, 2019 at 12:48:29PM +0000, Jason Gunthorpe wrote:
> > On Thu, Jul 04, 2019 at 02:42:47PM +0200, Greg KH wrote:
> > > On Thu, Jul 04, 2019 at 12:37:33PM +0000, Jason Gunthorpe wrote:
> > > > On Thu, Jul 04, 2019 at 02:29:50PM +0200, Greg KH wrote:
> > > > > On Thu, Jul 04, 2019 at 12:16:41PM +0000, Jason Gunthorpe wrote:
> > > > > > On Wed, Jul 03, 2019 at 07:12:50PM -0700, Jeff Kirsher wrote:
> > > > > > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > > > > >
> > > > > > > The RDMA block does not advertise on the PCI bus or any other bus.
> > > > > > > Thus the ice driver needs to provide access to the RDMA
> > > > > > > hardware block via a virtual bus; utilize the platform bus to provide this
> access.
> > > > > > >
> > > > > > > This patch initializes the driver to support RDMA as well as
> > > > > > > creates and registers a platform device for the RDMA driver
> > > > > > > to register to. At this point the driver is fully
> > > > > > > initialized to register a platform driver, however, can not
> > > > > > > yet register as the ops have not been implemented.
> > > > > >
> > > > > > I think you need Greg's ack on all this driver stuff -
> > > > > > particularly that a platform_device is OK.
> > > > >
> > > > > A platform_device is almost NEVER ok.
> > > > >
> > > > > Don't abuse it, make a real device on a real bus.  If you don't
> > > > > have a real bus and just need to create a device to hang other
> > > > > things off of, then use the virtual one, that's what it is there for.
> > > >
> > > > Ideally I'd like to see all the RDMA drivers that connect to
> > > > ethernet drivers use some similar scheme.
> > >
> > > Why?  They should be attached to a "real" device, why make any up?
> >
> > ? A "real" device, like struct pci_device, can only bind to one
> > driver. How can we bind it concurrently to net, rdma, scsi, etc?
> 
> MFD was designed for this very problem.
> 
> > > > This is for a PCI device that plugs into multiple subsystems in
> > > > the kernel, ie it has net driver functionality, rdma
> > > > functionality, some even have SCSI functionality
> > >
> > > Sounds like a MFD device, why aren't you using that functionality
> > > instead?
> >
> > This was also my advice, but in another email Jeff says:
> >
> >   MFD architecture was also considered, and we selected the simpler
> >   platform model. Supporting a MFD architecture would require an
> >   additional MFD core driver, individual platform netdev, RDMA function
> >   drivers, and stripping a large portion of the netdev drivers into
> >   MFD core. The sub-devices registered by MFD core for function
> >   drivers are indeed platform devices.
> 
> So, "mfd is too hard, let's abuse a platform device" is ok?
> 
> People have been wanting to do MFD drivers for PCI devices for a long time, it's
> about time someone actually did the work for it, I bet it will not be all that complex
> if tiny embedded drivers can do it :)
> 
Hi Greg - Thanks for your feedback!

We currently have 2 PCI function netdev drivers in the kernel (i40e & ice) that support devices (x722 & e810)
which are RDMA capable. Our objective is to add a single unified RDMA driver
(as this a subsystem specific requirement) which needs to access HW resources from the
netdev PF drivers. Attaching platform devices from the netdev drivers to the platform bus
and having a single RDMA platform driver bind to them and access these resources seemed
like a simple approach to realize our objective. But seems like attaching platform devices is
wrong. I would like to understand why. 

Are platform sub devices only to be added from an MFD core driver? I am also wondering if MFD arch.
would allow for realizing a single RDMA driver and whether we need an MFD core driver for
each device, x722 & e810 or whether it can be a single driver.

Shiraz
