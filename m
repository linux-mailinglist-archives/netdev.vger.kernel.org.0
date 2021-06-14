Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5F3A6F64
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhFNTuh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Jun 2021 15:50:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:42609 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234640AbhFNTuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:50:35 -0400
IronPort-SDR: xhdJRmMxWhfe1W15uhBZIG9MvqcZYwqTnVY2t1NdcZREDwVqQOnrdYMlwStYno+tBs0Gs0WmEi
 TTMoVr5E/AuA==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="185562901"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="185562901"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 12:48:29 -0700
IronPort-SDR: l7QvEWg6NRDbubJwLGjocFvtLUbn5E24xe1pM5yq+oQFQFUSRv/Hm0Ah42hP30pZK2tLz1cXTP
 vNuOBgGUK+Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="449999068"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2021 12:48:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 14 Jun 2021 12:48:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 14 Jun 2021 12:48:28 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.008;
 Mon, 14 Jun 2021 12:48:28 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: RE: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Thread-Topic: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Thread-Index: AQHXXt1GjtCxh0EytkiNcK+MTFGqUasPxiEAgAQFqICAAH12AIAACrqA//+ahEA=
Date:   Mon, 14 Jun 2021 19:48:28 +0000
Message-ID: <95887203e7094ffea2306c2130c2b7d6@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
        <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
        <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
        <20210614181218.GA7788@localhost>
 <20210614115043.4e2b48da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210614115043.4e2b48da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, June 14, 2021 11:51 AM
> To: Richard Cochran <richardcochran@gmail.com>
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> netdev@vger.kernel.org; sassmann@redhat.com; Brelinski, TonyX
> <tonyx.brelinski@intel.com>
> Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object for
> E810 devices
> 
> On Mon, 14 Jun 2021 11:12:20 -0700 Richard Cochran wrote:
> > On Mon, Jun 14, 2021 at 09:43:17AM -0700, Jacob Keller wrote:
> > > > Since dialed_freq is updated regardless of return value of .adjfine
> > > > the driver has no clear way to reject bad scaled_ppm>
> > >
> > > I'm not sure. +Richard?
> >
> > The driver advertises "max_adj".  The PHC layer checks user space inputs:
> >
> > ptp_clock.c line 140:
> > 	} else if (tx->modes & ADJ_FREQUENCY) {
> > 		s32 ppb = scaled_ppm_to_ppb(tx->freq);
> > 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
> > 			return -ERANGE;
> >
> > So, if the max_adj is correct for the driver/HW, then all is well.
> 
> tx->freq is a long, and the conversion to ppb can overflow the s32 type.
> E.g. 281474976645 will become -2 AFAICT. I hacked up phc_ctl to not do
> range checking and kernel happily accepted that value. Shall we do this?
> 
> --->8----
> 
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index 03a246e60fd9..ed32fc98d9d8 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -63,7 +63,7 @@ static void enqueue_external_timestamp(struct
> timestamp_event_queue *queue,
>         spin_unlock_irqrestore(&queue->lock, flags);
>  }
> 
> -s32 scaled_ppm_to_ppb(long ppm)
> +s64 scaled_ppm_to_ppb(long ppm)
>  {
>         /*
>          * The 'freq' field in the 'struct timex' is in parts per
> @@ -80,7 +80,7 @@ s32 scaled_ppm_to_ppb(long ppm)
>         s64 ppb = 1 + ppm;
>         ppb *= 125;
>         ppb >>= 13;
> -       return (s32) ppb;
> +       return ppb;
>  }
>  EXPORT_SYMBOL(scaled_ppm_to_ppb);
> 
> @@ -138,7 +138,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct
> __kernel_timex *tx)
>                 delta = ktime_to_ns(kt);
>                 err = ops->adjtime(ops, delta);
>         } else if (tx->modes & ADJ_FREQUENCY) {
> -               s32 ppb = scaled_ppm_to_ppb(tx->freq);
> +               s64 ppb = scaled_ppm_to_ppb(tx->freq);
>                 if (ppb > ops->max_adj || ppb < -ops->max_adj)
>                         return -ERANGE;
>                 if (ops->adjfine)

This looks correct to me.
