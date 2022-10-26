Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A964960E157
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiJZM7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbiJZM7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:59:39 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD46EDE8C;
        Wed, 26 Oct 2022 05:59:35 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666789174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lABM8qBfODA4VDQRynLERW7dnvib2XZRLEYg+K9ItVk=;
        b=nf4NC2E8eDLWLFZTYZZgxboG57SC8iJ6KGvsoWcn1RPvDKIQetD8HlLADzS9y1nbrWQFQ4
        /d9HXIf5nlqyHSOqHnAYTPK+wXRlOiCD9hA5redaLRWaJEgS/BMLYiv0fBpIHVrnC7ObBy
        LuIza/OAwGMKqJvGntC0Gu2JPMlF0DA=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: hinic: Convert the cmd code from decimal to hex to be more readable
Date:   Wed, 26 Oct 2022 20:59:10 +0800
Message-Id: <20221026125922.34080-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,TO_EQ_FM_DIRECT_MX,UPPERCASE_75_100,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The print cmd code is in hex, so using hex cmd code intead of
decimal is easy to check the value with print info.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  | 108 +++++++++---------
 1 file changed, 52 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index d2d89b0a5ef0..abffd967a791 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -46,104 +46,100 @@ enum hinic_port_cmd {
 	HINIC_PORT_CMD_VF_REGISTER = 0x0,
 	HINIC_PORT_CMD_VF_UNREGISTER = 0x1,
 
-	HINIC_PORT_CMD_CHANGE_MTU       = 2,
+	HINIC_PORT_CMD_CHANGE_MTU = 0x2,
 
-	HINIC_PORT_CMD_ADD_VLAN         = 3,
-	HINIC_PORT_CMD_DEL_VLAN         = 4,
+	HINIC_PORT_CMD_ADD_VLAN = 0x3,
+	HINIC_PORT_CMD_DEL_VLAN = 0x4,
 
-	HINIC_PORT_CMD_SET_PFC		= 5,
+	HINIC_PORT_CMD_SET_PFC = 0x5,
 
-	HINIC_PORT_CMD_SET_MAC          = 9,
-	HINIC_PORT_CMD_GET_MAC          = 10,
-	HINIC_PORT_CMD_DEL_MAC          = 11,
+	HINIC_PORT_CMD_SET_MAC = 0x9,
+	HINIC_PORT_CMD_GET_MAC = 0xA,
+	HINIC_PORT_CMD_DEL_MAC = 0xB,
 
-	HINIC_PORT_CMD_SET_RX_MODE      = 12,
+	HINIC_PORT_CMD_SET_RX_MODE = 0xC,
 
-	HINIC_PORT_CMD_GET_PAUSE_INFO	= 20,
-	HINIC_PORT_CMD_SET_PAUSE_INFO	= 21,
+	HINIC_PORT_CMD_GET_PAUSE_INFO = 0x14,
+	HINIC_PORT_CMD_SET_PAUSE_INFO = 0x15,
 
-	HINIC_PORT_CMD_GET_LINK_STATE   = 24,
+	HINIC_PORT_CMD_GET_LINK_STATE = 0x18,
 
-	HINIC_PORT_CMD_SET_LRO		= 25,
+	HINIC_PORT_CMD_SET_LRO = 0x19,
 
-	HINIC_PORT_CMD_SET_RX_CSUM	= 26,
+	HINIC_PORT_CMD_SET_RX_CSUM = 0x1A,
 
-	HINIC_PORT_CMD_SET_RX_VLAN_OFFLOAD = 27,
+	HINIC_PORT_CMD_SET_RX_VLAN_OFFLOAD = 0x1B,
 
-	HINIC_PORT_CMD_GET_PORT_STATISTICS = 28,
+	HINIC_PORT_CMD_GET_PORT_STATISTICS = 0x1C,
 
-	HINIC_PORT_CMD_CLEAR_PORT_STATISTICS = 29,
+	HINIC_PORT_CMD_CLEAR_PORT_STATISTICS = 0x1D,
 
-	HINIC_PORT_CMD_GET_VPORT_STAT	= 30,
+	HINIC_PORT_CMD_GET_VPORT_STAT = 0x1E,
 
-	HINIC_PORT_CMD_CLEAN_VPORT_STAT	= 31,
+	HINIC_PORT_CMD_CLEAN_VPORT_STAT	= 0x1F,
 
-	HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL = 37,
+	HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL = 0x25,
 
-	HINIC_PORT_CMD_SET_PORT_STATE   = 41,
+	HINIC_PORT_CMD_SET_PORT_STATE = 0x29,
 
-	HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL = 43,
+	HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL = 0x2B,
+	HINIC_PORT_CMD_GET_RSS_TEMPLATE_TBL = 0x2C,
 
-	HINIC_PORT_CMD_GET_RSS_TEMPLATE_TBL = 44,
+	HINIC_PORT_CMD_SET_RSS_HASH_ENGINE = 0x2D,
+	HINIC_PORT_CMD_GET_RSS_HASH_ENGINE = 0x2E,
 
-	HINIC_PORT_CMD_SET_RSS_HASH_ENGINE = 45,
+	HINIC_PORT_CMD_GET_RSS_CTX_TBL = 0x2F,
+	HINIC_PORT_CMD_SET_RSS_CTX_TBL = 0x30,
 
-	HINIC_PORT_CMD_GET_RSS_HASH_ENGINE = 46,
+	HINIC_PORT_CMD_RSS_TEMP_MGR	= 0x31,
 
-	HINIC_PORT_CMD_GET_RSS_CTX_TBL  = 47,
+	HINIC_PORT_CMD_RD_LINE_TBL = 0x39,
 
-	HINIC_PORT_CMD_SET_RSS_CTX_TBL  = 48,
+	HINIC_PORT_CMD_RSS_CFG = 0x42,
 
-	HINIC_PORT_CMD_RSS_TEMP_MGR	= 49,
+	HINIC_PORT_CMD_FWCTXT_INIT = 0x45,
 
-	HINIC_PORT_CMD_RD_LINE_TBL	= 57,
+	HINIC_PORT_CMD_GET_LOOPBACK_MODE = 0x48,
+	HINIC_PORT_CMD_SET_LOOPBACK_MODE = 0x49,
 
-	HINIC_PORT_CMD_RSS_CFG		= 66,
+	HINIC_PORT_CMD_ENABLE_SPOOFCHK = 0x4E,
 
-	HINIC_PORT_CMD_FWCTXT_INIT      = 69,
+	HINIC_PORT_CMD_GET_MGMT_VERSION = 0x58,
 
-	HINIC_PORT_CMD_GET_LOOPBACK_MODE = 72,
-	HINIC_PORT_CMD_SET_LOOPBACK_MODE,
+	HINIC_PORT_CMD_SET_FUNC_STATE = 0x5D,
 
-	HINIC_PORT_CMD_ENABLE_SPOOFCHK = 78,
+	HINIC_PORT_CMD_GET_GLOBAL_QPN = 0x66,
 
-	HINIC_PORT_CMD_GET_MGMT_VERSION = 88,
+	HINIC_PORT_CMD_SET_VF_RATE = 0x69,
 
-	HINIC_PORT_CMD_SET_FUNC_STATE   = 93,
+	HINIC_PORT_CMD_SET_VF_VLAN = 0x6A,
+	HINIC_PORT_CMD_CLR_VF_VLAN = 0x6B,
 
-	HINIC_PORT_CMD_GET_GLOBAL_QPN   = 102,
+	HINIC_PORT_CMD_SET_TSO = 0x70,
 
-	HINIC_PORT_CMD_SET_VF_RATE = 105,
+	HINIC_PORT_CMD_UPDATE_FW = 0x72,
 
-	HINIC_PORT_CMD_SET_VF_VLAN	= 106,
+	HINIC_PORT_CMD_SET_RQ_IQ_MAP = 0x73,
 
-	HINIC_PORT_CMD_CLR_VF_VLAN,
+	HINIC_PORT_CMD_LINK_STATUS_REPORT = 0xA0,
 
-	HINIC_PORT_CMD_SET_TSO          = 112,
+	HINIC_PORT_CMD_UPDATE_MAC = 0xA4,
 
-	HINIC_PORT_CMD_UPDATE_FW	= 114,
+	HINIC_PORT_CMD_GET_CAP = 0xAA,
 
-	HINIC_PORT_CMD_SET_RQ_IQ_MAP	= 115,
+	HINIC_PORT_CMD_GET_LINK_MODE = 0xD9,
 
-	HINIC_PORT_CMD_LINK_STATUS_REPORT = 160,
+	HINIC_PORT_CMD_SET_SPEED = 0xDA,
 
-	HINIC_PORT_CMD_UPDATE_MAC = 164,
+	HINIC_PORT_CMD_SET_AUTONEG = 0xDB,
 
-	HINIC_PORT_CMD_GET_CAP          = 170,
+	HINIC_PORT_CMD_GET_STD_SFP_INFO = 0xF0,
 
-	HINIC_PORT_CMD_GET_LINK_MODE	= 217,
+	HINIC_PORT_CMD_SET_LRO_TIMER = 0xF4,
 
-	HINIC_PORT_CMD_SET_SPEED	= 218,
+	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 0xF9,
 
-	HINIC_PORT_CMD_SET_AUTONEG	= 219,
-
-	HINIC_PORT_CMD_GET_STD_SFP_INFO = 240,
-
-	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
-
-	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 249,
-
-	HINIC_PORT_CMD_GET_SFP_ABS	= 251,
+	HINIC_PORT_CMD_GET_SFP_ABS = 0xFB,
 };
 
 /* cmd of mgmt CPU message for HILINK module */
-- 
2.25.1

