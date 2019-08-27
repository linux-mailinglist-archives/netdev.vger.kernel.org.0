Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828009E5A1
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfH0KZ7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 06:25:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:1918 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbfH0KZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:25:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 03:25:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,436,1559545200"; 
   d="scan'208";a="171151201"
Received: from kmsmsx157.gar.corp.intel.com ([172.21.138.134])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 03:25:55 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.25]) by
 kmsmsx157.gar.corp.intel.com ([169.254.5.162]) with mapi id 14.03.0439.000;
 Tue, 27 Aug 2019 18:25:54 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Thread-Topic: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
Thread-Index: AQHVXDc1t4vgWavJu0GuD73CQMEeB6cNa/mAgAFexdA=
Date:   Tue, 27 Aug 2019 10:25:54 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814758D9E@PGSMSX103.gar.corp.intel.com>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
 <20190826.142853.2135315525185656171.davem@davemloft.net>
In-Reply-To: <20190826.142853.2135315525185656171.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There is something wrong with the clock on the computer you are posting
> these patches from, the date in these postings are in the future by
> several hours.
> 
> This messes up the ordering of changes in patchwork and makes my life
> miserable to a certain degree, so please fix this.
> 
> Thank you.

Sorry about that as my machine's date somehow went out of
sync with the server time. I have already fixed that.

Thanks,
Weifeng
