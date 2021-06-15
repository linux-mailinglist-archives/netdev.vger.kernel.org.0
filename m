Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B796D3A7D10
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhFOL1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:27:05 -0400
Received: from m12-16.163.com ([220.181.12.16]:58699 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229939AbhFOL07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 07:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=B6k7i
        nvKCT/Pz/OK8O9wGyXAn8lzcUGY7sIqYwEMwyw=; b=WY1pMQvx9gAjEo7kEXQFF
        SrFBFF718IQhhQBFfWXEszuJwXmxO+AMrMdW6Ii8PWlC5nlEQyKpRqJ4YiHIQLlm
        hVcyRjjqG03RqjExeD2vd3Xq/Ao8Vqp+YenUbb2IoI+G2kCpXOQQSY58sEfcRkOH
        HLPumxYGhw63tn95zvj7/E=
Received: from ubuntu.localdomain (unknown [112.37.241.255])
        by smtp12 (Coremail) with SMTP id EMCowAA3ZkH9jchg_4XgxQ--.64545S2;
        Tue, 15 Jun 2021 19:24:46 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] Bluetooth: Fix a spelling mistake
Date:   Tue, 15 Jun 2021 19:24:43 +0800
Message-Id: <20210615112443.13956-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowAA3ZkH9jchg_4XgxQ--.64545S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFWxZryUWFW3AFy3WF1fCrg_yoWfCrbE9r
        navanagr4UJryIy3WayFs7X347Kw1ruF1kJwsxWryjg34DGwsrG3s7Xrs5KF17Ww47Cr9x
        Ars8J3Z5ur1IyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnZjjDUUUUU==
X-Originating-IP: [112.37.241.255]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiXB6yg1Xlz+G0xQAAsc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix a spelling mistake.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/bluetooth/hci_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 2b5059a56cda..e91ac6945ec3 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -760,7 +760,7 @@ void hci_le_conn_failed(struct hci_conn *conn, u8 status)
 	/* If the status indicates successful cancellation of
 	 * the attempt (i.e. Unknown Connection Id) there's no point of
 	 * notifying failure since we'll go back to keep trying to
-	 * connect. The only exception is explicit connect requests
+	 * connect. The only exception is explicit connection requests
 	 * where a timeout + cancel does indicate an actual failure.
 	 */
 	if (status != HCI_ERROR_UNKNOWN_CONN_ID ||
-- 
2.25.1


