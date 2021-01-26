Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2C030492E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387654AbhAZFa0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Jan 2021 00:30:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:62493 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387438AbhAZBXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 20:23:20 -0500
IronPort-SDR: x9jceKnOLavYxUheN863N0AnI02UXZBFnd7m2gkwJ0TmryoHeguobuqGpqYfAjyG+DXIK0XO61
 b3Iuai7zzlKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179973307"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179973307"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 16:39:37 -0800
IronPort-SDR: gIX+y+bha9VQfS+IZGNzSH3784yZO56IXNNIFN0S7WYkZEGD1QMtm2XCLKhmmEDqJWN/QgCm2E
 Q/97ETTxfNUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="393570853"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 25 Jan 2021 16:39:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 Jan 2021 16:39:35 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 Jan 2021 16:39:34 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Mon, 25 Jan 2021 16:39:34 -0800
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
Subject: RE: [PATCH 21/22] RDMA/irdma: Add irdma Kconfig/Makefile and remove
 i40iw
Thread-Topic: [PATCH 21/22] RDMA/irdma: Add irdma Kconfig/Makefile and remove
 i40iw
Thread-Index: AQHW8RllkKF48js1DESDK4bJiW2Saao5ObWA//99WFA=
Date:   Tue, 26 Jan 2021 00:39:34 +0000
Message-ID: <7607b5bc7d1f4b25b29ef61cb78dedb8@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-22-shiraz.saleem@intel.com>
 <20210125185007.GU4147@nvidia.com>
In-Reply-To: <20210125185007.GU4147@nvidia.com>
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

> Subject: Re: [PATCH 21/22] RDMA/irdma: Add irdma Kconfig/Makefile and remove
> i40iw
> 
> On Fri, Jan 22, 2021 at 05:48:26PM -0600, Shiraz Saleem wrote:
> > Add Kconfig and Makefile to build irdma driver.
> >
> > Remove i40iw driver and add an alias in irdma.
> > irdma is the replacement driver that supports X722.
> >
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> 
> This didn't make it to patchworks or the mailing list
> 
> You will need to send it with the git format-patch flag --irreversible-delete
> 

Ok.
