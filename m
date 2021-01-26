Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5AD304933
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbhAZFaf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Jan 2021 00:30:35 -0500
Received: from mga04.intel.com ([192.55.52.120]:57661 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387444AbhAZBXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 20:23:34 -0500
IronPort-SDR: y6EdSbsaz0j2wzKnucobQ5lGuonX7ogTGphXTKKL0M/sNUlyp6EYet/l+ChfS/zNWiWxK8uDoF
 uT3hdaH+rekQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="177259154"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="177259154"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 16:39:31 -0800
IronPort-SDR: UFltnYhMIF/tkSPWoLT+wGl5BHLvhVcaNBCMdw65nOZrNhriQ9mwhV52erjzO9SGre+jE6iQoC
 q0wTSG80CYZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="387603178"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2021 16:39:30 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 Jan 2021 16:39:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 Jan 2021 16:39:28 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Mon, 25 Jan 2021 16:39:28 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH 00/22] Add Intel Ethernet Protocol Driver for RDMA (irdma)
Thread-Topic: [PATCH 00/22] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Index: AQHW8RlOsEzaH1e1e0ivdRpCP+D5nao5OEaA//9+pPA=
Date:   Tue, 26 Jan 2021 00:39:28 +0000
Message-ID: <c1dfc28b01014bf3a46cb8acb83bd102@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210125184459.GT4147@nvidia.com>
In-Reply-To: <20210125184459.GT4147@nvidia.com>
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

> Subject: Re: [PATCH 00/22] Add Intel Ethernet Protocol Driver for RDMA (irdma)
> 
> On Fri, Jan 22, 2021 at 05:48:05PM -0600, Shiraz Saleem wrote:
> > From: "Shiraz, Saleem" <shiraz.saleem@intel.com>
> >
> > The following patch series introduces a unified Intel Ethernet
> > Protocol Driver for RDMA (irdma) for the X722 iWARP device and a new
> > E810 device which supports iWARP and RoCEv2. The irdma driver replaces
> > the legacy i40iw driver for X722 and extends the ABI already defined
> > for i40iw. It is backward compatible with legacy X722 rdma-core provider
> (libi40iw).
> >
> > X722 and E810 are PCI network devices that are RDMA capable. The RDMA
> > block of this parent device is represented via an auxiliary device exported to
> 'irdma'
> > using the core auxiliary bus infrastructure recently added for 5.11 kernel.
> > The parent PCI netdev drivers 'i40e' and 'ice' register auxiliary RDMA
> > devices with private data/ops encapsulated that bind to an 'irdma' auxiliary
> driver.
> >
> > This series is a follow on to an RFC series [1]. This series was built
> > against rdma for-next and currently includes the netdev patches for ease of
> review.
> > This include updates to 'ice' driver to provide RDMA support and converts 'i40e'
> > driver to use the auxiliary bus infrastructure .
> >
> > Once the patches are closer to merging, this series will be split into
> > a netdev-next and rdma-next patch series targeted at their respective
> > subsystems with Patch #1 and Patch #5 included in both. This is the
> > shared header file that will allow each series to independently compile.
> >
> > [1]
> > https://lore.kernel.org/linux-rdma/20200520070415.3392210-1-jeffrey.t.
> > kirsher@intel.com/
> >
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
> >   RDMA/irdma: Register an auxiliary driver and implement private channel
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
> 
> I didn't check, but I will remind you to compile with make W=1 and ensure this is all
> clean. Lee is doing good work making RDMA clean for W=1.
> 

Yes. That is done.
