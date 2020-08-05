Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2463123CBDA
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 17:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHEPxq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Aug 2020 11:53:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:14531 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgHEPsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 11:48:41 -0400
IronPort-SDR: LIaqkVMK65rXcttfhngsb3Otfr6ifsH1TH4QEuMbWPS4MJF9id+2J7BgxAkw1ezDBHD4QJY2wq
 rvAMTk6ulh5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="151790225"
X-IronPort-AV: E=Sophos;i="5.75,438,1589266800"; 
   d="scan'208";a="151790225"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 08:47:18 -0700
IronPort-SDR: 8c97S6oG1c5/FzKs8CVNTVfVFzvsJCPyLWYS7DF5jbHsTsp9THDuY4hdv7NXYTmM8f483Kjcds
 LX+RZXdftZXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,438,1589266800"; 
   d="scan'208";a="323136325"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 05 Aug 2020 08:47:18 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 08:47:18 -0700
Received: from fmsmsx103.amr.corp.intel.com (10.18.124.201) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 5 Aug 2020 08:47:18 -0700
Received: from fmsmsx101.amr.corp.intel.com ([169.254.1.197]) by
 FMSMSX103.amr.corp.intel.com ([169.254.2.6]) with mapi id 14.03.0439.000;
 Wed, 5 Aug 2020 08:47:17 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 net-next] ptp: only allow phase values lower than 1
 period
Thread-Topic: [PATCH v3 net-next] ptp: only allow phase values lower than 1
 period
Thread-Index: AQHWarzlFtTN9TVx00mP5hg/wMvsTakpObWAgABwH3A=
Date:   Wed, 5 Aug 2020 15:47:17 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58C8B400D7@fmsmsx101.amr.corp.intel.com>
References: <20200805001047.1372299-1-olteanv@gmail.com>
 <20200805020541.GA1603@hoboy>
In-Reply-To: <20200805020541.GA1603@hoboy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, August 04, 2020 7:06 PM
> To: Vladimir Oltean <olteanv@gmail.com>
> Cc: kuba@kernel.org; davem@davemloft.net; netdev@vger.kernel.org; Keller,
> Jacob E <jacob.e.keller@intel.com>
> Subject: Re: [PATCH v3 net-next] ptp: only allow phase values lower than 1
> period
> 
> On Wed, Aug 05, 2020 at 03:10:47AM +0300, Vladimir Oltean wrote:
> > The way we define the phase (the difference between the time of the
> > signal's rising edge, and the closest integer multiple of the period),
> > it doesn't make sense to have a phase value equal or larger than 1
> > period.
> >
> > So deny these settings coming from the user.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Acked-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks!
