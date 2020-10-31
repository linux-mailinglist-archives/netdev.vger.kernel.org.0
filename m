Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31E42A1915
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 18:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgJaRrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 13:47:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgJaRrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 13:47:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYuyU-004XAO-IB; Sat, 31 Oct 2020 18:47:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/3] drivers: net: xilinx_emaclite: Add missing parameter kerneldoc
Date:   Sat, 31 Oct 2020 18:47:19 +0100
Message-Id: <20201031174721.1080756-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031174721.1080756-1-andrew@lunn.ch>
References: <20201031174721.1080756-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The txqueue parameter to the watchdog callback is unused in this
driver. But it still needs to be documented.

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
2.28.0

