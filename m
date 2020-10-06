Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E51285106
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 19:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgJFRlK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Oct 2020 13:41:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:60493 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJFRlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 13:41:10 -0400
IronPort-SDR: lVm3SrteD+Ih7tsytmtctAnE0SJ46pGjud7L7pZ54L84Ucny08UCbZnbQLApk1hAM6ZJMFnZOP
 rmknkzXZ/mrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="249310042"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="249310042"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 10:41:04 -0700
IronPort-SDR: FWN0gfMLLMz51mLTKEALP7ftdCXctRtuya3sTcK/sMbwxMslvkRoiJls0MMwb4ao5HliGzGh8F
 siSaW4uhguKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="354478830"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 06 Oct 2020 10:41:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Oct 2020 10:41:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Oct 2020 10:41:00 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 6 Oct 2020 10:41:00 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@nvidia.com>
CC:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm0x+bCEx5k0iU0+RSRzmm941iKmKoH2AgACGDICAAB03gIAAAc6AgAAE8QD//4wBYA==
Date:   Tue, 6 Oct 2020 17:41:00 +0000
Message-ID: <3ff1445d86564ef3aae28d1d1a9a19ea@intel.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201006172650.GO1874917@unreal>
In-Reply-To: <20201006172650.GO1874917@unreal>
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

> Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> 
> On Tue, Oct 06, 2020 at 05:09:09PM +0000, Parav Pandit wrote:
> >
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Tuesday, October 6, 2020 10:33 PM
> > >
> > > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > > > Thanks for the review Leon.
> > > >
> > > > > > Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> > > > > > It enables drivers to create an ancillary_device and bind an
> > > > > > ancillary_driver to it.
> > > > >
> > > > > I was under impression that this name is going to be changed.
> > > >
> > > > It's part of the opens stated in the cover letter.
> > >
> > > ok, so what are the variants?
> > > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> > Since the intended use of this bus is to
> > (a) create sub devices that represent 'functional separation' and
> > (b) second use case for subfunctions from a pci device,
> >
> > I proposed below names in v1 of this patchset.
> >
> > (a) subdev_bus
> 
> It sounds good, just can we avoid "_" in the name and call it subdev?
> 

What is wrong with naming the bus 'ancillary bus'? I feel it's a fitting name.
An ancillary software bus for ancillary devices carved off a parent device registered on a primary bus.



