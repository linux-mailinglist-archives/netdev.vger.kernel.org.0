Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52D8306722
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 23:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbhA0WSq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jan 2021 17:18:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:40127 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237094AbhA0WSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 17:18:43 -0500
IronPort-SDR: KRKXgkISu8C6lZ6Gdk8ojnhiehMcP4q5Knf9BLzxFLuxvJLBmz4ANYHDX/2YKKsPRAaEcGt+nr
 j42Q6Rvmh73Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="244222431"
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="244222431"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 14:17:57 -0800
IronPort-SDR: 5jW1+fuVcmetFbAY3n8nMbNhDP8vEe8/MR15nAfP86MIk7kwQISdFNwq32WdlpwzRaV7yPLBf9
 OxSxOLMYpCVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="574517101"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jan 2021 14:17:57 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 27 Jan 2021 14:17:57 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Jan 2021 14:17:56 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Wed, 27 Jan 2021 14:17:56 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao5N6oA//+n/DCAAMFCAIAAeSAAgAHXAYD//6CioA==
Date:   Wed, 27 Jan 2021 22:17:56 +0000
Message-ID: <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
In-Reply-To: <20210127121847.GK1053290@unreal>
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
> On Wed, Jan 27, 2021 at 12:41:41AM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver
> > > and implement private channel OPs
> > >
> > > On Tue, Jan 26, 2021 at 12:42:16AM +0000, Saleem, Shiraz wrote:
> > >
> > > > I think this essentially means doing away with .open/.close piece.
> > >
> > > Yes, that too, and probably the FSM as well.
> > >
> > > > Or are you saying that is ok?  Yes we had a discussion in the past
> > > > and I thought we concluded. But maybe I misunderstood.
> > > >
> > > > https://lore.kernel.org/linux-rdma/9DD61F30A802C4429A01CA4200E302A
> > > > 7DCD 4FD03@fmsmsx124.amr.corp.intel.com/
> > >
> > > Well, having now seen how aux bus ended up and the way it effected
> > > the
> > > mlx5 driver, I am more firmly of the opinion this needs to be fixed.
> > > It is extremly hard to get everything right with two different registration
> schemes running around.
> > >
> > > You never answered my question:
> >
> > Sorry I missed it.
> > >
> > > > Still, you need to be able to cope with the user unbinding your
> > > > drivers in any order via sysfs. What happens to the VFs when the
> > > > PF is unbound and releases whatever resources? This is where the
> > > > broadcom driver ran into troubles..
> > >
> > > ?
> >
> > echo -n "ice.intel_rdma.0" > /sys/bus/auxiliary/drivers/irdma/unbind  ???
> >
> > That I believe will trigger a drv.remove() on the rdma PF side which
> > require the rdma VFs to go down.
> >
> > Yes, we currently have a requirement the aux rdma PF driver remain
> > inited at least to .probe() for VFs to survive.
> >
> > We are doing internal review, but it appears we could potentially get rid of the
> .open/.close callbacks.
> > And its associated FSM in ice.
> >
> > But if we remove peer_register/unregister, how do we synchronize
> > between say unload of the rdma driver and netdev driver stop accessing the priv
> channel iidc_peer_ops that it uses to send events to rdma?
> 
> And here we are returning to square one of intended usage of aux bus.
> Your driver should be structured to have PCI core logic that will represent physical
> device and many small sub-devices with their respective drivers.

Even with another core PCI driver, there still needs to be private communication channel
between the aux rdma driver and this PCI driver to pass things like QoS updates.

The split of the PCI core device into aux devices is a design choice.
Not sure what that has to do with the usage of bus.

> 
> ETH is another sub-device that shouldn't talk directly to the RDMA.
> 

ETH should talk indirectly to RDMA driver via the core PCI driver? And how does that solve this?
