Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8805438B8E6
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 23:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhETVTU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 May 2021 17:19:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:19453 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhETVTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 17:19:19 -0400
IronPort-SDR: VXSlu6l+90tFyqfU7xmiieiAJrjMGAjCZKR4gNxO6G4AcaRqSePgCMbYnPWcnNXcwKYgk5whRp
 qnvUvFyqUrAA==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="265252802"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="265252802"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 14:17:45 -0700
IronPort-SDR: 5qP8ALGYrDiw0UFI9U++VIFR4pUgo1ORKlskViqNzFfkhCiBhyGac8bwBIVJofTFz7tq+kBgn5
 cL2iI2QxM8QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="474210956"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 20 May 2021 14:17:45 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 20 May 2021 14:17:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 20 May 2021 14:17:44 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2242.008;
 Thu, 20 May 2021 14:17:44 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
Subject: RE: [PATCH v6 00/22] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Topic: [PATCH v6 00/22] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Index: AQHXTYXiXzxdtSbvXk+1moyi7tDMtKrtQLAA//+Qm2A=
Date:   Thu, 20 May 2021 21:17:43 +0000
Message-ID: <6ed0e6eed0b54dff84d831aa854b0df2@intel.com>
References: <20210520143809.819-1-shiraz.saleem@intel.com>
 <20210520200326.GX1096940@ziepe.ca>
In-Reply-To: <20210520200326.GX1096940@ziepe.ca>
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

> Subject: Re: [PATCH v6 00/22] Add Intel Ethernet Protocol Driver for RDMA
> (irdma)
> 
> On Thu, May 20, 2021 at 09:37:47AM -0500, Shiraz Saleem wrote:
> 
> > This series is built against 5.13-rc1 and currently includes the
> > netdev patches for ease of review. This includes updates to 'ice'
> > driver to provide RDMA support and converts 'i40e' driver to use the auxiliary
> bus infrastructure.
> > A shared pull request can be submitted once the community ACKs this
> submission.
> 
> Other than the one note I think I am fine with this now, but it is absolutely huge.
> 
> The rdma-core part needs to be put as a PR to the github, and I haven't looked at
> that yet. The current provider will work with this driver, yes?

Yes.

Tatyana will send a PR on github for new rdma-core provider.

> 
> Next you need to get the first 6 ethernet i40e patches onto a git branch based on
> v5.13-rc1 for Dave/Jakub to pull. Resend a v7 of just the rdma parts once netdev's
> part is accepted and I'll sort out the last steps for the rdma part.

OK.
