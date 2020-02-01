Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D019D14F5DD
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 02:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgBAB6l convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 Jan 2020 20:58:41 -0500
Received: from mga17.intel.com ([192.55.52.151]:12753 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgBAB6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 20:58:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 17:58:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,388,1574150400"; 
   d="scan'208";a="325736802"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2020 17:58:41 -0800
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 31 Jan 2020 17:58:40 -0800
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.147]) by
 ORSMSX153.amr.corp.intel.com ([169.254.12.111]) with mapi id 14.03.0439.000;
 Fri, 31 Jan 2020 17:58:40 -0800
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Chen Zhou <chenzhou10@huawei.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH next] igc: make non-global functions static
Thread-Topic: [PATCH next] igc: make non-global functions static
Thread-Index: AQHVxinHRRpBXZgR9U+0zAtOY/u1CqgFucdg
Date:   Sat, 1 Feb 2020 01:58:40 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971D2690@ORSMSX103.amr.corp.intel.com>
References: <20200108133959.93035-1-chenzhou10@huawei.com>
In-Reply-To: <20200108133959.93035-1-chenzhou10@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Chen Zhou
> Sent: Wednesday, January 8, 2020 5:40 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; chenzhou10@huawei.com
> Subject: [PATCH next] igc: make non-global functions static
> 
> Fix sparse warning:
> drivers/net/ethernet/intel/igc/igc_ptp.c:512:6:
> 	warning: symbol 'igc_ptp_tx_work' was not declared. Should it be
> static?
> drivers/net/ethernet/intel/igc/igc_ptp.c:644:6:
> 	warning: symbol 'igc_ptp_suspend' was not declared. Should it be
> static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_ptp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>

