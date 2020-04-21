Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8181B1AA0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgDUAXr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 20:23:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:38122 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDUAXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 20:23:47 -0400
IronPort-SDR: dXyENiCkv8jeOXlx6PcMLRXF/yljdABFmMihpnkFeKDyvFR7Byj4PsgRz9MT8FX1YIUUi2oOBW
 0SksJ5/HdFmw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 17:23:46 -0700
IronPort-SDR: STibwAP25+YrHMZy0NgBiCSUOB7UKElCHU3S4idES7KbQu0K24cvJhuCJTEMglI2oiigL8Y1XT
 b5X1lBx8AUdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="273348659"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga002.jf.intel.com with ESMTP; 20 Apr 2020 17:23:46 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 17:23:45 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 fmsmsx117.amr.corp.intel.com ([169.254.3.191]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 17:23:45 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Topic: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHWFNtu4ugEuh6AnUe8PZpOjYV9PKh+KgSAgAPqlNA=
Date:   Tue, 21 Apr 2020 00:23:45 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
In-Reply-To: <20200417193421.GB3083@unreal>
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

> Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> definitions
> 
> On Fri, Apr 17, 2020 at 10:12:36AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Register irdma as a virtbus driver capable of supporting virtbus
> > devices from multi-generation RDMA capable Intel HW. Establish the
> > interface with all supported netdev peer drivers and initialize HW.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  drivers/infiniband/hw/irdma/i40iw_if.c | 228 ++++++++++
> > drivers/infiniband/hw/irdma/irdma_if.c | 449 ++++++++++++++++++
> >  drivers/infiniband/hw/irdma/main.c     | 573 +++++++++++++++++++++++
> >  drivers/infiniband/hw/irdma/main.h     | 599 +++++++++++++++++++++++++
> >  4 files changed, 1849 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
> >  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
> >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> >
> 
> I didn't look in too much details, but three things caught my attention immediately:
> 1. Existence of ARP cache management logic in RDMA driver.

Our HW has an independent ARP table for the rdma block. 
driver needs to add an ARP table entry via an rdma admin
queue command before QP transitions to RTS.

> 2. Extensive use of dev_*() prints while we have ibdev_*() prints
The ib device object is not available till the end of the device init
similarly its unavailable early on in device deinit flows. So dev_*
is all we can use in those places.

3.Extra includes
> (moduleparam.h ???).
> 
This should be cleaned up. Thanks!
