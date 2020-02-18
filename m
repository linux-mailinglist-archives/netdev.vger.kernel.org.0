Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB8A163345
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBRUnN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Feb 2020 15:43:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:9969 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgBRUnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 15:43:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 12:43:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="282895305"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 12:43:12 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.69]) by
 FMSMSX105.amr.corp.intel.com ([169.254.4.155]) with mapi id 14.03.0439.000;
 Tue, 18 Feb 2020 12:43:12 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v4 22/25] RDMA/irdma: Add dynamic tracing for CM
Thread-Topic: [RFC PATCH v4 22/25] RDMA/irdma: Add dynamic tracing for CM
Thread-Index: AQHV4ditF+jts+DXo0WX+53ZwC8OF6gbT3uA//+tQjA=
Date:   Tue, 18 Feb 2020 20:43:11 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7C60C94C3@fmsmsx124.amr.corp.intel.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-23-jeffrey.t.kirsher@intel.com>
 <20200214145335.GT31668@ziepe.ca>
In-Reply-To: <20200214145335.GT31668@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjVlNjBjMTQtOGRkYy00ZDdlLTkxYjQtZjY4ZDgxMTM4MjA3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidnpvYnlkU1wvYXh5Tk9KOXU3QXpQN1VNdmRGVk4rWFgzcU8zanhcL1NSOEs5XC9Bd2lmU25rclwvYm5NODkxM3ZCVkkifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v4 22/25] RDMA/irdma: Add dynamic tracing for CM
> 
> On Wed, Feb 12, 2020 at 11:14:21AM -0800, Jeff Kirsher wrote:
> > From: "Michael J. Ruhl" <michael.j.ruhl@intel.com>
> >
> > Add dynamic tracing functionality to debug connection management
> > issues.
> 
> We now have tracing in the core CM, why does a driver need additional tracing?
> 

This is specifically for recording driver specific data / paths in connection setup/tear-down flows.   

