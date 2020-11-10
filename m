Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07EF2ACB34
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgKJCkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:40:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729243AbgKJCkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 21:40:39 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcJaG-006Cxk-HT; Tue, 10 Nov 2020 03:40:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 1/3] drivers: net: xilinx_emaclite: Add missing parameter kerneldoc
Date:   Tue, 10 Nov 2020 03:40:22 +0100
Message-Id: <20201110024024.1479741-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110024024.1479741-1-andrew@lunn.ch>
References: <20201110024024.1479741-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The txqueue parameter to the watchdog callback is unused in this
driver. But it still needs to be documented.

Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0c26f5bcc523..2c98e4cc07a5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -518,6 +518,7 @@ static int xemaclite_set_mac_address(struct net_device *dev, void *address)
 /**
  * xemaclite_tx_timeout - Callback for Tx Timeout
  * @dev:	Pointer to the network device
+ * @txqueue:	Unused
  *
  * This function is called when Tx time out occurs for Emaclite device.
  */
-- 
2.29.2

