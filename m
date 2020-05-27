Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68401E3510
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgE0B5Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 21:57:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:33186 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgE0B5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:57:15 -0400
IronPort-SDR: 6Fji7UMXKzC2nLSfIl+KXmYDR4zlps7X8ooQ5A3xSH+SGNA1xTBIgijK3hnWY2QzeZ7jnqML+/
 G6nDafT8oQjQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 18:57:15 -0700
IronPort-SDR: wfAreKOQ2WR3TSypPbWRXW3FQmgaEgWzzC/fOcfibO7ebg63SGD2QGilS0ifnw+zZIVCNzFt+T
 Ct2qy6UDcbhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="256629084"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga008.fm.intel.com with ESMTP; 26 May 2020 18:57:15 -0700
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 18:57:14 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.63]) by
 fmsmsx101.amr.corp.intel.com ([169.254.1.249]) with mapi id 14.03.0439.000;
 Tue, 26 May 2020 18:57:14 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>
Subject: RE: [RDMA RFC v6 01/16] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RDMA RFC v6 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHWLnTiP10E/Z+6SEyWSLona0rC/KixCEuAgAI+WsA=
Date:   Wed, 27 May 2020 01:57:14 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7EE040448@fmsmsx124.amr.corp.intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-2-jeffrey.t.kirsher@intel.com>
 <20200520072609.GE2365898@kroah.com>
In-Reply-To: <20200520072609.GE2365898@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [RDMA RFC v6 01/16] RDMA/irdma: Add driver framework definitions
> 
> On Wed, May 20, 2020 at 12:04:00AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Register irdma as a platform driver capable of supporting platform
> > devices from multi-generation RDMA capable Intel HW. Establish the
> > interface with all supported netdev peer devices and initialize HW.
> 
> Um, this changelog text does not match up with the actual patch at all :(
> 
> {sigh}
> 
> And Intel developers wonder why I'm grumpy these days...
> 

Apologies :(
