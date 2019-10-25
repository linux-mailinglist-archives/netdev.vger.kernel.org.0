Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB7FE5675
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfJYW1s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Oct 2019 18:27:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:29747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfJYW1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 18:27:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 15:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,230,1569308400"; 
   d="scan'208";a="229054185"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga002.fm.intel.com with ESMTP; 25 Oct 2019 15:27:47 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 25 Oct 2019 15:27:47 -0700
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.212]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.56]) with mapi id 14.03.0439.000;
 Fri, 25 Oct 2019 15:27:47 -0700
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
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
Thread-Index: AQGOetFAPbFeoIHdxRJDZlVegIphLQHJRZnhAdxiwysB1QCSuQJ6/k4op44H7uCAKV2vAP//jAtwgAB4hoCAAaHugIAAA8+A//+igjCAAMe3AIAA6SdA
Date:   Fri, 25 Oct 2019 22:27:46 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B2E2FE6@ORSMSX101.amr.corp.intel.com>
References: <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
 <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
 <20191023180108.GQ23952@ziepe.ca> <20191024185659.GE260560@kroah.com>
 <20191024191037.GC23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E1D29@ORSMSX101.amr.corp.intel.com>
 <20191025013048.GB265361@kroah.com>
In-Reply-To: <20191025013048.GB265361@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDZkYmUxYzUtZWRjZi00MjNkLWEyYTktMjUyMDYxZDdjMDVjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZW1DYkdyaTdMUjZSeXNcL0pVTUJnQnQ3NFY0U0ZTYlZReXVVdjJIa2ZaWXlsY0RMQ0dRRzJUQ3VTak5oTE1LS3cifQ==
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
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, October 24, 2019 6:31 PM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; dledford@redhat.com; Ismail, Mustafa
> <mustafa.ismail@intel.com>; Patil, Kiran <kiran.patil@intel.com>;
> lee.jones@linaro.org
> Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
> provide RDMA
> 
> On Thu, Oct 24, 2019 at 10:25:36PM +0000, Ertman, David M wrote:
> > The direct access of the platform bus was unacceptable, and the MFD
> > sub-system was suggested by Greg as the solution.  The MFD sub-system
> > uses the platform bus in the background as a base to perform its
> > functions, since it is a purely software construct that is handy and
> > fulfills its needs.  The question then is:  If the MFD sub- system is
> > using the platform bus for all of its background functionality, is the platform
> bus really only for platform devices?
> 
> Yes, how many times do I have to keep saying this?
> 
> The platform bus should ONLY be used for devices that are actually platform
> devices and can not be discovered any other way and are not on any other type
> of bus.
> 
> If you try to add platform devices for a PCI device, I am going to continue to
> complain.  I keep saying this and am getting tired.
> 
> Now yes, MFD does do "fun" things here, and that should probably be fixed up
> one of these days.  But I still don't see why a real bus would not work for you.
> 
> greg "platform devices are dead, long live the platform device" k-h

> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, October 24, 2019 6:31 PM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; dledford@redhat.com; Ismail, Mustafa
> <mustafa.ismail@intel.com>; Patil, Kiran <kiran.patil@intel.com>;
> lee.jones@linaro.org
> Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
> provide RDMA
> 
> On Thu, Oct 24, 2019 at 10:25:36PM +0000, Ertman, David M wrote:
> > The direct access of the platform bus was unacceptable, and the MFD
> > sub-system was suggested by Greg as the solution.  The MFD sub-system
> > uses the platform bus in the background as a base to perform its
> > functions, since it is a purely software construct that is handy and
> > fulfills its needs.  The question then is:  If the MFD sub- system is
> > using the platform bus for all of its background functionality, is the platform
> bus really only for platform devices?
> 
> Yes, how many times do I have to keep saying this?
> 
> The platform bus should ONLY be used for devices that are actually platform
> devices and can not be discovered any other way and are not on any other type
> of bus.
> 
> If you try to add platform devices for a PCI device, I am going to continue to
> complain.  I keep saying this and am getting tired.
> 
> Now yes, MFD does do "fun" things here, and that should probably be fixed up
> one of these days.  But I still don't see why a real bus would not work for you.
> 
> greg "platform devices are dead, long live the platform device" k-h

I'm sorry, the last thing I want to do is to annoy you! I just need to
figure out where to go from here.  Please, don't take anything I say as
argumentative.

I don't understand what you mean by "a real bus".  The irdma driver does
not have access to any physical bus.  It utilizes resources provided by
the PCI LAN drivers, but to receive those resources it needs a mechanism
to "hook up" with the PCI drivers.  The only way it has to locate them
is to register a driver function with a software based bus of some kind
and have the bus match it up to a compatible entity to achieve that hook up.

The PCI LAN driver has a function that controls the PCI hardware, and then
we want to present an entity for the RDMA driver to connect to.

To move forward, we are thinking of the following design proposal:

We could add a new module to the kernel named generic_bus.ko.  This would
create a new generic software bus and a set of APIs that would allow for
adding and removing simple generic virtual devices and drivers, not as
a MFD cell or a platform device. The power management events would also
be handled by the generic_bus infrastructure (suspend, resume, shutdown).
We would use this for matching up by having the irdma driver register
with this generic bus and hook to virtual devices that were added from
different PCI LAN drivers.

Pros:
1) This would avoid us attaching anything to the platform bus
2) Avoid having each PCI LAN driver creating its own software bus
3) Provide a common matching ground for generic devices and drivers that
eliminates problems caused by load order (all dependent on generic_bus.ko)
4) Usable by any other entity that wants a lightweight matching system
or information exchange mechanism

Cons:
1) Duplicates part of the platform bus functionality
2) Adds a new software bus to the kernel architecture

Is this path forward acceptable?

Thanks for any clarification/guidance you can provide!

-Dave E
