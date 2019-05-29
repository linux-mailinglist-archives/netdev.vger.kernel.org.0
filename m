Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C342C2D7F0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfE2IjO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 May 2019 04:39:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:1548 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2IjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 04:39:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 01:39:14 -0700
X-ExtLoop1: 1
Received: from pgsmsx105.gar.corp.intel.com ([10.221.44.96])
  by orsmga001.jf.intel.com with ESMTP; 29 May 2019 01:39:11 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.93]) by
 PGSMSX105.gar.corp.intel.com ([169.254.4.53]) with mapi id 14.03.0415.000;
 Wed, 29 May 2019 16:39:10 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v3 0/5] net: stmmac: enable EHL SGMII
Thread-Topic: [PATCH net-next v3 0/5] net: stmmac: enable EHL SGMII
Thread-Index: AQHVFcTZLHl57v7lrUiIrmrnYDAoDqaBNN0AgACP6TA=
Date:   Wed, 29 May 2019 08:39:09 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC81470697E@PGSMSX103.gar.corp.intel.com>
References: <1559125118-24324-1-git-send-email-weifeng.voon@intel.com>
 <78EB27739596EE489E55E81C33FEC33A0B932F7F@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B932F7F@DE02WEMBXB.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> Did you rebase this series against latest net-next tree ?
> 
> Because you are missing MMC module in your HWIF table entry. This module
> was recently added with the addition of selftests.

No, the base is on last Thursday. Let me rebased on the latest net-next and submit for v4.

Thanks,
Weifeng

> 
> Thanks,
> Jose Miguel Abreu
