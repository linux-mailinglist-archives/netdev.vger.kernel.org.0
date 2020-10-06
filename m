Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90075285121
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 19:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgJFRpw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Oct 2020 13:45:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:29297 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJFRpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 13:45:50 -0400
IronPort-SDR: 5zxbtfxqBv1h0t6H6lVh7fVtMWJmGaGfaNcv/Fws6tbBrpekXOZ1/PUdxz9ONLm9aYpKwxxS5u
 t/SLM4+fijGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="151530378"
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="151530378"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 10:45:46 -0700
IronPort-SDR: p2zLtZq8QrsYooxe9aWXVEy0jeqWU1a5IsPjcCtcmiCTScD85iGD5A25ihB/Cz66yPNTT2kM5w
 xJ+Nj42tuFCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="460905673"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 06 Oct 2020 10:45:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Oct 2020 10:45:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Oct 2020 10:45:42 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 6 Oct 2020 10:45:41 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm0x+bCEx5k0iU0+RSRzmm941iKmLSYGA//+QDSA=
Date:   Tue, 6 Oct 2020 17:45:41 +0000
Message-ID: <b78f8cc808204ce58c52a38139146b35@intel.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006172317.GN1874917@unreal>
In-Reply-To: <20201006172317.GN1874917@unreal>
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
> On Mon, Oct 05, 2020 at 11:24:41AM -0700, Dave Ertman wrote:
> > Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> > It enables drivers to create an ancillary_device and bind an
> > ancillary_driver to it.
> >
> > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > Each ancillary_device has a unique string based id; driver binds to an
> > ancillary_device based on this id through the bus.
> >
> > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > Reviewed-by: Pierre-Louis Bossart
> > <pierre-louis.bossart@linux.intel.com>
> > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > ---
> 
> <...>
> 
> > +/**
> > + * __ancillary_driver_register - register a driver for ancillary bus
> > +devices
> > + * @ancildrv: ancillary_driver structure
> > + * @owner: owning module/driver
> > + */
> > +int __ancillary_driver_register(struct ancillary_driver *ancildrv,
> > +struct module *owner) {
> > +	if (WARN_ON(!ancildrv->probe) || WARN_ON(!ancildrv->remove) ||
> > +	    WARN_ON(!ancildrv->shutdown) || WARN_ON(!ancildrv->id_table))
> > +		return -EINVAL;
> 
> In our driver ->shutdown is empty, it will be best if ancillary bus will do "if (-
> >remove) ..->remove()" pattern.
> 
I prefer that too if its possible. We will look into it.
