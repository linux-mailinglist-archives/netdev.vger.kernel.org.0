Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972C51EC55D
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgFBW7s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Jun 2020 18:59:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:11992 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgFBW7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 18:59:48 -0400
IronPort-SDR: LoPCPWnEyR1urLYnV8i18uqA6cFPFGF+bR0YIIYHZa2SnG1562/ZlugTXcc9or/2AMpOvKj+VR
 WyHDrdzNMdfA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 15:59:48 -0700
IronPort-SDR: fJn/aZ8iK/PsOq6sdhpg597V3t7fiYdWeE6tk3Bc00X0fCnpUPTZA8G20bGcpeAXbUBfvv5qCF
 heJFMjRc3+nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,466,1583222400"; 
   d="scan'208";a="304173342"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jun 2020 15:59:47 -0700
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 2 Jun 2020 15:59:47 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.63]) by
 fmsmsx118.amr.corp.intel.com ([169.254.1.174]) with mapi id 14.03.0439.000;
 Tue, 2 Jun 2020 15:59:46 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>
Subject: RE: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
Thread-Topic: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
Thread-Index: AQHWL3n2Pw6kzLOq1Ui4t0VQsTHX2qi6bFjAgAFz44CAAjb+0IAGQQ8AgAFIiQA=
Date:   Tue, 2 Jun 2020 22:59:46 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7EE04CC42@fmsmsx124.amr.corp.intel.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200521141247.GQ24561@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7EE04047F@fmsmsx124.amr.corp.intel.com>
 <20200527050855.GB349682@unreal>
 <9DD61F30A802C4429A01CA4200E302A7EE045C3B@fmsmsx124.amr.corp.intel.com>
 <20200601142840.GE4962@mellanox.com>
In-Reply-To: <20200601142840.GE4962@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
> 
> On Fri, May 29, 2020 at 03:21:05PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates
> > > 2020-05-19
> > >
> >
> > [......]
> >
> > >
> > > I'm looking on it and see static assignments, to by dynamic you will need "to
> play"
> > > with hw_shifts/hw_masks later, but you don't. What am I missing?
> > >
> > > +	for (i = 0; i < IRDMA_MAX_SHIFTS; ++i)
> > > +		dev->hw_shifts[i] = i40iw_shifts[i];
> > > +
> > > +	for (i = 0; i < IRDMA_MAX_MASKS; ++i)
> > > +		dev->hw_masks[i] = i40iw_masks[i];
> > >
> > > >
> > > > we still need to use the custom macro FLD_LS_64 without FIELD_PREP
> > > > in this case as FIELD_PREP expects compile time constants.
> > > > +#define FLD_LS_64(dev, val, field)	\
> > > > +	(((u64)(val) << (dev)->hw_shifts[field ## _S]) &
> > > > +(dev)->hw_masks[field ## _M])
> > > > And the shifts are still required for these fields which causes a
> > > > bit of inconsistency
> > > >
> >
> >
> > The device hw_masks/hw_shifts array store masks/shifts of those
> > descriptor fields that have same name across HW generations but differ
> > in some attribute such as field width. Yes they are statically
> > assigned, initialized with values from i40iw_masks and icrdma_masks,
> > depending on the HW generation. We can even use GENMASK for the values
> > in i40iw_masks[] , icrdma_masks[] but FIELD_PREP cant be used on
> > dev->hw_masks[]
> 
> So compute the shift and mask when building i40iw_shifts array using the compile
> time constant?
> 

i40iw_shifts[] and i40iw_mask[] are setup as compile constants
and used to initialize dev->hw_masks[], dev->hw_shifts[] if the device is gen1.
I still don't see how FIELD_PREP can be used on a value and
dev->hw_masks[i].

