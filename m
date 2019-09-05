Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7ACA9800
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 03:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbfIEBXN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 21:23:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:18044 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfIEBXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 21:23:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 18:23:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,469,1559545200"; 
   d="scan'208";a="358289549"
Received: from kmsmsx153.gar.corp.intel.com ([172.21.73.88])
  by orsmga005.jf.intel.com with ESMTP; 04 Sep 2019 18:23:10 -0700
Received: from pgsmsx110.gar.corp.intel.com (10.221.44.111) by
 KMSMSX153.gar.corp.intel.com (172.21.73.88) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Sep 2019 09:23:09 +0800
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.25]) by
 PGSMSX110.gar.corp.intel.com ([169.254.13.32]) with mapi id 14.03.0439.000;
 Thu, 5 Sep 2019 09:23:09 +0800
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
Thread-Index: AQHVYymBSgLFf/MxREuRucVyuWUrHacbFd8AgAEzd7A=
Date:   Thu, 5 Sep 2019 01:23:08 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC81475C23E@PGSMSX103.gar.corp.intel.com>
References: <1567605774-5500-1-git-send-email-weifeng.voon@intel.com>
 <20190904145804.GA9068@lunn.ch>
In-Reply-To: <20190904145804.GA9068@lunn.ch>
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

> On Wed, Sep 04, 2019 at 10:02:54PM +0800, Voon Weifeng wrote:
> > From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>
> >
> > DW EQoS v5.xx controllers added capability for interrupt generation
> > when MDIO interface is done (GMII Busy bit is cleared).
> > This patch adds support for this interrupt on supported HW to avoid
> > polling on GMII Busy bit.
> >
> > stmmac_mdio_read() & stmmac_mdio_write() will sleep until wake_up() is
> > called by the interrupt handler.
> >
> > Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
> > Reviewed-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> > Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> > Signed-off-by: Chuah, Kim Tatt <kim.tatt.chuah@intel.com>
> > Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> 
> Hi Voon
> 
> It is normal to include a short description of what you changed between
> the previous version and this version.

The change log is near the end of the patch:
/**
--
Changelog v2
*mdio interrupt mode or polling mode will depends on mdio interrupt enable bit
*Disable the mdio interrupt enable bit in stmmac_release
*Remove the condition for initialize wait queues
*Applied reverse Christmas tree
1.9.1

> 
> The formatting of this patch also looks a bit odd. Did you use git
> format-patch ; git send-email?

Yes, I do git format-patch, then ./scripts/checkpatch.pl. 
Lastly git send-email

> 
> Thanks
> 	Andrew
