Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBD739A48B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFCP3w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Jun 2021 11:29:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:4862 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhFCP3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 11:29:51 -0400
IronPort-SDR: g9J5YT1KzZXtPEXFwjdU7ncGX7MshcRybRH253t7gEtclWPNLbVXY6Jh4cc3z2rEOtEzBt01Hz
 fBaSfExFPmcQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="265239006"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="265239006"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 08:28:06 -0700
IronPort-SDR: s7ugCr/3xn7nn4tlKgh/Ps80/V2DE04BkfH3dGLtTIMAJEc+ALmsfUUZwRSaQMUeMkLFDVc0Ju
 aqjjCiyVKaTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="636275289"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jun 2021 08:28:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 08:28:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 08:28:05 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2242.008;
 Thu, 3 Jun 2021 08:28:05 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
Subject: RE: [PATCH v7 00/16] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Topic: [PATCH v7 00/16] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Index: AQHXV/FDG6bKRhKrD0umWvGqP6xLmasBz7SA//+QAWA=
Date:   Thu, 3 Jun 2021 15:28:04 +0000
Message-ID: <362328112f414b6ca0cd06b5ca4baea2@intel.com>
References: <20210602205138.889-1-shiraz.saleem@intel.com>
 <20210602231505.GA188443@nvidia.com>
In-Reply-To: <20210602231505.GA188443@nvidia.com>
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

> Subject: Re: [PATCH v7 00/16] Add Intel Ethernet Protocol Driver for RDMA
> (irdma)
> 
> On Wed, Jun 02, 2021 at 03:51:22PM -0500, Shiraz Saleem wrote:
> > The following patch series introduces a unified Intel Ethernet
> > Protocol Driver for RDMA (irdma) for the X722 iWARP device and a new
> > E810 device which supports iWARP and RoCEv2. The irdma module replaces
> > the legacy i40iw module for X722 and extends the ABI already defined
> > for i40iw. It is backward compatible with legacy X722 rdma-core provider
> (libi40iw).
> >
> > X722 and E810 are PCI network devices that are RDMA capable. The RDMA
> > block of this parent device is represented via an auxiliary device exported to
> 'irdma'
> > using the core auxiliary bus infrastructure recently added for 5.11 kernel.
> > The parent PCI netdev drivers 'i40e' and 'ice' register auxiliary RDMA
> > devices with private data/ops encapsulated that bind to auxiliary
> > drivers registered in irdma module.
> >
> > Currently, default is RoCEv2 for E810. Runtime support for protocol
> > switch to iWARP will be made available via devlink in a future patch.
> >
> > This rdma series is built against the shared branch iwl-next [1] which
> > is expected to be merged into rdma-next first for the netdev parts.
> 
> Okay, applied to for-next, please keep on top of any 0-day stuff that comes out. I
> need it all fixed in 2 weeks
> 

Sure.

Tatyana is out till June 7th, so I sent a new PR for the user-space bit with the updated kernel headers commit.

Shiraz
