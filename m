Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E7C12E861
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgABQAk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jan 2020 11:00:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:33084 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbgABQAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 11:00:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 08:00:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="270346918"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Jan 2020 08:00:38 -0800
Received: from fmsmsx161.amr.corp.intel.com (10.18.125.9) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jan 2020 08:00:38 -0800
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.87]) by
 FMSMSX161.amr.corp.intel.com ([10.18.125.9]) with mapi id 14.03.0439.000;
 Thu, 2 Jan 2020 08:00:38 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: RE: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
 i40iw
Thread-Topic: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
 i40iw
Thread-Index: AQHVruL28gEIgb9lXUm9x+ExMCj0FKe15AgAgAJKZ3CABzTwAIAYQRoA
Date:   Thu, 2 Jan 2020 16:00:37 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7C1DEF259@fmsmsx123.amr.corp.intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-20-jeffrey.t.kirsher@intel.com>
 <20191211200200.GA13279@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7B6B9343F@fmsmsx124.amr.corp.intel.com>
 <20191217210406.GC17227@ziepe.ca>
In-Reply-To: <20191217210406.GC17227@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjEwY2JiODgtMzUyYy00YWQ4LWE1YzEtMTVhNDg1ZDhlY2Q1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiN0RsV3RtTjQ2aXJuZ2FlOFpmdTIwSEllSVZhR2ZSNG5EUkV0VWV4akpQN3A4WkVOaFwvZ2pJYXZIeGNHUzVJT3cifQ==
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

> Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
> i40iw
> 
> 
> > >  - The whole cqp_compl_thread thing looks really weird
> > What is the concern?
> 
> It looks like an open coded work queue
> 

The cqp_compl_thread is not a work queue in the sense
that no work is queued to it. It is a thread that is signaled to
check for and handle CQP completion events if present.

