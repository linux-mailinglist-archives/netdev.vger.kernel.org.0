Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975F82B139D
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgKMBBX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Nov 2020 20:01:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:10942 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMBBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 20:01:22 -0500
IronPort-SDR: 5Dx8NFtyqsGTBeGog/Engpc5K+nSlTLuEHhAMMihelAtV3RVzA/7vYEqxeklUHP+Qpmptoe4Wr
 bkr5ez/aAOTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="170576609"
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="170576609"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 17:01:14 -0800
IronPort-SDR: UTyCa1TTlO3Scx0RkJ2KoBpkmPVK0edGxutARnjcBJ/P3wunH0pyc2qGDybmyyKjlkhru56qc4
 NWDhKmqymz2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="309009253"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 12 Nov 2020 17:01:14 -0800
Received: from shsmsx603.ccr.corp.intel.com (10.109.6.143) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Nov 2020 17:01:13 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX603.ccr.corp.intel.com (10.109.6.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Nov 2020 09:01:11 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.1713.004;
 Fri, 13 Nov 2020 09:01:11 +0800
From:   "Li, Philip" <philip.li@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     lkp <lkp@intel.com>, Dmytro Shytyi <dmytro@shytyi.net>,
        kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
Subject: RE: [kbuild-all] Re: [PATCH net-next] net: Variable SLAAC: SLAAC with
 prefixes of arbitrary length in PIO
Thread-Topic: [kbuild-all] Re: [PATCH net-next] net: Variable SLAAC: SLAAC
 with prefixes of arbitrary length in PIO
Thread-Index: AQHWt8rnymHV+oRFv0+mSedV58/YYKnEsPmAgACHjsD//3/5gIAAhmeA
Date:   Fri, 13 Nov 2020 01:01:11 +0000
Message-ID: <905a3ef02edb4aa9883ae4d6080120a9@intel.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <20201112162423.6b4de8d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5bc4f8ce9a6c40029043bc902a38af25@intel.com>
 <20201112165119.54bd07ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112165119.54bd07ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> On Fri, 13 Nov 2020 00:32:55 +0000 Li, Philip wrote:
> > > Subject: [kbuild-all] Re: [PATCH net-next] net: Variable SLAAC: SLAAC
> with
> > > prefixes of arbitrary length in PIO
> > >
> > > On Wed, 11 Nov 2020 09:34:24 +0800 kernel test robot wrote:
> > > > If you fix the issue, kindly add following tag as appropriate
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > Good people of kernel test robot, could you please rephrase this to say
> > > that the tag is only appropriate if someone is sending a fix up/follow
> > > up patch?
> > Thanks for the input, based on your suggestion how about
> >
> > Kindly add below tag as appropriate if you send a fix up/follow up patch
> 
> I'm not sure myself how best to phrase it, I'm not a native speaker.
> How about:
> 
> Kindly add below tag if you send a new patch solely addressing this issue
Thanks, we will consider this, and provide update next week to gather
more inputs. If anyone has further suggestion, it will be very welcome.

There did have some confusion and discussed earlier actually regarding
when/how to add the Reported-by, thus we use appropriate to let developer
decide the best choice for his own situation. But if it leads to confusion,
we will keep looking for a better way.

BTW: if we just remove this message line, and leave below Reported-by only, would
it be a good choice? 

> 
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > Or any wording change suggestion to make it more clear/friendly?

