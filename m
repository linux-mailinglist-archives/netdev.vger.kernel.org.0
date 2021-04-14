Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEF635E9F2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 02:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348070AbhDNAVc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 20:21:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:25692 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230493AbhDNAVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 20:21:30 -0400
IronPort-SDR: nimtIaW2PQ74Z/Hm1kzyVSqpVC3vBroxw1RuLKRrDLJjK+QFk0fDyBx0G3qsClwgtUxYFMrVtK
 uwh8wd2vAi6A==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="174633928"
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="174633928"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 17:21:10 -0700
IronPort-SDR: Bl5g51HxI9V5c8Jxm1sW/ntdgLKsFWPHu5EHpZERZj13To26jaFAl3peKTyX4wYLlPlDI8uewa
 JZ1HyRpCqHUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="521799499"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 13 Apr 2021 17:21:10 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 13 Apr 2021 17:21:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 13 Apr 2021 17:21:09 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Tue, 13 Apr 2021 17:21:09 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Parav Pandit <parav@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Lacombe, John S" <john.s.lacombe@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v4 05/23] ice: Add devlink params support
Thread-Index: AQHXKyglet/OMpr4HUC3+2oFUaS+kaqpm5SA///RCKCAALIhgIABT5TAgAZO+4CAAM18wIAAq1sA///kuJA=
Date:   Wed, 14 Apr 2021 00:21:08 +0000
Message-ID: <4d9a592fa5694de8aadc60db1376da20@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
 <20210407224631.GI282464@nvidia.com>
 <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
 <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
 <8a7cd11994c2447a926cf2d3e60a019c@intel.com>
 <BY5PR12MB4322A28E6678CBB8A6544026DC4F9@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB4322A28E6678CBB8A6544026DC4F9@BY5PR12MB4322.namprd12.prod.outlook.com>
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

> Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
> 
> 
> 
> > From: Saleem, Shiraz <shiraz.saleem@intel.com>
> > Sent: Tuesday, April 13, 2021 8:11 PM
> [..]
> 
> > > > > Parav is talking about generic ways to customize the aux devices
> > > > > created and that would seem to serve the same function as this.
> > > >
> > > > Is there an RFC or something posted for us to look at?
> > > I do not have polished RFC content ready yet.
> > > But coping the full config sequence snippet from the internal draft
> > > (changed for ice
> > > example) here as I like to discuss with you in this context.
> >
> > Thanks Parav! Some comments below.
> >
> > >
> > > # (1) show auxiliary device types supported by a given devlink device.
> > > # applies to pci pf,vf,sf. (in general at devlink instance).
> > > $ devlink dev auxdev show pci/0000:06.00.0
> > > pci/0000:06.00.0:
> > >   current:
> > >     roce eth
> > >   new:
> > >   supported:
> > >     roce eth iwarp
> > >
> > > # (2) enable iwarp and ethernet type of aux devices and disable roce.
> > > $ devlink dev auxdev set pci/0000:06:00.0 roce off iwarp on
> > >
> > > # (3) now see which aux devices will be enable on next reload.
> > > $ devlink dev auxdev show pci/0000:06:00.0
> > > pci/0000:06:00.0:
> > >   current:
> > >     roce eth
> > >   new:
> > >     eth iwarp
> > >   supported:
> > >     roce eth iwarp
> > >
> > > # (4) now reload the device and see which aux devices are created.
> > > At this point driver undergoes reconfig for removal of roce and
> > > adding
> > iwarp.
> > > $ devlink reload pci/0000:06:00.0
> >
> > I see this is modeled like devlink resource.
> >
> > Do we really to need a PCI driver re-init to switch the type of the
> > auxdev hanging off the PCI dev?
> >
> I don't see a need to re-init the whole PCI driver. Since only aux device config is
> changed only that piece to get reloaded.

But that is what mlx5 and other implementations does on reload no? i.e. a PCI driver reinit.
I can see an ice implementation of reload morphing to similar over time to support a new config
that requires a true reinit of PCI driver entities.

> 
> > Why not just allow the setting to apply dynamically during a 'set'
> > itself with an unplug/plug of the auxdev with correct type.
> >
> This suggestion came up in the internal discussion too.
> However such task needs to synchronize with devlink reload command and also
> with driver remove() sequence.
> So locking wise and depending on amount of config change, it is close to what
> reload will do.

Holding this mutex across the auxiliary device unplug/plug in "set" wont cut it?
https://elixir.bootlin.com/linux/v5.12-rc7/source/drivers/net/ethernet/mellanox/mlx5/core/main.c#L1304

> For example other resource config or other params setting also to take effect.
> So to avoid defining multiple config sequence, doing as part of already existing
> devlink reload, it brings simple sequence to user.
> 
> For example,
> 1. enable/disable desired aux devices
> 2. configure device resources
> 3. set some device params
> 4. do devlink reload and apply settings done in #1 to #3

Sure. But a user might also just want to operate on just an auxiliary device configuration change. As in #1.
And he ends up having everything hanging off the PF to get blown out, including potentially
the VFs. That feels like too big a hammer.

Shiraz

