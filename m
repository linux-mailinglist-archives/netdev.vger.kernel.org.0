Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D2A396DFC
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhFAHgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:36:05 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3312 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhFAHgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 03:36:04 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvP1c1Jbnz19MNF;
        Tue,  1 Jun 2021 15:29:40 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 15:34:20 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <jdmason@kudzu.us>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: vxge: Remove unused variable
Date:   Tue, 1 Jun 2021 15:47:44 +0800
Message-ID: <20210601074744.4079327-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removes this annoying warning:

drivers/net/ethernet/neterion/vxge/vxge-main.c:1609:22: warning: unused variable ‘status’ [-Wunused-variable]
 1609 |  enum vxge_hw_status status;

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 21bc4d6662e4..297bce5f635f 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -1606,7 +1606,6 @@ static void vxge_config_ci_for_tti_rti(struct vxgedev *vdev)
 
 static int do_vxge_reset(struct vxgedev *vdev, int event)
 {
-	enum vxge_hw_status status;
 	int ret = 0, vp_id, i;
 
 	vxge_debug_entryexit(VXGE_TRACE, "%s:%d", __func__, __LINE__);
-- 
2.25.1

