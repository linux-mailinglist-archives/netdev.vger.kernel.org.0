Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED415612B1F
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 16:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJ3PDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 11:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ3PDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 11:03:44 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2486F29D
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 08:03:43 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id g4-20020adfbc84000000b0022fc417f87cso2189140wrh.12
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 08:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bCYE4qx05izYsowYR+uebTwUf/NzWHyoShQmQS5qpMQ=;
        b=s6x+SrrMI876yyJKY1YRxPDjhMg8r5eb68BKG799mKsjBasrVc5Hy/JQagQTnsdO9B
         L5XaYHYsrm7m+zxdW8NN9/eICEhaEcvtGXvtAIhJZPGWb/nhyxIcSX+Kd36dQCaQA8Qb
         fbXOkdmljMPGkXxO29unV8nsBQngrmp/d3P1gVTRYA3jXj5DLUPdZsZ/ffPW5e+NYNjZ
         8qL1OSbphqgsh1/A/OrCknpxggR/m6y6AwoG7cGrhd3LKS4WgjiNY00f1pjcEuKuFyQl
         w5hrP8VZFmUOTjk8U67qX170HXAU9GrU1i2ckRRaRXY0l48ae5IM8rdirXsb1OOc2qgL
         3s6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bCYE4qx05izYsowYR+uebTwUf/NzWHyoShQmQS5qpMQ=;
        b=eGD9lXE6ibLBSuWNkvlxlqgYxayJ/tujgj6p+niniv5FLHzQlePk/5nr15hSIuRq+M
         6qjkmtKroIltUCUoUiSNtIz5hFtFgCPD0f3ei/OEs/lO77XWHc0h6kfl8+lOFPWGa0/v
         piYIJEhvQq7AJJqqdqRWV/C81nqwNbbuyA9rZTM0zvqnR29j5o2zC3zR5Fm0GklrAOel
         vK8tAYIqEUh/XXiu1uUy/MfNoRnJQdi1ZHU5U0MktJMCoLyXeDFlE/jlEhz+S1NR0RFo
         AM7nnlel6eu5YlhINkR3q+bPZzGMiwkecDtJOAbJEf+o1zEWj5gpB7SgbMvfu2+mkUiR
         ulSg==
X-Gm-Message-State: ACrzQf2mlRqOT0yXn8yxmuafkiiXBY2Djv/wgA1aMLetWyfzg8HjiIZL
        DO3RU228ESInSMiO1q9qkJl3tQJp2pJw
X-Google-Smtp-Source: AMsMyM4MO6D7JdJYn/L5TbweM/kytVKdfDdcYw7dfnN+lOuaaTyZkFJsu/BNbm/AXGof22h9BBKfPC0+tWsx
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:9511:b66:ed30:9ace])
 (user=dvyukov job=sendgmr) by 2002:a5d:4441:0:b0:236:6c3e:efb4 with SMTP id
 x1-20020a5d4441000000b002366c3eefb4mr5096954wrr.539.1667142221486; Sun, 30
 Oct 2022 08:03:41 -0700 (PDT)
Date:   Sun, 30 Oct 2022 16:03:37 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221030150337.3379753-1-dvyukov@google.com>
Subject: [PATCH] nfc: Add KCOV annotations
From:   Dmitry Vyukov <dvyukov@google.com>
To:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org
Cc:     syzkaller@googlegroups.com, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add remote KCOV annotations for NFC processing that is done
in background threads. This enables efficient coverage-guided
fuzzing of the NFC subsystem.

The intention is to add annotations to background threads that
process skb's that were allocated in syscall context
(thus have a KCOV handle associated with the current fuzz test).
This includes nci_recv_frame() that is called by the virtual nci
driver in the syscall context.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: netdev@vger.kernel.org

---

Here is this commit on github if it makes it easier for you to review:
https://github.com/dvyukov/linux/commit/de173650f38b05cabd6fc7878b3ffddfd6a6a42d

---
 net/nfc/nci/core.c | 8 +++++++-
 net/nfc/nci/hci.c  | 4 +++-
 net/nfc/rawsock.c  | 3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 6a193cce2a754..dbe5258e13ffe 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/bitops.h>
 #include <linux/skbuff.h>
+#include <linux/kcov.h>
 
 #include "../nfc.h"
 #include <net/nfc/nci.h>
@@ -1472,6 +1473,7 @@ static void nci_tx_work(struct work_struct *work)
 		skb = skb_dequeue(&ndev->tx_q);
 		if (!skb)
 			return;
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
 
 		/* Check if data flow control is used */
 		if (atomic_read(&conn_info->credits_cnt) !=
@@ -1487,6 +1489,7 @@ static void nci_tx_work(struct work_struct *work)
 
 		mod_timer(&ndev->data_timer,
 			  jiffies + msecs_to_jiffies(NCI_DATA_TIMEOUT));
+		kcov_remote_stop();
 	}
 }
 
@@ -1497,7 +1500,8 @@ static void nci_rx_work(struct work_struct *work)
 	struct nci_dev *ndev = container_of(work, struct nci_dev, rx_work);
 	struct sk_buff *skb;
 
-	while ((skb = skb_dequeue(&ndev->rx_q))) {
+	for (; (skb = skb_dequeue(&ndev->rx_q)); kcov_remote_stop()) {
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
 
 		/* Send copy to sniffer */
 		nfc_send_to_raw_sock(ndev->nfc_dev, skb,
@@ -1551,6 +1555,7 @@ static void nci_cmd_work(struct work_struct *work)
 		if (!skb)
 			return;
 
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
 		atomic_dec(&ndev->cmd_cnt);
 
 		pr_debug("NCI TX: MT=cmd, PBF=%d, GID=0x%x, OID=0x%x, plen=%d\n",
@@ -1563,6 +1568,7 @@ static void nci_cmd_work(struct work_struct *work)
 
 		mod_timer(&ndev->cmd_timer,
 			  jiffies + msecs_to_jiffies(NCI_CMD_TIMEOUT));
+		kcov_remote_stop();
 	}
 }
 
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 78c4b6addf15a..de175318a3a0f 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -14,6 +14,7 @@
 #include <net/nfc/nci.h>
 #include <net/nfc/nci_core.h>
 #include <linux/nfc.h>
+#include <linux/kcov.h>
 
 struct nci_data {
 	u8 conn_id;
@@ -409,7 +410,8 @@ static void nci_hci_msg_rx_work(struct work_struct *work)
 	const struct nci_hcp_message *message;
 	u8 pipe, type, instruction;
 
-	while ((skb = skb_dequeue(&hdev->msg_rx_queue)) != NULL) {
+	for (; (skb = skb_dequeue(&hdev->msg_rx_queue)); kcov_remote_stop()) {
+		kcov_remote_start_common(skb_get_kcov_handle(skb));
 		pipe = NCI_HCP_MSG_GET_PIPE(skb->data[0]);
 		skb_pull(skb, NCI_HCI_HCP_PACKET_HEADER_LEN);
 		message = (struct nci_hcp_message *)skb->data;
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 8dd569765f96e..5125392bb68eb 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -12,6 +12,7 @@
 #include <net/tcp_states.h>
 #include <linux/nfc.h>
 #include <linux/export.h>
+#include <linux/kcov.h>
 
 #include "nfc.h"
 
@@ -189,6 +190,7 @@ static void rawsock_tx_work(struct work_struct *work)
 	}
 
 	skb = skb_dequeue(&sk->sk_write_queue);
+	kcov_remote_start_common(skb_get_kcov_handle(skb));
 
 	sock_hold(sk);
 	rc = nfc_data_exchange(dev, target_idx, skb,
@@ -197,6 +199,7 @@ static void rawsock_tx_work(struct work_struct *work)
 		rawsock_report_error(sk, rc);
 		sock_put(sk);
 	}
+	kcov_remote_stop();
 }
 
 static int rawsock_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)

base-commit: 02a97e02c64fb3245b84835cbbed1c3a3222e2f1
-- 
2.38.1.273.g43a17bfeac-goog

