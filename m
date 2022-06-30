Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEDF561371
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 09:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiF3HnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 03:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbiF3HnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 03:43:07 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E9A3B55A;
        Thu, 30 Jun 2022 00:43:01 -0700 (PDT)
X-QQ-mid: bizesmtp68t1656574957teobvpan
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 15:42:28 +0800 (CST)
X-QQ-SSF: 0100000000200070C000B00A0000000
X-QQ-FEAT: hN6wzL7d0UsiEnMr6xOtAk/cLcddHpnYkgtiNC0ASRaL0Fh9mmdnfs2dExQbN
        BDYRg5ebkXbQBxHJqiyHPRZdjxDusFvqA0/4EOctmjHPKYAzAxVxoEO+/k8awg8AeZ5k5gY
        FZR4N+gBdtbhUGzjHWHjvNHli8r65HXWKyBkzGwUjoWMKncP6JVNuht74s3FWSMOIEaBYnI
        DMmaCdOb7FtqA4xs7vaKqsdXkV2NN3oiegbooCm/lQu5YM+YBKsub7LK0ZIkgDIxWp9k1nu
        IKh+W16cla98FVDkX2LpgVrx6DjTJ9o/cc2/Dam+8gQCLSBozDEi5YoEoxDMZlzY7crUSMA
        wiywtLg4T+AGDsAUJw=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     idosch@nvidia.com, petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] mellanox/mlxsw: fix repeated words in comments
Date:   Thu, 30 Jun 2022 15:42:21 +0800
Message-Id: <20220630074221.63148-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'action'.
Delete the redundant word 'refer'.
Delete the redundant word 'for'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.c              | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index fa33caecc91d..636db9a87457 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1164,7 +1164,7 @@ EXPORT_SYMBOL(mlxsw_afa_block_append_vlan_modify);
  * trap control. In addition, the Trap / Discard action enables activating
  * SPAN (port mirroring).
  *
- * The Trap with userdef action action has the same functionality as
+ * The Trap with userdef action has the same functionality as
  * the Trap action with addition of user defined value that can be set
  * and used by higher layer applications.
  */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 34bec9cd572c..0107cbc32fc7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -180,7 +180,7 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, u8 slot_index,
 		} else {
 			/* When reading upper pages 1, 2 and 3 the offset
 			 * starts at 0 and I2C high address is used. Please refer
-			 * refer to "Memory Organization" figure in SFF-8472
+			 * to "Memory Organization" figure in SFF-8472
 			 * specification for graphical depiction.
 			 */
 			i2c_addr = MLXSW_REG_MCIA_I2C_ADDR_HIGH;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
index 10ae1115de6c..24ff305a2995 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c
@@ -15,7 +15,7 @@ struct mlxsw_sp2_kvdl_part_info {
 	 * usage bits we need and how many indexes there are
 	 * represented by a single bit. This could be got from FW
 	 * querying appropriate resources. So have the resource
-	 * ids for for this purpose in partition definition.
+	 * ids for this purpose in partition definition.
 	 */
 	enum mlxsw_res_id usage_bit_count_res_id;
 	enum mlxsw_res_id index_range_res_id;
-- 
2.36.1

