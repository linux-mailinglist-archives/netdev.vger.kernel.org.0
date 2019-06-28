Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF40591EB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 05:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfF1DVr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Jun 2019 23:21:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:62098 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1DVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 23:21:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 20:21:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,426,1557212400"; 
   d="scan'208";a="153250013"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga007.jf.intel.com with ESMTP; 27 Jun 2019 20:21:46 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.135]) by
 ORSMSX101.amr.corp.intel.com ([169.254.8.95]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 20:21:46 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Detlev Casanova <detlev.casanova@gmail.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] e1000e: Make watchdog use delayed work
Thread-Topic: [PATCH v3] e1000e: Make watchdog use delayed work
Thread-Index: AQHVKXHl35anXlANxkOwN6YqevaOE6awbigw
Date:   Fri, 28 Jun 2019 03:21:45 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B970B54AA@ORSMSX103.amr.corp.intel.com>
References: <20190623031437.19716-1-detlev.casanova@gmail.com>
In-Reply-To: <20190623031437.19716-1-detlev.casanova@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDg0MDBiZWItMGZiNS00OTE4LTgyNzItMzZkOTdmMWNhYmIxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidjBKRWVabGUyRzh2NzBnY0MrM284YnRvMHZQOGlNbWRlbFo3WkJlKzhRa3JSN0JrUjBrcHJxK0FrbmJvV3IxbiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Detlev Casanova
> Sent: Saturday, June 22, 2019 8:15 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> <davem@davemloft.net>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Detlev Casanova <detlev.casanova@gmail.com>
> Subject: [PATCH v3] e1000e: Make watchdog use delayed work
> 
> Use delayed work instead of timers to run the watchdog of the e1000e
> driver.
> 
> Simplify the code with one less middle function.
> 
> Signed-off-by: Detlev Casanova <detlev.casanova@gmail.com>
> ---
>  drivers/net/ethernet/intel/e1000e/e1000.h  |  5 +-
>  drivers/net/ethernet/intel/e1000e/netdev.c | 54 ++++++++++++----------
>  2 files changed, 32 insertions(+), 27 deletions(-)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>
