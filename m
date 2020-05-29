Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44AC1E819F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgE2PUn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 May 2020 11:20:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:39007 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgE2PUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 11:20:42 -0400
IronPort-SDR: a1ET7mcKLh7er+bVgDi9xzVvbbQ8cSsUpMdktNIFIWe1c5bjyMV0oy/NJKHJTGNJsG9hjVHe9R
 xV9fd9ggT4EQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 08:20:41 -0700
IronPort-SDR: LQEUXC+cAhG+FL2gp7/NXf6WcTofD9xmoBngKEgW3aNY8vHhpX0mijhomntTjoxTwDCwSAFr/1
 q95WQLjeBc+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="302874098"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga002.fm.intel.com with ESMTP; 29 May 2020 08:20:41 -0700
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 29 May 2020 08:20:41 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.63]) by
 FMSMSX109.amr.corp.intel.com ([169.254.15.75]) with mapi id 14.03.0439.000;
 Fri, 29 May 2020 08:20:41 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Latif, Faisal" <faisal.latif@intel.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        "oren@mellanox.com" <oren@mellanox.com>,
        "shlomin@mellanox.com" <shlomin@mellanox.com>,
        "vladimirk@mellanox.com" <vladimirk@mellanox.com>
Subject: RE: [PATCH v3 07/13] RDMA/i40iw: Remove FMR leftovers
Thread-Topic: [PATCH v3 07/13] RDMA/i40iw: Remove FMR leftovers
Thread-Index: AQHWNSigLRUp92Ur7Uim3S1ML/U1mKi+DM1Q
Date:   Fri, 29 May 2020 15:20:40 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7EE045C24@fmsmsx124.amr.corp.intel.com>
References: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
 <7-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <7-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH v3 07/13] RDMA/i40iw: Remove FMR leftovers
> 
> From: Jason Gunthorpe <jgg@mellanox.com>
> 
> The ibfmr member is never referenced, remove it.
> 
> Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Faisal Latif <faisal.latif@intel.com>
> Cc: Shiraz Saleem <shiraz.saleem@intel.com>

Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
