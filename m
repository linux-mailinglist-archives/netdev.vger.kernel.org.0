Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217A2355F79
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344586AbhDFXaj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Apr 2021 19:30:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:29081 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344418AbhDFXae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:30:34 -0400
IronPort-SDR: CNRnsIpyetkI6VjoOIHoh7qbbu2z3lQuF4KH27s/ehK674rBZKjB86PS20bGWxsEC1fybDOtQT
 +DP8Y03lrp+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="254512708"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="254512708"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 16:30:25 -0700
IronPort-SDR: OlwFKWXR4GKH/wqcB/R+3F0cE3WcEw6MfELYrLKlf4CoNj8MvK7KxctH413A3QTf3frGJLx5Zv
 h44eBY57eNGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="441106637"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Apr 2021 16:30:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 16:30:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 16:30:24 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Tue, 6 Apr 2021 16:30:24 -0700
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
Thread-Index: AQHXKyghWxg1YMB540GtculmvcetP6qolJkA//+MQXA=
Date:   Tue, 6 Apr 2021 23:30:23 +0000
Message-ID: <be8b420a3fa844ed94d80f5a6c65acaf@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406231550.GB7405@nvidia.com>
In-Reply-To: <20210406231550.GB7405@nvidia.com>
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

> Subject: Re: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
> (irdma)
> 
> On Tue, Apr 06, 2021 at 04:01:02PM -0500, Shiraz Saleem wrote:
> > Dave Ertman (4):
> >   iidc: Introduce iidc.h
> >   ice: Initialize RDMA support
> >   ice: Implement iidc operations
> >   ice: Register auxiliary device to provide RDMA
> >
> > Michael J. Ruhl (1):
> >   RDMA/irdma: Add dynamic tracing for CM
> >
> > Mustafa Ismail (13):
> >   RDMA/irdma: Register auxiliary driver and implement private channel
> >     OPs
> >   RDMA/irdma: Implement device initialization definitions
> >   RDMA/irdma: Implement HW Admin Queue OPs
> >   RDMA/irdma: Add HMC backing store setup functions
> >   RDMA/irdma: Add privileged UDA queue implementation
> >   RDMA/irdma: Add QoS definitions
> >   RDMA/irdma: Add connection manager
> >   RDMA/irdma: Add PBLE resource manager
> >   RDMA/irdma: Implement device supported verb APIs
> >   RDMA/irdma: Add RoCEv2 UD OP support
> >   RDMA/irdma: Add user/kernel shared libraries
> >   RDMA/irdma: Add miscellaneous utility definitions
> >   RDMA/irdma: Add ABI definitions
> >
> > Shiraz Saleem (5):
> >   ice: Add devlink params support
> >   i40e: Prep i40e header for aux bus conversion
> >   i40e: Register auxiliary devices to provide RDMA
> >   RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw
> >   RDMA/irdma: Update MAINTAINERS file
> 
> This doesn't apply, and I don't really know why:
> 
> Applying: iidc: Introduce iidc.h
> Applying: ice: Initialize RDMA support
> Applying: ice: Implement iidc operations
> Applying: ice: Register auxiliary device to provide RDMA
> Applying: ice: Add devlink params support
> Applying: i40e: Prep i40e header for aux bus conversion
> Applying: i40e: Register auxiliary devices to provide RDMA
> Applying: RDMA/irdma: Register auxiliary driver and implement private channel
> OPs
> Applying: RDMA/irdma: Implement device initialization definitions
> Applying: RDMA/irdma: Implement HW Admin Queue OPs
> Applying: RDMA/irdma: Add HMC backing store setup functions
> Applying: RDMA/irdma: Add privileged UDA queue implementation
> Applying: RDMA/irdma: Add QoS definitions
> Applying: RDMA/irdma: Add connection manager
> Applying: RDMA/irdma: Add PBLE resource manager
> Applying: RDMA/irdma: Implement device supported verb APIs
> Applying: RDMA/irdma: Add RoCEv2 UD OP support
> Applying: RDMA/irdma: Add user/kernel shared libraries
> Applying: RDMA/irdma: Add miscellaneous utility definitions
> Applying: RDMA/irdma: Add dynamic tracing for CM
> Applying: RDMA/irdma: Add ABI definitions
> Applying: RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw Using index
> info to reconstruct a base tree...
> error: removal patch leaves file contents
> error: drivers/infiniband/hw/i40iw/Kconfig: patch does not apply
> 
> Can you investigate and fix it? Perhaps using a 9 year old version of git is the
> problem?
> 

Hi Jason - I think its because I used --irreversible-delete flag in git format-patch for review that this one doesn't apply.

I can resend without it if your trying to apply.

Shiraz
