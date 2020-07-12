Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9721CC19
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgGLXQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:16:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgGLXP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPD-Hj; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 02/20] net: can: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:14:58 +0200
Message-Id: <20200712231516.1139335-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/can/af_can.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 128d37a4c2e0..5c06404bdf3e 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -410,6 +410,7 @@ static struct hlist_head *can_rcv_list_find(canid_t *can_id, canid_t *mask,
 
 /**
  * can_rx_register - subscribe CAN frames from a specific interface
+ * @net: the applicable net namespace
  * @dev: pointer to netdevice (NULL => subcribe from 'all' CAN devices list)
  * @can_id: CAN identifier (see description)
  * @mask: CAN mask (see description)
@@ -498,6 +499,7 @@ static void can_rx_delete_receiver(struct rcu_head *rp)
 
 /**
  * can_rx_unregister - unsubscribe CAN frames from a specific interface
+ * @net: the applicable net namespace
  * @dev: pointer to netdevice (NULL => unsubscribe from 'all' CAN devices list)
  * @can_id: CAN identifier
  * @mask: CAN mask
-- 
2.27.0.rc2

