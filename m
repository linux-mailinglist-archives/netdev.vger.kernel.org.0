Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E19A088A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfH1Rde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:33:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:19308 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1Rdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 13:33:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 10:33:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="182093696"
Received: from glass.png.intel.com ([172.30.181.95])
  by fmsmga007.fm.intel.com with ESMTP; 28 Aug 2019 10:33:30 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     davem@davemloft.net, linux@armlinux.org.uk,
        mcoquelin.stm32@gmail.com, joabreu@synopsys.com,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.comi, alexandre.torgue@st.com,
        weifeng.voon@intel.com
Subject: [RFC net-next v1 3/5] net: phy: add private data to mdio_device
Date:   Thu, 29 Aug 2019 01:33:19 +0800
Message-Id: <20190828173321.25334-4-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190828173321.25334-1-boon.leong.ong@intel.com>
References: <20190828173321.25334-1-boon.leong.ong@intel.com>
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

