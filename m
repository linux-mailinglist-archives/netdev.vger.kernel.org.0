Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDA91C8C78
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgEGNf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:35:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3845 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbgEGNf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 09:35:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 98D68EC751636B2B238B;
        Thu,  7 May 2020 21:35:55 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 7 May 2020 21:35:48 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <elder@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] net: ipa: remove duplicate headers
Date:   Thu, 7 May 2020 21:39:45 +0800
Message-ID: <20200507133945.25601-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicate headers which are included twice.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
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
 
-- 
2.20.1

