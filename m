Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45EDC1479CF
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 09:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbgAXI5A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jan 2020 03:57:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:6017 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgAXI5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 03:57:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 00:57:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,357,1574150400"; 
   d="scan'208";a="260174253"
Received: from pgsmsx104.gar.corp.intel.com ([10.221.44.91])
  by fmsmga002.fm.intel.com with ESMTP; 24 Jan 2020 00:56:57 -0800
Received: from pgsmsx114.gar.corp.intel.com ([169.254.4.192]) by
 PGSMSX104.gar.corp.intel.com ([169.254.3.14]) with mapi id 14.03.0439.000;
 Fri, 24 Jan 2020 16:56:56 +0800
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Joao Pinto" <Joao.Pinto@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Alexandru Ardelean" <alexandru.ardelean@analog.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v3 2/5] net: stmmac: fix incorrect GMAC_VLAN_TAG
 register writting in GMAC4+
Thread-Topic: [PATCH net v3 2/5] net: stmmac: fix incorrect GMAC_VLAN_TAG
 register writting in GMAC4+
Thread-Index: AQHV0QSDmNiamEvEckGAHFcP1jevNaf19hiAgAOQN5A=
Date:   Fri, 24 Jan 2020 08:56:56 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B75C488EF5@pgsmsx114.gar.corp.intel.com>
References: <20200122090936.28555-1-boon.leong.ong@intel.com>
 <20200122090936.28555-3-boon.leong.ong@intel.com>
 <BN8PR12MB326699D4E4CD49804F2E5097D30C0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB326699D4E4CD49804F2E5097D30C0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-GB, en-US
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

>Thanks for adding patch 4/5 but I meant in previous reply that this patch
>should also go for XGMAC cores ...
>
Noted. We will add tis in v4. 
 
