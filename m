Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165F22D991E
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgLNNno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:43:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9525 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406099AbgLNNnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:43:32 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CvjHV49t2zhtBs;
        Mon, 14 Dec 2020 21:42:14 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 14 Dec 2020 21:42:44 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] nfc/pn533/usb: convert comma to semicolon
Date:   Mon, 14 Dec 2020 21:43:14 +0800
Message-ID: <20201214134314.4618-1-zhengyongjun3@huawei.com>
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
 drivers/nfc/pn533/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 84f2983bf384..84d2bfabf42b 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -517,7 +517,7 @@ static int pn533_usb_probe(struct usb_interface *interface,
 	case PN533_DEVICE_ACR122U:
 		protocols = PN533_NO_TYPE_B_PROTOCOLS;
 		fops = &pn533_acr122_frame_ops;
-		protocol_type = PN533_PROTO_REQ_RESP,
+		protocol_type = PN533_PROTO_REQ_RESP;
 
 		rc = pn533_acr122_poweron_rdr(phy);
 		if (rc < 0) {
-- 
2.22.0

