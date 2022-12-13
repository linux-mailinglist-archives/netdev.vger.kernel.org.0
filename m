Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF9564AE7E
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 04:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiLMD5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 22:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiLMD5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 22:57:16 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8955D62;
        Mon, 12 Dec 2022 19:57:14 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=jiapeng.chong@linux.alibaba.com;NM=0;PH=DS;RN=13;SR=0;TI=SMTPD_---0VXC615N_1670903828;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VXC615N_1670903828)
          by smtp.aliyun-inc.com;
          Tue, 13 Dec 2022 11:57:12 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2] net: ksz884x: Remove some unused functions
Date:   Tue, 13 Dec 2022 11:57:07 +0800
Message-Id: <20221213035707.118309-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions are defined in the ksz884x.c file, but not called
elsewhere, so delete these unused functions.

drivers/net/ethernet/micrel/ksz884x.c:2212:20: warning: unused function 'port_cfg_force_flow_ctrl'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3418
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Delete more unused functions.

 drivers/net/ethernet/micrel/ksz884x.c | 89 ---------------------------
 1 file changed, 89 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index e6acd1e7b263..5d6ed7a63e59 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -2209,102 +2209,13 @@ static inline void port_cfg_back_pressure(struct ksz_hw *hw, int p, int set)
 		KS8842_PORT_CTRL_2_OFFSET, PORT_BACK_PRESSURE, set);
 }
 
-static inline void port_cfg_force_flow_ctrl(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_FORCE_FLOW_CTRL, set);
-}
-
-static inline int port_chk_back_pressure(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_BACK_PRESSURE);
-}
-
-static inline int port_chk_force_flow_ctrl(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_FORCE_FLOW_CTRL);
-}
-
 /* Spanning Tree */
 
-static inline void port_cfg_rx(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_RX_ENABLE, set);
-}
-
-static inline void port_cfg_tx(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_TX_ENABLE, set);
-}
-
 static inline void sw_cfg_fast_aging(struct ksz_hw *hw, int set)
 {
 	sw_cfg(hw, KS8842_SWITCH_CTRL_1_OFFSET, SWITCH_FAST_AGING, set);
 }
 
-static inline void sw_flush_dyn_mac_table(struct ksz_hw *hw)
-{
-	if (!(hw->overrides & FAST_AGING)) {
-		sw_cfg_fast_aging(hw, 1);
-		mdelay(1);
-		sw_cfg_fast_aging(hw, 0);
-	}
-}
-
-/* VLAN */
-
-static inline void port_cfg_ins_tag(struct ksz_hw *hw, int p, int insert)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_INSERT_TAG, insert);
-}
-
-static inline void port_cfg_rmv_tag(struct ksz_hw *hw, int p, int remove)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_REMOVE_TAG, remove);
-}
-
-static inline int port_chk_ins_tag(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_INSERT_TAG);
-}
-
-static inline int port_chk_rmv_tag(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_1_OFFSET, PORT_REMOVE_TAG);
-}
-
-static inline void port_cfg_dis_non_vid(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_DISCARD_NON_VID, set);
-}
-
-static inline void port_cfg_in_filter(struct ksz_hw *hw, int p, int set)
-{
-	port_cfg(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_INGRESS_VLAN_FILTER, set);
-}
-
-static inline int port_chk_dis_non_vid(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_DISCARD_NON_VID);
-}
-
-static inline int port_chk_in_filter(struct ksz_hw *hw, int p)
-{
-	return port_chk(hw, p,
-		KS8842_PORT_CTRL_2_OFFSET, PORT_INGRESS_VLAN_FILTER);
-}
-
 /* Mirroring */
 
 static inline void port_cfg_mirror_sniffer(struct ksz_hw *hw, int p, int set)
-- 
2.20.1.7.g153144c

