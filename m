Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98F31B1AAC
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgDUA1F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 20:27:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:19873 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgDUA1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 20:27:04 -0400
IronPort-SDR: 2vR653HZWMaDdOkIcFC65kmroM0eDGkPbJxKDB5k1jWCGLWG7DTQ1ByF8g9sNb9dTBN5jNl4lU
 wQ5w3bse1rKA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 17:27:04 -0700
IronPort-SDR: e7kkLlHV+lLLMqXGCZLSzIomCCgAlt5RTKp4GTiuEqwLrpUJIy+q29k58ZsuUV12QMZf4Qu9r5
 y3gHJvGBtjfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="402011915"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 20 Apr 2020 17:27:03 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 17:27:03 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 FMSMSX102.amr.corp.intel.com ([169.254.10.190]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 17:27:03 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 10/16] RDMA/irdma: Add RoCEv2 UD OP support
Thread-Topic: [RFC PATCH v5 10/16] RDMA/irdma: Add RoCEv2 UD OP support
Thread-Index: AQHWFNtyRXdFIoltSUSWlm5UATXko6h+LVsAgAQXLSA=
Date:   Tue, 21 Apr 2020 00:27:03 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD485A1@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-11-jeffrey.t.kirsher@intel.com>
 <20200417194618.GD3083@unreal>
In-Reply-To: <20200417194618.GD3083@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v5 10/16] RDMA/irdma: Add RoCEv2 UD OP support
> 
> On Fri, Apr 17, 2020 at 10:12:45AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add the header, data structures and functions to populate the WQE
> > descriptors and issue the Control QP commands that support RoCEv2 UD
> > operations.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---

[..]

> > +#define IRDMA_UDA_CQPSQ_QHASH_ENTRYTYPE_S 42 #define
> > +IRDMA_UDA_CQPSQ_QHASH_ENTRYTYPE_M \
> > +	((u64)0x7 << IRDMA_UDA_CQPSQ_QHASH_ENTRYTYPE_S)
> 
> GENMASK*() are better suit here instead of shifts.
> 

OK. I think Jason prefers that too. Will look to make that change in the next rev.
