Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58699356032
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245377AbhDGAS4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Apr 2021 20:18:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:61043 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241990AbhDGASy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:18:54 -0400
IronPort-SDR: ivwexgUIdWF2Zw6pl6tQG5fQq1KTwpNSWOEP7UNgyws79MJ/Isn6HIKCSoBZFJUsoV5la3Mvm5
 PXeWxxiB3MTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="173263528"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="173263528"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:18:45 -0700
IronPort-SDR: R84kVeu+UL5qkjO4zwChz5f/bWaR+4ALyHvRo7CXmPWukveX7ACDk2sCVeLNc1s8MClYlbWKXC
 ZfZ6Lr024fXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="598145103"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 06 Apr 2021 17:18:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 17:18:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 17:18:43 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Tue, 6 Apr 2021 17:18:43 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Topic: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Index: AQHXKyghWxg1YMB540GtculmvcetP6qolJkA//+MQXCAAA95YA==
Date:   Wed, 7 Apr 2021 00:18:43 +0000
Message-ID: <9b14e89ed2d54f5581deb147a0ae4505@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406231550.GB7405@nvidia.com>
 <be8b420a3fa844ed94d80f5a6c65acaf@intel.com>
In-Reply-To: <be8b420a3fa844ed94d80f5a6c65acaf@intel.com>
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

> Subject: RE: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
> (irdma)
> 
> > Subject: Re: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for
> > RDMA
> > (irdma)
> >
> > On Tue, Apr 06, 2021 at 04:01:02PM -0500, Shiraz Saleem wrote:
> > > Dave Ertman (4):
> > >   iidc: Introduce iidc.h
> > >   ice: Initialize RDMA support
> > >   ice: Implement iidc operations
> > >   ice: Register auxiliary device to provide RDMA
> > >
> > > Michael J. Ruhl (1):
> > >   RDMA/irdma: Add dynamic tracing for CM
> > >
> > > Mustafa Ismail (13):
> > >   RDMA/irdma: Register auxiliary driver and implement private channel
> > >     OPs
> > >   RDMA/irdma: Implement device initialization definitions
> > >   RDMA/irdma: Implement HW Admin Queue OPs
> > >   RDMA/irdma: Add HMC backing store setup functions
> > >   RDMA/irdma: Add privileged UDA queue implementation
> > >   RDMA/irdma: Add QoS definitions
> > >   RDMA/irdma: Add connection manager
> > >   RDMA/irdma: Add PBLE resource manager
> > >   RDMA/irdma: Implement device supported verb APIs
> > >   RDMA/irdma: Add RoCEv2 UD OP support
> > >   RDMA/irdma: Add user/kernel shared libraries
> > >   RDMA/irdma: Add miscellaneous utility definitions
> > >   RDMA/irdma: Add ABI definitions
> > >
> > > Shiraz Saleem (5):
> > >   ice: Add devlink params support
> > >   i40e: Prep i40e header for aux bus conversion
> > >   i40e: Register auxiliary devices to provide RDMA
> > >   RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw
> > >   RDMA/irdma: Update MAINTAINERS file
> >
> > This doesn't apply, and I don't really know why:
> >
> > Applying: iidc: Introduce iidc.h
> > Applying: ice: Initialize RDMA support
> > Applying: ice: Implement iidc operations
> > Applying: ice: Register auxiliary device to provide RDMA
> > Applying: ice: Add devlink params support
> > Applying: i40e: Prep i40e header for aux bus conversion
> > Applying: i40e: Register auxiliary devices to provide RDMA
> > Applying: RDMA/irdma: Register auxiliary driver and implement private
> > channel OPs
> > Applying: RDMA/irdma: Implement device initialization definitions
> > Applying: RDMA/irdma: Implement HW Admin Queue OPs
> > Applying: RDMA/irdma: Add HMC backing store setup functions
> > Applying: RDMA/irdma: Add privileged UDA queue implementation
> > Applying: RDMA/irdma: Add QoS definitions
> > Applying: RDMA/irdma: Add connection manager
> > Applying: RDMA/irdma: Add PBLE resource manager
> > Applying: RDMA/irdma: Implement device supported verb APIs
> > Applying: RDMA/irdma: Add RoCEv2 UD OP support
> > Applying: RDMA/irdma: Add user/kernel shared libraries
> > Applying: RDMA/irdma: Add miscellaneous utility definitions
> > Applying: RDMA/irdma: Add dynamic tracing for CM
> > Applying: RDMA/irdma: Add ABI definitions
> > Applying: RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw
> > Using index info to reconstruct a base tree...
> > error: removal patch leaves file contents
> > error: drivers/infiniband/hw/i40iw/Kconfig: patch does not apply
> >
> > Can you investigate and fix it? Perhaps using a 9 year old version of
> > git is the problem?
> >
> 
> Hi Jason - I think its because I used --irreversible-delete flag in git format-patch for
> review that this one doesn't apply.
> 
> I can resend without it if your trying to apply.
> 

I resend it without using --irreversible-delete. Hopefully, it applies cleanly now.
