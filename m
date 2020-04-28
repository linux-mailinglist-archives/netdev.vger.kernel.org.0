Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84AB1BCDA4
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgD1Un5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Apr 2020 16:43:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:56560 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgD1Un4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 16:43:56 -0400
IronPort-SDR: gseQal60f9SfGu4kmajUEowDSKQU+3+ISMLndXiRQoOJRV7u0QJ0z13jt8WbtIZIfpMrLQVqi8
 +NVeKKmkwKXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 13:43:56 -0700
IronPort-SDR: g2OEYGvoO4KwUCFqSsx2OOzXN8+OA2kDyYmQBwOSXIf04L82tuD1FOjQr82W/vLQaoWKkdwX0b
 8+/EOsvcKBsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="292986867"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga002.fm.intel.com with ESMTP; 28 Apr 2020 13:43:56 -0700
Received: from fmsmsx121.amr.corp.intel.com (10.18.125.36) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 28 Apr 2020 13:43:55 -0700
Received: from fmsmsx102.amr.corp.intel.com ([169.254.10.190]) by
 fmsmsx121.amr.corp.intel.com ([169.254.6.5]) with mapi id 14.03.0439.000;
 Tue, 28 Apr 2020 13:43:55 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [iproute2 v2] devlink: add support for DEVLINK_CMD_REGION_NEW
Thread-Topic: [iproute2 v2] devlink: add support for DEVLINK_CMD_REGION_NEW
Thread-Index: AQHWHYFvMSupE5PZAUuywNPdGnFJgKiPbTeA//+TLLA=
Date:   Tue, 28 Apr 2020 20:43:54 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58B6CF6786@FMSMSX102.amr.corp.intel.com>
References: <20200428172057.1109672-1-jacob.e.keller@intel.com>
 <20200428131311.18fd742f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200428131311.18fd742f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, April 28, 2020 1:13 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [iproute2 v2] devlink: add support for DEVLINK_CMD_REGION_NEW
> 
> On Tue, 28 Apr 2020 10:20:57 -0700 Jacob Keller wrote:
> > +	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_NEW,
> > +			NLM_F_REQUEST | NLM_F_ACK);
> 
> misaligned

Hah, yep.

Thanks,
Jake
