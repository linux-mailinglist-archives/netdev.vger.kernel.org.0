Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06E5356FD3
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353348AbhDGPG7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Apr 2021 11:06:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:32107 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353344AbhDGPGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:06:55 -0400
IronPort-SDR: +21cLu05b+pa37Nzv1tWlBapYcUKqY+hev7w99Deo3UrIn4DLz75TYtiK+isYoKgmI7KTpklDw
 4lJbcSmvtU4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="193370094"
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="193370094"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 08:06:19 -0700
IronPort-SDR: N/vMsWv4Rwxgb9PPimUMsVpQmtOxbHES+yd1LH8wi559sEsDS2aR/Pm45z4onEKVb2sVZRZQdH
 nMwaPQPcde1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="519468632"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 07 Apr 2021 08:06:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 08:06:19 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 7 Apr 2021 08:06:18 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Wed, 7 Apr 2021 08:06:18 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Topic: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
 (irdma)
Thread-Index: AQHXKyghWxg1YMB540GtculmvcetP6qolJkA//+MQXCAAUFqgP//r4Kg
Date:   Wed, 7 Apr 2021 15:06:18 +0000
Message-ID: <23e44d40b89a4ab69a4d3b6336b5dc51@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406231550.GB7405@nvidia.com>
 <be8b420a3fa844ed94d80f5a6c65acaf@intel.com>
 <20210407113157.GC7405@nvidia.com>
In-Reply-To: <20210407113157.GC7405@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v4 00/23] Add Intel Ethernet Protocol Driver for RDMA
> (irdma)
> 
> On Tue, Apr 06, 2021 at 11:30:23PM +0000, Saleem, Shiraz wrote:
> 
> > Hi Jason - I think its because I used --irreversible-delete flag in git format-patch
> for review that this one doesn't apply.
> 
> I doubt it

The documentation hints at it.
https://git-scm.com/docs/git-format-patch

-D
--irreversible-delete
Omit the preimage for deletes, i.e. print only the header but not the diff between the preimage and /dev/null. The resulting patch is not meant to be applied with patch or git apply; this is solely for people who want to just concentrate on reviewing the text after the change. In addition, the output obviously lacks enough information to apply such a patch in reverse, even manually, hence the name of the option.

> 
> > I can resend without it if your trying to apply.
> 
> Now it is too big to go to the mailing lists
> 

It is showing now.
https://patchwork.kernel.org/project/linux-rdma/patch/20210407001502.1890-23-shiraz.saleem@intel.com/
