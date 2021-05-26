Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE6E39167F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhEZLtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:49:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5559 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhEZLta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:49:30 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fqpz50sTczjWwd;
        Wed, 26 May 2021 19:45:05 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
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
Subject: [PATCH net-next 06/10] net: wan: code indent use tabs where possible
Date:   Wed, 26 May 2021 19:44:51 +0800
Message-ID: <1622029495-30357-7-git-send-email-huangguangbin2@huawei.com>
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

Code indent should use tabs where possible.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_fr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index a39e5082c20f..fa10eea88fbc 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -6,16 +6,16 @@
  * Copyright (C) 1999 - 2006 Krzysztof Halasa <khc@pm.waw.pl>
  *
 
-            Theory of PVC state
+	Theory of PVC state
 
  DCE mode:
 
  (exist,new) -> 0,0 when "PVC create" or if "link unreliable"
-         0,x -> 1,1 if "link reliable" when sending FULL STATUS
-         1,1 -> 1,0 if received FULL STATUS ACK
+	 0,x -> 1,1 if "link reliable" when sending FULL STATUS
+	 1,1 -> 1,0 if received FULL STATUS ACK
 
  (active)    -> 0 when "ifconfig PVC down" or "link unreliable" or "PVC create"
-             -> 1 when "PVC up" and (exist,new) = 1,0
+	     -> 1 when "PVC up" and (exist,new) = 1,0
 
  DTE mode:
  (exist,new,active) = FULL STATUS if "link reliable"
-- 
2.8.1

