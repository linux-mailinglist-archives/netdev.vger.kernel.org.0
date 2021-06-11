Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0633B3A3A61
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhFKDlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:41:42 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9071 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbhFKDlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 23:41:31 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1RN96pT5zZcpD;
        Fri, 11 Jun 2021 11:36:41 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 11:39:33 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 11:39:32 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 8/8] net: pc300too: fix the comments style issue
Date:   Fri, 11 Jun 2021 11:36:22 +0800
Message-ID: <1623382582-37854-9-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
References: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
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

Networking block comments don't use an empty /* line,
use /* Comment...
This patch fixes the comments style issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/pc300too.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index 885dcc5..7b123a7 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -54,8 +54,7 @@ static unsigned int CLOCK_BASE;
 
 enum { PC300_RSV = 1, PC300_X21, PC300_TE }; /* card types */
 
-/*
- *      PLX PCI9050-1 local configuration and shared runtime registers.
+/*      PLX PCI9050-1 local configuration and shared runtime registers.
  *      This structure can be used to access 9050 registers (memory mapped).
  */
 typedef struct {
-- 
2.8.1

