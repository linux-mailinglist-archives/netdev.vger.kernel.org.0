Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37DD5BFA19
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiIUJFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiIUJFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:05:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C995532D9A;
        Wed, 21 Sep 2022 02:04:59 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXXSf0HWWzlWqX;
        Wed, 21 Sep 2022 17:00:50 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 17:04:56 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <nbd@nbd.name>, <lorenzo@kernel.org>, <ryder.lee@mediatek.com>,
        <shayne.chen@mediatek.com>, <sean.wang@mediatek.com>,
        <kvalo@kernel.org>, <matthias.bgg@gmail.com>, <amcohen@nvidia.com>,
        <stephen@networkplumber.org>, <cuigaosheng1@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 1/5] mlxsw: reg: Remove unused inline function mlxsw_reg_sftr2_pack()
Date:   Wed, 21 Sep 2022 17:04:51 +0800
Message-ID: <20220921090455.752011-2-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921090455.752011-1-cuigaosheng1@huawei.com>
References: <20220921090455.752011-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All uses of mlxsw_reg_sftr2_pack() have
been removed since commit 77b7f83d5c25 ("mlxsw: Enable unified
bridge model"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d71d7f9a20f1..e188497c1b3e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -2272,22 +2272,6 @@ MLXSW_ITEM_BIT_ARRAY(reg, sftr2, port, 0x20, 0x80, 1);
  */
 MLXSW_ITEM_BIT_ARRAY(reg, sftr2, port_mask, 0xA0, 0x80, 1);
 
-static inline void mlxsw_reg_sftr2_pack(char *payload,
-					unsigned int flood_table,
-					unsigned int index,
-					enum mlxsw_flood_table_type table_type,
-					unsigned int range, u16 port, bool set)
-{
-	MLXSW_REG_ZERO(sftr2, payload);
-	mlxsw_reg_sftr2_swid_set(payload, 0);
-	mlxsw_reg_sftr2_flood_table_set(payload, flood_table);
-	mlxsw_reg_sftr2_index_set(payload, index);
-	mlxsw_reg_sftr2_table_type_set(payload, table_type);
-	mlxsw_reg_sftr2_range_set(payload, range);
-	mlxsw_reg_sftr2_port_set(payload, port, set);
-	mlxsw_reg_sftr2_port_mask_set(payload, port, 1);
-}
-
 /* SMID-V2 - Switch Multicast ID Version 2 Register
  * ------------------------------------------------
  * The MID record maps from a MID (Multicast ID), which is a unique identifier
-- 
2.25.1

