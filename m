Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C328136112D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhDORh0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Apr 2021 13:37:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:35993 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233395AbhDORhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 13:37:25 -0400
IronPort-SDR: 24hzNGKPSUApnUIpu7ndlPXngMIlbT+nC1rfbI++33xu1XMUGpFOWa8022WFOSxwNTHKQMsiNe
 OzC9xz0IfO3g==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="258863673"
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="258863673"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 10:37:01 -0700
IronPort-SDR: BJaKfhRNnoZIE/kaBy6Cra+5zZfmPztxfd8aSURWHyKdZZQJgSrob2/LPo92YV3122nKI78AWn
 NWy2xRBS0YLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="399646801"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 15 Apr 2021 10:37:00 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 10:37:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 10:36:59 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Thu, 15 Apr 2021 10:36:59 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Lacombe, John S" <john.s.lacombe@intel.com>
Subject: RE: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Topic: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Index: AQHXKygiEMWtUC1Uo0mj4KR4ZXyZX6qpqNQA///J7iCAAKscAIABP3oQgAYu4wCAAadCQA==
Date:   Thu, 15 Apr 2021 17:36:59 +0000
Message-ID: <dff8229e5092447cb3d16fecd14e0fb8@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407154430.GA502757@nvidia.com>
 <1e61169b83ac458aa9357298ecfab846@intel.com>
 <20210407224324.GH282464@nvidia.com>
 <2339b8bb35b74aabbb708fcd1a6ab40f@intel.com>
 <20210412161214.GA1115060@nvidia.com>
In-Reply-To: <20210412161214.GA1115060@nvidia.com>
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

> Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> 
> On Mon, Apr 12, 2021 at 02:50:43PM +0000, Saleem, Shiraz wrote:
> 

[....]

> > There is a near-term Intel ethernet VF driver which will use IIDC to
> > provide RDMA in the VF, and implement some of these .ops callbacks.
> > There is also intent to move i40e to IIDC.
> 
> "near-term" We are now on year three of Intel talking about this driver!
> 
> Get the bulk of the thing merged and deal with the rest in followup patches.

We will submit with symbols exported from ice and direct calls from irdma.

Shiraz
