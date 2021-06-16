Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539463A93C9
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhFPH3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:16 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4940 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhFPH3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:02 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4c9s2WQkz6w2W;
        Wed, 16 Jun 2021 15:23:45 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 12/15] net: cosa: fix the code style issue about trailing statements
Date:   Wed, 16 Jun 2021 15:23:38 +0800
Message-ID: <1623828221-48349-13-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
References: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Trailing statements should be on next line.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 121 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 79 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index fbfc3e5..4fb602b 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -1379,18 +1379,27 @@ static int download(struct cosa_data *cosa, const char __user *microcode, int le
 {
 	int i;
 
-	if (put_wait_data(cosa, 'w') == -1) return -1;
+	if (put_wait_data(cosa, 'w') == -1)
+		return -1;
 	if ((i=get_wait_data(cosa)) != 'w') { printk("dnld: 0x%04x\n",i); return -2;}
-	if (get_wait_data(cosa) != '=') return -3;
-
-	if (puthexnumber(cosa, address) < 0) return -4;
-	if (put_wait_data(cosa, ' ') == -1) return -10;
-	if (get_wait_data(cosa) != ' ') return -11;
-	if (get_wait_data(cosa) != '=') return -12;
-
-	if (puthexnumber(cosa, address+length-1) < 0) return -13;
-	if (put_wait_data(cosa, ' ') == -1) return -18;
-	if (get_wait_data(cosa) != ' ') return -19;
+	if (get_wait_data(cosa) != '=')
+		return -3;
+
+	if (puthexnumber(cosa, address) < 0)
+		return -4;
+	if (put_wait_data(cosa, ' ') == -1)
+		return -10;
+	if (get_wait_data(cosa) != ' ')
+		return -11;
+	if (get_wait_data(cosa) != '=')
+		return -12;
+
+	if (puthexnumber(cosa, address + length - 1) < 0)
+		return -13;
+	if (put_wait_data(cosa, ' ') == -1)
+		return -18;
+	if (get_wait_data(cosa) != ' ')
+		return -19;
 
 	while (length--) {
 		char c;
@@ -1405,9 +1414,12 @@ static int download(struct cosa_data *cosa, const char __user *microcode, int le
 		microcode++;
 	}
 
-	if (get_wait_data(cosa) != '\r') return -21;
-	if (get_wait_data(cosa) != '\n') return -22;
-	if (get_wait_data(cosa) != '.') return -23;
+	if (get_wait_data(cosa) != '\r')
+		return -21;
+	if (get_wait_data(cosa) != '\n')
+		return -22;
+	if (get_wait_data(cosa) != '.')
+		return -23;
 #if 0
 	printk(KERN_DEBUG "cosa%d: download completed.\n", cosa->num);
 #endif
@@ -1420,18 +1432,28 @@ static int download(struct cosa_data *cosa, const char __user *microcode, int le
  */
 static int startmicrocode(struct cosa_data *cosa, int address)
 {
-	if (put_wait_data(cosa, 'g') == -1) return -1;
-	if (get_wait_data(cosa) != 'g') return -2;
-	if (get_wait_data(cosa) != '=') return -3;
-
-	if (puthexnumber(cosa, address) < 0) return -4;
-	if (put_wait_data(cosa, '\r') == -1) return -5;
+	if (put_wait_data(cosa, 'g') == -1)
+		return -1;
+	if (get_wait_data(cosa) != 'g')
+		return -2;
+	if (get_wait_data(cosa) != '=')
+		return -3;
+
+	if (puthexnumber(cosa, address) < 0)
+		return -4;
+	if (put_wait_data(cosa, '\r') == -1)
+		return -5;
 	
-	if (get_wait_data(cosa) != '\r') return -6;
-	if (get_wait_data(cosa) != '\r') return -7;
-	if (get_wait_data(cosa) != '\n') return -8;
-	if (get_wait_data(cosa) != '\r') return -9;
-	if (get_wait_data(cosa) != '\n') return -10;
+	if (get_wait_data(cosa) != '\r')
+		return -6;
+	if (get_wait_data(cosa) != '\r')
+		return -7;
+	if (get_wait_data(cosa) != '\n')
+		return -8;
+	if (get_wait_data(cosa) != '\r')
+		return -9;
+	if (get_wait_data(cosa) != '\n')
+		return -10;
 #if 0
 	printk(KERN_DEBUG "cosa%d: microcode started\n", cosa->num);
 #endif
@@ -1448,18 +1470,28 @@ static int startmicrocode(struct cosa_data *cosa, int address)
  */
 static int readmem(struct cosa_data *cosa, char __user *microcode, int length, int address)
 {
-	if (put_wait_data(cosa, 'r') == -1) return -1;
-	if ((get_wait_data(cosa)) != 'r') return -2;
-	if ((get_wait_data(cosa)) != '=') return -3;
-
-	if (puthexnumber(cosa, address) < 0) return -4;
-	if (put_wait_data(cosa, ' ') == -1) return -5;
-	if (get_wait_data(cosa) != ' ') return -6;
-	if (get_wait_data(cosa) != '=') return -7;
-
-	if (puthexnumber(cosa, address+length-1) < 0) return -8;
-	if (put_wait_data(cosa, ' ') == -1) return -9;
-	if (get_wait_data(cosa) != ' ') return -10;
+	if (put_wait_data(cosa, 'r') == -1)
+		return -1;
+	if ((get_wait_data(cosa)) != 'r')
+		return -2;
+	if ((get_wait_data(cosa)) != '=')
+		return -3;
+
+	if (puthexnumber(cosa, address) < 0)
+		return -4;
+	if (put_wait_data(cosa, ' ') == -1)
+		return -5;
+	if (get_wait_data(cosa) != ' ')
+		return -6;
+	if (get_wait_data(cosa) != '=')
+		return -7;
+
+	if (puthexnumber(cosa, address + length - 1) < 0)
+		return -8;
+	if (put_wait_data(cosa, ' ') == -1)
+		return -9;
+	if (get_wait_data(cosa) != ' ')
+		return -10;
 
 	while (length--) {
 		char c;
@@ -1480,9 +1512,12 @@ static int readmem(struct cosa_data *cosa, char __user *microcode, int length, i
 		microcode++;
 	}
 
-	if (get_wait_data(cosa) != '\r') return -21;
-	if (get_wait_data(cosa) != '\n') return -22;
-	if (get_wait_data(cosa) != '.') return -23;
+	if (get_wait_data(cosa) != '\r')
+		return -21;
+	if (get_wait_data(cosa) != '\n')
+		return -22;
+	if (get_wait_data(cosa) != '.')
+		return -23;
 #if 0
 	printk(KERN_DEBUG "cosa%d: readmem completed.\n", cosa->num);
 #endif
@@ -1744,7 +1779,8 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 		while (!(cosa_getstatus(cosa)&SR_TX_RDY)) {
 			count++;
 			udelay(10);
-			if (count > 1000) break;
+			if (count > 1000)
+				break;
 		}
 		pr_info("status %x\n", cosa_getstatus(cosa));
 		pr_info("ready after %d loops\n", count);
@@ -1753,7 +1789,8 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 		count = 0;
 		while (!(cosa_getstatus(cosa)&SR_TX_RDY)) {
 			count++;
-			if (count > 1000) break;
+			if (count > 1000)
+				break;
 			udelay(10);
 		}
 		pr_info("ready after %d loops\n", count);
-- 
2.8.1

