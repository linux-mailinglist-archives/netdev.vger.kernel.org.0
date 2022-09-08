Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658C55B1D83
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiIHMot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiIHMob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:44:31 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E821C633D;
        Thu,  8 Sep 2022 05:44:24 -0700 (PDT)
X-QQ-mid: bizesmtp73t1662641038t06ja4je
Received: from localhost.localdomain ( [182.148.14.0])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 08 Sep 2022 20:43:57 +0800 (CST)
X-QQ-SSF: 0100000000200090C000B00A0000000
X-QQ-FEAT: wOTYu9h7OeoIW0glcDkwKp5SeP7ka1mzTCfRQa4e6yT371MOZXffS2n5wPhDg
        w6+eMGCfVhpArNKn93wuSqyueKKyGmhfS+J4VGEXJLBxf3Hf/8iji4/1fX5LC+YWbDuehIU
        PUprPJDKXepD+bnbb2Py28u5UwMqnsXTfh0mtwjtTo+JKSRYYVhq9D/08CCwqZJoxDUwEEO
        l9GnpRi6bmyBKzdHJHzODfbm9O0bVv2EQnZOVLbvfhRYmOcjVsl3wOvWq1fpswhwNYK7g8E
        N+b3YzaNIctr9Qqg+/ewlXhGqkE2GUleBPKmc67LR7h9CywCahHMb82pYDIkGO8incHLH4f
        qd7UUdJDmNGLLrR9LnFbL6bwvScynhPQciddPjQvCMdyVtrA+s=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] mellanox/mlxsw: fix repeated words in comments
Date:   Thu,  8 Sep 2022 20:43:50 +0800
Message-Id: <20220908124350.22861-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'in'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2c4443c6b964..48f1fa62a4fd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1819,7 +1819,7 @@ void mlxsw_sp_ipip_entry_demote_tunnel(struct mlxsw_sp *mlxsw_sp,
 /* The configuration where several tunnels have the same local address in the
  * same underlay table needs special treatment in the HW. That is currently not
  * implemented in the driver. This function finds and demotes the first tunnel
- * with a given source address, except the one passed in in the argument
+ * with a given source address, except the one passed in the argument
  * `except'.
  */
 bool
-- 
2.36.1

