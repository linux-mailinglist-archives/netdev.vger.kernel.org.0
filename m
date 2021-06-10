Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624CE3A254C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFJHZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:25:26 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5476 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFJHZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:25:12 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0wNm38HPzZfs1;
        Thu, 10 Jun 2021 15:20:24 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:23:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/8] net: ixp4xx_hss: add some required spaces
Date:   Thu, 10 Jun 2021 15:20:02 +0800
Message-ID: <1623309605-15671-6-git-send-email-huangguangbin2@huawei.com>
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

Add space required before the open parenthesis '('.
Add space required after that close brace '}'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index d657bca..d8f1df9 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -322,7 +322,7 @@ static DEFINE_SPINLOCK(npe_lock);
 
 static const struct {
 	int tx, txdone, rx, rxfree;
-}queue_ids[2] = {{HSS0_PKT_TX0_QUEUE, HSS0_PKT_TXDONE_QUEUE, HSS0_PKT_RX_QUEUE,
+} queue_ids[2] = {{HSS0_PKT_TX0_QUEUE, HSS0_PKT_TXDONE_QUEUE, HSS0_PKT_RX_QUEUE,
 		  HSS0_PKT_RXFREE0_QUEUE},
 		 {HSS1_PKT_TX0_QUEUE, HSS1_PKT_TXDONE_QUEUE, HSS1_PKT_RX_QUEUE,
 		  HSS1_PKT_RXFREE0_QUEUE},
@@ -1177,7 +1177,7 @@ static int hss_hdlc_attach(struct net_device *dev, unsigned short encoding,
 	if (encoding != ENCODING_NRZ)
 		return -EINVAL;
 
-	switch(parity) {
+	switch (parity) {
 	case PARITY_CRC16_PR1_CCITT:
 		port->hdlc_cfg = 0;
 		return 0;
@@ -1264,7 +1264,7 @@ static int hss_hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
-	switch(ifr->ifr_settings.type) {
+	switch (ifr->ifr_settings.type) {
 	case IF_GET_IFACE:
 		ifr->ifr_settings.type = IF_IFACE_V35;
 		if (ifr->ifr_settings.size < size) {
@@ -1281,7 +1281,7 @@ static int hss_hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	case IF_IFACE_SYNC_SERIAL:
 	case IF_IFACE_V35:
-		if(!capable(CAP_NET_ADMIN))
+		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 		if (copy_from_user(&new_line, line, size))
 			return -EFAULT;
-- 
2.8.1

