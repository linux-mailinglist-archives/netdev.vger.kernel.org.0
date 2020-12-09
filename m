Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541422D437F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732577AbgLINkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:40:40 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9571 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732425AbgLINk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:40:28 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrdS82h2TzM1nV;
        Wed,  9 Dec 2020 21:39:04 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:39:36 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-afs@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: ipa: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:40:03 +0800
Message-ID: <20201209134003.1679-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ipa/ipa_qmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 5090f0f923ad..174f093b66b8 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -413,7 +413,7 @@ static void ipa_client_init_driver_work(struct work_struct *work)
 	int ret;
 
 	ipa_qmi = container_of(work, struct ipa_qmi, init_driver_work);
-	qmi = &ipa_qmi->client_handle,
+	qmi = &ipa_qmi->client_handle;
 
 	ipa = container_of(ipa_qmi, struct ipa, qmi);
 	dev = &ipa->pdev->dev;
-- 
2.22.0

