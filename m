Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD0A256755
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgH2L6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:58:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10349 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728129AbgH2L6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:58:03 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0340F1079B35744126E6;
        Sat, 29 Aug 2020 19:57:57 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:57:49 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: hns: Remove unused macro AE_NAME_PORT_ID_IDX
Date:   Sat, 29 Aug 2020 19:57:37 +0800
Message-ID: <20200829115737.12040-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
index b43dec0560a8..b98244f75ab9 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c
@@ -13,8 +13,6 @@
 #include "hns_dsaf_ppe.h"
 #include "hns_dsaf_rcb.h"
 
-#define AE_NAME_PORT_ID_IDX 6
-
 static struct hns_mac_cb *hns_get_mac_cb(struct hnae_handle *handle)
 {
 	struct  hnae_vf_cb *vf_cb = hns_ae_get_vf_cb(handle);
-- 
2.17.1


