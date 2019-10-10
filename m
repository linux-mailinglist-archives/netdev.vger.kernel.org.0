Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EAFD346A
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfJJXgh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 19:36:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:23008 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbfJJXgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 19:36:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 16:36:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="394223072"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga005.fm.intel.com with ESMTP; 10 Oct 2019 16:36:36 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.88]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.122]) with mapi id 14.03.0439.000;
 Thu, 10 Oct 2019 16:36:36 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v1] documentation: correct include file
 reference
Thread-Topic: [PATCH net-next v1] documentation: correct include file
 reference
Thread-Index: AQHVf6F0fEVqTcz5PEKs5qbvb8OBDadUh6Sw
Date:   Thu, 10 Oct 2019 23:36:35 +0000
Message-ID: <02874ECE860811409154E81DA85FBB5896921C4C@ORSMSX121.amr.corp.intel.com>
References: <20191010193112.15215-1-jesse.brandeburg@intel.com>
In-Reply-To: <20191010193112.15215-1-jesse.brandeburg@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTkwMTYxN2EtMmExZi00NmVlLWIzYzMtYzZiMGZlYTNhZmJjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQkhwZWlCUTZCVmlzcHd6RHY2cWVpSVlxcGRRRERhMG5EUnByZjNQMHo2Ylg1N2lxNWxOSXVSQzBkVHRGV2YrTiJ9
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

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jesse Brandeburg
> Sent: Thursday, October 10, 2019 12:31 PM
> To: netdev@vger.kernel.org
> Subject: [PATCH net-next v1] documentation: correct include file reference
> 
> The documentation had a reference to a filename before
> a rename had been completed.  Fix the name so the documentation
> is correct.
> 
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  Documentation/networking/net_dim.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/net_dim.txt
> b/Documentation/networking/net_dim.txt
> index 9cb31c5e2dcd..eef3956f91db 100644
> --- a/Documentation/networking/net_dim.txt
> +++ b/Documentation/networking/net_dim.txt
> @@ -132,7 +132,7 @@ usage is not complete but it should make the outline of
> the usage clear.
> 
>  my_driver.c:
> 
> -#include <linux/net_dim.h>
> +#include <linux/dim.h>
> 
>  /* Callback for net DIM to schedule on a decision to change moderation */
>  void my_driver_do_dim_work(struct work_struct *work)
> --
> 2.20.1

I think my patch at https://lore.kernel.org/netdev/20191009191831.29180-1-jacob.e.keller@intel.com/ fixed this.

Thanks,
Jake
