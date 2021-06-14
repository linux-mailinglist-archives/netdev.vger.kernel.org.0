Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524753A6F73
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbhFNTwj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Jun 2021 15:52:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:39773 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235102AbhFNTw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:52:29 -0400
IronPort-SDR: SqbJN+FMis6zZ+LfquvACUor4o8nMdTsrtDY1OSzfuvopVf3P6aO2l608tPJ9+EZFnw03c2gD0
 nsfkStVTlV+Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="186242439"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="186242439"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 12:50:25 -0700
IronPort-SDR: vmKasSbYOrQCFT4j1Z2c+KV70aAT3ZJ5O74gqAb/XDnHXmuJu48zRy3C3XIVmy9oIPONhnrA7W
 S5XDK0+zP5hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="449999421"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2021 12:50:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 14 Jun 2021 12:50:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 14 Jun 2021 12:50:23 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.008;
 Mon, 14 Jun 2021 12:50:23 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: RE: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Thread-Topic: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Thread-Index: AQHXXt1GjtCxh0EytkiNcK+MTFGqUasPxiEAgAQFqICAAHxlgP//pp6Q
Date:   Mon, 14 Jun 2021 19:50:23 +0000
Message-ID: <427ddb2579f14d77b537aae9c2fa9759@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
        <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
        <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
 <20210614110831.65d21c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210614110831.65d21c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> Sent: Monday, June 14, 2021 11:09 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Richard Cochran
> <richardcochran@gmail.com>; davem@davemloft.net; netdev@vger.kernel.org;
> sassmann@redhat.com; Brelinski, TonyX <tonyx.brelinski@intel.com>
> Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object for
> E810 devices
> 
> On Mon, 14 Jun 2021 09:43:17 -0700 Jacob Keller wrote:
> > >> +static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
> > >> +{
> > >> +	struct ice_pf *pf = ptp_info_to_pf(info);
> > >> +	u64 freq, divisor = 1000000ULL;
> > >> +	struct ice_hw *hw = &pf->hw;
> > >> +	s64 incval, diff;
> > >> +	int neg_adj = 0;
> > >> +	int err;
> > >> +
> > >> +	incval = ICE_PTP_NOMINAL_INCVAL_E810;
> > >> +
> > >> +	if (scaled_ppm < 0) {
> > >> +		neg_adj = 1;
> > >> +		scaled_ppm = -scaled_ppm;
> > >> +	}
> > >> +
> > >> +	while ((u64)scaled_ppm > div_u64(U64_MAX, incval)) {
> > >> +		/* handle overflow by scaling down the scaled_ppm and
> > >> +		 * the divisor, losing some precision
> > >> +		 */
> > >> +		scaled_ppm >>= 2;
> > >> +		divisor >>= 2;
> > >> +	}
> > >
> > > I have a question regarding ppm overflows.
> > >
> > > We have the max_adj field in struct ptp_clock_info which is checked
> > > against ppb, but ppb is a signed 32 bit and scaled_ppm is a long,
> > > meaning values larger than S32_MAX << 16 / 1000 will overflow
> > > the ppb calculation, and therefore the check.
> >
> > Hmmm.. I thought ppb was a s64, not an s32.
> >
> > In general, I believe max_adj is usually capped at 1 billion anyways,
> > since it doesn't make sense to slow a clock by more than 1billioln ppb,
> > and increasing it more than that isn't really useful either.
> 
> Do you mean it's capped somewhere in the code to 1B?
> 
> I'm no time expert but this is not probability where 1 is a magic
> value, adjusting clock by 1 - 1ppb vs 1 + 1ppb makes little difference,
> no? Both mean something is super fishy with the nominal or expected
> frequency, but the hardware can do that and more.
> 
> Flipping the question, if adjusting by large ppb values is not correct,
> why not cap the adjustment at the value which would prevent the u64
> overflow?

Large ppb values are sometimes used when you want to slew a clock to bring it in sync when its a few milliseconds to seconds off, without performing a time jump (so that you maintain monotonic increasing time).

That being said, we are supposed to be checking max_adj, except that you're right the conversion to ppb could overflow, and there's no check prior to the conversion from scaled_ppm to ppb.

> 
> I don't really have a preferences here, I'm mostly disturbed by
> the overflow in the ppb vs max_adj check.
> 
> > > Are we okay with that? Is my math off? Did I miss some part
> > > of the kernel which filters crazy high scaled_ppm/freq?
> > >
> > > Since dialed_freq is updated regardless of return value of .adjfine
> > > the driver has no clear way to reject bad scaled_ppm>
> >
> > I'm not sure. +Richard?
