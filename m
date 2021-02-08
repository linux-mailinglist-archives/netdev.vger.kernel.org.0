Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76468312A8F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhBHGL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:11:28 -0500
Received: from m12-16.163.com ([220.181.12.16]:55061 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhBHGLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 01:11:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=cTWym3oVQIjSfoH5nN
        obF1JoOdewS/g9kOSM1f3Qcq8=; b=SzFopcjzrRuwbdRG0HVLf0EQss3alQ03Mg
        VtQZEY/AZn3bP2xU8kRnZhRgNhjkMsHY3rOspVb50VuLqHWGyH99HrmnFcO6VK2j
        17xnabvSc9NlaECsXI3WCmzPecJYG+IX//IV/kok8M78UUje1rGm6hXQS6aXeUlT
        k9TH0lyN4=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.53.134])
        by smtp12 (Coremail) with SMTP id EMCowAC3dTZCnyBgzP1vbA--.21006S2;
        Mon, 08 Feb 2021 10:17:41 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     davem@davemloft.net, alex.dewar90@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: st-nci: Remove unnecessary variable
Date:   Mon,  8 Feb 2021 10:17:32 +0800
Message-Id: <20210208021732.21856-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EMCowAC3dTZCnyBgzP1vbA--.21006S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWxAFyrKw1fuw4UZw1kXwb_yoWDXwbE9r
        95Z3s7ur4Iqr1jv34jkw45ZF9Igr48uF10gr1rKa4YkryDuan0v3srur93Gry5G3y8AF9I
        krnYkrySvr9rujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUe-J55UUUUU==
X-Originating-IP: [119.137.53.134]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiLwYzsVUMXGp54QAAsc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

The variable r is defined at the beginning and initialized
to 0 until the function returns r, and the variable r is
not reassigned.Therefore, we do not need to define the
variable r, just return 0 directly at the end of the function.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/st-nci/se.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 807eae0..1cba8f6 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -276,7 +276,6 @@ static int st_nci_hci_apdu_reader_event_received(struct nci_dev *ndev,
 						   u8 event,
 						   struct sk_buff *skb)
 {
-	int r = 0;
 	struct st_nci_info *info = nci_get_drvdata(ndev);
 
 	pr_debug("apdu reader gate event: %x\n", event);
@@ -298,7 +297,7 @@ static int st_nci_hci_apdu_reader_event_received(struct nci_dev *ndev,
 	}
 
 	kfree_skb(skb);
-	return r;
+	return 0;
 }
 
 /*
-- 
1.9.1


