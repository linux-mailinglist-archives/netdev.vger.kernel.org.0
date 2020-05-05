Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222521C5243
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 11:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgEEJ7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 05:59:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3848 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgEEJ7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 05:59:09 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0EACCDC1F4196C5375BC;
        Tue,  5 May 2020 17:59:06 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 5 May 2020 17:58:57 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: ipa: remove duplicated include from ipa_mem.c
Date:   Tue, 5 May 2020 10:03:07 +0000
Message-ID: <20200505100307.191806-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ipa/ipa_mem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index aa8f6b0f3d50..3ef814119aab 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -17,7 +17,6 @@
 #include "ipa_data.h"
 #include "ipa_cmd.h"
 #include "ipa_mem.h"
-#include "ipa_data.h"
 #include "ipa_table.h"
 #include "gsi_trans.h"



