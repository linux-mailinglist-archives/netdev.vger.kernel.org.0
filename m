Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA4D305461
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbhA0HUE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jan 2021 02:20:04 -0500
Received: from mga14.intel.com ([192.55.52.115]:19855 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317274AbhA0AnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:43:13 -0500
IronPort-SDR: Xxt0tR8mWcosft9yamM146bAir3LT1R1RZS/CrpcQ0Go819HYlQXRNUbexYVqsAimdLKvvtF1g
 L7G6R/KcNEpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="179214246"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="179214246"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:42:10 -0800
IronPort-SDR: 6KjnBDWsQAWixZsskSqxNs30hiX8fdYGiNIMFuv6u549UHm66GizwqeJ/ezP4xmRCLeHvfoCyc
 dfljPes5Ooog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="393908646"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 26 Jan 2021 16:42:10 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 16:42:09 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 26 Jan 2021 16:42:09 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
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
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao3Ul6AgAGNgQD//8rX0IAA9s8AgAACh4CAAGNSUA==
Date:   Wed, 27 Jan 2021 00:42:09 +0000
Message-ID: <328b9c06a18e48efbcc4121c5d375cb7@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
 <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
 <20210126011043.GG4147@nvidia.com>
In-Reply-To: <20210126011043.GG4147@nvidia.com>
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
> On Mon, Jan 25, 2021 at 05:01:40PM -0800, Jacob Keller wrote:
> >
> >
> > On 1/25/2021 4:39 PM, Saleem, Shiraz wrote:
> > >> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver
> > >> and implement private channel OPs
> > >>
> > >> On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
> > >>> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> > >>>> From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >>>>
> > >>>> Register irdma as an auxiliary driver which can attach to
> > >>>> auxiliary RDMA devices from Intel PCI netdev drivers i40e and
> > >>>> ice. Implement the private channel ops, add basic devlink support
> > >>>> in the driver and register net notifiers.
> > >>>
> > >>> Devlink part in "the RDMA client" is interesting thing.
> > >>>
> > >>> The idea behind auxiliary bus was that PCI logic will stay at one
> > >>> place and devlink considered as the tool to manage that.
> > >>
> > >> Yes, this doesn't seem right, I don't think these auxiliary bus
> > >> objects should have devlink instances, or at least someone from
> > >> devlink land should approve of the idea.
> > >>
> > >
> > > In our model, we have one auxdev (for RDMA) per PCI device function
> > > owned by netdev driver and one devlink instance per auxdev. Plus there is an
> Intel netdev driver for each HW generation.
> > > Moving the devlink logic to the PCI netdev driver would mean
> > > duplicating the same set of RDMA params in each Intel netdev driver.
> > > Additionally, plumbing RDMA specific params in the netdev driver sort of
> seems misplaced to me.
> > >
> >
> > I agree that plumbing these parameters at the PCI side in the devlink
> > of the parent device is weird. They don't seem to be parameters that
> > the parent driver cares about.
> 
> It does, the PCI driver is not supposed to spawn any aux devices for RDMA at all
> if RDMA is disabled.
> 
> For an iWarp driver I would consider ENABLE_ROCE to really be a general
> ENABLE_RDMA.

Well the driver supports iWARP and RoCE for E810 device.
Are you saying that this generic enable_roce devlink param really
is an enable 'rdma' traffic or not param?

> 
> Are you sure you need to implement this?

What we are after is some mechanism for user to switch the protocols iWARP vs RoCE
[default the device comes up as an iWARP dev]. The protocol info is really needed early-on
in the RDMA driver.probe(). i.e. when the rdma admin queue is created.

The same goes with the other param resource_limits_selector. It's a profile selector that a user
can chose to different # of max QP, CQs, MRs etc.

> 
> In any event, you just can't put the generic ENABLE_ROCE flag anyplace but the
> PCI device for devlink, it breaks the expected user API established by mlx5
> 
> Jason
