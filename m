Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7925D92F
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgIDNBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:01:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56920 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730311AbgIDNBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:01:41 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 61244116E2FDBEFA3C65;
        Fri,  4 Sep 2020 21:01:36 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 4 Sep 2020
 21:01:30 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] caif: Remove duplicate macro SRVL_CTRL_PKT_SIZE
Date:   Fri, 4 Sep 2020 20:58:58 +0800
Message-ID: <20200904125858.16204-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove SRVL_CTRL_PKT_SIZE which is defined more than once.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/caif/cfsrvl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/caif/cfsrvl.c b/net/caif/cfsrvl.c
index d0a4d0ac7045..9cef9496a707 100644
--- a/net/caif/cfsrvl.c
+++ b/net/caif/cfsrvl.c
@@ -21,7 +21,6 @@
 #define SRVL_FLOW_OFF 0x81
 #define SRVL_FLOW_ON  0x80
 #define SRVL_SET_PIN  0x82
-#define SRVL_CTRL_PKT_SIZE 1
 
 #define container_obj(layr) container_of(layr, struct cfsrvl, layer)
 
-- 
2.17.1

