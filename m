Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546B318A16C
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCRRUv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Mar 2020 13:20:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:48886 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgCRRUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 13:20:51 -0400
IronPort-SDR: R6vnL+EpKTxOINuSD4wIG3M1uzkAs140n75cK8Etf1LrhxZvnCrXRc2yJZCLMd99yoYeSW4Cbg
 /umYfCtsMNVg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 10:20:51 -0700
IronPort-SDR: fifPT9ukBzFlmI7HsxLVwnl5e5EFPuH1bvrrCbLVJtxUn4dRvM/YMR/u3TelRh0apK87P7h3/p
 iMfoe2PfVv6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="279803706"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga002.fm.intel.com with ESMTP; 18 Mar 2020 10:20:49 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Mar 2020 10:20:39 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Mar 2020 10:20:39 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 18 Mar 2020 10:20:39 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next] i40e: trivial fixup of
 comments in i40e_xsk.c
Thread-Topic: [Intel-wired-lan] [PATCH net-next] i40e: trivial fixup of
 comments in i40e_xsk.c
Thread-Index: AQHV+3wNvXEbfBEs1kCDia4++aK6v6hOm8BQ
Date:   Wed, 18 Mar 2020 17:20:39 +0000
Message-ID: <25812f58f1e1431580115028dfdbb0ad@intel.com>
References: <158435379870.2479973.8293720099992666964.stgit@carbon>
In-Reply-To: <158435379870.2479973.8293720099992666964.stgit@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Jesper Dangaard Brouer
>Sent: Monday, March 16, 2020 3:17 AM
>To: Jesper Dangaard Brouer <brouer@redhat.com>; netdev@vger.kernel.org
>Cc: Topel, Bjorn <bjorn.topel@intel.com>; intel-wired-lan@lists.osuosl.org; Karlsson, Magnus <magnus.karlsson@intel.com>
>Subject: [Intel-wired-lan] [PATCH net-next] i40e: trivial fixup of comments in i40e_xsk.c
>
>The comment above i40e_run_xdp_zc() was clearly copy-pasted from function i40e_xsk_umem_setup, which is just above.
>
>Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>---
> drivers/net/ethernet/intel/i40e/i40e_xsk.c |    4 +---
>1 file changed, 1 insertion(+), 3 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


