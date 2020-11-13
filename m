Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CED42B1346
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgKMAc7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Nov 2020 19:32:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:47606 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:32:58 -0500
IronPort-SDR: uUX0y3cqj41IbZ2czIFdTp5Y74yjGp27dVXOTXB2rx8kKC5mDDV4pnslOlvUwJWy4E0/KHuysu
 hhKTTiNcga/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="169621638"
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="169621638"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 16:32:58 -0800
IronPort-SDR: O4WV4hjsdA5G7ttgHqJHgEGPfwF0hKx2MMEvPJRpDHTiUzuY7gnXHRvd2+ScNIlhwJIXQV7fXn
 wYsCge5A1tKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="532376721"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 12 Nov 2020 16:32:58 -0800
Received: from shsmsx606.ccr.corp.intel.com (10.109.6.216) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Nov 2020 16:32:57 -0800
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX606.ccr.corp.intel.com (10.109.6.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Nov 2020 08:32:55 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.1713.004;
 Fri, 13 Nov 2020 08:32:55 +0800
From:   "Li, Philip" <philip.li@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, lkp <lkp@intel.com>
CC:     Dmytro Shytyi <dmytro@shytyi.net>, kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
Subject: RE: [kbuild-all] Re: [PATCH net-next] net: Variable SLAAC: SLAAC with
 prefixes of arbitrary length in PIO
Thread-Topic: [kbuild-all] Re: [PATCH net-next] net: Variable SLAAC: SLAAC
 with prefixes of arbitrary length in PIO
Thread-Index: AQHWt8rnymHV+oRFv0+mSedV58/YYKnEsPmAgACHjsA=
Date:   Fri, 13 Nov 2020 00:32:55 +0000
Message-ID: <5bc4f8ce9a6c40029043bc902a38af25@intel.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
 <20201112162423.6b4de8d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112162423.6b4de8d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

> Subject: [kbuild-all] Re: [PATCH net-next] net: Variable SLAAC: SLAAC with
> prefixes of arbitrary length in PIO
> 
> On Wed, 11 Nov 2020 09:34:24 +0800 kernel test robot wrote:
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> 
> Good people of kernel test robot, could you please rephrase this to say
> that the tag is only appropriate if someone is sending a fix up/follow
> up patch?
Thanks for the input, based on your suggestion how about

Kindly add below tag as appropriate if you send a fix up/follow up patch
Reported-by: kernel test robot <lkp@intel.com>

Or any wording change suggestion to make it more clear/friendly?

Thanks

> 
> Folks keep adding those tags on the next revisions of the their patches
> which is quite misleading.
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
