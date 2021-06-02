Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A1F398144
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhFBGnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:43:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3503 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhFBGnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:43:04 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvzrD1jB3zYs59;
        Wed,  2 Jun 2021 14:38:36 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:41:19 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] Bluetooth: Fix spelling mistakes
Date:   Wed, 2 Jun 2021 14:54:58 +0800
Message-ID: <20210602065458.105041-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
udpate  ==> update
retreive  ==> retrieve
accidentially  ==> accidentally
correspondig  ==> corresponding
adddress  ==> address
estabilish  ==> establish
commplete  ==> complete
Unkown  ==> Unknown
triggerd  ==> triggered
transtion  ==> transition

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/bluetooth/hci_conn.c  | 2 +-
 net/bluetooth/hci_core.c  | 8 ++++----
 net/bluetooth/hci_event.c | 2 +-
 net/bluetooth/hci_sock.c  | 6 +++---
 net/bluetooth/mgmt.c      | 2 +-
 net/bluetooth/smp.c       | 6 +++---
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 88ec08978ff4..0ceb72d32208 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -758,7 +758,7 @@ void hci_le_conn_failed(struct hci_conn *conn, u8 status)
 	conn->state = BT_CLOSED;
 
 	/* If the status indicates successful cancellation of
-	 * the attempt (i.e. Unkown Connection Id) there's no point of
+	 * the attempt (i.e. Unknown Connection Id) there's no point of
 	 * notifying failure since we'll go back to keep trying to
 	 * connect. The only exception is explicit connect requests
 	 * where a timeout + cancel does indicate an actual failure.
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index fd12f1652bdf..aa214834c374 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -648,7 +648,7 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
 						 */
 
 		/* If the controller supports Extended Scanner Filter
-		 * Policies, enable the correspondig event.
+		 * Policies, enable the corresponding event.
 		 */
 		if (hdev->le_features[0] & HCI_LE_EXT_SCAN_POLICY)
 			events[1] |= 0x04;	/* LE Direct Advertising
@@ -1454,7 +1454,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 		}
 
 		/* Check for valid public address or a configured static
-		 * random adddress, but let the HCI setup proceed to
+		 * random address, but let the HCI setup proceed to
 		 * be able to determine if there is a public address
 		 * or not.
 		 *
@@ -3544,7 +3544,7 @@ void hci_conn_params_clear_disabled(struct hci_dev *hdev)
 		if (params->auto_connect != HCI_AUTO_CONN_DISABLED)
 			continue;
 
-		/* If trying to estabilish one time connection to disabled
+		/* If trying to establish one time connection to disabled
 		 * device, leave the params, but mark them as just once.
 		 */
 		if (params->explicit_connect) {
@@ -4279,7 +4279,7 @@ void *hci_sent_cmd_data(struct hci_dev *hdev, __u16 opcode)
 	return hdev->sent_cmd->data + HCI_COMMAND_HDR_SIZE;
 }
 
-/* Send HCI command and wait for command commplete event */
+/* Send HCI command and wait for command complete event */
 struct sk_buff *hci_cmd_sync(struct hci_dev *hdev, u16 opcode, u32 plen,
 			     const void *param, u32 timeout)
 {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 016b2999f219..ea06b010ccad 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6032,7 +6032,7 @@ static bool hci_get_cmd_complete(struct hci_dev *hdev, u16 opcode,
 		return true;
 	}
 
-	/* Check if request ended in Command Status - no way to retreive
+	/* Check if request ended in Command Status - no way to retrieve
 	 * any extra parameters in this case.
 	 */
 	if (hdr->evt == HCI_EV_CMD_STATUS)
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 251b9128f530..6ef98a887571 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1130,7 +1130,7 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 		if (!hci_sock_gen_cookie(sk)) {
 			/* In the case when a cookie has already been assigned,
 			 * then there has been already an ioctl issued against
-			 * an unbound socket and with that triggerd an open
+			 * an unbound socket and with that triggered an open
 			 * notification. Send a close notification first to
 			 * allow the state transition to bounded.
 			 */
@@ -1326,9 +1326,9 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 		if (hci_pi(sk)->channel == HCI_CHANNEL_CONTROL) {
 			if (!hci_sock_gen_cookie(sk)) {
 				/* In the case when a cookie has already been
-				 * assigned, this socket will transtion from
+				 * assigned, this socket will transition from
 				 * a raw socket into a control socket. To
-				 * allow for a clean transtion, send the
+				 * allow for a clean transition, send the
 				 * close notification first.
 				 */
 				skb = create_monitor_ctrl_close(sk);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index f9be7f9084d6..f290d0c54d32 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3341,7 +3341,7 @@ static int set_local_name(struct sock *sk, struct hci_dev *hdev, void *data,
 	}
 
 	/* The name is stored in the scan response data and so
-	 * no need to udpate the advertising data here.
+	 * no need to update the advertising data here.
 	 */
 	if (lmp_le_capable(hdev) && hci_dev_test_flag(hdev, HCI_ADVERTISING))
 		__hci_req_update_scan_rsp_data(&req, hdev->cur_adv_instance);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 372e3b25aaa4..93144e0c7efa 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -40,7 +40,7 @@
 	((struct smp_dev *)((struct l2cap_chan *)((hdev)->smp_data))->data)
 
 /* Low-level debug macros to be used for stuff that we don't want
- * accidentially in dmesg, i.e. the values of the various crypto keys
+ * accidentally in dmesg, i.e. the values of the various crypto keys
  * and the inputs & outputs of crypto functions.
  */
 #ifdef DEBUG
@@ -560,7 +560,7 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
 				return err;
 
 			/* This is unlikely, but we need to check that
-			 * we didn't accidentially generate a debug key.
+			 * we didn't accidentally generate a debug key.
 			 */
 			if (crypto_memneq(smp->local_pk, debug_pk, 64))
 				break;
@@ -1902,7 +1902,7 @@ static u8 sc_send_public_key(struct smp_chan *smp)
 				return SMP_UNSPECIFIED;
 
 			/* This is unlikely, but we need to check that
-			 * we didn't accidentially generate a debug key.
+			 * we didn't accidentally generate a debug key.
 			 */
 			if (crypto_memneq(smp->local_pk, debug_pk, 64))
 				break;
-- 
2.25.1

