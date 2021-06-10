Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3AE3A2549
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhFJHZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:25:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3820 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhFJHZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:25:11 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0wLP4KkKzWsV4;
        Thu, 10 Jun 2021 15:18:21 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/8] net: ixp4xx_hss: fix the code style issue about "foo* bar"
Date:   Thu, 10 Jun 2021 15:20:00 +0800
Message-ID: <1623309605-15671-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
References: <1623309605-15671-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Fix the checkpatch error as "foo* bar" and should be "foo *bar",
and "(foo*)" should be "(foo *)".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 6aa01d5..48bc914 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -332,7 +332,7 @@ static const struct {
  * utility functions
  ****************************************************************************/
 
-static inline struct port* dev_to_port(struct net_device *dev)
+static inline struct port *dev_to_port(struct net_device *dev)
 {
 	return dev_to_hdlc(dev)->priv;
 }
@@ -351,9 +351,9 @@ static inline void memcpy_swab32(u32 *dest, u32 *src, int cnt)
  * HSS access
  ****************************************************************************/
 
-static void hss_npe_send(struct port *port, struct msg *msg, const char* what)
+static void hss_npe_send(struct port *port, struct msg *msg, const char *what)
 {
-	u32 *val = (u32*)msg;
+	u32 *val = (u32 *)msg;
 
 	if (npe_send_message(port->npe, msg, what)) {
 		pr_crit("HSS-%i: unable to send command [%08X:%08X] to %s\n",
-- 
2.8.1

