Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CE4A967A
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfIDWae convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 18:30:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:7929 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfIDWae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 18:30:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 15:30:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,468,1559545200"; 
   d="scan'208";a="266812442"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga001.jf.intel.com with ESMTP; 04 Sep 2019 15:30:33 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 4 Sep 2019 15:30:28 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Sep 2019 15:30:27 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 4 Sep 2019 15:30:27 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH v2 net-next 2/2] i40e: Implement debug macro hw_dbg using
 dev_dbg
Thread-Topic: [PATCH v2 net-next 2/2] i40e: Implement debug macro hw_dbg using
 dev_dbg
Thread-Index: AQHVYoy755cDx9NN1EiWzgKEhOLZpqccG35Q
Date:   Wed, 4 Sep 2019 22:30:27 +0000
Message-ID: <88b220e5a964498fbcf91e530ee67de0@intel.com>
References: <20190903192021.25789-1-maurosr@linux.vnet.ibm.com>
 <20190903192021.25789-2-maurosr@linux.vnet.ibm.com>
In-Reply-To: <20190903192021.25789-2-maurosr@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDhjMTc3Y2YtMWFiOC00ZmVmLWEyZmItNzhiN2JkZjQ2NzUyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUWpzc0MxM0tHNnpPVjRkbDJtZ0xGSzJONGwwRWQ3Z0xsVEtOUUl6dGZrS1wvZEJOSlhIdXdLYkhGanVwWGp4bUoifQ==
dlp-reaction: no-action
dlp-version: 11.0.400.15
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Mauro S. M. Rodrigues [mailto:maurosr@linux.vnet.ibm.com]
> Sent: Tuesday, September 3, 2019 12:20 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org;
> davem@davemloft.net; Bowers, AndrewX <andrewx.bowers@intel.com>;
> Jakub Kicinski <jakub.kicinski@netronome.com>;
> maurosr@linux.vnet.ibm.com
> Subject: [PATCH v2 net-next 2/2] i40e: Implement debug macro hw_dbg
> using dev_dbg
> 
> There are several uses of hw_dbg in the code, producing no output. This
> patch implments it using dev_debug.
> 
> Initially the intention was to implement it using netdev_dbg, analogously to
> what is done in ixgbe for instance. That approach was avoided due to some
> early usages of hw_dbg, like i40e_pf_reset, before the vsi structure
> initialization causing NULL pointer dereference during the driver probe if the
> dbg messages were turned on as soon as the module is probed.
> 
> v2:
>  - Use dev_dbg instead of pr_debug, and take advantage of dev_name
> instead of crafting pretty much the same device name locally as suggested by
> Jakub Kicinski.
> 
> Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_common.c | 1 +
>  drivers/net/ethernet/intel/i40e/i40e_hmc.c    | 1 +
>  drivers/net/ethernet/intel/i40e/i40e_osdep.h  | 5 ++++-
>  3 files changed, 6 insertions(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


