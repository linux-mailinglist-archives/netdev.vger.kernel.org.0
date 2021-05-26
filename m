Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A282F39167E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhEZLto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:49:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:4012 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhEZLta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:49:30 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fqpzg4nsvzmZM2;
        Wed, 26 May 2021 19:45:35 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 04/10] net: wan: add some required spaces
Date:   Wed, 26 May 2021 19:44:49 +0800
Message-ID: <1622029495-30357-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
References: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Add spaces required after that close brace '}'.
Add spaces required before the open parenthesis '('.
Add spaces required after that ','.
Add spaces required around that '='.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_fr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 4a6172cca682..512ef79459da 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -125,7 +125,7 @@ struct pvc_device {
 		unsigned int fecn: 1;
 		unsigned int becn: 1;
 		unsigned int bandwidth;	/* Cisco LMI reporting only */
-	}state;
+	} state;
 };
 
 struct frad_state {
@@ -161,7 +161,7 @@ static inline void dlci_to_q922(u8 *hdr, u16 dlci)
 
 static inline struct frad_state *state(hdlc_device *hdlc)
 {
-	return(struct frad_state *)(hdlc->state);
+	return (struct frad_state *)(hdlc->state);
 }
 
 static inline struct pvc_device *find_pvc(hdlc_device *hdlc, u16 dlci)
@@ -1223,7 +1223,8 @@ static int fr_ioctl(struct net_device *dev, struct ifreq *ifr)
 		     new_settings.dce != 1))
 			return -EINVAL;
 
-		result=hdlc->attach(dev, ENCODING_NRZ,PARITY_CRC16_PR1_CCITT);
+		result = hdlc->attach(dev, ENCODING_NRZ,
+				      PARITY_CRC16_PR1_CCITT);
 		if (result)
 			return result;
 
-- 
2.8.1

