Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29163C0786
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfI0O22 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Sep 2019 10:28:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:16572 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfI0O22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 10:28:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 07:28:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="194499183"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga006.jf.intel.com with ESMTP; 27 Sep 2019 07:28:27 -0700
Received: from fmsmsx125.amr.corp.intel.com (10.18.125.40) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Sep 2019 07:28:27 -0700
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.221]) by
 FMSMSX125.amr.corp.intel.com ([169.254.2.5]) with mapi id 14.03.0439.000;
 Fri, 27 Sep 2019 07:28:27 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Thread-Topic: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Thread-Index: AQHVdInZOibqAWBxbUuxHf9fYH6XHqc+ryaA//+gxZCAAIT9gIAAszkA
Date:   Fri, 27 Sep 2019 14:28:27 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7AC70465F@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
 <20190926174009.GD14368@unreal>
 <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
 <20190926195517.GA1743170@kroah.com>
In-Reply-To: <20190926195517.GA1743170@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZmE4YWIyOTEtYjdjNi00M2RhLWI3MzctYjkzMDE2YTg3YzY5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZExlQkdqTGFhMHdYWmgrYmtQUG9zOVVlQVI5SjRMSHVoYzl5QXlBODJiUVkrV3R1R1c4ZHliZnZDakpoSGVjMyJ9
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

> Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> 
> On Thu, Sep 26, 2019 at 07:49:44PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> > >
> > > On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
> > > > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > > >
> > > > Mark i40iw as deprecated/obsolete.
> > > >
> > > > irdma is the replacement driver that supports X722.
> > >
> > > Can you simply delete old one and add MODULE_ALIAS() in new driver?
> > >
> >
> > Yes, but we thought typically driver has to be deprecated for a few cycles
> before removing it.
> 
> If you completely replace it with something that works the same, why keep the old
> one around at all?

Agree. Thanks!


> 
> Unless you don't trust your new code?  :)
> 
We do :)
