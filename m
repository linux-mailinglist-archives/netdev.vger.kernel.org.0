Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C97E5EEC3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 23:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfGCVo4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jul 2019 17:44:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:50343 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbfGCVo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 17:44:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 14:44:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,448,1557212400"; 
   d="scan'208";a="184861600"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jul 2019 14:44:55 -0700
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 3 Jul 2019 14:44:55 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.70]) by
 ORSMSX112.amr.corp.intel.com ([169.254.3.232]) with mapi id 14.03.0439.000;
 Wed, 3 Jul 2019 14:44:55 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] iavf: remove unused debug
 function iavf_debug_d
Thread-Topic: [Intel-wired-lan] [PATCH net-next] iavf: remove unused debug
 function iavf_debug_d
Thread-Index: AQHVMJ5XiQrcda6PCk6e4wmTDurJL6a5b8lw
Date:   Wed, 3 Jul 2019 21:44:55 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D3FD2B4@ORSMSX104.amr.corp.intel.com>
References: <20190702062021.41524-1-yuehaibing@huawei.com>
In-Reply-To: <20190702062021.41524-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWU0MDViMDUtOWIyMy00YjFhLWJhZmEtZTA0ZjZmNzg1NzY0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiazgyelwvMVNkSFBKQ0ZTM3BsTCtcL1hZdzNWSjdTeTVCeWN4MGFtRWpEN2I3dW1Xc0hZVUFtZzl2NUNmeklVWW90In0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of YueHaibing
> Sent: Monday, July 1, 2019 11:20 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; YueHaibing <yuehaibing@huawei.com>; linux-
> kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next] iavf: remove unused debug
> function iavf_debug_d
> 
> There is no caller of function iavf_debug_d() in tree since commit
> 75051ce4c5d8 ("iavf: Fix up debug print macro"), so it can be removed.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 22 ----------------------
>  1 file changed, 22 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


