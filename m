Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA20344CB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 12:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfFDKwv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jun 2019 06:52:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:36958 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbfFDKwu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 06:52:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 03:52:49 -0700
X-ExtLoop1: 1
Received: from pgsmsx112-dag.png.intel.com (HELO PGSMSX112.gar.corp.intel.com) ([10.108.55.234])
  by fmsmga004.fm.intel.com with ESMTP; 04 Jun 2019 03:52:47 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.93]) by
 PGSMSX112.gar.corp.intel.com ([169.254.3.134]) with mapi id 14.03.0415.000;
 Tue, 4 Jun 2019 18:44:52 +0800
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
Subject: RE: [PATCH net-next v5 0/5] net: stmmac: enable EHL SGMI
Thread-Topic: [PATCH net-next v5 0/5] net: stmmac: enable EHL SGMI
Thread-Index: AQHVF6gS/5FY/hbRY0qoIZQd1nkGR6aJUNoAgAIDo9A=
Date:   Tue, 4 Jun 2019 10:44:51 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814709476@PGSMSX103.gar.corp.intel.com>
References: <1559332694-6354-1-git-send-email-weifeng.voon@intel.com>
 <78EB27739596EE489E55E81C33FEC33A0B93B791@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B93B791@DE02WEMBXB.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This patch-set is to enable Ethernet controller (DW Ethernet QoS and
> > DW Ethernet PCS) with SGMII interface in Elkhart Lake.
> > The DW Ethernet PCS is the Physical Coding Sublayer that is between
> > Ethernet MAC and PHY and uses MDIO Clause-45 as Communication.
> 
> This series look fine to me but unfortunately I don't have my GMAC5.10
> setup available to test for regressions ... The changes look isolated
> though.
> 
> Could you please run the stmmac selftests at least and add the output
> here ?

Sure, the selftests feature is good as I am able to detect that the 
dwmac510_xpcs_ops misses the selftest entry. I will fix and add the
selftests results in the v6 cover letter. 


> 
> Thanks,
> Jose Miguel Abreu
