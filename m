Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EB1BFA4A
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfIZTtp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 15:49:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:49608 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbfIZTtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 15:49:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 12:49:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="390848677"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga006.fm.intel.com with ESMTP; 26 Sep 2019 12:49:45 -0700
Received: from fmsmsx158.amr.corp.intel.com (10.18.116.75) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Sep 2019 12:49:45 -0700
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.221]) by
 fmsmsx158.amr.corp.intel.com ([169.254.15.72]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 12:49:44 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Thread-Topic: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Thread-Index: AQHVdInZOibqAWBxbUuxHf9fYH6XHqc+ryaA//+gxZA=
Date:   Thu, 26 Sep 2019 19:49:44 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
 <20190926174009.GD14368@unreal>
In-Reply-To: <20190926174009.GD14368@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiN2JhNGE2YmItZjJhMS00OTEyLTg0OGItNDVlNDM1ODMwYWNhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRlhxUU8wM0lPY0doM0lCRXJXNVJnbkFsbHdCY2sybEwzem1RZlFUTmxsMzZLZUh3RWEzT3ROcWJsOXZrSTlxUCJ9
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

> Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> 
> On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
> > From: Shiraz Saleem <shiraz.saleem@intel.com>
> >
> > Mark i40iw as deprecated/obsolete.
> >
> > irdma is the replacement driver that supports X722.
> 
> Can you simply delete old one and add MODULE_ALIAS() in new driver?
> 

Yes, but we thought typically driver has to be deprecated for a few cycles before removing it.
