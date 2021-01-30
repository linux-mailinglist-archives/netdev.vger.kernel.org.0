Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579E2309144
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 02:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhA3B2o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jan 2021 20:28:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:11132 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhA3BVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 20:21:52 -0500
IronPort-SDR: KiyvYPbhou3R+qX4uLsgliy1PpdleHlpeTVIIrZjNYlgbck6L86nExysJlIyf7S8pl+hkhSFjo
 QwPpuYxqIb7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="242025138"
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="242025138"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 17:19:16 -0800
IronPort-SDR: WVnYgMGfdXzN12TCASt/52qPxBvtN70sNUFwBC3spdeNgunv7+uQU4dMo9OhVd4gw3nS4TpMen
 LoG7gxDtVIYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="411803150"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jan 2021 17:19:16 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:19:15 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Fri, 29 Jan 2021 17:19:15 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao3Ul6AgAGNgQD//8rX0IAA9s8AgAACh4CAAGNSUIABSS+AgAD/0AA=
Date:   Sat, 30 Jan 2021 01:19:15 +0000
Message-ID: <4d07c2a9527a4297b04007bdfeaae22e@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
 <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
 <20210126011043.GG4147@nvidia.com>
 <328b9c06a18e48efbcc4121c5d375cb7@intel.com>
 <20210127024423.GL4147@nvidia.com>
In-Reply-To: <20210127024423.GL4147@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Wed, Jan 27, 2021 at 12:42:09AM +0000, Saleem, Shiraz wrote:
> 
> > > It does, the PCI driver is not supposed to spawn any aux devices for
> > > RDMA at all if RDMA is disabled.
> > >
> > > For an iWarp driver I would consider ENABLE_ROCE to really be a
> > > general ENABLE_RDMA.
> >
> > Well the driver supports iWARP and RoCE for E810 device.
> > Are you saying that this generic enable_roce devlink param really is
> > an enable 'rdma' traffic or not param?
> 
> I've thought of it that way, that is what it was created for at least.
> 
> Overloading it to be a iwarp not roce switch feels wrong

OK.

> 
> > > Are you sure you need to implement this?
> >
> > What we are after is some mechanism for user to switch the protocols
> > iWARP vs RoCE [default the device comes up as an iWARP dev]. The
> > protocol info is really needed early-on in the RDMA driver.probe(). i.e. when the
> rdma admin queue is created.
> 
> This needs to be a pci devlink at least, some kind of mode switch seems
> appropriate
> 
> > The same goes with the other param resource_limits_selector. It's a
> > profile selector that a user can chose to different # of max QP, CQs,
> > MRs etc.
> 
> And it must be done at init time? Also seems like pci devlink

Yes.

> 
> Generally speaking anything that requires the rdma driver to be reloaded should
> remove/restore the aux device.
> 
> Mode switch from roce to/from iwarp should create aux devices of different names
> which naturally triggers the right kind of sequences in the driver core
> 

OK we will move devlink out of aux rdma driver to PCI driver.

About separate aux dev names for iWARP, RoCE, that sounds reasonable.

