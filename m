Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3B42DFDC
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfE2OfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:35:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17605 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbfE2OfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 10:35:11 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BD5F246E6011C24A2A11;
        Wed, 29 May 2019 22:35:08 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 29 May 2019
 22:34:59 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: dsa: sja1105: Make static_config_check_memory_size static
Date:   Wed, 29 May 2019 22:34:32 +0800
Message-ID: <20190529143432.19268-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/dsa/sja1105/sja1105_static_config.c:446:1: warning:
 symbol 'static_config_check_memory_size' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/dsa/sja1105/sja1105_static_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index b3c992b0abb0..7e90e62da389 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -442,7 +442,7 @@ const char *sja1105_static_config_error_msg[] = {
 		"vl-forwarding-parameters-table.partspc.",
 };
 
-sja1105_config_valid_t
+static sja1105_config_valid_t
 static_config_check_memory_size(const struct sja1105_table *tables)
 {
 	const struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
-- 
2.17.1


