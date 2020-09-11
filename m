Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C39266A41
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgIKVqF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Sep 2020 17:46:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:13222 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgIKVqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 17:46:04 -0400
IronPort-SDR: 4nHSfUgFUw3I7PyixEk31qyDHerIBZCvFCluNoYATBK5LL0s7rp2uET4rwQkuof7wGMgddtffU
 nItbzh2gCilg==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="176917614"
X-IronPort-AV: E=Sophos;i="5.76,417,1592895600"; 
   d="scan'208";a="176917614"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 14:46:03 -0700
IronPort-SDR: vu8B9FT5mMmo0YkxNNF8v838DT/3Dw7sgk5wcDjezmo8b8xhMpx8Cvh3iZJlXWQ+FnNj7bMK8l
 OHKvHq3W6MEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,417,1592895600"; 
   d="scan'208";a="301049489"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 11 Sep 2020 14:46:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Sep 2020 14:46:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Sep 2020 14:46:02 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.1713.004;
 Fri, 11 Sep 2020 14:46:02 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next v5 3/5] devlink: introduce flash update overwrite mask
Thread-Topic: [net-next v5 3/5] devlink: introduce flash update overwrite mask
Thread-Index: AQHWh7lr2xUM/L57BkyZM9jfL2dIQKljHLiAgAAAc4CAAN0F8A==
Date:   Fri, 11 Sep 2020 21:46:02 +0000
Message-ID: <2b1f6ce3a6a14a47a116a017a89cfd13@intel.com>
References: <20200910212812.2242377-1-jacob.e.keller@intel.com>
        <20200910212812.2242377-4-jacob.e.keller@intel.com>
        <20200910183229.72b808f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200910183405.16bbfe34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910183405.16bbfe34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 10, 2020 6:34 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [net-next v5 3/5] devlink: introduce flash update overwrite mask
> 
> On Thu, 10 Sep 2020 18:32:29 -0700 Jakub Kicinski wrote:
> > On Thu, 10 Sep 2020 14:28:10 -0700 Jacob Keller wrote:
> > > +#define DEVLINK_FLASH_OVERWRITE_SETTINGS
> BIT(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
> > > +#define DEVLINK_FLASH_OVERWRITE_IDENTIFIERS
> BIT(DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT)
> >
> > You got two more here.
> 
> Ah! FWIW I found the macro you can use instead: _BITUL(x)
> Couldn't grep that one out yesterday.

Thanks, will fix

-Jake
