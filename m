Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5623D285132
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 19:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgJFRu1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Oct 2020 13:50:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:30023 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJFRu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 13:50:27 -0400
IronPort-SDR: jHu1WU4r4YKi0fHdhxeOAGwuxLHULZ6C7j8B9G6X6tVklfQxWuHpfwsolXMyB3oM5j+rqoRA7U
 TAGEdtnJfbpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="151532122"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="151532122"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 10:50:27 -0700
IronPort-SDR: Yc8FvicxbAFK/d55UAgu1EYcs4a/MfQoxCEmyqD+X+ivCdV5FaqM5CD/pukTZ1/p1/HJ2r1hJR
 PV+d6waPX2gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="353588091"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Oct 2020 10:50:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Oct 2020 10:50:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Oct 2020 10:50:24 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 6 Oct 2020 10:50:24 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
CC:     "Ertman, David M" <david.m.ertman@intel.com>,
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
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm0x+bCEx5k0iU0+RSRzmm941iKmKoH2AgACGDICAAB03gP//lu/w
Date:   Tue, 6 Oct 2020 17:50:21 +0000
Message-ID: <7c188f4d06f3499bb0262599fd9b55d3@intel.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
In-Reply-To: <20201006170241.GM1874917@unreal>
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
> On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > Thanks for the review Leon.
> >
> > > > Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> > > > It enables drivers to create an ancillary_device and bind an
> > > > ancillary_driver to it.
> > >
> > > I was under impression that this name is going to be changed.
> >
> > It's part of the opens stated in the cover letter.
> 
> ok, so what are the variants?
> system bus (sysbus), sbsystem bus (subbus), crossbus ?
> 
> >
> > [...]
> >
> > > > +	const struct my_driver my_drv = {
> > > > +		.ancillary_drv = {
> > > > +			.driver = {
> > > > +				.name = "myancillarydrv",
> > >
> > > Why do we need to give control over driver name to the driver authors?
> > > It can be problematic if author puts name that already exists.
> >
> > Good point. When I used the ancillary_devices for my own SoundWire
> > test, the driver name didn't seem specifically meaningful but needed
> > to be set to something, what mattered was the id_table. Just thinking
> > aloud, maybe we can add prefixing with KMOD_BUILD, as we've done
> > already to avoid collisions between device names?
> 
> IMHO, it shouldn't be controlled by the drivers at all and need to have kernel
> module name hardwired. Users will use it later for various bind/unbind/autoprobe
> tricks and it will give predictability for them.
> 

+1. This name is not used in the match. Having the bus hardwire the modname sounds like a good idea.

Shiraz
