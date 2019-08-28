Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92442A08E8
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfH1Rry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:47:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:20453 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfH1Rrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 13:47:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 10:47:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="192675396"
Received: from glass.png.intel.com ([172.30.181.95])
  by orsmga002.jf.intel.com with ESMTP; 28 Aug 2019 10:47:34 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     davem@davemloft.net, linux@armlinux.org.uk,
        mcoquelin.stm32@gmail.com, joabreu@synopsys.com,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        weifeng.voon@intel.com
Subject: [RFC net-next v2 3/5] net: phy: add private data to mdio_device
Date:   Thu, 29 Aug 2019 01:47:20 +0800
Message-Id: <20190828174722.6726-4-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190828174722.6726-1-boon.leong.ong@intel.com>
References: <20190828174722.6726-1-boon.leong.ong@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY converter device is represented as mdio_device and requires private
data. So, we add pointer for private data to mdio_device struct.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 include/linux/mdio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index e0ccd56a7ac0..fc7dfbe75006 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -40,6 +40,8 @@ struct mdio_device {
 	struct reset_control *reset_ctrl;
 	unsigned int reset_assert_delay;
 	unsigned int reset_deassert_delay;
+	/* Private data */
+	void *priv;
 };
 #define to_mdio_device(d) container_of(d, struct mdio_device, dev)
 
-- 
2.17.0

