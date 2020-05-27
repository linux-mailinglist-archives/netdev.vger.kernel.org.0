Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C51E351D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgE0B6U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 21:58:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:42453 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgE0B6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:58:19 -0400
IronPort-SDR: SoCC1puBUZD5ZGGfMRXrDBGlTAJgfw060MJd7zMKX73Fh03R8tKEHzmXIVir4T6rSMIUCeMb6D
 IQF63kiRR5vQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 18:58:19 -0700
IronPort-SDR: mDXG3KMwrj0GEbQCwuUN3MN+A/IVZpszY+s4Dwc5TeT8ZXZxJreODBQ5uk0D/rXugnkvrwIz/Z
 2IALXHl/SxPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="255329125"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga007.fm.intel.com with ESMTP; 26 May 2020 18:58:19 -0700
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 18:58:18 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.63]) by
 fmsmsx122.amr.corp.intel.com ([169.254.5.111]) with mapi id 14.03.0439.000;
 Tue, 26 May 2020 18:58:18 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Gal Pressman <galpress@amazon.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [RDMA RFC v6 16/16] RDMA/irdma: Update MAINTAINERS file
Thread-Topic: [RDMA RFC v6 16/16] RDMA/irdma: Update MAINTAINERS file
Thread-Index: AQHWLnTlyDOLqDRTOEW6y4JOM/BCS6ixDraAgAI4IpA=
Date:   Wed, 27 May 2020 01:58:18 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7EE040496@fmsmsx124.amr.corp.intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200520070415.3392210-17-jeffrey.t.kirsher@intel.com>
 <7a82fb8b-b16e-3b40-1d30-d9f52d0ff496@amazon.com>
In-Reply-To: <7a82fb8b-b16e-3b40-1d30-d9f52d0ff496@amazon.com>
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

> Subject: Re: [RDMA RFC v6 16/16] RDMA/irdma: Update MAINTAINERS file
> 
> On 20/05/2020 10:04, Jeff Kirsher wrote:
> > From: Shiraz Saleem <shiraz.saleem@intel.com>
> >
> > Add maintainer entry for irdma driver.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  MAINTAINERS | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS index
> > 598d0e1b3501..8b8e3e0064cf 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8745,6 +8745,14 @@ L:	linux-pm@vger.kernel.org
> >  S:	Supported
> >  F:	drivers/cpufreq/intel_pstate.c
> >
> > +INTEL ETHERNET PROTOCL DRIVER FOR RDMA
> > +M:	Mustafa Ismail <mustafa.ismail@intel.com>
> > +M:	Shiraz Saleem <shiraz.saleem@intel.com>
> > +L:	linux-rdma@vger.kernel.org
> > +S:	Supported
> > +F:	drivers/infiniband/hw/irdma/
> > +F:	include/uapi/rdma/irdma-abi.h
> 
> This list should be sorted alphabetically.
> 

Yes. Thanks!
