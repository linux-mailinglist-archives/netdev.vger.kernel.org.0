Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E844185807
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgCOBxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:53:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51804 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbgCOBxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:53:51 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 53A42D97348215CCE5A9;
        Sat, 14 Mar 2020 18:06:23 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Sat, 14 Mar 2020
 18:06:13 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <luiz.von.dentz@intel.com>
CC:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] Bluetooth: L2CAP: remove set but not used variable 'credits'
Date:   Sat, 14 Mar 2020 18:06:06 +0800
Message-ID: <20200314100606.41532-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/bluetooth/l2cap_core.c: In function l2cap_ecred_conn_req:
net/bluetooth/l2cap_core.c:5848:6: warning: variable credits set but not used [-Wunused-but-set-variable]

commit 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
involved this unused variable, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/bluetooth/l2cap_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 5e6e35ab44dd..8b0fca39989d 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5845,7 +5845,7 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		__le16 dcid[5];
 	} __packed pdu;
 	struct l2cap_chan *chan, *pchan;
-	u16 credits, mtu, mps;
+	u16 mtu, mps;
 	__le16 psm;
 	u8 result, len = 0;
 	int i, num_scid;
@@ -5868,7 +5868,6 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	}
 
 	psm  = req->psm;
-	credits = 0;
 
 	BT_DBG("psm 0x%2.2x mtu %u mps %u", __le16_to_cpu(psm), mtu, mps);
 
-- 
2.20.1


