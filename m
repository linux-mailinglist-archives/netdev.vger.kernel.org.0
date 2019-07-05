Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127066011D
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfGEGnb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Jul 2019 02:43:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:5049 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbfGEGnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 02:43:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 23:43:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,454,1557212400"; 
   d="scan'208";a="155211389"
Received: from pgsmsx111.gar.corp.intel.com ([10.108.55.200])
  by orsmga007.jf.intel.com with ESMTP; 04 Jul 2019 23:43:27 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.4]) by
 PGSMSX111.gar.corp.intel.com ([169.254.2.22]) with mapi id 14.03.0439.000;
 Fri, 5 Jul 2019 14:43:27 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Thread-Topic: [PATCH v1 net-next] net: stmmac: enable clause 45 mdio support
Thread-Index: AQHVMUGmUw8CyhUBakCg51utnm9b/6a4aBMAgAFBlaD//59qAIAArWRQgAAA3wCAAJ+BsP//gXOAgAE5twD//6BVAAAUiF6w
Date:   Fri, 5 Jul 2019 06:43:26 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814738BFB@PGSMSX103.gar.corp.intel.com>
References: <1562147404-4371-1-git-send-email-weifeng.voon@intel.com>
 <20190703140520.GA18473@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147384B6@PGSMSX103.gar.corp.intel.com>
 <20190704033038.GA6276@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC81473862D@PGSMSX103.gar.corp.intel.com>
 <20190704135420.GD13859@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8147388E0@PGSMSX103.gar.corp.intel.com>
 <20190704155217.GI18473@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC814738B36@PGSMSX103.gar.corp.intel.com>
 <20190705045242.GB30115@lunn.ch>
In-Reply-To: <20190705045242.GB30115@lunn.ch>
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

> > If the community prefers readability
> 
> Readability nearly always comes first. There is nothing performance
> critical here, MDIO is a slow bus. So the code should be readable,
> simple to understand.
> 
Noted and thanks for the comments.

> 
> , I will suggest to do the c45 setup in
> > both stmmac_mdio_read() and stmmac_mdio_write() 's if(C45) condition
> rather
> > than splitting into 2 new c45_read() and c45_write() functions.
> 
> Fine.
> 
> 	Andrew

I will start preparing v2. Thanks.  

Weifeng
