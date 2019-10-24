Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4CFE3F54
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbfJXWZj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Oct 2019 18:25:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:37783 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729789AbfJXWZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 18:25:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 15:25:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="188733714"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga007.jf.intel.com with ESMTP; 24 Oct 2019 15:25:37 -0700
Received: from orsmsx115.amr.corp.intel.com (10.22.240.11) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 24 Oct 2019 15:25:37 -0700
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.212]) by
 ORSMSX115.amr.corp.intel.com ([169.254.4.146]) with mapi id 14.03.0439.000;
 Thu, 24 Oct 2019 15:25:37 -0700
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: RE: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Thread-Topic: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Thread-Index: AQGOetFAPbFeoIHdxRJDZlVegIphLQHJRZnhAdxiwysB1QCSuQJ6/k4op44H7uCAKV2vAP//jAtwgAB4hoCAAaHugIAAA8+A//+igjA=
Date:   Thu, 24 Oct 2019 22:25:36 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B2E1D29@ORSMSX101.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
 <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
 <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
 <20191023180108.GQ23952@ziepe.ca> <20191024185659.GE260560@kroah.com>
 <20191024191037.GC23952@ziepe.ca>
In-Reply-To: <20191024191037.GC23952@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMmM1ZDg2MTktMWQzYS00OGI2LWE5MTUtODg1ZTYyMmU4ODhmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiYlVwSU9hVVF0eVpJcGt1U0g4MWZvR1V3cjNEcmRkTFVGRnA1M3RoSnVGU3k5dHozdSt0eVArVExtWStNWGlqMiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
> Sent: Thursday, October 24, 2019 12:11 PM
> To: gregkh@linuxfoundation.org
> Cc: Ertman, David M <david.m.ertman@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; dledford@redhat.com; Ismail, Mustafa
> <mustafa.ismail@intel.com>; Patil, Kiran <kiran.patil@intel.com>
> Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
> provide RDMA
> 
> On Thu, Oct 24, 2019 at 02:56:59PM -0400, gregkh@linuxfoundation.org wrote:
> > On Wed, Oct 23, 2019 at 03:01:09PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Oct 23, 2019 at 05:55:38PM +0000, Ertman, David M wrote:
> > > > > Did any resolution happen here? Dave, do you know what to do to
> > > > > get Greg's approval?
> > > > >
> > > > > Jason
> > > >
> > > > This was the last communication that I saw on this topic.  I was
> > > > taking Greg's silence as "Oh ok, that works" :)  I hope I was not being too
> optimistic!
> > > >
> > > > If there is any outstanding issue I am not aware of it, but please
> > > > let me know if I am out of the loop!
> > > >
> > > > Greg, if you have any other concerns or questions I would be happy to
> address them!
> > >
> > > I was hoping to hear Greg say that taking a pci_device, feeding it
> > > to the multi-function-device stuff to split it to a bunch of
> > > platform_device's is OK, or that mfd should be changed somehow..
> >
> > Again, platform devices are ONLY for actual platform devices.  A PCI
> > device is NOT a platform device, sorry.
> 
> To be fair to David, IIRC, you did suggest mfd as the solution here some months
> ago, but I think you also said it might need some fixing
> :)
> 
> > If MFD needs to be changed to handle non-platform devices, fine, but
> > maybe what you really need to do here is make your own "bus" of
> > individual devices and have drivers for them, as you can't have a
> > "normal" PCI driver for these.
> 
> It does feel like MFD is the cleaner model here otherwise we'd have each
> driver making its own custom buses for its multi-function capability..
> 
> David, do you see some path to fix mfd to not use platform devices?
> 
> Maybe it needs a MFD bus type and a 'struct mfd_device' ?
> 
> I guess I'll drop these patches until it is sorted.
> 
> Jason


The original submission of the RDMA driver had separate drivers to
interact with the ice and i40e LAN drivers.  There was only about 2000
lines of code different between them, so a request was (rightly so)
made to unify the RDMA drivers into a single driver.

Our original submission for IIDC had a "software bus" that the ice driver
was creating.  The problem, now that the RDMA driver is a unified driver
for both the ice and i40e drivers, each of which would need to create their
own bus.  So, we cannot have module dependencies for the irdma driver,
as we don't know which hardware the user will have installed in the system.
or which drivers will be loaded in what order.  As new hardware is supported
(presumably by the same irdma driver) this will only get more complicated.
For instance, if the ice driver loads, then the irdma, then the i40e.  The irdma
will have no notice that a new bus was created that it needs to register with
by the i40e driver.

Our original solution to this problem was with netdev notifiers, which met with
resistance, and the statement that the bus infrastructure was the proper way to
approach the interaction of the LAN driver and peer.  This did turn out to be a
much more elegant way to approach the issue.

The direct access of the platform bus was unacceptable, and the MFD sub-system
was suggested by Greg as the solution.  The MFD sub-system uses the platform
bus in the background as a base to perform its functions, since it is a purely software
construct that is handy and fulfills its needs.  The question then is:  If the MFD sub-
system is using the platform bus for all of its background functionality, is the platform
bus really only for platform devices?  It seems that the kernel is already using the
platform bus as a generic software based bus, and it fulfills the role efficiently.

Dave E.

