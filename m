Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0053A1068
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbhFIJpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:45:04 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5351 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhFIJpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:45:03 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0MWS22wRz6vl8;
        Wed,  9 Jun 2021 17:39:16 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:43:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:43:03 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/9] net: lapbether: remove redundant blank line
Date:   Wed, 9 Jun 2021 17:39:47 +0800
Message-ID: <1623231595-33851-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
References: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
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

This patch the redundant blank line.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/lapbether.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 5964686..bb529ef 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -307,7 +307,6 @@ static int lapbeth_set_mac_address(struct net_device *dev, void *addr)
 	return 0;
 }
 
-
 static const struct lapb_register_struct lapbeth_callbacks = {
 	.connect_confirmation    = lapbeth_connected,
 	.connect_indication      = lapbeth_connected,
-- 
2.8.1

