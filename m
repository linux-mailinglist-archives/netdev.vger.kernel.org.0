Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7AA2E1161
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 02:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgLWBZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 20:25:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9239 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgLWBZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 20:25:35 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D0wTS6TQRzkvDy;
        Wed, 23 Dec 2020 09:23:56 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 23 Dec 2020 09:24:42 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless v2 -next] wcn36xx: Remove unnecessary memset
Date:   Wed, 23 Dec 2020 09:25:16 +0800
Message-ID: <20201223012516.24286-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memcpy operation is next to memset code, and the size to copy is equals to the size to
memset, so the memset operation is unnecessary, remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 766400f7b61c..273fed22711f 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -484,7 +484,6 @@ static void init_hal_msg(struct wcn36xx_hal_msg_header *hdr,
 
 #define PREPARE_HAL_PTT_MSG_BUF(send_buf, p_msg_body) \
 	do {							\
-		memset(send_buf, 0, p_msg_body->header.len); \
 		memcpy(send_buf, p_msg_body, p_msg_body->header.len); \
 	} while (0)
 
-- 
2.22.0

