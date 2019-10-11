Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1657BD36AE
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 03:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfJKBFi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 21:05:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:54650 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfJKBFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 21:05:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 18:05:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,282,1566889200"; 
   d="scan'208";a="277965188"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga001.jf.intel.com with ESMTP; 10 Oct 2019 18:05:37 -0700
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 10 Oct 2019 18:05:37 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.9]) by
 ORSMSX153.amr.corp.intel.com ([169.254.12.244]) with mapi id 14.03.0439.000;
 Thu, 10 Oct 2019 18:05:37 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>
Subject: RE: [net-next v3 2/7] net: reject PTP periodic output requests with
 unsupported flags
Thread-Topic: [net-next v3 2/7] net: reject PTP periodic output requests
 with unsupported flags
Thread-Index: AQHVdJXdch2ZIrEq/0WYWnhPkQaHZqdUtobw
Date:   Fri, 11 Oct 2019 01:05:36 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B9714C866@ORSMSX103.amr.corp.intel.com>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-3-jacob.e.keller@intel.com>
In-Reply-To: <20190926181109.4871-3-jacob.e.keller@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWUxZDE1ZjktYTI0Ni00NmZiLThhZDctNDM1NWUzNDM1ZmQ1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiV013eHdrTjZOenowTXR0K0NrQjV5VHM5RGprcExuSUFVMEJzMnZJWmY0aUIzSjdCSG55WFFNQ1lPKzJ1eDB3USJ9
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

> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Jacob Keller
> Sent: Thursday, September 26, 2019 11:11 AM
> To: netdev@vger.kernel.org
> Cc: Intel Wired LAN <intel-wired-lan@lists.osuosl.org>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; Keller, Jacob E <jacob.e.keller@intel.com>;
> Richard Cochran <richardcochran@gmail.com>; Felipe Balbi
> <felipe.balbi@linux.intel.com>; David S . Miller <davem@davemloft.net>; Hall,
> Christopher S <christopher.s.hall@intel.com>
> Subject: [net-next v3 2/7] net: reject PTP periodic output requests with
> unsupported flags
> 
> Commit 823eb2a3c4c7 ("PTP: add support for one-shot output") introduced
> a new flag for the PTP periodic output request ioctl. This flag is not
> currently supported by any driver.
> 
> Fix all drivers which implement the periodic output request ioctl to
> explicitly reject any request with flags they do not understand. This
> ensures that the driver does not accidentally misinterpret the
> PTP_PEROUT_ONE_SHOT flag, or any new flag introduced in the future.
> 
> This is important for forward compatibility: if a new flag is
> introduced, the driver should reject requests to enable the flag until
> the driver has actually been modified to support the flag in question.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Christopher Hall <christopher.s.hall@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  drivers/net/ethernet/broadcom/tg3.c                 | 4 ++++
>  drivers/net/ethernet/intel/igb/igb_ptp.c            | 4 ++++
>  drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 4 ++++
>  drivers/net/ethernet/microchip/lan743x_ptp.c        | 4 ++++
>  drivers/net/ethernet/renesas/ravb_ptp.c             | 4 ++++
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c    | 4 ++++
>  drivers/net/phy/dp83640.c                           | 3 +++
>  7 files changed, 27 insertions(+)
> 

For the igb sections...
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

