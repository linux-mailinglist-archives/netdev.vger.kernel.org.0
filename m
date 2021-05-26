Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4F939167A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhEZLtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:49:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5558 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhEZLt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:49:29 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fqpz43QNRzjWwr;
        Wed, 26 May 2021 19:45:04 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 02/10] net: wan: add blank line after declarations
Date:   Wed, 26 May 2021 19:44:47 +0800
Message-ID: <1622029495-30357-3-git-send-email-huangguangbin2@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_fr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 0b6e133de4ad..96e4a89fa923 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -329,6 +329,7 @@ static int pvc_open(struct net_device *dev)
 
 	if (pvc->open_count++ == 0) {
 		hdlc_device *hdlc = dev_to_hdlc(pvc->frad);
+
 		if (state(hdlc)->settings.lmi == LMI_NONE)
 			pvc->state.active = netif_carrier_ok(pvc->frad);
 
@@ -344,6 +345,7 @@ static int pvc_close(struct net_device *dev)
 
 	if (--pvc->open_count == 0) {
 		hdlc_device *hdlc = dev_to_hdlc(pvc->frad);
+
 		if (state(hdlc)->settings.lmi == LMI_NONE)
 			pvc->state.active = 0;
 
@@ -1143,6 +1145,7 @@ static void fr_destroy(struct net_device *frad)
 {
 	hdlc_device *hdlc = dev_to_hdlc(frad);
 	struct pvc_device *pvc = state(hdlc)->first_pvc;
+
 	state(hdlc)->first_pvc = NULL; /* All PVCs destroyed */
 	state(hdlc)->dce_pvc_count = 0;
 	state(hdlc)->dce_changed = 1;
-- 
2.8.1

