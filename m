Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625ADAA224
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 13:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733123AbfIEL6d convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 Sep 2019 07:58:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:46267 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731725AbfIEL6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 07:58:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 04:58:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="382866378"
Received: from pgsmsx105.gar.corp.intel.com ([10.221.44.96])
  by fmsmga005.fm.intel.com with ESMTP; 05 Sep 2019 04:58:31 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.25]) by
 PGSMSX105.gar.corp.intel.com ([169.254.4.133]) with mapi id 14.03.0439.000;
 Thu, 5 Sep 2019 19:58:29 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2 net-next] net: stmmac: Add support for MDIO interrupts
Thread-Topic: [PATCH v2 net-next] net: stmmac: Add support for MDIO
 interrupts
Thread-Index: AQHVYymBSgLFf/MxREuRucVyuWUrHacbFd8AgAEzd7D//9O3AIAA3mKw
Date:   Thu, 5 Sep 2019 11:58:29 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC81475C6AD@PGSMSX103.gar.corp.intel.com>
References: <1567605774-5500-1-git-send-email-weifeng.voon@intel.com>
 <20190904145804.GA9068@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81475C23E@PGSMSX103.gar.corp.intel.com>
 <20190905064002.GB415@lunn.ch>
In-Reply-To: <20190905064002.GB415@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The change log is near the end of the patch:
> > /**
> > --
> > Changelog v2
> > *mdio interrupt mode or polling mode will depends on mdio interrupt
> > enable bit *Disable the mdio interrupt enable bit in stmmac_release
> > *Remove the condition for initialize wait queues *Applied reverse
> > Christmas tree
> > 1.9.1
> 
> At the end, nobody sees it, because everybody else does it at the
> beginning.
> 
> https://www.kernel.org/doc/html/latest/process/submitting-
> patches.html?highlight=submitting#the-canonical-patch-format
> 
> This talks about the ---. David prefers to see the change log before the
> ---. Other maintainers want it after the ---.
> 
> >
> > >
> > > The formatting of this patch also looks a bit odd. Did you use git
> > > format-patch ; git send-email?
> >
> > Yes, I do git format-patch, then ./scripts/checkpatch.pl.
> > Lastly git send-email
> 
> What looked odd is the missing --- marker. git format-patch should of
> create that as part of the patch.
> 
>        Andrew

I found out why as I did a git format-patch with -p which is without the
Stat. I will resent v3 to using correct format.

Weifeng
