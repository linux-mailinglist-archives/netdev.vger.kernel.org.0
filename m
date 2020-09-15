Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70F9269B0B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIOB04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:26:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:19876 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgIOB04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:26:56 -0400
IronPort-SDR: ACLzazRlii4pXL+zz0yuIApwvt9VfsIoiKsZnb3H3tXIxJ9ozAqJ0sYVlsuGCmSBWRYIP0OzBD
 7tv2BL7IODmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="139195469"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="139195469"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:26:55 -0700
IronPort-SDR: X1mLw+WKIcGdRUEAS6YE3OAgd0yykakJDcHVHbcztrxjTp4xUteXKRmpVAqN8mjkKphG9dntir
 efLOrLzVs3Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="345632589"
Received: from glass.png.intel.com ([172.30.181.92])
  by orsmga007.jf.intel.com with ESMTP; 14 Sep 2020 18:26:50 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Rusell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Vijaya Balan Sadhishkhanna 
        <sadhishkhanna.vijaya.balan@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>
Subject: [PATCH net-next 0/3] net: stmmac: Add ethtool support for get|set channels
Date:   Tue, 15 Sep 2020 09:28:37 +0800
Message-Id: <20200915012840.31841-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is to add support for user to get or set Tx/Rx channel
via ethtool. There are two patches that fixes bug introduced on upstream
in order to have the feature work.

Tested on Intel Tigerlake Platform.

Aashish Verma (1):
  net: stmmac: Fix incorrect location to set real_num_rx|tx_queues

Ong Boon Leong (2):
  net: stmmac: add ethtool support for get/set channels
  net: stmmac: use netif_tx_start|stop_all_queues() function

 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  26 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 135 +++++++++---------
 3 files changed, 98 insertions(+), 64 deletions(-)

-- 
2.17.0

