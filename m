Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090CA56B11E
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 05:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbiGHDxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 23:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbiGHDxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 23:53:49 -0400
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF82771BE5;
        Thu,  7 Jul 2022 20:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=82Uye
        dPEauwT5cf5wHBTyobSyIimwqIK7UX1yZj1hqg=; b=LIoF5qwkAQXiMqjp4eEWR
        CVtdg68cKtOEcacBOjYEKmoZiCoPHUhfz6lKe9BE8JzABD69AUudrB0Xyf/DpWG+
        uq7Ku1Jm4TAI0E9FIMKI45rWHxPixXtNseFr61fn9wg7izaC+wvHdXFqSGg8hEdk
        eqALjah1eTDNs/MdoEyL68=
Received: from bf-rmsz-11.ccdomain.com (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowAAXVuvgqcdiOwytNw--.46411S2;
        Fri, 08 Jul 2022 11:52:01 +0800 (CST)
From:   Zhongjun Tan <hbut_tan@163.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhongjun Tan <tanzhongjun@coolpad.com>
Subject: [PATCH] iavf: Remove condition with no effect
Date:   Fri,  8 Jul 2022 11:51:54 +0800
Message-Id: <20220708035154.44079-1-hbut_tan@163.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAAXVuvgqcdiOwytNw--.46411S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFWkCr4Uur4UKF4ftr1DZFb_yoWfZFX_Kr
        Wjqr4xCan8JF1SvryUtrW29a4j9rWqywn7uF9Fk39Fy343Xw1UCr1DZw1fAr4Y9ry5GF9r
        Z3ZxJryxt34jyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnqjg3UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: xkex3sxwdqqiywtou0bp/xtbBlwI4xmI0WBtgogAAs8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhongjun Tan <tanzhongjun@coolpad.com>

Remove condition with no effect

Signed-off-by: Zhongjun Tan <tanzhongjun@coolpad.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 69ade653f5d4..52b622ea7d6b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2136,8 +2136,6 @@ iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
 		vlan_ethertype = ETH_P_8021Q;
 	else if (prev_features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX))
 		vlan_ethertype = ETH_P_8021AD;
-	else if (prev_features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX))
-		vlan_ethertype = ETH_P_8021Q;
 	else
 		vlan_ethertype = ETH_P_8021Q;
 
-- 
2.29.0

