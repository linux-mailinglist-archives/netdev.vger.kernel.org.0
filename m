Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9754A187413
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732584AbgCPUcP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Mar 2020 16:32:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:47399 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732573AbgCPUcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:32:14 -0400
IronPort-SDR: 2/h/JSkPEJgs+Ha48uZkQ99n2b3Sup4OwaOEBGpvaC/sgyoYFL3hkPKEsXOvdk/5tMNSOW0YGL
 znAoNWPIq9pQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 13:32:14 -0700
IronPort-SDR: O7wchPFsCDjbA5BJR3f+5rCkfQAZYX1SfTdm0v5kJxufJ9g92Phb4lHQYAJUhUMp+B8qW0OD4q
 6Zwz9Gz4jYAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,561,1574150400"; 
   d="scan'208";a="390829276"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga004.jf.intel.com with ESMTP; 16 Mar 2020 13:32:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Mar 2020 13:32:13 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Mar 2020 13:32:12 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Mon, 16 Mar 2020 13:32:12 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH 2/7] i40e: Use scnprintf() for avoiding
 potential buffer overflow
Thread-Topic: [Intel-wired-lan] [PATCH 2/7] i40e: Use scnprintf() for avoiding
 potential buffer overflow
Thread-Index: AQHV94BpxEHGJZ/0oUmmtF0B/EZBq6hLtNEg
Date:   Mon, 16 Mar 2020 20:32:12 +0000
Message-ID: <92500904ba1a4c91b5a1215d12266234@intel.com>
References: <20200311083745.17328-1-tiwai@suse.de>
 <20200311083745.17328-3-tiwai@suse.de>
In-Reply-To: <20200311083745.17328-3-tiwai@suse.de>
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

-----Original Message-----
From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Takashi Iwai
Sent: Wednesday, March 11, 2020 1:38 AM
To: netdev@vger.kernel.org
Cc: intel-wired-lan@lists.osuosl.org; David S . Miller <davem@davemloft.net>
Subject: [Intel-wired-lan] [PATCH 2/7] i40e: Use scnprintf() for avoiding potential buffer overflow

Since snprintf() returns the would-be-output size instead of the actual output size, the succeeding calls may go beyond the given buffer limit.  Fix it by replacing with scnprintf().

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


