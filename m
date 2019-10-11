Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEF5D36A1
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfJKA5z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 20:57:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:40771 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfJKA5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 20:57:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 17:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,282,1566889200"; 
   d="scan'208";a="394240903"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga005.fm.intel.com with ESMTP; 10 Oct 2019 17:57:54 -0700
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 10 Oct 2019 17:57:53 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.9]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.60]) with mapi id 14.03.0439.000;
 Thu, 10 Oct 2019 17:57:53 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [net-next v3 5/7] igb: reject unsupported
 external timestamp flags
Thread-Topic: [Intel-wired-lan] [net-next v3 5/7] igb: reject unsupported
 external timestamp flags
Thread-Index: AQHVdJXc8aJ9UqMiT0GZBjsf6sJ1iKdUtIIw
Date:   Fri, 11 Oct 2019 00:57:52 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B9714C829@ORSMSX103.amr.corp.intel.com>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-6-jacob.e.keller@intel.com>
In-Reply-To: <20190926181109.4871-6-jacob.e.keller@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMGViZGRjOGMtMGMwZS00YjFkLWJkMDQtNTU4Mzc5MDkyNzIyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQUlDdERiZlVkSnU1aHdoSGMwWTB3bmpFRmFXQ3c1eTZIWW85ZVI1UGRiZTVVZ2pxR3hEZlFXSmxDdDdXQ0ZzQiJ9
x-ctpclassification: CTP_NT
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

> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On Behalf Of
> Jacob Keller
> Sent: Thursday, September 26, 2019 11:11 AM
> To: netdev@vger.kernel.org
> Cc: Intel Wired LAN <intel-wired-lan@lists.osuosl.org>
> Subject: [Intel-wired-lan] [net-next v3 5/7] igb: reject unsupported external
> timestamp flags
> 
> Fix the igb PTP support to explicitly reject any future flags that
> get added to the external timestamp request ioctl.
> 
> In order to maintain currently functioning code, this patch accepts all
> three current flags. This is because the PTP_RISING_EDGE and
> PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
> have interpreted them slightly differently.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ptp.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>
