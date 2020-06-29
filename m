Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B948520E926
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgF2XNa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jun 2020 19:13:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:15324 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgF2XNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:13:30 -0400
IronPort-SDR: riSHhY+paipn6zx3cv4g7/mqJoCjdNMfM3u91ENFQSMnyPo5t3mj27Rkz35CW0I0R/wqwKfgMl
 e5TKwi9vhoMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="230947114"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="230947114"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:13:29 -0700
IronPort-SDR: RAjKt3WZpFXx7hlBV7yLxlW8MF8VY5sxzDH2OkYePH/FJ1yuAlD9ozl6M72YlAIAPqFyctJiR1
 6ng62zwRVNEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="480957969"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jun 2020 16:13:28 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 16:13:28 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.100]) with mapi id 14.03.0439.000;
 Mon, 29 Jun 2020 16:13:28 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Mark Brown <broonie@kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Ranjani Sridharan" <ranjani.sridharan@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Fred Oh <fred.oh@linux.intel.com>
Subject: RE: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Thread-Topic: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Thread-Index: AQHWLnSiAGSTMkhab0e5z+5I+qwHCaixZBKAgAIdMYCAACf0gIAA+ieAgAEKhICAAN72gIAAtpOAgAOUdACAAAYyAIABKCWAgDS7Q4CAACj9gP//jcrw
Date:   Mon, 29 Jun 2020 23:13:27 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449874174D@ORSMSX112.amr.corp.intel.com>
References: <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de> <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk> <20200629225959.GF25301@ziepe.ca>
In-Reply-To: <20200629225959.GF25301@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, June 29, 2020 16:00
> To: Mark Brown <broonie@kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>; Takashi Iwai <tiwai@suse.de>;
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>; Ranjani Sridharan
> <ranjani.sridharan@linux.intel.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; davem@davemloft.net; netdev@vger.kernel.org;
> linux-rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Fred Oh <fred.oh@linux.intel.com>
> Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
> client
> 
> On Mon, Jun 29, 2020 at 09:33:17PM +0100, Mark Brown wrote:
> > On Wed, May 27, 2020 at 09:17:33AM +0200, Greg KH wrote:
> >
> > > Ok, that's good to hear.  But platform devices should never be
> > > showing up as a child of a PCI device.  In the "near future" when we
> > > get the virtual bus code merged, we can convert any existing users
> > > like this to the new code.
> >
> > What are we supposed to do with things like PCI attached FPGAs and
> > ASICs in that case?  They can have host visible devices with physical
> > resources like MMIO ranges and interrupts without those being split up
> > neatly as PCI subfunctions - the original use case for MFD was such
> > ASICs, there's a few PCI drivers in there now.
> 
> Greg has been pretty clear that MFD shouldn't have been used on top of PCI
> drivers.
> 
> In a sense virtual bus is pretty much MFD v2.
 
With the big distinction that MFD uses Platform bus/devices, which is why we could not
use MFD as a solution, and virtbus does not.
