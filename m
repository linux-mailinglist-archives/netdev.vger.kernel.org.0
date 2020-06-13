Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3171F8030
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 03:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgFMBTl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 12 Jun 2020 21:19:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:20902 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgFMBTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 21:19:40 -0400
IronPort-SDR: 60Ugcgj0iV2GEvuI4+kdZ8e/vCnxlIxAYwyVx4vHAMAdW06TLMMUWrfViT5cL82zI4ZiNPcLt5
 HAtRbEWSa5ow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2020 18:19:39 -0700
IronPort-SDR: g+DHNb1xy/6WlYbREldUd/CdZC7SW5PLjNIi4djvDxjJvqv/3mitUJWFHulzONlKaXE8PHrcx2
 5CZDaABSQg0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,505,1583222400"; 
   d="scan'208";a="380886342"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jun 2020 18:19:39 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 12 Jun 2020 18:19:39 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX113.amr.corp.intel.com ([169.254.9.126]) with mapi id 14.03.0439.000;
 Fri, 12 Jun 2020 18:19:39 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
Subject: RE: linux-next: build warning after merge of the net-next tree
Thread-Topic: linux-next: build warning after merge of the net-next tree
Thread-Index: AQHWMpGs2FQHjjcR3ke+g8+izxT9Nqi7Is4AgBst3wD//4r6QA==
Date:   Sat, 13 Jun 2020 01:19:38 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986F666D@ORSMSX112.amr.corp.intel.com>
References: <20200525224004.799f54d4@canb.auug.org.au>
        <61CC2BC414934749BD9F5BF3D5D94044986D9CE3@ORSMSX112.amr.corp.intel.com>
 <20200613111616.79a01f31@canb.auug.org.au>
In-Reply-To: <20200613111616.79a01f31@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Sent: Friday, June 12, 2020 18:16
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: David Miller <davem@davemloft.net>; Networking
> <netdev@vger.kernel.org>; Linux Next Mailing List <linux-
> next@vger.kernel.org>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; Lifshits, Vitaly <vitaly.lifshits@intel.com>
> Subject: Re: linux-next: build warning after merge of the net-next tree
> 
> Hi all,
> 
> On Wed, 27 May 2020 01:15:09 +0000 "Kirsher, Jeffrey T"
> <jeffrey.t.kirsher@intel.com> wrote:
> >
> > > -----Original Message-----
> > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Sent: Monday, May 25, 2020 05:40
> > > To: David Miller <davem@davemloft.net>; Networking
> > > <netdev@vger.kernel.org>
> > > Cc: Linux Next Mailing List <linux-next@vger.kernel.org>; Linux
> > > Kernel Mailing List <linux-kernel@vger.kernel.org>; Lifshits, Vitaly
> > > <vitaly.lifshits@intel.com>; Kirsher, Jeffrey T
> > > <jeffrey.t.kirsher@intel.com>
> > > Subject: linux-next: build warning after merge of the net-next tree
> > >
> > > Hi all,
> > >
> > > After merging the net-next tree, today's linux-next build (sparc64
> > > defconfig) produced this warning:
> > >
> > > drivers/net/ethernet/intel/e1000e/netdev.c:137:13: warning:
> 'e1000e_check_me'
> > > defined but not used [-Wunused-function]  static bool
> > > e1000e_check_me(u16
> > > device_id)
> > >              ^~~~~~~~~~~~~~~
> > >
> > > Introduced by commit
> > >
> > >   e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME
> > > systems")
> > >
> > > CONFIG_PM_SLEEP is not set for this build.
> > >
> > [Kirsher, Jeffrey T]
> >
> > Vitaly informed me that he has a fix that he will be sending me, I will make
> sure to expedite it.
> 
> I am still getting this warning.

I apologize, I have not seen a fix from Vitaly, that I am aware of.  I will make sure you have a patch before Monday.
