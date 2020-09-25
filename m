Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FBD278431
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgIYJir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:38:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:9653 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgIYJir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 05:38:47 -0400
IronPort-SDR: rcSuxplNg4ELtBsPvtkFNdwxgkgxI8P2nhi8CqMat9O+PFFEpLi7iSHUSVNQBCBCgcD3mnTQoK
 /QBXtZQspm/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="179567455"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="179567455"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 02:38:47 -0700
IronPort-SDR: UVYHkA+vVLvG0bs05VJZW5OxL9S6dps6B4bM8Uo+t3YxsbpK3IP8mFbOehDbvEBf6mdg4Npjod
 OoiLMayKkDww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="455752636"
Received: from glass.png.intel.com ([172.30.181.92])
  by orsmga004.jf.intel.com with ESMTP; 25 Sep 2020 02:38:42 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Vijaya Balan Sadhishkhanna 
        <sadhishkhanna.vijaya.balan@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>
Subject: [PATCH net-next 0/1] net: stmmac: Enable VLAN filter fail queue for Intel platform data
Date:   Fri, 25 Sep 2020 17:40:40 +0800
Message-Id: <20200925094041.12038-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up on a earlier patch submission at:-
https://patchwork.ozlabs.org/patch/1275604/

Changes since the previous patch submission:
- Enable VLAN fail queue for Intel platform data (dwmac-intel).
- Steer the VLAN failed packet to the last Rx queue.


Chuah, Kim Tatt (1):
  net: stmmac: Add option for VLAN filter fail queue enable

 drivers/net/ethernet/stmicro/stmmac/common.h      |  2 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |  5 +++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 15 +++++++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h      |  6 ++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +++
 include/linux/stmmac.h                            |  2 ++
 7 files changed, 32 insertions(+), 2 deletions(-)

-- 
2.17.0

