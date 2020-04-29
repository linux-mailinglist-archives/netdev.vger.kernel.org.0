Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C301BE9EC
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgD2VbD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Apr 2020 17:31:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:42138 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgD2VbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 17:31:03 -0400
IronPort-SDR: /1LZV5ntrsPctbfPl9nGC50uEW4P4O/PY/+SUlHoI/E1QyRTRQzWEcg6ZIWj4QMJVI9EHVHFrt
 rux5Egd6VHHA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 14:30:43 -0700
IronPort-SDR: 9JewxBjfjY15Rd/XnC/GlJxi+8m5dKH+KaL2XgyQPckQVsCYe8baAS6hjX4xBgcoCG4RoONz2Q
 Dd38l96k2FjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="367930872"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga001.fm.intel.com with ESMTP; 29 Apr 2020 14:30:43 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 29 Apr 2020 14:30:43 -0700
Received: from fmsmsx102.amr.corp.intel.com ([169.254.10.190]) by
 FMSMSX151.amr.corp.intel.com ([169.254.7.87]) with mapi id 14.03.0439.000;
 Wed, 29 Apr 2020 14:30:43 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH net-next] devlink: let kernel allocate region snapshot id
Thread-Topic: [PATCH net-next] devlink: let kernel allocate region snapshot
 id
Thread-Index: AQHWHceR29w0a4iV6kCQcvF+ImGWRqiQDKwAgAAr4oCAAIq1gP//29OA
Date:   Wed, 29 Apr 2020 21:30:43 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B6CF81A0@FMSMSX102.amr.corp.intel.com>
References: <20200429014248.893731-1-kuba@kernel.org>
        <20200429054552.GB6581@nanopsycho.orion>
        <02874ECE860811409154E81DA85FBB58B6CF7AFF@FMSMSX102.amr.corp.intel.com>
 <20200429093923.394c7c1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200429093923.394c7c1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, April 29, 2020 9:39 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; davem@davemloft.net; netdev@vger.kernel.org;
> kernel-team@fb.com
> Subject: Re: [PATCH net-next] devlink: let kernel allocate region snapshot id
> 
> On Wed, 29 Apr 2020 15:34:30 +0000 Keller, Jacob E wrote:
> > > How the output is going to looks like it this or any of the follow-up
> > > calls in this function are going to fail?
> > >
> > > I guess it is going to be handled gracefully in the userspace app,
> > > right?
> >
> > I'm wondering what the issue is with just waiting to send the
> > snapshot id back until after this succeeds. Is it just easier to keep
> > it near the allocation?
> 
> I just wasn't happy with the fact that the response send may fail.
> So it just seems like better protocol from the start to expect user
> space to pay attention to the error code at the end, before it takes
> action on the response.

Ok that seems reasonable to me.

Can we get documentation updates for this?

Thanks,
Jake
