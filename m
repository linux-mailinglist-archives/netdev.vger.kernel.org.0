Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F6939878B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhFBLGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:06:13 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7070 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFBLGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:06:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fw5gh3HVqzYpWg;
        Wed,  2 Jun 2021 19:01:36 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 19:04:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 19:04:20 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/6] net: hdlc_cisco: add some required spaces
Date:   Wed, 2 Jun 2021 19:01:13 +0800
Message-ID: <1622631676-34037-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622631676-34037-1-git-send-email-huangguangbin2@huawei.com>
References: <1622631676-34037-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Add spaces required after the close parenthesis '}'.
Add spaces required after that ','.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_cisco.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index 227939d..3f6a51a 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -32,7 +32,7 @@ struct hdlc_header {
 	u8 address;
 	u8 control;
 	__be16 protocol;
-}__packed;
+} __packed;
 
 struct cisco_packet {
 	__be32 type;		/* code */
@@ -40,7 +40,7 @@ struct cisco_packet {
 	__be32 par2;
 	__be16 rel;		/* reliability */
 	__be32 time;
-}__packed;
+} __packed;
 #define	CISCO_PACKET_LEN	18
 #define	CISCO_BIG_PACKET_LEN	20
 
@@ -341,7 +341,8 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 		    new_settings.timeout < 2)
 			return -EINVAL;
 
-		result = hdlc->attach(dev, ENCODING_NRZ,PARITY_CRC16_PR1_CCITT);
+		result = hdlc->attach(dev, ENCODING_NRZ,
+				      PARITY_CRC16_PR1_CCITT);
 		if (result)
 			return result;
 
-- 
2.8.1

