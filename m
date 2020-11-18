Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B32B841E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgKRSr5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Nov 2020 13:47:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:28596 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgKRSr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:47:56 -0500
IronPort-SDR: e59alZmi8gDrdPn/21m1KNwJNpNqmhLvLTFQTnleaGV0hjfhJggJpD4hGLPw+4AVeOrJogMUm3
 e/yEJt3642Bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="158199760"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="158199760"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 10:47:55 -0800
IronPort-SDR: 21awqr29/gdilBdJzZ2L4xrvdgnXZ6iVa17h6o489eSd338sX4jD0bb5vmo0lVDoaH1w1TPVRC
 Ocnd8pVyvV4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="532843422"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 18 Nov 2020 10:47:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Nov 2020 10:47:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Nov 2020 10:47:54 -0800
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.1713.004;
 Wed, 18 Nov 2020 10:47:54 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>
Subject: RE: [net-next v3 1/2] devlink: move request_firmware out of driver
Thread-Topic: [net-next v3 1/2] devlink: move request_firmware out of driver
Thread-Index: AQHWvR2ackQWguMXlk+0V+1rPQ6Nz6nM0gOAgAHsLwD//34d4A==
Date:   Wed, 18 Nov 2020 18:47:54 +0000
Message-ID: <c325902b7bfd41588fa3a93484a50f79@intel.com>
References: <20201117200820.854115-1-jacob.e.keller@intel.com>
        <20201117200820.854115-2-jacob.e.keller@intel.com>
        <505ed03a-6e71-5abc-dd18-c3c737c6ade8@intel.com>
 <20201118103224.4662565f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118103224.4662565f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, November 18, 2020 10:32 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@nvidia.com>; Michael Chan
> <michael.chan@broadcom.com>; Shannon Nelson <snelson@pensando.io>;
> Saeed Mahameed <saeedm@nvidia.com>; Boris Pismenny
> <borisp@nvidia.com>; Bin Luo <luobin9@huawei.com>
> Subject: Re: [net-next v3 1/2] devlink: move request_firmware out of driver
> 
> On Tue, 17 Nov 2020 12:10:49 -0800 Jacob Keller wrote:
> > Oof, forgot to metion that the only change since v2 is to fix the typo
> > in the commit message pointed out by Shannon. Otherwise, this patch is
> > identical and just comes in series with the other change.
> 
> Fine by me, although I thought Shannon asked for some changes to debug
> prints in ionic?

Oh I might have missed those comments let me go look.
