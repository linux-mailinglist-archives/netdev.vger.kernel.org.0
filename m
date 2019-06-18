Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84CA14A25D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfFRNgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:36:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:21689 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfFRNgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:36:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 06:36:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="164705578"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga006.jf.intel.com with ESMTP; 18 Jun 2019 06:36:03 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [RFC net-next 0/5] net: stmmac: Introducing IEEE802.1Qbv feature
Date:   Wed, 19 Jun 2019 05:36:13 +0800
Message-Id: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enabling IEEE 802.1Qbv Enhancements for Scheduled Traffics (EST) which
is available in EQoS ver5.xx. The EST features can be configured using
tc taprio hw offload which proposed by Vinicius. A few hw tunable data
are configured through platform data.

Ong Boon Leong (1):
  net: stmmac: introduce IEEE 802.1Qbv configuration functionalities

Vinicius Costa Gomes (1):
  taprio: Add support for hardware offloading

Voon Weifeng (3):
  net: stmmac: gcl errors reporting and its interrupt handling
  net: stmmac: enable HW offloading for tc taprio
  net: stmmac: Set TSN HW tunable after tsn setup

 drivers/net/ethernet/stmicro/stmmac/Makefile      |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h      |   4 +
 drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c  | 913 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.h  | 218 ++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  16 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  66 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  71 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c   |  96 +++
 include/linux/netdevice.h                         |   1 +
 include/linux/stmmac.h                            |   4 +
 include/net/pkt_sched.h                           |  18 +
 include/uapi/linux/pkt_sched.h                    |   4 +
 net/sched/sch_taprio.c                            | 263 ++++++-
 13 files changed, 1673 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dw_tsn_lib.h

-- 
1.9.1

