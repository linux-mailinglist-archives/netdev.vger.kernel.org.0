Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C7B21015C
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgGABNb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jun 2020 21:13:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:44366 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgGABNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 21:13:31 -0400
IronPort-SDR: iTqrCvoH6Kt0KcRF51NhdH7SzjD+g01qViyI3jrSoCOQF4hWIvwVUYSZpeEEZjLFHNcdBeM3sm
 VLjYdlITGtfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="147979694"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="147979694"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 18:13:30 -0700
IronPort-SDR: 4SJd2OVBXt2+Pb/j+nENGIo9U5Fnk4OJ2zGKwoohhcCyk7U4EkuJeKK0IsT3+MstVxbHBDtLZr
 kPtFXv1Su2Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="481394754"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jun 2020 18:13:30 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 30 Jun 2020 18:13:29 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX116.amr.corp.intel.com ([169.254.7.158]) with mapi id 14.03.0439.000;
 Tue, 30 Jun 2020 18:13:29 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Brady, Alan" <alan.brady@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Michael, Alice" <alice.michael@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        lkp <lkp@intel.com>
Subject: RE: [net-next v3 15/15] idpf: Introduce idpf driver
Thread-Topic: [net-next v3 15/15] idpf: Introduce idpf driver
Thread-Index: AQHWS16TPBESI1lj00iHdVXe4L8dEajrtIUAgAYkvMCAAIsSgP//jgSg
Date:   Wed, 1 Jul 2020 01:13:29 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044987434B7@ORSMSX112.amr.corp.intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-16-jeffrey.t.kirsher@intel.com>
        <20200626115236.7f36d379@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61CC2BC414934749BD9F5BF3D5D9404498743241@ORSMSX112.amr.corp.intel.com>
 <20200630175923.142777be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200630175923.142777be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, June 30, 2020 17:59
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Brady, Alan <alan.brady@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Michael, Alice <alice.michael@intel.com>; Burra, Phani R
> <phani.r.burra@intel.com>; Hay, Joshua A <joshua.a.hay@intel.com>;
> Chittim, Madhu <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>; lkp <lkp@intel.com>
> Subject: Re: [net-next v3 15/15] idpf: Introduce idpf driver
> 
> On Tue, 30 Jun 2020 23:48:34 +0000 Kirsher, Jeffrey T wrote:
> > > On Thu, 25 Jun 2020 19:07:37 -0700 Jeff Kirsher wrote:
> > > > +MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
> > >
> > > Corporations do not author things, people do. Please drop this.
> >
> > Your statement makes sense and I know that we have done this
> > historically, like several other drivers (not saying it is right).
> > The thought process was that our drivers are not written by just one
> > or two people, but more like 20+ developers.  So should we list all
> > 20+ people that wrote the drivers, or just choose one person?  Also
> > what happens when that person no longer works at Intel and the email
> > is no longer vaild, should we constantly update the MODULE_AUTHOR() to
> > reflect valid employees working on the driver?  That is the reason we
> > were using "Intel Corporation" and a valid email that will always be
> > good for support questions.
> 
> MODULE_AUTHOR() is not required, most of the "documentation" page for this
> driver is about where to get support, MAINTAINERS exist..  not to mention that
> this is an upstream driver, so posting to netdev is always appropriate.
> 
> I think we should be covered.

Ok, I am fine with that then.

@Brady, Alan - Go ahead and just remove the MODULE_AUTHOR() line.
