Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D19830CC13
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbhBBTnQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Feb 2021 14:43:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:64474 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239384AbhBBTm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 14:42:56 -0500
IronPort-SDR: ZSWcpNGkBb/hD8mtU9ezmWwFNsMky83zXiUxzFzJOJ4U7SUvoE7uHSxA1O/GyHOA4VbPajno+H
 jX4MeSG5iEzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="178358718"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="178358718"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 11:42:13 -0800
IronPort-SDR: dxAnULbu/swAHZqgIqC6zC/oHuyvu42pyvTMwxGJygCq9Cae7KYvlzvWnEaJDWWqKpeARLrtYJ
 yopW1pwiQhrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="391647623"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 02 Feb 2021 11:42:12 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Feb 2021 11:42:11 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Tue, 2 Feb 2021 11:42:11 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao5N6oA//+n/DCAAMFCAIAAeSAAgAHXAYD//6CioIABFy+AgABrh4CAAjZjEIAE9xSA///EJCAAE6rJAAAhzgAAAAzd8EA=
Date:   Tue, 2 Feb 2021 19:42:11 +0000
Message-ID: <4720390ef608423dac481d813e8b8a62@intel.com>
References: <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com> <20210128054133.GA1877006@unreal>
 <d58f341898834170af1bfb6719e17956@intel.com>
 <20210201191805.GO4247@nvidia.com>
 <925c33a0b174464898c9fc5651b981ee@intel.com>
 <CAPcyv4gbW-27ySTmxf97zzcoVA_myM8uLV=ziscMuSKGBz7dqg@mail.gmail.com>
 <20210202171454.GX4247@nvidia.com>
In-Reply-To: <20210202171454.GX4247@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Mon, Feb 01, 2021 at 05:06:58PM -0800, Dan Williams wrote:
> > On Mon, Feb 1, 2021 at 4:40 PM Saleem, Shiraz <shiraz.saleem@intel.com>
> wrote:
> > >
> > > > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary
> > > > driver and implement private channel OPs
> > > >
> > > > On Sat, Jan 30, 2021 at 01:19:36AM +0000, Saleem, Shiraz wrote:
> > > > > > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary
> > > > > > driver and implement private channel OPs
> > > > > >
> > > > > > On Wed, Jan 27, 2021 at 07:16:41PM -0400, Jason Gunthorpe wrote:
> > > > > > > On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:
> > > > > > >
> > > > > > > > Even with another core PCI driver, there still needs to be
> > > > > > > > private communication channel between the aux rdma driver
> > > > > > > > and this PCI driver to pass things like QoS updates.
> > > > > > >
> > > > > > > Data pushed from the core driver to its aux drivers should
> > > > > > > either be done through new callbacks in a struct
> > > > > > > device_driver or by having a notifier chain scheme from the core
> driver.
> > > > > >
> > > > > > Right, and internal to driver/core device_lock will protect
> > > > > > from parallel probe/remove and PCI flows.
> > > > > >
> > > > >
> > > > > OK. We will hold the device_lock while issuing the .ops
> > > > > callbacks from core
> > > > driver.
> > > > > This should solve our synchronization issue.
> > > > >
> > > > > There have been a few discussions in this thread. And I would
> > > > > like to be clear on what to do.
> > > > >
> > > > > So we will,
> > > > >
> > > > > 1. Remove .open/.close, .peer_register/.peer_unregister 2.
> > > > > Protect ops callbacks issued from core driver to the aux driver
> > > > > with device_lock
> > > >
> > > > A notifier chain is probably better, honestly.
> > > >
> > > > Especially since you don't want to split the netdev side, a
> > > > notifier chain can be used by both cases equally.
> > > >
> > >
> > > The device_lock seems to be a simple solution to this synchronization
> problem.
> > > May I ask what makes the notifier scheme better to solve this?
> > >
> >
> > Only loosely following the arguments here, but one of the requirements
> > of the driver-op scheme is that the notifying agent needs to know the
> > target device. With the notifier-chain approach the target device
> > becomes anonymous to the notifier agent.
> 
> Yes, and you need to have an aux device in the first place. The netdev side has
> neither of this things. 

But we do. The ice PCI driver is thing spawning the aux device. And we are trying to do
something directed here specifically between the ice PCI driver and the irdma aux driver.
Seems the notifier chain approach, from the comment above, is less directed and when
you want to broadcast events from core driver to multiple registered subscribers.

I think there is going to be need for some ops even if we were to use notifier chains.
Such as ones that need a ret_code.



I think it would be a bit odd to have extensive callbacks that
> are for RDMA only, that suggests something in the core API is not general enough.
> 

Yes there are some domain specific ops. But it is within the boundary of how the aux bus should be used no? 

https://www.kernel.org/doc/html/latest/driver-api/auxiliary_bus.html
"The auxiliary_driver can also be encapsulated inside custom drivers that make the core device's functionality extensible by adding additional domain-specific ops as follows:"

struct my_driver {
        struct auxiliary_driver auxiliary_drv;
        const struct my_ops ops;
};
